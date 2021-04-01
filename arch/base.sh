#!/bin/bash

#Get Bitwarden creds
if [ -z $BW_USERNAME ]
then
  read -p "Bitwarden Username: " BW_USERNAME
  read -sp "Bitwarden Password: " BW_PASSWORD
fi

#Set Timezone and Locale
TIMEZONE=${TIMEZONE:-US/Arizona}
cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime
echo "$TIMEZONE" > /etc/timezone
sed -ri 's/^#en_US\.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen

#Install essentiall applications
pacman -Sy --noconfirm
pacman -S --noconfirm zsh tmux git openssh chezmoi bat fzf ripgrep ranger \
        yarn python python-msgpack python-pynvim cmake unzip autoconf protobuf \
        clang python-pip
yarn global add @bitwarden/cli

#Build latest Neovim from source
../common/build-nvim.sh

#Get dotfiles and apply
USERNAME=${1:-sephory}
export HOME=${2:-/home/$USERNAME}
../common/dotfiles.sh $USERNAME $HOMe

#Install Plugin managers
curl -Lo  ~/.zsh/antigen.zsh --create-dirs git.io/antigen
git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
