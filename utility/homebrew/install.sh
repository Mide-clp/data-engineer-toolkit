#!/bin/bash

BLUE="\033[0;34m"
WHITE="\033[0;37m"
RED="\033[0;31m"
GREEN="\033[0;32m"
GREEN_BG="\033[42m\033[1;30m"
COLOR_RESET="\033[0m"


install_homebrew() {
  echo -e "${BLUE}##################### Checking if Homebrew has been installed!"
  if [[ $(command -v brew) ]]; then
    echo -e "${GREEN}##################### Homebrew has already been installed!"
  else
    echo -e "${BLUE}##################### Installing Homebrew!"
    xcode-select --install
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew analytics off
    echo -e "${GREEN}##################### Homebrew installation completed!"
  fi
}
