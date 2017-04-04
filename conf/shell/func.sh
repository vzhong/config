#!/usr/bin/env sh

# colored man
man() {
  env \
  LESS_TERMCAP_mb=$(printf "\e[1;31m") \
  LESS_TERMCAP_md=$(printf "\e[1;31m") \
  LESS_TERMCAP_me=$(printf "\e[0m") \
  LESS_TERMCAP_se=$(printf "\e[0m") \
  LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
  LESS_TERMCAP_ue=$(printf "\e[0m") \
  LESS_TERMCAP_us=$(printf "\e[1;32m") \
  man "$@"
}

cat() {
  local out colored
  out=$(/bin/cat $@)
  colored=$(echo $out | pygmentize -f console -g 2>/dev/null)
  [[ -n $colored ]] && echo "$colored" || echo "$out"
}

mcd() {
  mkdir -p $@
  cd $@
}


# git
gu() {
  git pull && git submodule update --init --recursive
}

gss() {
  git status
}

gc() {
  git commit
}

gd() {
  git diff
}
