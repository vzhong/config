# Config

### Installation

``` bash
git clone --recursive git@github.com:vzhong/config ~/config
cd ~/config
python install.py
```


homebrew:
```
set -x

git clone --recursive git@github.com:vzhong/config ~/config
cd ~/config
python install.py

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install"

brew tap homebrew/python
brew install python numpy scipy matplotlib
brew install caskroom/cask/brew-cask
brew cask install google-chrome dropbox 1password cuda flux gog-galaxy google-drive
```
