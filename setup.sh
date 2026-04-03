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

# 4. Aplica a configuração do sistema
echo "🚀 Iniciando o NixOS Rebuild para o host: $HOSTNAME..."
sudo nixos-rebuild switch --flake .#$HOSTNAME

# 5. Ativa a trava de segurança para o futuro
touch "$LOCKFILE"

echo ""
echo "✅ Sistema configurado com sucesso!"
echo "🔒 Trava de segurança ativada. O setup não rodará novamente para este host."