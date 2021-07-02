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
apt install -y zsh tmux git fzf ripgrep ranger yarnpkg \
	python3 python3-msgpack python3-pip cmake unzip \
	libprotobuf-dev build-essential ssh clang curl

yarn global add @bitwarden/cli
pip3 install pynvim
sh -c "$(curl -fsLS git.io/chezmoi)"

curl -L $(curl -s https://api.github.com/repos/omnisharp/omnisharp-roslyn/releases/latest \
| rg "browser_download_url.*bat_.*amd64.deb" \
| cut -d '"' -f 4) -o /tmp/bat.deb \
&& dpkg -i /tmp/bat.deb

$SCRIPT_PATH/../common/build-nvim.sh

USERNAME=${1:-sephory}
USERID=${2-1000}
if ! id $USERNAME &>/dev/null; then
	useradd -ms /bin/zsh -u $USERID $USERNAME
fi

export HOME=${2:-/home/$USERNAME}
source $SCRIPT_PATH/../common/dotfiles.sh

chown -R $USERNAME $HOME
