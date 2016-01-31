#!/usr/bin/env python2

import os
import shutil
import stat
import logging
import subprocess
import sys
from distutils import spawn
from time import time

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
  logging.info("{}".format(cmd))
  start = time()
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
  out, err = p.communicate()
  if verbose:
    logging.info(out)
    logging.info('time elapsed {}'.format(time() - start))
  if p.returncode:
    raise Exception(err)
  else:
    logging.warn(err)
  return out

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
  logging.info('cloning repository {}'.format(repo))
  cmd = ['git', 'clone', repo]
  if to:
    cmd += [to]
  if recursive:
    cmd += ['--recursive']
  try:
    run(cmd)
  except Exception as e:
    if 'already exists' in e:
      logging.critical('skipping because directory already exists')

def install_rvm():
  brew_install(['gnupg', 'gnupg2'])
  run('gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3')
  rvm = run('curl -sSL https://get.rvm.io', verbose=False)
  run(['bash', '-s', 'stable', '--ruby', rvm])

def install_editors():
  # vim
  brew_install('vim')
  link('vim', '.vim')
  mkdir_if_not_exist('vim/bundle')
  git_clone('https://github.com/tarjoilija/zgen.git')
  git_clone('https://github.com/klen/python-mode.git', to='vim/bundle/python-mode')
  git_clone('https://github.com/chriskempson/tomorrow-theme.git')
  git_clone('https://github.com/gmarik/Vundle.vim.git', to='vim/bundle/vundle')
  git_clone('https://github.com/flazz/vim-colorschemes.git', to='vim/bundle/colorschemes')

  # emacs
  if get_os() == 'mac':
    brew_install('emacs-mac', tap='railwaycat/homebrew-emacsmacport', options=['--with-spacemacs-icon'])
  else:
    brew_install('emacs')
  git_clone('git clone https://github.com/syl20bnr/spacemacs', to='emacs.d')

  # atom
  brew_install('atom')

def install_os_specific():
  if get_os() == 'mac':
    run('brew install caskroom/cask/brew-cask')
    run('brew cask install seil java iterm2 flux')
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
  if not get_executable('rvm'):
    install_rvm()
  # optional fun bropages
  run('gem install bropages')

  # shell
  brew_install(['zsh', 'tmux', 'mosh', 'cmake'])
  # link tmux
  link('tmux', '.tmux.d')

  # editors
  install_editors()

  # link dotfiles
  dot_files_dir = os.path.join(root_dir, 'dotfiles')
  for f in [f for f in os.listdir(dot_files_dir) if f.endswith('.rc')]:
    link(os.path.join('dotfiles', f), '.' + f.replace('.rc', ''))

  # link global git ignore
  link('git/gitignore', '.gitignore')

  # link local files
  link('local', '.local')
  temp = os.path.join(home_dir, '.local', 'bin')
  st = os.stat(temp)
  os.chmod(temp, st.st_mode | stat.S_IEXEC)

  # os specific
  logging.info('installing os specific packages')
  install_os_specific()

  print('you need to change your default shell to zsh:')
  print('sudo cat "{}" >> /etc/shells'.format(get_executable('zsh')))
  print('chsh -s {}'.format(get_executable('zsh')))
  print('finished! you can now run the following to get started')
  print('source {}/.zshrc'.format(os.environ['HOME']))
