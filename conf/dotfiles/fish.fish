# set universal
set -U EDITOR vim
set -U HOMEBREW_NO_ANALYTICS 1

# source user specifications, if any
if test -e ~/.local.fish
  source ~/.local.fish
end

# set paths
set PATH /usr/local/bin /usr/sbin $PATH

set PATH "$HOME/.mylocal/bin" $PATH

if test -n "$CONDA_ROOT"
  set PATH "$CONDA_ROOT/bin" $PATH
end

if test -n "$BREW_ROOT"
  set PATH "$BREW_ROOT/bin" $PATH
  set MANPATH "$BREW_ROOT/share/man" $PATH
  set INFOPATH "$BREW_ROOT/share/info" $PATH
end

if test -n "$CUDA_ROOT"
  set PATH "$CUDA_ROOT/bin" $PATH
  set LD_LIBRARY_PATH "$CUDA_ROOT/lib64" $LD_LIBRARY_PATH
end

# theme
set -g theme_powerline_fonts yes
set -g theme_color_scheme zenburn

# aliases
alias ga='git add'
alias gaa='git add .'
alias gaaa='git add --all'
alias gau='git add --update'
alias gb='git branch'
alias gbd='git branch --delete '
alias gc='git commit'
alias gcm='git commit --message'
alias gcf='git commit --fixup'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcom='git checkout master'
alias gcos='git checkout staging'
alias gcod='git checkout develop'
alias gd='git diff'
alias gda='git diff HEAD'
alias gi='git init'
alias glg='git log --graph --oneline --decorate --all'
alias gld='git log --pretty=format:"%h %ad %s" --date=short --all'
alias gm='git merge --no-ff'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gp='git push'
alias gpr='git pull --rebase'
alias gr='git rebase'
alias gs='git status'
alias gss='git status --short'
alias gst='git stash'
alias gsta='git stash apply'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash save'
