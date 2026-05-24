# 🐧 Nix com Flakes & Home Manager

## ⚙️ Pré-requisitos

1. **Git** configurado e repositório com:
   - `flake.nix` (descrição de inputs e outputs)
   - `hosts/<nome-do-host>/configuration.nix` (configuração global do sistema por host)
   - `hosts/<nome-do-host>/hardware-configuration.nix` (configurações do hardware do sistema por host)
   - `hosts/<nome-do-host>/home.nix` (configuração do Home Manager por host)

2. **Clone** do repositório atual:
   ```bash
   # Instale o git temporariamente
   nix-shell -p git
   
   # Clone o repositório
   git clone https://github.com/joaopfusco/nix-config.git

   # Entre no diretório
   cd nix-config
   ```

---

## 🔄 Atualização e Gerenciamento

```bash
# Sincronize com o repositório remoto
git pull origin main

# Atualize inputs do Flake
nix flake update

# Reaplique configurações do usuário (Home Manager)
home-manager switch --flake .#joaop@ubuntu

# Reaplique configurações do macOS (Darwin)
darwin-rebuild switch --flake .#macbook
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
git clone git@github.com:joaopfusco/nix-config.git

# Entre no diretório
cd nix-config
```

### 3. Executar o comando de switch
Execute o comando abaixo para aplicar as configurações do Flake:

```bash
# Linux
home-manager switch --flake .#{username}@{hostname}
```

```bash
# macOS
darwin-rebuild switch --flake .#{hostname}
```

---
