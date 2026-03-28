# Home Manager Configuration

## 🔄 Atualização e Gerenciamento

```bash
# Sincronize com o repositório remoto
git pull origin main

# Atualize inputs do Flake
nix flake update

# Reaplique configurações do usuário (Home Manager)
home-manager switch --flake .#joaop
```

---

## 🚀 Setup Inicial

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
