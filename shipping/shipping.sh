echo "Enabling the specific version of NodeJS module"
dnf module disable nodejs -y && dnf module enable nodejs:18 -y

echo "Installing Maven"
dnf install maven -y

echo "Creating APP user"
useradd roboshop

echo "Creating APP directory"
mkdir /app

echo "Downloading and extracting shipping component content"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip  && cd /app  && unzip /tmp/shipping.zip

echo "Downloading  dependencies and building the application"
cd /app &&  mvn clean package && mv target/shipping-1.0.jar shipping.jar

echo "Copying shipping service file"
cp /home/centos/roboshop-shell/shipping/shipping.service /etc/systemd/system/shipping.service

echo "Reloading Daemon"
systemctl daemon-reload

echo "Enabling and restarting shipping service"
systemctl enable shipping  && systemctl start shipping


echo "Installing mysql client"
dnf install mysql -y

echo "loading schema"
mysql -h MYSQL-SERVER-IPADDRESS -uroot -pRoboShop@1 < /app/schema/shipping.sql

echo "restarting shipping service"
systemctl restart shipping