#!/bin/bash

BLUE="\033[0;34m"
WHITE="\033[0;37m"
RED="\033[0;31m"
GREEN="\033[0;32m"
GREEN_BG="\033[42m\033[1;30m"
COLOR_RESET="\033[0m"


put_path() {
  if [[ $SHELL == *"/zsh"* ]]; then
    echo "export $1" >> ~/.zprofile
    source ~/.zprofile

  elif [[ $SHELL == *"/bash"* ]]; then
    echo "export $1" >> ~/.bash_profile
    echo "export $1" >> ~/.profile

    source ~/.bash_profile
    source ~/.profile

  else
      echo -e "${RED}#####################Can't add path: Shell type not yet supported!"

  fi
}

java_installation_checker(){
  if [[ $OSTYPE == 'darwin'* ]]; then
    echo -e "${BLUE}##################### Checking if JAVA has been installed!"
    if ! [[ $(command -v java) ]]; then
      source "$PWD/utility/homebrew/install.sh"
      install_homebrew

      echo -e "${BLUE}##################### Installing JAVA!"
      brew tap adoptopenjdk/openjdk
      brew install --cask adoptopenjdk8

      echo -e "${GREEN}##################### JAVA installation completed!"
    fi

  elif [[ $OSTYPE == 'linux'* ]]; then
    echo -e "${GREEN}##################### Checking if JAVA has been installed!"
    if ! [[ $(command -v java) ]]; then
      echo -e "${BLUE}##################### Installing JAVA!"
      sudo apt update
      sudo apt install openjdk-8-jdk
       echo -e "${GREEN}##################### JAVA installation completed!"
    fi
  fi
}

python_installation_checker(){
  if [[ $OSTYPE == 'darwin'* ]]; then
    source "$PWD/utility/python/install.sh"
    install_python_mac

  elif [[ $OSTYPE == 'linux'* ]]; then
    source "$PWD/utility/python/install.sh"
    install_python_linux
  fi
}