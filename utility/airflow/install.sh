#!/bin/bash

AIRFLOW_VERSION=2.6.3
AIRFLOW_DIR=~/airflow/
BLUE="\033[0;34m"
WHITE="\033[0;37m"
RED="\033[0;31m"
GREEN="\033[0;32m"
GREEN_BG="\033[42m\033[1;30m"
COLOR_RESET="\033[0m"

install_airflow(){
   echo -e "${BLUE}##################### Checking if Airflow has been installed!"
   if ! [[ $(command -v airflow) ]]; then
    echo -e "${GREEN}##################### Installing Airflow!"

    sudo pip install apache-airflow==$AIRFLOW_VERSION

    local airflow_home=AIRFLOW_HOME=$AIRFLOW_DIR
    source "$PWD/utility/helper/script.sh"
    put_path $airflow_home

    airflow db init
    cd $AIRFLOW_DIR
    mkdir dags
    mkdir logs
    mkdir plugins
    echo -e "${GREEN}##################### Airflow installation completed!"

    echo -e "${BLUE}##################### The Airflow folder can be found in the user home directory"
    echo -e "${RED}Execute the below to create the admin user"
    echo -e "${WHITE}airflow users create ${BLUE}--username${WHITE} admin ${BLUE}--firstname ${WHITE}admin ${BLUE}--lastname ${WHITE}admin ${BLUE}--role ${WHITE}Admin ${BLUE}--email ${WHITE}admin@example.org"
  else
    echo -e "${BLUE}##################### Airflow has already been been installed!"


  fi
}



airflow_main() {
  echo -e " ${BLUE}What would you like to do? ${COLOR_RESET}"
  options=("INSTALL" "UNINSTALL")
  echo -e "[${GREEN} 1.${COLOR_RESET}]${GREEN} ${options[0]} AIRFLOW ${COLOR_RESET}"
  echo -e "[${RED} 2.${COLOR_RESET}]${RED} ${options[1]} AIRFLOW ${COLOR_RESET}"
  read -p "Enter the number corresponding to your needed action: " option

  case ${options[(($option- 1))]} in

    "INSTALL")
      if [[ $OSTYPE == 'darwin'* ]]; then
        if ! [[ $(command -v python) ]]; then
          source "$PWD/utility/python/install.sh"
          install_python_mac
        fi
        install_airflow

      elif [[ $OSTYPE == 'linux'* ]]; then
        if ! [[ $(command -v python) ]]; then
          source "$PWD/utility/python/install.sh"
          install_python_linux
        fi
        install_airflow
      fi
    ;;
    "UNINSTALL")
      echo -e "${BLUE}##################### Uninstalling Airflow!"
      if [[ $OSTYPE == 'darwin'* ]]; then
        sudo pip uninstall apache-airflow
        sudo rm -rf $AIRFLOW_DIR
      elif [[ $OSTYPE == 'linux'* ]]; then
        sudo pip uninstall apache-airflow
        sudo rm -rf $AIRFLOW_DIR
      fi
      echo -e "${RED}##################### Airflow uninstalled!${COLOR_RESET}"
    ;;

    *)
    echo "${RED}Wrong option selected"
    sleep 2
    ;;
  esac

}
