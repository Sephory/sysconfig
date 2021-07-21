#!/bin/bash

SCRIPT_PATH=$(dirname "$(realpath -s "$0")")

#Get Bitwarden creds
if [ -z $BW_USERNAME ]
then
  read -p "Bitwarden Username: " BW_USERNAME
  read -sp "Bitwarden Password: " BW_PASSWORD
fi

apt update
apt upgrade -y

#Install essential applications
apt install -y zsh git fzf ripgrep ranger npm \
	 unzip ssh curl jq
npm i -g yarn
yarn global add @bitwarden/cli@1.16.0
pip3 install pynvim
sh -c "$(curl -fsLS git.io/chezmoi)"

curl -L $(curl -s https://api.github.com/repos/sharkdp/bat/releases/latest \
| rg "browser_download_url.*bat_.*amd64.deb" \
| cut -d '"' -f 4) -o /tmp/bat.deb \
&& dpkg -i /tmp/bat.deb

USERNAME=${1:-sephory}
USERID=${2-1000}
if ! id $USERNAME &>/dev/null; then
	useradd -ms /bin/zsh -u $USERID $USERNAME
fi

export HOME=${2:-/home/$USERNAME}
PATH=$HOME/bin:$HOME/.yarn/bin:$PATH

source $SCRIPT_PATH/../common/package-managers.sh
source $SCRIPT_PATH/../common/dotfiles.sh

chown -R $USERNAME $HOME
