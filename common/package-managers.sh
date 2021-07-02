#Install Plugin managers
curl -Lo  ~/.zsh/antigen.zsh --create-dirs git.io/antigen
git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

source $HOME/.tmux/plugins/tpm/bin/install_plugins
