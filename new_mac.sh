#!/usr/bin/env bash
set -x

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install"

git clone --recursive git@github.com:vzhong/config ~/config
cd ~/config
python install.py
source ~/.zshrc

brew tap homebrew/python
brew install zsh python numpy scipy matplotlib mosh caskroom/cask/brew-cask
brew cask install google-chrome dropbox flux gog-galaxy google-drive hazel dayone-cli evernote mailbox basictex

pip install ipython theano
