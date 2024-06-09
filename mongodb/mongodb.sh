echo "Setting up mongo repo"
cp /home/centos/roboshop-shell/mongodb/mongo.repo /etc/yum.repos.d/mongo.repo


echo "Installing MongoDB"
dnf install mongodb-org -y

echo "Enabling and restarting mongod service"
systemctl enable mongod && systemctl start mongod

echo "Updating the listening address"
sed -i 's/127.0.0.1/0.0.0.0/'  /etc/mongod.conf

echo "Restarting the mongod service"
systemctl restart mongod
