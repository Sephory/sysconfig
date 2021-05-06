#!/bin/bash

SCRIPT_PATH=$(dirname "$(realpath -s "$0")")

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
pacman -S --noconfirm zsh tmux git chezmoi bat fzf ripgrep ranger w3m \
        yarn python python-msgpack python-pynvim cmake unzip protobuf \
        base-devel openssh clang python-pip
yarn global add @bitwarden/cli

#Build latest Neovim from source
$SCRIPT_PATH/../common/build-nvim.sh

#Create User
USERNAME=${1:-sephory}
USERID=${2:-1000}
useradd -ms /bin/zsh -u $USERID
usermod --aG wheel $USERNAME

#Get dotfiles and apply
export HOME=${2:-/home/$USERNAME}
source $SCRIPT_PATH/../common/dotfiles.sh

#Install Plugin managers
curl -Lo  ~/.zsh/antigen.zsh --create-dirs git.io/antigen
git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

source $HOME/.tmux/plugins/tpm/bin/install_plugins

chown -R $USERNAME $HOME
