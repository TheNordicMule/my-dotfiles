#!/usr/bin/env bash

(cd ..
# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install nix
sh <(curl -L https://nixos.org/nix/install)

# wall papers
git clone https://github.com/linuxdotexe/nordic-wallpapers.git
)
