# 🐧 NixOS com Flakes & Home Manager

## ⚙️ Pré-requisitos

1. **Git** configurado e repositório com:
   - `flake.nix` (descrição de inputs e outputs)
   - `hosts/<nome-do-host>/configuration.nix` (configuração global do sistema por host)
   - `hosts/<nome-do-host>/hardware-configuration.nix` (configurações do hardware do sistema por host)
   - `home.nix` (configuração do Home Manager)

2. **Clone** do repositório atual:
   ```bash
   # Instale o git temporariamente
   nix-shell -p git
   
   # Clone o repositório
   git clone https://github.com/joaopfusco/nixos-config.git

   # Entre no diretório
   cd nixos-config
   ```

---

## 🛠 Comandos Principais

| Ação                             | Comando                                                                    |
|----------------------------------|----------------------------------------------------------------------------|
| Build & Switch                   | `nixos-rebuild switch --flake .#nixos-vm`                                  |
| Build sem restart                | `nixos-rebuild build --flake .#nixos-vm && result/bin/switch-to-configuration switch` |
| Testar (dry-run)                 | `nixos-rebuild test --flake .#nixos-vm`                                    |
| Aplicar Home Manager             | `home-manager switch --flake .#joaop`                                       |
| Atualizar Flake Lock             | `nix flake update`                                                         |

---

## 🔄 Atualização e Gerenciamento

```bash
# Sincronize com o repositório remoto
git pull origin main

# Atualize inputs do Flake
nix flake update

# Rebuild e switch do sistema (sudo)
sudo nixos-rebuild switch --flake .#nixos-vm

# Reaplique configurações do usuário (Home Manager)
home-manager switch --flake .#joaop
```

---

## 🚀 Setup Inicial (Nova Instalação)

Para configurar uma nova máquina (PC físico ou VM) do zero utilizando este repositório privado via SSH, siga os passos abaixo:

### 1. Gerar e Adicionar a Chave SSH no GitHub
Como o repositório é privado, você precisa de uma chave SSH para cloná-lo. No terminal do sistema recém-instalado, abra um shell com o Git e gere a chave:

```bash
# Inicie um shell temporário com Git
nix-shell -p git

# Gere uma nova chave SSH (pressione Enter para aceitar os caminhos padrões)
ssh-keygen -t ed25519 -C "joaopedrofusco@gmail.com"

# Exiba a chave pública gerada
cat ~/.ssh/id_ed25519.pub
```

Copie todo o texto da chave exibida na tela. Acesse o GitHub pelo navegador, vá em Settings > SSH and GPG keys > New SSH key, cole a chave e salve.

### 2. Clonar o Repositório
Com a chave autorizada no GitHub, clone o repositório utilizando a URL SSH:

```bash
# Clone o repositório
git clone git@github.com:joaopfusco/nixos-config.git

# Entre no diretório
cd nixos-config
```

### 3. Executar o Script de Configuração
O script automatizado irá copiar as configurações de hardware da máquina atual, adicioná-las ao Git e realizar o primeiro build do Flake:

```bash
# Dê permissão de execução ao script
chmod +x setup.sh

# Execute o instalador
./setup.sh
```

---