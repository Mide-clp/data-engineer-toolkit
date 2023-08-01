#!/bin/bash

HADOOP_VERSION="3.3.6"
HADOOP_HOME=~/hadoop
BLUE="\033[0;34m"
WHITE="\033[0;37m"
RED="\033[0;31m"
GREEN="\033[0;32m"
GREEN_BG="\033[42m\033[1;30m"
COLOR_RESET="\033[0m"

hadoop_tmp_dir="$(echo ~)/hadoop_data/hadoop_tmp_dir"
namenode="$(echo ~)/hadoop_data/data/dfs/namenode"
datanode="$(echo ~)/hadoop_data/data/dfs/datanode"
checkpoint_dir="$(echo ~)/hadoop_data/data/dfs/namesecondary"


put_environment_variable(){
  source "$PWD/utility/helper/script.sh"

  local hadoop_home=HADOOP_HOME="$HADOOP_HOME"
  put_path $hadoop_home
  local hadoop_install=HADOOP_INSTALL='$HADOOP_HOME'
  put_path $hadoop_install
  local hadoop_mapred_home=HADOOP_MAPRED_HOME='$HADOOP_HOME'
  put_path $hadoop_mapred_home
  local hadoop_common_home=HADOOP_COMMON_HOME='$HADOOP_HOME'
  put_path $hadoop_common_home
  local hadoop_hdfs=HADOOP_HDFS_HOME='$HADOOP_HOME'
  put_path $hadoop_hdfs
  local yarn_home=YARN_HOME='$HADOOP_HOME'
  put_path $yarn_home
  local hadoop_common_lib=HADOOP_COMMON_LIB_NATIVE_DIR='$HADOOP_HOME/lib/native'
  put_path $hadoop_common_lib
  local path='PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin'
  put_path $path
  local hadoop_opts=HADOOP_OPTS'-Djava.library.path=$HADOOP_HOME/lib/native'
  put_path $hadoop_opts
  local hadoop_conf=HADOOP_CONF_DIR='$HADOOP_HOME/etc/hadoop'
  put_path $hadoop_conf
}


install_hadoop(){
  source "$PWD/utility/helper/script.sh"
  java_installation_checker

  tar xzf hadoop-$HADOOP_VERSION.tar.gz
  mv hadoop-$HADOOP_VERSION $HADOOP_HOME

  local java_home=$(which javac)
  local java_path=$(readlink -f $java_home | sed 's@/bin/javac$@@')
#  put_environment_variable

  {
    echo "export JAVA_HOME=$java_path"
    echo 'export HADOOP_OPTS="$HADOOP_OPTS -Djava.library.path=$HADOOP_HOME/lib/"'
    echo 'export HADOOP_COMMON_LIB_NATIVE_DIR="$HADOOP_HOME/lib/native/"'
  }  >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh


#  home=$(echo ~)
#  mkdir -p $home/hadoop_data/hadoop_tmp_dir/
#  mkdir -p $home/hadoop_data/dfsdata/namenode/
#  mkdir -p $home/hadoop_data/dfsdata/datanode/

}


install_hadoop_linux(){

#  wget https://downloads.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz

  install_hadoop


  sed -i '/configuration>/d' $HADOOP_HOME/etc/hadoop/core-site.xml
  cat $PWD/utility/hadoop/core-site.xml >> $HADOOP_HOME/etc/hadoop/core-site.xml
  sed -i "s#hadoop_tmp_dir#$hadoop_tmp_dir#g" $HADOOP_HOME/etc/hadoop/core-site.xml

  sed -i '/configuration>/d' $HADOOP_HOME/etc/hadoop/hdfs-site.xml
  cat $PWD/utility/hadoop/hdfs-site.xml >> $HADOOP_HOME/etc/hadoop/hdfs-site.xml
  sed -i "s#namenode_dir#$namenode#g" $HADOOP_HOME/etc/hadoop/hdfs-site.xml
  sed -i "s#datanode_dir#$datanode#g" $HADOOP_HOME/etc/hadoop/hdfs-site.xml
  sed -i "s#checkpoint_dir#$checkpoint_dir#g" $HADOOP_HOME/etc/hadoop/hdfs-site.xml

  sed -i '/configuration>/d' $HADOOP_HOME/etc/hadoop/mapred-site.xml
  cat $PWD/utility/hadoop/mapred-site.xml >> $HADOOP_HOME/etc/hadoop/mapred-site.xml
  sed -i '/configuration>/d'  $HADOOP_HOME/etc/hadoop/yarn-site.xml
  cat $PWD/utility/hadoop/yarn-site.xml >> $HADOOP_HOME/etc/hadoop/yarn-site.xml

  ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
  chmod 0600 ~/.ssh/authorized_keys

  hdfs namenode -format
}

install_hadoop_mac(){
#  curl "https://downloads.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" -o "hadoop-$HADOOP_VERSION.tar.gz"
  install_hadoop
  sed -i -e '/configuration>/d' $HADOOP_HOME/etc/hadoop/core-site.xml
  cat $PWD/utility/hadoop/core-site.xml >> $HADOOP_HOME/etc/hadoop/core-site.xml
  sed -i "" "s#hadoop_tmp_dir#$hadoop_tmp_dir#g" $HADOOP_HOME/etc/hadoop/core-site.xml

  sed -i -e '/configuration>/d' $HADOOP_HOME/etc/hadoop/hdfs-site.xml
  cat $PWD/utility/hadoop/hdfs-site.xml >> $HADOOP_HOME/etc/hadoop/hdfs-site.xml
  sed -i "" "s#namenode_dir#$namenode#g" $HADOOP_HOME/etc/hadoop/hdfs-site.xml
  sed -i "" "s#datanode_dir#$datanode#g" $HADOOP_HOME/etc/hadoop/hdfs-site.xml
  sed -i "" "s#checkpoint_dir#$checkpoint_dir#g" $HADOOP_HOME/etc/hadoop/hdfs-site.xml

  sed -i -e '/configuration>/d' $HADOOP_HOME/etc/hadoop/mapred-site.xml
  cat $PWD/utility/hadoop/mapred-site.xml >> $HADOOP_HOME/etc/hadoop/mapred-site.xml
  sed -i -e '/configuration>/d'  $HADOOP_HOME/etc/hadoop/yarn-site.xml
  cat $PWD/utility/hadoop/yarn-site.xml >> $HADOOP_HOME/etc/hadoop/yarn-site.xml

  ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
  chmod 0600 ~/.ssh/authorized_keys

  hdfs namenode -format
}


hadoop_main() {
  echo -e " ${BLUE}What would you like to do? ${COLOR_RESET}"
  options=("INSTALL" "UNINSTALL" "START" "STOP")
  echo -e "[${BLUE} 1.${COLOR_RESET}]${BLUE} ${options[0]} HADOOP ${COLOR_RESET}"
  echo -e "[${RED} 2.${COLOR_RESET}]${RED} ${options[1]} HADOOP ${COLOR_RESET}"
  echo -e "[${GREEN} 3.${COLOR_RESET}]${GREEN} ${options[2]} HADOOP ${COLOR_RESET}"
  echo -e "[${WHITE} 4.${COLOR_RESET}]${WHITE} ${options[3]} HADOOP ${COLOR_RESET}"
  read -p "Enter the number corresponding to your needed action: " option


  case ${options[(($option- 1))]} in

    "INSTALL")
      echo -e "${GREEN}##################### Installing HADOOP!"
      if [[ $OSTYPE == 'darwin'* ]]; then
        install_hadoop_mac
      elif [[ $OSTYPE == 'linux'* ]]; then
        install_hadoop_linux
      fi
      echo -e "${GREEN}##################### HADOOP installation completed!"
    ;;

    "UNINSTALL")
      echo -e "${BLUE}##################### Uninstalling HADOOP!"
      sudo rm -rf $HADOOP_HOME
      sudo rm -rf ~/hadoop_data
      echo -e "${RED}##################### HADOOP uninstalled!"
    ;;

  "START")
    echo -e "${BLUE}##################### Starting HADOOP!"
    start-dfs.sh
    start-yarn.sh
    echo -e "${GREEN}##################### HADOOP is running on ${WHITE}http://127.0.0.1:9870/"
  ;;

  "STOP")
    echo -e "${BLUE}##################### Stopping HADOOP!"
    stop-dfs.sh
    stop-yarn.sh
    echo -e "${WHITE}##################### Stopped Successfully!"
  ;;

  *)
    echo "${RED}Wrong option selected"
    sleep 2
  ;;
  esac

}
