#!/usr/bin/env sh
export ZDORDIR=${HOME}/.config/zsh
if [[ -f ${HOME}/.localrc ]]; then
  source ${HOME}/.localrc
fi

if [ -n "$BREW_ROOT" ]; then
  export PATH=${BREW_ROOT}/bin:${BREW_ROOT}/sbin:$PATH
  export MANPATH=${BREW_ROOT}/share/man:$MANPATH
  export INFOPATH=${BREW_ROOT}/share/info:$INFOPATH
fi

if [ -n "$LOCAL_ROOT" ]; then
    export PATH=${LOCAL_ROOT}/bin:$PATH
fi

if [ -n "$CUDA_ROOT" ]; then
    export PATH=${CUDA_ROOT}/bin:$PATH
    export LD_LIBRARY_PATH=${CUDA_ROOT}/lib64:$LD_LIBRARY_PATH
fi

if [ -n "$TORCH_ROOT" ]; then
    source ${TORCH_ROOT}/install/bin/torch-activate
fi

if [ -n "$CONDA_ROOT" ]; then
    export PATH=${CONDA_ROOT}/bin:$PATH
fi
