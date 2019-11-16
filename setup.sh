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
sudo apt install -y curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/shells:/zsh-users:/zsh-completions/xUbuntu_19.04/ /' > /etc/apt/sources.list.d/shells:zsh-users:zsh-completions.list"
wget -nv https://download.opensuse.org/repositories/shells:zsh-users:zsh-completions/xUbuntu_19.04/Release.key -O Release.key
sudo apt-key add - < Release.key
sudo apt update
sudo apt install -y zsh-completions

# Install Powerline-fonts
sudo apt install -y fonts-powerline

# Install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k

# Load ZSH config
curl -fsSL https://raw.githubusercontent.com/m-kutnik/env-setup/master/p10k.zsh_config > ~/.p10k.zsh
curl -fsSL https://raw.githubusercontent.com/m-kutnik/env-setup/master/zshrc_config > ~/.zshrc

source ~/.zshrc
# Install N and Node
mkdir -p ~/.local/bin
(cd ~/.local/bin && curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n && bash n latest)

mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'

# Install Brave
sudo apt install -y apt-transport-https
curl -s https://brave-browser-apt-beta.s3.brave.com/brave-core-nightly.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-beta.gpg add -
source /etc/os-release
echo "deb [arch=amd64] https://brave-browser-apt-beta.s3.brave.com/ $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/brave-browser-beta-${UBUNTU_CODENAME}.list
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
sudo dpkg -i "$TEMP_DEB"
rm -f "$TEMP_DEB"

# Install VSCode
sudo apt install -y software-properties-common apt-transport-https wget
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install -y code

# Import VSCode settings
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

