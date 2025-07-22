#!/bin/bash
set -e

echo "[1/8] Updating system..."
sudo apt update && sudo apt upgrade -y

echo "[2/8] Installing Docker dependencies..."
sudo apt install -y ca-certificates curl gnupg

echo "[3/8] Adding Docker GPG key and repository..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[4/8] Installing Docker and Compose..."
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "[5/8] Adding user '$USER' to docker group..."
sudo usermod -aG docker "$USER"

echo "[6/8] Installing developer tools (git, vim, make, etc.)..."
sudo apt install -y git make vim htop wget unzip

read -p "[7/8] Do you want to install VSCode? (y/n): " install_vscode
wget https://update.code.visualstudio.com/latest/linux-deb-arm64/stable -O code_arm64.deb
sudo apt install ./code_arm64.deb

echo "[8/8] Installing zsh and Oh My Zsh..."
sudo apt install -y zsh

# Set zsh as default
chsh -s $(which zsh)

# Oh My Zsh non-interactive install
export RUNZSH=no
export CHSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Change theme to agnoster
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="agnoster"/' ~/.zshrc

# Add plugins: autosuggestions and syntax highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Enable plugins
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

echo ""
echo "✅ All done! Please reboot or logout and log back in:"
echo "- Docker group will work without sudo"
echo "- Zsh + Oh My Zsh is now your shell"

