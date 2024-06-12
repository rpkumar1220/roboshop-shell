red=\e[31m
green=\e[32m
yellow=\e[33m
blue=\e[34m
magenta=\e[36m
cyan=\e[36m
close=\e[0m



nodejs(){
    echo "${cyan} Setting up NodeJS Repo ${close}"
    dnf module disable nodejs -y && dnf module enable nodejs:18 -y

    echo "${green} Installing NodeJS RPM ${close}"
    dnf install nodejs -y

    app_setup

    echo "${blue} Downloading NodeJS Dependencies${close}"
    cd /app && npm install

    conf
    service
}



app_setup(){
    echo "${yellow} Adding APP user ${close}"
    useradd roboshop

    echo "${yellow} Creating APP directory ${close}"
    mkdir /app

    echo "${blue} Downloading ${component} content and extracting it ${close}"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip && cd /app && unzip /tmp/${component}.zip
}


conf(){
    echo "${magenta} Copying ${component} service file ${close}"
    cp /home/centos/roboshop-shell/${component}.service /etc/systemd/system/${component}.service

}

service(){
    echo "${yellow} Reloading Daemon ${close}"
    systemctl daemon-reload

    echo "${yellow} Enabling and restarting ${component} service ${close}"
    systemctl enable ${component} && systemctl start ${component}
}


mongodb_setup(){
    echo "${cyan} setting up mongodb repo ${close}"
    cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

    echo "${yellow} Installing mongodb client ${close}"
    dnf install mongodb-org-shell -y

    echo "${yellow} Loading the schema ${close}"
    mongo --host 172.31.27.147 </app/schema/catalogue.js
}


maven(){
  echo "${green} Installing Maven ${close}"
  dnf install maven -y

  app_setup

  echo "${yellow} Downloading  dependencies and building the application ${close}"
  cd /app &&  mvn clean package && mv target/shipping-1.0.jar shipping.jar

  conf
  service
  mongodb_setup

  echo "restarting shipping service"
  systemctl restart ${component}
}

python(){
  echo "${green} installing python ${close}"
  dnf install python36 gcc python3-devel -y

  app_setup

  echo "${green} downloading dependencies ${close}"
  cd /app  && pip3.6 install -r requirements.txt

  conf
  service
}

golang(){
  echo "${green} Installing GoLang ${close}"
  dnf install golang -y

  app_setup

  echo "${green} Downloading dependencies ${close}"
  cd /app  &&  go mod init dispatch && go get && go build

  conf
  service

}

