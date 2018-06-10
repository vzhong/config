# set universal
set -U EDITOR vim
set -U HOMEBREW_NO_ANALYTICS 1

# source user specifications, if any
if test -e ~/.local.fish
  source ~/.local.fish
end

# set paths
if not contains /usr/local/bin $PATH
  set PATH /usr/local/bin $PATH
end

if not contains /usr/sbin $PATH
  set PATH /usr/sbin $PATH
end

if not contains "$HOME/.mylocal/bin" $PATH
  set PATH "$HOME/.mylocal/bin" $PATH
end

if test -n "$BREW_ROOT"
  if not contains "$BREW_ROOT/bin" $PATH
    set PATH "$BREW_ROOT/bin" $PATH
  end
  if not contains "$BREW_ROOT/share/man" $MANPATH
    set MANPATH "$BREW_ROOT/share/man" $MANPATH
  end
  if not contains "$BREW_ROOT/share/info" $INFOPATH
    set INFOPATH "$BREW_ROOT/share/info" $INFOPATH
  end
end

if test -n "$CUDA_ROOT"
  if not contains "$CUDA_ROOT/bin" $PATH
    set PATH "$CUDA_ROOT/bin" $PATH
  end
  if not contains "$CUDA_ROOT/lib64" $LD_LIBRARY_PATH
    set LD_LIBRARY_PATH "$CUDA_ROOT/lib64" $LD_LIBRARY_PATH
  end
end

if test -n "$CONDA_ROOT"
  source $CONDA_ROOT/etc/fish/conf.d/conda.fish
  conda activate root
end

# theme
set -g theme_powerline_fonts yes
set -g theme_color_scheme zenburn

# use vim bindings
fish_vi_key_bindings

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
