#!/usr/bin/env python3

import os
import shutil
import logging
import subprocess
import sys
import requests
from time import time

def get_os():
  platform = sys.platform.lower()
  if 'darwin' in platform:
    return 'mac'
  elif 'linux' in platform:
    return 'linux'
  else:
    raise Exception('unsupported platform {}'.format(platform))

def run(cmd, stdin=None, verbose=True, condition=None):
  if condition is not None and not condition:
    return

  if isinstance(cmd, str):
    cmd = cmd.split(' ')
  logging.info("{}".format(cmd))
  start = time()
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
  if stdin:
    p.stdin.write(stdin + '\n')
    p.stdin.flush()

  while p.poll() is None:
    l = p.stdout.readline().decode().rstrip('\n')
    if verbose:
      print(l)
  if verbose:
    print(p.stdout.read().decode().rstrip('\n'))
    logging.info('time elapsed {}'.format(time() - start))
  sys.stderr.write(p.stderr.read().decode())
  if p.returncode:
    raise Exception("Command failed: {}".format(' '.join(cmd) + ('< {}'.format(stdin) if stdin else '')))

def rm_if_exists(p):
  if os.path.islink(p):
    # logging.info('unlinking {}'.format(p))
    os.unlink(p)
  elif os.path.exists(p):
    # logging.info('removing {}'.format(p))
    if os.path.isdir(p):
      shutil.rmtree(p)
    else:
      os.remove(p)

def download_file(url, fname=None):
  if fname is None:
    local_filename = url.split('/')[-1]
  else:
    local_filename = fname
  # NOTE the stream=True parameter
  r = requests.get(url, stream=True)
  with open(local_filename, 'wb') as f:
    for chunk in r.iter_content(chunk_size=1024):
      if chunk:  # filter out keep-alive new chunks
        f.write(chunk)
  return local_filename

def mkdir_if_not_exist(d):
  if not os.path.isdir(d):
    os.makedirs(d)

def get_executable(e):
    return shutil.which(e)

def link(from_file, to_file, override_to_dir=''):
  from_file = os.path.join(root_dir, from_file)
  temp = override_to_dir if override_to_dir else home_dir
  to_file = os.path.join(temp, to_file)
  rm_if_exists(to_file)
  # logging.info('symlinking {} to {}'.format(from_file, to_file))
  if not os.path.isdir(os.path.dirname(to_file)):
    logging.info('making directory {}'.format(os.path.dirname(to_file)))
    os.makedirs(os.path.dirname(to_file))
  os.symlink(from_file, to_file)


if __name__ == '__main__':
  op_sys = get_os()
  logging.basicConfig(level=logging.INFO)
  logging.info('Hello, {}!'.format(os.environ['USER']))
  logging.info('Setting up your environment for {}'.format(op_sys))

  root_dir = os.path.abspath(os.path.dirname(__file__))
  logging.info('located config directory at {}'.format(root_dir))

  home_dir = os.path.abspath(os.environ['HOME'])
  logging.info('located home directory at {}'.format(home_dir))

  # homebrew
  if not get_executable('brew'):
    logging.info('Installing Homebrew')
    url = 'https://raw.githubusercontent.com/{}/install/master/install'.format('Linuxbrew' if op_sys == 'linux' else 'Homebrew')
    fname = download_file(url)
    run('ruby ' + fname)
    rm_if_exists(fname)
  else:
    logging.info('Homebrew is already installed')

  # anaconda
  if not get_executable('conda'):
    logging.info('Installing Anaconda')
    url = 'https://repo.continuum.io/archive/Anaconda3-4.3.1-{}-x86_64.sh'.format('MacOSX' if op_sys == 'mac' else 'Linux')
    fname = download_file(url)
    run('bash {} -b -p {}/anaconda'.format(fname, os.environ.get('HOME')))
    rm_if_exists(fname)
  else:
    logging.info('Anaconda is already installed')

  # zsh
  download_file('https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh', fname='ohmyzsh.sh')
  run('bash ohmyzsh.sh')
  os.remove('ohmyzsh.sh')
  powerlevel_dir = '{}/.oh-my-zsh/custom/themes/powerlevel9k'.format(os.environ['HOME'])
  run('git clone https://github.com/bhilburn/powerlevel9k.git {}'.format(powerlevel_dir))

  run('brew install cmake', condition=not get_executable('cmake'))
  run('brew install mosh', condition=not get_executable('mosh'))
  run('brew install tmux', condition=not get_executable('tmux'))
  run('brew install neovim', condition=not get_executable('nvim'))

  link('conf/tmux', '.tmux.d')
  mkdir_if_not_exist('.config')
  link('conf/nvim', '.config/nvim')
  link('conf/local', '.config/local')
  link('conf/shell', '.config/shell')
  mkdir_if_not_exist('.config/fish')
  link('conf/dotfiles/fish.sh', '.config/fish/config.fish')
  link('conf/dotfiles/zsh.sh', '{}/.zshrc'.format(os.environ['HOME']))
  link('conf/dotfiles/gitconfig.yml', '.gitconfig')
  link('conf/dotfiles/gitignore', '.gitignore')
  link('conf/dotfiles/tmux.sh', '.tmux.conf')

  # powerline fonts
  powerline_dir = os.path.join('{}/.config/powerline'.format(os.environ['HOME']))
  if not os.path.isdir(powerline_dir):
    run('git clone https://github.com/powerline/fonts.git {}'.format(powerline_dir))
    curr_dir = os.getcwd()
    os.chdir(powerline_dir)
    run('./install.sh')
    os.chdir(curr_dir)

  # vim package manager
  mkdir_if_not_exist('{}/.local/share/nvim/site/autoload'.format(os.environ['HOME']))
  download_file('https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim', '{}/.local/share/nvim/site/autoload/plug.vim'.format(os.environ['HOME']))

  print('you need to change your default shell to zsh:')
  print('sudo cat "{}" >> /etc/shells'.format(get_executable('zsh')))
  print('chsh -s {}'.format(get_executable('zsh')))
  print('finished! you can now run the following to get started')
  print('source {}/.zshrc'.format(os.environ['HOME']))
