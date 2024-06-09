echo "installing python"
dnf install python36 gcc python3-devel -y

echo "Creating APP user"
useradd roboshop

echo "Creating APP directory"
mkdir /app

echo "Downloading and extracting payment component content"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip  && cd /app  && unzip /tmp/payment.zip


echo "downloading dependencies"
cd /app  && pip3.6 install -r requirements.txt

echo "Copying payment service file"
cp /home/centos/roboshop-shell/cart/payment.service /etc/systemd/system/payment.service

echo "Reloading Daemon"
systemctl daemon-reload

echo "Enabling and restarting payment service"
systemctl enable payment  && systemctl start payment