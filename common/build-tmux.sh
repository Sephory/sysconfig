#!/bin/bash

mkdir -p /tmp/tmux-build
git clone https://github.com/tmux/tmux /tmp/tmux-build
cd /tmp/tmux-build
sh autogen.sh
./configure
make && make install
rm -R /tmp/tmux-build
