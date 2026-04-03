#!/usr/bin/env bash

# Para o script se qualquer comando falhar
set -e

read -p "Qual é o nome deste host? " HOSTNAME

# Variável para o arquivo de trava de segurança
LOCKFILE="$HOME/.config/nixos-config-setup-$HOSTNAME.lock"

# 1. Trava de Segurança
# Verifica se o setup já rodou para este host
if [ -f "$LOCKFILE" ]; then
  echo "🛑 ERRO: O setup já foi executado anteriormente para o host '$HOSTNAME'!"
  echo "Para proteger sua configuração, este script só pode ser executado uma vez."
  echo "Se você realmente precisa forçar uma nova execução, apague o arquivo '$LOCKFILE'."
  exit 1
fi

# Cria a pasta do host se não existir
if [ ! -d "hosts/$HOSTNAME" ]; then
  echo "📁 Criando diretório para o host $HOSTNAME..."
  mkdir -p "hosts/$HOSTNAME"
fi

# Detecta se o sistema é NixOS ou Standalone (Ubuntu, Fedora, WSL, etc)
if [ -f "/etc/nixos/hardware-configuration.nix" ]; then
  echo "❄️  NixOS detectado! Copiando arquivos do sistema..."

  # 2. Lida com o hardware-configuration.nix (O local sempre manda)
  echo "⚙️  Copiando hardware-configuration.nix do sistema local (/etc/nixos/)..."
  cp /etc/nixos/hardware-configuration.nix "hosts/$HOSTNAME/"
  git add "hosts/$HOSTNAME/hardware-configuration.nix"

  # 3. Lida com o configuration.nix (Preserva o do repositório, se existir)
  if [ ! -f "hosts/$HOSTNAME/configuration.nix" ]; then
    echo "📄 configuration.nix não encontrado no repositório. Copiando do sistema local..."
    cp /etc/nixos/configuration.nix "hosts/$HOSTNAME/"
    git add "hosts/$HOSTNAME/configuration.nix"
  else
    echo "📄 configuration.nix já existe no repositório. A versão do Git será mantida."
  fi

else
  echo "🐧 Sistema não-NixOS detectado (Standalone). Ignorando configurações de hardware..."
fi

# 4. Cria um home.nix base se não existir
if [ ! -f "hosts/$HOSTNAME/home.nix" ]; then
  echo "🏠 home.nix não encontrado. Criando um template básico..."
  
  # Usamos 'cat <<EOF' para escrever o conteúdo dentro do arquivo novo
  cat <<EOF > "hosts/$HOSTNAME/home.nix"
{ config, pkgs, ... }:

{
  imports = [
    
  ];
}
EOF
  
  git add "hosts/$HOSTNAME/home.nix"
else
  echo "🏠 home.nix já existe no repositório. A versão do Git será mantida."
fi

# 5. Ativa a trava de segurança para o futuro
touch "$LOCKFILE"

# 6. Exibe as instruções finais
echo ""
echo "✅ Arquivos gerados e configurados com sucesso para o host: $HOSTNAME!"
echo "🔒 Trava de segurança ativada. O setup não rodará novamente para este host."
echo ""
echo "🚀 Para aplicar a configuração, copie e cole UM dos comandos abaixo no terminal:"
echo ""
echo "👉 Se esta máquina for NixOS:"
echo "   sudo nixos-rebuild switch --flake .#$HOSTNAME"
echo ""
echo "👉 Se esta máquina for Standalone (Ubuntu, Fedora, WSL, etc):"
echo "   home-manager switch --flake .#joaop@$HOSTNAME"
echo ""