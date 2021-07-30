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
pacman -S --noconfirm zsh git chezmoi bat fzf ripgrep ranger \
        yarn jq unzip openssh
yarn global add @bitwarden/cli --ignore-engines
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y

#Allow wheel group to sudo
sed -i 's/^# \(%wheel ALL=(ALL) ALL\)/\1/' /etc/sudoers

#Create User
USERNAME=${1:-sephory}
USERID=${2:-1000}
if ! id $USERNAME &>/dev/null; then
	useradd -ms /bin/zsh -u $USERID $USERNAME
	usermod -aG wheel $USERNAME
fi


#Get dotfiles and apply
export HOME=${2:-/home/$USERNAME}
source $SCRIPT_PATH/../common/dotfiles.sh
source $SCRIPT_PATH/../common/package-managers.sh

chown -R $USERNAME:$USERNAME $HOME
