#!/usr/bin/env bash
set -x

# homebrew
echo "getting homebrew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# xcode echo "setting up xcode" xcode-select --install

# python
echo "setting up python"
brew tap homebrew/python
brew install python numpy scipy matplotlib 
pip install ipython theano docopt

# shell
echo "setting up shell environment"
brew install zsh tmux mosh cmake
brew install macvim --override-system-vim
chsh -s $(which zsh)
mkdir -p ~/.vim/bundle/
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/vundle
git clone https://github.com/tarjoilija/zgen.git
# source ~/.zshrc
echo "-- you should run :BundleInstall to finish setting up vim"

# git
echo "setting up git repo"
git clone --recursive git@github.com:vzhong/config ~/config
cd ~/config
python install.py

# ruby
echo "setting up ruby"
brew install gnupg gnupg2
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable --ruby
gem install bropages

# brew cask
echo "setting up additional software via cask"
brew install caskroom/cask/brew-cask
brew cask install seil java iterm2 pycharm intellij-idea spotify dropbox mailbox 
brew cask install google-drive google-chrome google-hangouts flux evernote atom postgres
echo "you should install 1password manually"

# set up icloud
ln -s ~/Library/Mobile\ Documents/com\~apple\~CloudDocs/ ~/sync

