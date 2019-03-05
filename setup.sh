#!/bin/bash

set -eu

THIS_DIR=$(cd $(dirname $0); pwd)

cd $THIS_DIR

echo "start setup..."

for f in .??*; do
  # Ignore files
  [[ $f == .git ]] && continue
  [[ $f == .gitignore ]] && continue
  [[ $f == .gitmodules ]] && continue

  # Make symbolic links of dotfile to HOME
  ln -snfv ~/dotfiles/"$f" ~/
done

if [ ! -d ~/bin ]
  then
    mkdir ~/bin
fi

for f in bin/*; do
  ln -snfv ~/dotfiles/"$f" ~/bin/
done

echo "finished!"
