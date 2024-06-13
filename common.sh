red="\e[31m"
green="\e[32m"
yellow="\e[33m"
blue="\e[34m"
magenta="\e[36m"
cyan="\e[36m"
close="\e[0m"



log_file="/tmp/robo_shell.log"

set_hostname(){
  set-hostname ${component}
}


stat_check(){
  if [ $1 -eq 0 ]; then
    echo -e "${green} Success ${close}"
  else
    echo -e "${red} Failure ${close}"
  fi
}

app_setup(){
    id roboshop  &>> ${log_file}
    if [ $? -eq 0 ]; then
      echo -e "${yellow} Adding APP user ${close}"
      useradd roboshop  &>> ${log_file}
    else
      echo -e "${red} user already exists ${close}"
    fi
      stat_check $?

    cd /app  &>> ${log_file}
    if [ $? -eq 0 ]; then
      echo -e "${yellow} Directory already exists ${close}"
       mkdir /app  &>> ${log_file}
       echo -e "${blue} Downloading ${component} content and extracting it ${close}"
       curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
       cd /app && unzip /tmp/${component}.zip &>> ${log_file}
       stat_check $?
    else
    echo -e "${yellow} Creating APP directory ${close}"
    fi
    stat_check $?
}


conf(){
    echo -e  "${magenta} Copying ${component} service file ${close}"
    cp /home/centos/roboshop-shell/${component}.service /etc/systemd/system/${component}.service  &>> ${log_file}
    stat_check $?
}

service(){
    echo -e "${yellow} Reloading Daemon ${close}"
    systemctl daemon-reload   &>> ${log_file}
    stat_check $?

    echo -e "${yellow} Enabling and restarting ${component} service ${close}"
    systemctl enable ${component} && systemctl start ${component}   &>> ${log_file}
    stat_check $?
}




nodejs(){
    echo -e "${cyan} Setting up NodeJS Repo ${close}"
    dnf module disable nodejs -y && dnf module enable nodejs:18 -y  &>> ${log_file}
    stat_check $?

    echo -e "${green} Installing NodeJS RPM ${close}"
    dnf install nodejs -y  &>> ${log_file}
    stat_check $?

    app_setup
    stat_check $?

    echo -e "${blue} Downloading NodeJS Dependencies${close}"
    cd /app && npm install  &>> ${log_file}
    stat_check $?

    conf
    service

}





mongodb_setup(){
    echo -e "${cyan} setting up mongodb repo ${close}"
    cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo  &>> ${log_file}
    stat_check $?

    echo -e "${yellow} Installing mongodb client ${close}"
    dnf install mongodb-org-shell -y  &>> ${log_file}
    stat_check $?


    echo -e "${yellow} Loading the schema ${close}"
    mongo --host 172.31.92.161 </app/schema/catalogue.js  &>> ${log_file}
    stat_check $?
}


maven(){
  echo -e "${green} Installing Maven ${close}"
  dnf install maven -y  &>> ${log_file}
  stat_check $?

  app_setup


  echo -e "${yellow} Downloading  dependencies and building the application ${close}"
  cd /app &&  mvn clean package && mv target/shipping-1.0.jar shipping.jar  &>> ${log_file}
  stat_check $?


  conf
  service


  echo -e "${green} Installing mysql ${close}"
  dnf install mysql -y &>> ${log_file}
  stat_check $?

  echo -e "${yellow} schema loading ${close}"
  mysql -h 172.31.84.179 -uroot -pRoboShop@1 < /app/schema/${component}.sql   &>> ${log_file}
  stat_check $?

  echo -e "${yellow} restarting shipping service ${close}"
  systemctl restart ${component}   &>> ${log_file}
  stat_check $?
}

python(){
  echo -e "${green} installing python ${close}"
  dnf install python36 gcc python3-devel -y  &>> ${log_file}
  stat_check $?


  app_setup

  echo -e "${green} downloading dependencies ${close}"
  cd /app  && pip3.6 install -r requirements.txt  &>> ${log_file}
  stat_check $?

  conf
  service
}

golang(){
  echo -e "${green} Installing GoLang ${close}"
  dnf install golang -y   &>> ${log_file}
  stat_check $?

  app_setup

  echo -e "${green} Downloading dependencies ${close}"
  cd /app  &>> ${log_file}
  go mod init dispatch &>> ${log_file}
  go get &>> ${log_file}
  go build  &>> ${log_file}
  stat_check $?

  conf
  service

}
