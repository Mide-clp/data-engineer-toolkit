#!/bin/bash

utility=("airflow" "aws_cli" "hadoop" "pyspark" "python" "terraform")

BLUE="\033[0;34m"
WHITE="\033[0;37m"
RED="\033[0;31m"
GREEN="\033[0;32m"
GREEN_BG="\033[42m\033[1;30m"
COLOR_RESET="\033[0m"



introduction() {
    echo -e "\033[1;34m"
    echo "------------------------------------------"
    echo "                                          "
    echo "  Welcome to the Data Engineering Toolkit!"
    echo "                                          "
    echo "------------------------------------------"
    echo -e " ${RED} Effortlessly install essential applications and focus on what matters most! ${COLOR_RESET}"

}

options_listing() {
  local upper_options=$(echo $2 |tr [:lower:] [:upper:])
  echo -e "[${GREEN} $1.${COLOR_RESET}]${BLUE} $upper_options ${COLOR_RESET}"
}

clear
introduction
sleep 1
clear
options=1
for app in "${utility[@]}";
do

  options_listing $options $app
  ((options+=1))
done
read -p "Enter the number corresponding to your needed utility: " option
echo "You Picked the: ${utility[(($option- 1))]} utility"
sleep 1
clear

case ${utility[(($option- 1))]} in
  "aws_cli")
    source ./utility/aws/install.sh
    aws_main
  ;;

  "python")
    source ./utility/python/install.sh
    python_main
  ;;

"pyspark")
    source ./utility/pyspark/install.sh
    pyspark_main
  ;;

"airflow")
    source ./utility/airflow/install.sh
    airflow_main
  ;;

"hadoop")
    source ./utility/hadoop/install.sh
    hadoop_main
  ;;

  *)
    echo "${RED}Wrong option selected"
    sleep 2
esac


