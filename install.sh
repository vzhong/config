#!/usr/bin/env bash
set -x

# homebrew
if ! brew ; then
    echo "getting homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
# xcode echo "setting up xcode" xcode-select --install

# python
echo "setting up python"
brew tap homebrew/python
brew install python numpy scipy matplotlib 
pip install ipython theano docopt

# ruby
echo "setting up ruby"
brew install gnupg gnupg2
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable --ruby
gem install bropages

# shell
echo "setting up shell environment"
brew install zsh tmux mosh cmake
chsh -s $(which zsh)

# link and stuff
python install.py

# necessary repos
mkdir -p ~/.vim/bundle/
git clone https://github.com/tarjoilija/zgen.git
git clone https://github.com/klen/python-mode.git ~/.vim/bundle/python-mode
git clone https://github.com/chriskempson/tomorrow-theme.git
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/vundle
git clone https://github.com/flazz/vim-colorschemes.git ~/.vim/bundle/colorschemes

# brew cask
echo "setting up additional software via cask"
brew install caskroom/cask/brew-cask
brew cask install seil java iterm2 flux atom

# finalize
source ~/.zshrc

echo "-- you should run :BundleInstall to finish setting up vim"
echo "you should install 1password manually"

