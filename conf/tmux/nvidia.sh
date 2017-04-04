#!/usr/bin/env bash
if type "nvidia-smi" > /dev/null; then
    nvidia-smi | grep MiB | awk '{print "GPU:", $2, $3, $9 "/" $11}'
fi

