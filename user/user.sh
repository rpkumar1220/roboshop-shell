echo "Enabling the specific version of NodeJS module"
dnf module disable nodejs -y && dnf module enable nodejs:18 -y

echo "Installing NodeJS"
dnf install nodejs -y

echo "Creating APP user"
useradd roboshop

echo "Creating APP directory"
mkdir /app

echo "Downloading and extracting user component content"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip  && cd /app  && unzip /tmp/user.zip

echo "Installing NodeJS dependencies"
cd /app  &&  npm install

echo "Copying cart service file"
cp /home/centos/roboshop-shell/cart/user.service /etc/systemd/system/user.service

echo "Reloading Daemon"
systemctl daemon-reload

echo "Enabling and restarting user service"
systemctl enable user  && systemctl start user