#!/bin/bash

USERNAME=${1:-sephory}
export HOME=${2:-/home/$USERNAME}
cd $HOME

#dotnet tools
DOTNET_SCRIPT=/tmp/dotnet/dotnet-install.sh
DOTNET_SDKS=("2.2" "3.1")
mkdir /tmp/dotnet
chmod 700 $DOTNET_SCRIPT
curl -L https://dot.net/v1/dotnet-install.sh -o $DOTNET_SCRIPT
for SDK in ${DOTNET_SDKS[@]}; do
  $DOTNET_SCRIPT -c $SDK
done

OMNISHARP_LOCATION=~/.dotnet/omnisharp
mkdir $OMNISHARP_LOCATION
curl -L $(curl -s https://api.github.com/repos/omnisharp/omnisharp-roslyn/releases/latest \
| rg "browser_download_url.*omnisharp-linux-x64.tar.gz" \
| cut -d '"' -f 4) --output - \
| tar -xz -C $OMNISHARP_LOCATION

#html
yarn global add vscode-html-languageserver-bin

#cssls
yarn global add vscode-css-languageserver-bin

#tsserver
yarn global add typescript typescript-language-server

#vuels
yarn global add vls

#sql-cli
pip install mssql-cli
