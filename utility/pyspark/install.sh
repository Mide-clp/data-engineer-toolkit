#!/bin/bash

PYSPARK_VERSION="3.4.1"

BLUE="\033[0;34m"
WHITE="\033[0;37m"
RED="\033[0;31m"
GREEN="\033[0;32m"
GREEN_BG="\033[42m\033[1;30m"
COLOR_RESET="\033[0m"


pyspark_installer(){
  tar -xvzf spark-$PYSPARK_VERSION-bin-hadoop3.tgz
  sudo mv spark-$PYSPARK_VERSION-bin-hadoop3 /opt/spark

  source "$PWD/utility/helper/script.sh"
  put_path $1
  put_path $2
  rm -rf spark-$PYSPARK_VERSION-bin-hadoop3.tgz
}


install_pyspark_mac(){
  local spark_home=SPARK_HOME="~/spark"
  local path=PATH='$SPARK_HOME/bin:$PATH'

  # install java
  source "$PWD/utility/helper/script.sh"
  java_installation_checker
  python_installation_checker

  echo -e "${BLUE}##################### Checking if PYSPARK has been installed!"
  if ! [[ $(command -v pyspark) ]]; then
    echo -e "${BLUE}##################### Installing PYSPARK!"
    curl "https://archive.apache.org/dist/spark/spark-$PYSPARK_VERSION/spark-$PYSPARK_VERSION-bin-hadoop3.tgz" -o "spark-$PYSPARK_VERSION-bin-hadoop3.tgz"
    pyspark_installer $spark_home $path
    echo -e "${GREEN}##################### PYSPARK installation completed!"
  fi
}

install_pyspark_linux(){
  local spark_home=SPARK_HOME='~/spark'
  local path=PATH='$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin'


  # install java & python
  source "$PWD/utility/helper/script.sh"
  java_installation_checker
  python_installation_checker

  echo -e "${GREEN}##################### Checking if PYSPARK has been installed!"
  if ! [[ $(command -v pyspark) ]]; then
    echo -e "${BLUE}##################### Installing PYSPARK!"
    wget "https://archive.apache.org/dist/spark/spark-$PYSPARK_VERSION/spark-$PYSPARK_VERSION-bin-hadoop3.tgz"
    pyspark_installer $spark_home $path
    echo -e "${GREEN}##################### PYSPARK installation completed!"



  fi
}

uninstall_pyspark(){
  sudo rm -rf /opt/spark
}


pyspark_main() {
  echo -e " ${BLUE}What would you like to do? ${COLOR_RESET}"
  options=("INSTALL" "UNINSTALL")
  echo -e "[${GREEN} 1.${COLOR_RESET}]${GREEN} ${options[0]} PYSPARK ${COLOR_RESET}"
  echo -e "[${RED} 2.${COLOR_RESET}]${RED} ${options[1]} PYSPARK ${COLOR_RESET}"
  read -p "Enter the number corresponding to your needed action: " option

  case ${options[(($option- 1))]} in

    "INSTALL")
      if [[ $OSTYPE == 'darwin'* ]]; then
        install_pyspark_mac
      elif [[ $OSTYPE == 'linux'* ]]; then
        install_pyspark_linux
      fi
    ;;

    "UNINSTALL")
      echo -e "${BLUE}##################### Uninstalling PYSPARK!"
      if [[ $OSTYPE == 'darwin'* ]]; then
        uninstall_pyspark
      elif [[ $OSTYPE == 'linux'* ]]; then
        uninstall_pyspark
      fi
      echo -e "${RED}##################### PYSPARK uninstalled!"
    ;;

    *)
    echo "${RED}Wrong option selected"
    sleep 2
    ;;
  esac

}
