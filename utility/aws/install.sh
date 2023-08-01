#!/bin/bash

BLUE="\033[0;34m"
WHITE="\033[0;37m"
RED="\033[0;31m"
GREEN="\033[0;32m"
GREEN_BG="\033[42m\033[1;30m"
COLOR_RESET="\033[0m"



install_aws_cli() {
  echo -e "${BLUE}##################### Checking if AWS CLI has been installed!"
  if [[ $(command -v aws) ]]; then
    echo -e "${GREEN}##################### AWS CLI has already been installed!"
  else
    echo -e "${BLUE}##################### Installing AWS CLI!"
    curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
    unzip awscli-bundle.zip
    sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
    rm -rf awscli-bundle.zip
    rm -rf awscli-bundle

    echo -e "${GREEN}##################### AWS CLI installation completed!"
  fi
}

mac_install() {
 source "$PWD/utility/homebrew/install.sh"
 source "$PWD/utility/python/install.sh"

 install_homebrew
 install_python_mac
 install_aws_cli
}

linux_install(){
  source "$PWD/utility/python/install.sh"
  install_python_linux

  if ! [[ $(command -v unzip) ]]; then
    sudo apt-get install unzip
  fi
  install_aws_cli
}

uninstall_aws_cli(){
  echo -e "${BLUE}##################### Uninstalling AWS CLI!"
  rm -rf /usr/local/aws
  rm /usr/local/bin/aws
  echo -e "${RED}##################### AWS CLI uninstalled!"
}
aws_main() {
  echo -e " ${BLUE}What would you like to do? ${COLOR_RESET}"
  options=("INSTALL" "UNINSTALL")
  echo -e "[${GREEN} 1.${COLOR_RESET}]${GREEN} ${options[0]} AWS CLI ${COLOR_RESET}"
  echo -e "[${RED} 2.${COLOR_RESET}]${RED} ${options[1]} AWS CLI ${COLOR_RESET}"
  read -p "Enter the number corresponding to your needed action: " option

  case ${options[(($option- 1))]} in

    "INSTALL")
      if [[ $OSTYPE == 'darwin'* ]]; then
        mac_install
      elif [[ $OSTYPE == 'linux'* ]]; then
        linux_install
      fi
    ;;

    "UNINSTALL")
      uninstall_aws_cli
    ;;

    *)
    echo "${RED}Wrong option selected"
    sleep 2
    ;;
  esac

}



