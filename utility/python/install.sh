#!/bin/bash

PYTHON_VERSION=3.10

BLUE="\033[0;34m"
WHITE="\033[0;37m"
RED="\033[0;31m"
GREEN="\033[0;32m"
GREEN_BG="\033[42m\033[1;30m"
COLOR_RESET="\033[0m"


install_python_mac(){
  echo -e "${BLUE}##################### Checking if python has been installed!"

  if [[ $(command -v python) ]]; then
    echo -e "${GREEN}##################### Python has already been installed!"

  else
    echo -e "${BLUE}##################### Installing python!"
    source "$PWD/utility/homebrew/install.sh"

    install_homebrew
    brew install python
    local full_path=PATH="$(brew --prefix python)/libexec/bin:$PATH"

    source "$PWD/utility/helper/script.sh"
    put_path $full_path

    echo -e "${GREEN}##################### Python installation completed!"
  fi
}

install_python_linux(){
  echo -e "${GREEN}##################### Checking if python has been installed!"
  if ! [[ $(command -v python) ]]; then
    echo -e "${BLUE}##################### Updating package tool!"
    sudo apt update
    echo -e "${GREEN}##################### Package tool update completed!"

    echo -e "${BLUE}##################### Installing python!"
    sudo add-apt-repository ppa:deadsnakes/ppa
    sudo apt install "python$PYTHON_VERSION"
    sudo update-alternatives --remove-all python
    sudo update-alternatives --install /usr/bin/python python /usr/bin/"python$PYTHON_VERSION" 1
    sudo apt remove --purge python3-apt
    sudo apt autoclean
    sudo apt install python3-apt
    sudo apt install "python$PYTHON_VERSION-distutils"
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    sudo "python$PYTHON_VERSION" get-pip.py
    sudo apt install "python$PYTHON_VERSION-venv"
    rm get-pip.py
    echo -e "${GREEN}##################### Python installation completed!"
  fi
}

uninstall_python_mac(){
  echo -e "${BLUE}##################### Uninstalling python!"
  brew uninstall python
  echo -e "${RED}##################### Python uninstalled!"
}


uninstall_python_linux(){
  echo -e "${BLUE}##################### Uninstalling python!"
  sudo update-alternatives --remove-all python
  sudo apt-get remove "python$PYTHON_VERSION"
  echo -e "${RED}##################### Python uninstalled!"
}

python_main(){
  echo -e " ${BLUE}What would you like to do? ${COLOR_RESET}"
  options=("INSTALL" "UNINSTALL")
  echo -e "[${GREEN} 1.${COLOR_RESET}]${GREEN} ${options[0]} PYTHON ${COLOR_RESET}"
  echo -e "[${RED} 2.${COLOR_RESET}]${RED} ${options[1]} PYTHON ${COLOR_RESET}"
  read -p "Enter the number corresponding to your needed action: " option

  case ${options[(($option- 1))]} in

    "INSTALL")
      if [[ $OSTYPE == 'darwin'* ]]; then
        install_python_mac
      elif [[ $OSTYPE == 'linux'* ]]; then
        install_python_linux
      fi
    ;;
    "UNINSTALL")
      if [[ $OSTYPE == 'darwin'* ]]; then
        uninstall_python_mac
      elif [[ $OSTYPE == 'linux'* ]]; then
        uninstall_python_linux
      fi
    ;;

    "UNINSTALL")
      if [[ $OSTYPE == 'darwin'* ]]; then
        uninstall_python_mac
      elif [[ $OSTYPE == 'linux'* ]]; then
        uninstall_python_linux
      fi
    ;;

    *)
    echo "${RED}Wrong option selected"
    sleep 2
    ;;
  esac

}