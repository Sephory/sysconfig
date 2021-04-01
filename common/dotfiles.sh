#!/bin/bash

USERNAME=${1:-sephory}
export HOME=${2:-/home/$USERNAME}
cd $HOME
export BW_SESSION=$(bw login $BW_USERNAME $BW_PASSWORD --raw)
unset BW_USERNAME BW_PASSWORD
chezmoi init https://$(bw get username github.com):$(bw get password github.com)@github.com/sephory/dotfiles
chezmoi apply

