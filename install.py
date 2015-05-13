#!/usr/bin/env python2

import os
import sys
import shutil
import stat

def rm_if_exists(p):
  if os.path.islink(p):
    print 'unlinking', p
    os.unlink(p)
  elif os.path.exists(p):
    print 'removing', p
    if os.path.isdir(p):
      shutil.rmtree(p)
    else:
      os.remove(p)

if __name__ == '__main__':
  root_dir = os.path.abspath(os.path.dirname(__file__))
  print 'located root directory at', root_dir

  home_dir = os.path.abspath(os.environ['HOME'])
  print 'located home directory at', home_dir

  def link(from_file, to_file, override_to_dir=''):
    from_file = os.path.join(root_dir, from_file)
    temp = override_to_dir if override_to_dir else home_dir
    to_file = os.path.join(temp, to_file)
    rm_if_exists(to_file)
    print 'symlinking', from_file, 'to', to_file
    if not os.path.isdir(os.path.dirname(to_file)):
      print 'making directory', os.path.dirname(to_file)
      os.makedirs(os.path.dirname(to_file))
    os.symlink(from_file, to_file)

  # link dot files
  dot_files_dir = os.path.join(root_dir, 'dotfiles')
  for f in [f for f in os.listdir(dot_files_dir) if f.endswith('.rc')]:
    link(os.path.join('dotfiles', f), '.' + f.replace('.rc', ''))

  # link emacs
  link('emacs.d', '.emacs.d')

  # link vim
  link('Vundle.vim', '.vim/bundle/Vundle.vim')

  # link sublime
  if sys.platform == 'darwin':
  	link('sublime', "Library/Application Support/Sublime Text 3/Packages/User")
  else:
    if os.path.isdir(os.path.join(home_dir, '.config/sublime-text-3')):
  	  link('sublime', '.config/sublime-text-3/Packages/User')

  # link tmux
  link('tmux', '.tmux.d')

  # link my bin files
  link('victor', '.victor')
  temp = os.path.join(home_dir, '.victor', 'bin')
  st = os.stat(temp)
  os.chmod(temp, st.st_mode | stat.S_IEXEC),
