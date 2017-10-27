#!/bin/bash

set -eu

THIS_DIR=$(cd $(dirname $0); pwd)

cd $THIS_DIR

echo "start setup..."
for f in .??*; do
  ln -snfv ~/dotfiles/"$f" ~/
done
