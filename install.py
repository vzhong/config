#!/usr/bin/env python2

import os
import shutil
import stat
import logging
import subprocess
import sys
from distutils import spawn

def get_os():
  platform = sys.platform.lower()
  if 'darwin' in platform:
    return 'mac'
  elif 'linux' in platform:
    return 'linux'
  else:
    raise Exception('unsupported platform {}'.format(platform))

def run(cmd, verbose=True):
  if isinstance(cmd, str):
    cmd = cmd.split(' ')
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
  out, err = p.communicate()
  if err:
      raise Exception(err)
  logging.info("{}".format(cmd))
  if verbose:
    logging.info(out)

def rm_if_exists(p):
  if os.path.islink(p):
    logging.info('unlinking {}'.format(p))
    os.unlink(p)
  elif os.path.exists(p):
    logging.info('removing {}'.format(p))
    if os.path.isdir(p):
      shutil.rmtree(p)
    else:
      os.remove(p)

def mkdir_if_not_exist(d):
  if not os.path.isdir(d):
    os.makedirs(d)

def get_executable(e):
    return spawn.find_executable(e)

def link(from_file, to_file, override_to_dir=''):
  from_file = os.path.join(root_dir, from_file)
  temp = override_to_dir if override_to_dir else home_dir
  to_file = os.path.join(temp, to_file)
  rm_if_exists(to_file)
  logging.info('symlinking {} to {}'.format(from_file, to_file))
  if not os.path.isdir(os.path.dirname(to_file)):
    logging.info('making directory {}'.format(os.path.dirname(to_file)))
    os.makedirs(os.path.dirname(to_file))
  os.symlink(from_file, to_file)

def install_homebrew():
  logging.info('installing homebrew')
  curl = {
      'linux': '"$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/linuxbrew/go/install)"',
      'mac': '"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"',
  }[get_os()]
  run(['ruby', '-e', curl])

def brew_install(brews, tap=None, options=()):
  if not isinstance(brews, list):
    brews = [brews]
  logging.info('installing {} via homebrew'.format(brews))
  if options:
    logging.info('with options {}'.format(options))
  if tap:
    logging.info('tapping {}'.format(tap))
    run(['brew', 'tap', tap])
  run(['brew', 'install'] + brews + list(options))

def git_clone(repo, to=None, recursive=True):
  logging('cloning repository {}'.format(repo))
  cmd = ['git', 'clone', repo]
  if to:
    cmd += [to]
  if recursive:
    cmd += ['--recursive']
  run(cmd)

def install_editors():
  brew_install('vim')
  if get_os() == 'mac':
    brew_install('emacs-mac', tap='railwaycat/homebrew-emacsmacport', options=['--with-spacemacs-icon'])
  else:
    brew_install('emacs')

def install_os_specific():
  if get_os() == 'mac':
    run('brew install caskroom/cask/brew-cask')
    run('brew cask install seil java iterm2 flux atom')
    # disable photo app auto startup on connecting ios device
    run('defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true')

def source(f):
  logging.info('reloading {}'.format(f))
  run('source {}'.format(f))


if __name__ == '__main__':
  logging.basicConfig(level=logging.INFO)
  logging.info('Hello, {}!'.format(os.environ['USER']))
  logging.info('Setting up your environment for {}'.format(get_os()))

  root_dir = os.path.abspath(os.path.dirname(__file__))
  logging.info('located config directory at {}'.format(root_dir))

  home_dir = os.path.abspath(os.environ['HOME'])
  logging.info('located home directory at {}'.format(home_dir))

  # homebrew
  if not get_executable('brew'):
    install_homebrew()

  # python
  brew_install('python', tap='homebrew/python')

  # ruby (RVM)
  brew_install(['gnupg', 'gnupg2'])
  run('gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3')
  run('\curl -sSL https://get.rvm.io | bash -s stable --ruby')
  # optional fun bropages
  run('gem install bropages')

  # change default shell
  brew_install(['zsh', 'tmux', 'mosh', 'cmake'])
  run(['chsh', '-s', get_executable('zsh')])

  # editors
  install_editors()

  # link dotfiles
  dot_files_dir = os.path.join(root_dir, 'dotfiles')
  for f in [f for f in os.listdir(dot_files_dir) if f.endswith('.rc')]:
    link(os.path.join('dotfiles', f), '.' + f.replace('.rc', ''))

  # link global git ignore
  link('git/gitignore', '.gitignore')

  # link vim
  link('vim', '.vim')
  mkdir_if_not_exist('~/.vim/bundle')

  # link tmux
  link('tmux', '.tmux.d')

  # link local files
  link('local', '.local')
  temp = os.path.join(home_dir, '.local', 'bin')
  st = os.stat(temp)
  os.chmod(temp, st.st_mode | stat.S_IEXEC)

  # clone repos
  git_clone('https://github.com/tarjoilija/zgen.git')
  git_clone('https://github.com/klen/python-mode.git', to='~/.vim/bundle/python-mode')
  git_clone('https://github.com/chriskempson/tomorrow-theme.git')
  git_clone('https://github.com/gmarik/Vundle.vim.git', to='~/.vim/bundle/vundle')
  git_clone('https://github.com/flazz/vim-colorschemes.git', to='~/.vim/bundle/colorschemes')
  git_clone('git clone https://github.com/syl20bnr/spacemacs', to='~/.emacs.d')

  # os specific
  source('~/.zshrc')
