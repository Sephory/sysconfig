#!/bin/bash

mkdir -p /tmp/neovim-build
git clone https://github.com/neovim/neovim /tmp/neovim-build
cd /tmp/neovim-build
make CCMAKE_BUILD_TYPE=RelWithDebInfo
make install
rm -R /tmp/neovim-build

