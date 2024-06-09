echo "Installing GoLang"
dnf install golang -y

echo "Creating APP user"
useradd roboshop

echo "Creating APP directory"
mkdir /app

echo "Downloading and extracting dispatch component content"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip  && cd /app  && unzip /tmp/dispatch.zip

echo "Downloading dependencies"
cd /app  &&  go mod init dispatch && go get && go build

echo "Copying dispatch service file"
cp /home/centos/roboshop-shell/dispatch/dispatch.service /etc/systemd/system/dispatch.service

echo "Reloading Daemon"
systemctl daemon-reload

echo "Enabling and restarting dispatch service"
systemctl enable dispatch  && systemctl start dispatch
