#!/bin/bash
set -e && set -o errexit
sudo apt update
sudo apt dist-upgrade -y 

# Install git
sudo apt install -y git

# Install xclip
sudo apt install -y xclip

# Install zsh
sudo apt install -y zsh

# Install OhMyZSH
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions || true

# Install Powerline-fonts
sudo apt install -y fonts-powerline

# Install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k || true

# Load ZSH config
curl -fsSL https://raw.githubusercontent.com/m-kutnik/env-setup/master/p10k.zsh_config > ~/.p10k.zsh
curl -fsSL https://raw.githubusercontent.com/m-kutnik/env-setup/master/zshrc_config > ~/.zshrc

zsh ~/.zshrc
# Install N and Node
mkdir -p ~/.local/bin
(cd ~/.local/bin && curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n && bash n latest)

mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'

# Install Brave
sudo apt install -y apt-transport-https
curl -s https://brave-browser-apt-beta.s3.brave.com/brave-core-nightly.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-beta.gpg add -
. /etc/os-release
echo "deb [arch=amd64] https://brave-browser-apt-beta.s3.brave.com/ $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/brave-browser-beta.list
sudo apt update
sudo apt install -y brave-browser-beta

# Install Spotify
curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add - 
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update
sudo apt install -y spotify-client

# Install Gitkraken
TEMP_DEB="$(mktemp)" &&
wget -O "$TEMP_DEB" 'https://release.gitkraken.com/linux/gitkraken-amd64.deb' &&
sudo apt install "$TEMP_DEB"
rm -f "$TEMP_DEB"

# Install VSCode
sudo apt install -y software-properties-common apt-transport-https wget
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install -y code

# Import VSCode settings
mkdir -p ~/.config/Code/User/
curl -fsSL https://raw.githubusercontent.com/m-kutnik/env-setup/master/vscode_config > ~/.config/Code/User/settings.json

# Install VSCode extensions
code --install-extension mubaidr.vuejs-extension-pack
code --install-extension HookyQR.beautify
code --install-extension kisstkondoros.vscode-codemetrics
code --install-extension dbaeumer.vscode-eslint
code --install-extension spywhere.guides
code --install-extension abusaidm.html-snippets
code --install-extension wix.vscode-import-cost
code --install-extension Zignd.html-css-class-completion
code --install-extension eg2.vscode-npm-script
code --install-extension christian-kohler.npm-intellisense
code --install-extension christian-kohler.path-intellisense
code --install-extension shinnn.stylelint
code --install-extension Gruntfuggly.todo-tree
code --install-extension vscode-icons-team.vscode-icons

# Finish
zsh

