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

  # Copy file instead of symlink. They could contain sensitive information.
  # Therefore, they will be modified after copying to HOME.
  [[ $f == .msmtprc ]] && cp -v ~/dotfiles/"$f" ~/

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
