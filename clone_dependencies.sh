#!/usr/bin/env bash

(cd ..
git clone https://github.com/arcticicestudio/nord-tmux.git
git clone https://github.com/linuxdotexe/nordic-wallpapers.git
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
)
