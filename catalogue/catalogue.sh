echo "Setting up NodeJS Repo"
dnf module disable nodejs -y && dnf module enable nodejs:18 -y

echo "Installing NodeJS RPM"
dnf install nodejs -y

echo "Adding APP user"
useradd roboshop

echo "Creating APP directory"
mkdir /app

echo "Downloading catalogue content and extracting it"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip && cd /app && unzip /tmp/catalogue.zip

echo "Downloading NodeJS Dependencies"
cd /app && npm install

echo "Copying catalogue service file"
cp /home/centos/roboshop-shell/cart/catalogue.service /etc/systemd/system/catalogue.service

echo "Reloading Daemon"
systemctl daemon-reload

echo "Enabling and restarting catalogue service"
systemctl enable catalogue && systemctl start catalogue

echo "setting up mongodb repo"
cp /home/centos/roboshop-shell/mongodb/mongo.repo /etc/yum.repos.d/mongo.repo

echo "Installing mongodb client"
dnf install mongodb-org-shell -y

echo "Loading the schema"
mongo --host 172.31.20.224 </app/schema/catalogue.js