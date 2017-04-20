source ~/.config/shell/env.sh
source ~/.config/shell/func.sh

source ~/.config/zsh/init.zsh

# load modules
zstyle ':prezto:load' pmodule \
  'utility' \
  'environment' \
  'history' \
  'archive' \
  'syntax-highlighting' \
  'history-substring-search' \
  'utility' \
  'completion' \
  'directory' \
  'command-not-found' \
  'ssh' \
  'tmux' \
  'prompt'

if [ -f ~/.localrc ]; then
    source ~/.localrc
fi

source ${HOME}/.config/shell/env.sh
source ${HOME}/.config/shell/func.sh
source ${HOME}/.config/shell/path.sh

# load ssh identities
zstyle ':prezto:module:ssh:load' identities 'id_rsa'

# auto title terminal
zstyle ':prezto:module:terminal' auto-title 'yes'
zstyle ':prezto:module:terminal:window-title' format '%n@%m: %s'
zstyle ':prezto:module:terminal:tab-title' format '%m: %s'

# tmux + iterm2
zstyle ':prezto:module:tmux:iterm' integrate 'yes'

# theme
zstyle ':prezto:module:prompt' theme 'sorin'

alias rm=rm
