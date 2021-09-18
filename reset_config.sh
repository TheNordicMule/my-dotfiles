#!/usr/bin/env zsh
# I stole this script from ThePrimeagen link here:
# https://github.com/ThePrimeagen/.dotfiles/blob/master/install
pushd $DOTFILES
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
    stow -D $folder
    stow $folder
done
popd
