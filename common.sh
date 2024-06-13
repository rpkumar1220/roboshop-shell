red="\e[31m"
green="\e[32m"
yellow="\e[33m"
blue="\e[34m"
magenta="\e[36m"
cyan="\e[36m"
close="\e[0m"



nodejs(){
    echo -e "${cyan} Setting up NodeJS Repo ${close}"
    dnf module disable nodejs -y && dnf module enable nodejs:18 -y

    echo -e "${green} Installing NodeJS RPM ${close}"
    dnf install nodejs -y

    app_setup

    echo -e "${blue} Downloading NodeJS Dependencies${close}"
    cd /app && npm install

    conf
    service
}



app_setup(){
    echo -e "${yellow} Adding APP user ${close}"
    useradd roboshop

    echo -e "${yellow} Creating APP directory ${close}"
    mkdir /app

    echo -e "${blue} Downloading ${component} content and extracting it ${close}"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip && cd /app && unzip /tmp/${component}.zip
}


conf(){
    echo -e  "${magenta} Copying ${component} service file ${close}"
    cp /home/centos/roboshop-shell/${component}.service /etc/systemd/system/${component}.service

}

service(){
    echo -e "${yellow} Reloading Daemon ${close}"
    systemctl daemon-reload

    echo -e "${yellow} Enabling and restarting ${component} service ${close}"
    systemctl enable ${component} && systemctl start ${component}
}


mongodb_setup(){
    echo -e "${cyan} setting up mongodb repo ${close}"
    cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

    echo -e "${yellow} Installing mongodb client ${close}"
    dnf install mongodb-org-shell -y

    echo -e "${yellow} Loading the schema ${close}"
    mongo --host 172.31.92.161 </app/schema/catalogue.js
}


maven(){
  echo -e "${green} Installing Maven ${close}"
  dnf install maven -y

  app_setup

  echo -e "${yellow} Downloading  dependencies and building the application ${close}"
  cd /app &&  mvn clean package && mv target/shipping-1.0.jar shipping.jar

  conf
  service

  echo -e "${green} Installing mysql ${close}"
  dnf install mysql -y

  echo -e "${yellow} schema loading ${close}"
  mysql -h 172.31.84.179 -uroot -pRoboShop@1 < /app/schema/shipping.sql


  echo -e "${yellow} restarting shipping service ${close}"
  systemctl restart ${component}
}

python(){
  echo -e "${green} installing python ${close}"
  dnf install python36 gcc python3-devel -y

  app_setup

  echo -e "${green} downloading dependencies ${close}"
  cd /app  && pip3.6 install -r requirements.txt

  conf
  service
}

golang(){
  echo -e "${green} Installing GoLang ${close}"
  dnf install golang -y

  app_setup

  echo -e "${green} Downloading dependencies ${close}"
  cd /app  &&  go mod init dispatch && go get && go build

  conf
  service

}

