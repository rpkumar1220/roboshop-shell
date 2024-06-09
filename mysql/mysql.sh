echo "Disabling the default mysql repo version"
dnf module disable mysql -y

echo "Copying mysql repo file"
cp /home/centos/roboshop-shell/mysql/mysql.repo /etc/yum.repos.d/mysql.repo

echo "Installing MySql"
dnf install mysql-community-server -y

echo "Enabling and restarting mysql service"
systemctl enable mysqld && systemctl start mysqld

echo "Setting up password for mysql DB"
mysql_secure_installation --set-root-pass RoboShop@1

echo "Checking the connection to DB"
mysql -uroot -pRoboShop@1

echo "Disconnecting from db"
\q