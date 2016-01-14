#!/usr/bin/env bash
set -x

mkdir libs
sudo gem install bundler

git clone git@github.com:ttscoff/Slogger.git libs/slogger
cd libs/slogger
bundle install
cd -

