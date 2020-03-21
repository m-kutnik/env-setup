#!/bin/bash
set -e && set -o errexit
sudo apt update
sudo apt dist-upgrade -y 

# Install make
sudo apt install -y make

# Install git
sudo apt install -y git

# Install xclip
sudo apt install -y xclip

# Install fonts
sudo apt install -y fontconfig
mkdir -p ~/.fonts
wget -q --show-progress 'https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete%20Mono.ttf?raw=true' -P ~/.fonts/
wget -q --show-progress 'https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete.otf?raw=true' -P ~/.fonts/
wget -q --show-progress 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf' -P ~/.fonts/
wget -q --show-progress 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf' -P ~/.fonts/
wget -q --show-progress 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf' -P ~/.fonts/
wget -q --show-progress 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf' -P ~/.fonts/

fc-cache -vf ~/.fonts

# Install zsh
sudo apt install -y zsh

# Install OhMyZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install ZSH plugins
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting || true
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions || true
git clone https://github.com/buonomo/yarn-completion ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/yarn-completion || true

# Install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k || true

# Load ZSH config
curl -fsSL https://raw.githubusercontent.com/m-kutnik/env-setup/master/p10k.zsh_config > ~/.p10k.zsh
curl -fsSL https://raw.githubusercontent.com/m-kutnik/env-setup/master/zshrc_config-wsl > ~/.zshrc

# Install N and Node
mkdir -p ~/.local/bin
mkdir -p ~/.npm-global
curl -L https://git.io/n-install | N_PREFIX=~/.n bash -s -- -y latest

. ~/.bashrc # Reload shell
npm config set prefix '~/.npm-global'

# Install Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y yarn

# Install VueCLI
npm install -g @vue/cli

# Install ESLint
npm install -g eslint

# Add DNS sync script
wget https://gist.github.com/matthiassb/9c8162d2564777a70e3ae3cbee7d2e95/raw/b204a9faa2b4c8d58df283ddc356086333e43408/dns-sync.sh -O /etc/init.d/dns-sync.sh
chmod +x /etc/init.d/dns-sync.sh
unlink /etc/resolv.conf
service dns-sync.sh start

# Install Gitkraken
TEMP_DEB="$(mktemp)" &&
wget -O "$TEMP_DEB.deb" 'https://release.gitkraken.com/linux/gitkraken-amd64.deb' &&
sudo apt install "$TEMP_DEB.deb"
rm -f "$TEMP_DEB.deb"

# Install Docker (TODO)
sudo apt-get install -y apt-transport-https ca-certificates gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu disco stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Finish
zsh
