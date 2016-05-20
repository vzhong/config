#!/usr/bin/env zsh
set -x
set -e

source ~/.funcrc

yaourt -S --needed cuda gcc5
# yaourt -S --noconfirm -needed python-tensorflow

echo "Installing torch... You may need to hand-hold the installation"
gitclone https://github.com/torch/distro.git ~/torch --recursive
cd ~/torch

# CUDA doesn't play nice with modern GCC
CC=gcc-5
CXX=g++-5
./install-deps
./install
cd -
