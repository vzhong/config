#####################
## Keys
#####################

# Use backtick as the prefix
unbind C-b
set -g prefix `
bind ` send-prefix

# allow tmux inside tmux: use a <command> to send to inner tmux
bind-key a send-prefix

set-option -g allow-rename off

# enable mouse
# set-option -g mouse on

# vim keys in mode
# set-option -g status-keys vi
# set-window-option -g mode-keys vi

# use v to begin selection
# bind-key -t vi-copy v begin-selection
# bind-key -t vi-copy y copy-selection  # "reattach-to-user-namespace pbcopy"

# use fish
set-option -g default-shell /usr/local/bin/fish


#####################
## Windows
#####################

# use ` L to switch to last window
bind-key L last-window

# Move around panes
bind h select-pane -L
bind l select-pane -R
bind k select-pane -U
bind j select-pane -D

bind \ split-window -h
bind - split-window -v

bind-key    -T prefix w                confirm-before -p "kill-window #W? (y/n)" kill-window
bind-key    -T prefix x                confirm-before -p "kill-pane #W? (y/n)" kill-pane

# shift left and right to move windows
bind-key -n S-Left swap-window -t -1
bind-key -n S-Right swap-window -t +1

#####################
## Settings
#####################

# fix copy-paste
# set -g default-command "reattach-to-user-namespace -l $SHELL"

# start windows at 1
set -g base-index 1
set-window-option -g pane-base-index 1

# large scroll history
set -g history-limit 30000

# do not erase terminal output after exiting program
setw -g alternate-screen on

# fast key repetition
set -s escape-time 0

# use default shell
set-option -g default-shell $SHELL


######################
## THEME
######################

# panes

## Status bar design
# status line
set -g status-justify left
set -g status-interval 2

# messaging
set -g message-command-style fg=blue,bg=black

#window mode

# window status
setw -g window-status-format " #F#I:#W#F "
setw -g window-status-current-format " #F#I:#W#F "
setw -g window-status-format "#[fg=magenta]#[bg=black] #I #[bg=cyan]#[fg=colour8] #W "
setw -g window-status-current-format "#[bg=brightmagenta]#[fg=colour8] #I #[fg=colour8]#[bg=colour14] #W "

# Info on left (I don't have a session display for now)
set -g status-left ''

# loud or quiet?
set-option -g visual-activity off
set-option -g visual-bell off
set-option -g visual-silence off
set-window-option -g monitor-activity off
set-option -g bell-action none

set -g default-terminal "screen-256color"

# The modes {
setw -g clock-mode-colour colour135
setw -g mode-style bg=colour6,fg=colour0,bold,fg=colour196,bg=colour238

# }
# The panes {

set -g pane-border-style fg=black,bg=colour235,fg=colour238
set -g pane-active-border-style fg=brightred,bg=colour236,fg=colour51

# }
# The statusbar {

set -g status-position bottom
set -g status-style bg=default,fg=colour12,bg=colour234,fg=colour137,dim
set -g status-left ''
set -g status-right '#[fg=colour233,bg=colour241,bold] %d/%m #[fg=colour233,bg=colour245,bold] %H:%M:%S '
set -g status-right-length 50
set -g status-left-length 20

setw -g window-status-current-style bg=colour0,fg=colour11,dim,fg=colour81,bg=colour238,bold
setw -g window-status-current-format ' #I#[fg=colour250]:#[fg=colour255]#W#[fg=colour50]#F '

setw -g window-status-style bg=green,fg=black,reverse,fg=colour138,bg=colour235,none
setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '

setw -g window-status-bell-style bold,fg=colour255,bg=colour1

# }
# The messages {

set -g message-style fg=black,bg=yellow,bold,fg=colour232,bg=colour166


# Add truecolor support
set-option -ga terminal-overrides ",xterm-256color:Tc"
# Default terminal is 256 colors
set -g default-terminal "screen-256color"

# }
