#!/usr/bin/env bash
set -x

# don't open photos app when iphone is plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

