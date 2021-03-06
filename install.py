#!/usr/bin/env python3

import logging
import os
import shutil
import subprocess
import sys
from time import time

import requests


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
    logging.info('{}'.format(cmd))
    start = time()
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if stdin:
        p.stdin.write(stdin + '\n')
        p.stdin.flush()

    while p.poll() is None:
        line = p.stdout.readline().decode().rstrip('\n')
        if verbose:
            print(line)
    if verbose:
        print(p.stdout.read().decode().rstrip('\n'))
        logging.info('time elapsed {}'.format(time() - start))
    sys.stderr.write(p.stderr.read().decode())
    if p.returncode:
        raise Exception('Command failed: {}'.format(
            ' '.join(cmd) + ('< {}'.format(stdin) if stdin else '')))


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
    logging.info('Downloaded {} to {}'.format(url, local_filename))
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
        url = 'https://raw.githubusercontent.com/Homebrew/install/master/install.sh'
        fname = download_file(url)
        run('bash ' + fname)
        rm_if_exists(fname)
    else:
        logging.info('Homebrew is already installed')

    # anaconda
    if not get_executable('conda'):
        logging.info('Installing Anaconda')
        url = 'https://repo.continuum.io/archive/Anaconda3-5.2.0-{}-x86_64.sh'.format(
            'MacOSX' if op_sys == 'mac' else 'Linux')
        fname = download_file(url)
        run('bash {} -b -p {}/anaconda'.format(fname, os.environ.get('HOME')))
        rm_if_exists(fname)
    else:
        logging.info('Anaconda is already installed')

    # fish
    if not get_executable('fish'):
        run('brew install fish bc curl')
    run('curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish')

    # run('brew install npm', condition=not get_executable('npm'))
    run('brew install fzf', condition=not get_executable('fzf'))
    run('brew install grc', condition=not get_executable('grc'))
    run('brew install tmux', condition=not get_executable('tmux'))
    run('brew install neovim', condition=not get_executable('nvim'))

    link('conf/tmux', '.tmux.d')
    mkdir_if_not_exist('.config')
    link('conf/nvim', '.config/nvim')
    link('conf/dotfiles/fish.fish', '.config/fish/config.fish')
    link('conf/dotfiles/gitconfig.yml', '.gitconfig')
    link('conf/dotfiles/gitignore', '.gitignore')
    link('conf/dotfiles/tmux.sh', '.tmux.conf')
    link('local', '.mylocal')

    # powerline fonts
    powerline_dir = os.path.join('{}/.config/powerline'.format(
        os.environ['HOME']))
    if not os.path.isdir(powerline_dir):
        run('git clone https://github.com/powerline/fonts.git {}'.format(
            powerline_dir))
        curr_dir = os.getcwd()
        os.chdir(powerline_dir)
        run('./install.sh')
        os.chdir(curr_dir)

    # vim package manager
    to_file = '{}/.local/share/nvim/site/autoload/plug.vim'.format(
        os.environ['HOME'])
    if not os.path.isfile(to_file):
        mkdir_if_not_exist('{}/.local/share/nvim/site/autoload'.format(
            os.environ['HOME']))
        download_file(
            'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim',
            to_file)

    print('you need to change your default shell to fish:')
    print('sudo echo "{}" >> /etc/shells'.format(get_executable('fish')))
    print('chsh -s {}'.format(get_executable('fish')))
    print('finished! you can now run the following to get started')
    print(get_executable('fish'))
    print('dont forget to run the following')
    print('fish post.fish')
