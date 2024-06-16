#!/usr/bin/env zsh
# I stole this script from ThePrimeagen link here:
# https://github.com/ThePrimeagen/.dotfiles/blob/master/install
pushd ~/my-dotfiles
folders=("alacritty" "amethyst" "sketchybar" "tmux" "vim" "zsh")
for folder in "${folders[@]}"
do
    stow -D $folder
    stow $folder
done
popd
