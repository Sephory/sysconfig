#!/bin/bash

#Get Bitwarden creds
if [ -z $BW_USERNAME ]
then
  read -p "Bitwarden Username: " BW_USERNAME
  read -sp "Bitwarden Password: " BW_PASSWORD
fi

#Set Timezone
TIMEZONE=${TIMEZONE:-US/Arizona}
cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime
echo "$TIMEZONE" > /etc/timezone

#Install essentiall applications
BUILDDEPS="cmake unzip autoconf protobuf"
pacman -Sy --noconfirm
pacman -S --noconfirm zsh tmux git openssh chezmoi bat fzf ripgrep yarn \
	python python-msgpack python-pynvim $BUILDDEPS
yarn global add @bitwarden/cli

#Build latest Neovim from source
mkdir -p /tmp/neovim-build
git clone https://github.com/neovim/neovim /tmp/neovim-build
cd /tmp/neovim-build
make CCMAKE_BUILD_TYPE=RelWithDebInfo
make install
rm -R /tmp/neovim-build

#Get dotfiles and apply
USERNAME=${$1:-sephory}
export HOME=${$2:-/home/$USERNAME}
cd $HOME
export BW_SESSION=$(bw login $BW_USERNAME $BW_PASSWORD --raw)
unset BW_USERNAME BW_PASSWORD
chezmoi init https://$(bw get username github.com):$(bw get password github.com)@github.com/sephory/dotfiles
chezmoi apply

#Install Plugin managers
curl -Lo  ~/.zsh/antigen.zsh --create-dirs git.io/antigen
git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

#Install Plugins
~/.tmux/plugins/tpm/bin/install_plugins
nvim --headless +PackerInstall +qa
