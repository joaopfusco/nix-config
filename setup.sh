#!/usr/bin/env bash

set -e

read -p "Qual é o nome deste host (ex: nixos, nixos-vm)? " HOSTNAME

if [ ! -d "hosts/$HOSTNAME" ]; then
  echo "📁 Criando diretório para o host $HOSTNAME..."
  mkdir -p "hosts/$HOSTNAME"
fi

echo "⚙️ Copiando hardware-configuration.nix de /etc/nixos/..."
cp /etc/nixos/hardware-configuration.nix "hosts/$HOSTNAME/"

echo "📦 Rastreando o novo hardware config no Git..."
git add "hosts/$HOSTNAME/hardware-configuration.nix"

GITHUB_USER="joaopfusco"
REPO_NAME="nixos-config"

echo "🔐 Alterando a URL do remote para SSH..."
git remote set-url origin "git@github.com:$GITHUB_USER/$REPO_NAME.git"

# 5. Aplica a configuração do sistema usando o seu Flake
echo "🚀 Iniciando o NixOS Rebuild para o host: $HOSTNAME..."
sudo nixos-rebuild switch --flake .#$HOSTNAME

echo ""
echo "✅ Sistema configurado com sucesso!"
echo "⚠️  IMPORTANTE: O sistema já está usando a sua configuração."
echo "⚠️  Porém, como mudamos para SSH, você precisa gerar sua chave e adicionar no GitHub antes de conseguir dar 'git push'."