from install import *

def install_torch():
  logging.info('installing torch')
  run('curl -s https://raw.githubusercontent.com/torch/ezinstall/master/install-deps | bash')
  git_clone('https://github.com/torch/distro.git', to='~/torch')
  run('cd ~/torch && ./install.sh')
  run('cat "export TORCH_ROOT=${HOME}/torch" >> ~/.localrc')

if __name__ == '__main__':
  logging.info('Installing research libraries')
  if not get_executable('th'):
    install_torch()

  if not get_executable('psql'):
    brew_install('postgres')

  brew_install(['numpy', 'scipy', 'matplotlib'])

  run('pip install ipython theano docopt')
