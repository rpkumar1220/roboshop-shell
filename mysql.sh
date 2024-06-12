source common.sh

echo "${red} Disabling the default mysql repo version ${close}"
dnf module disable mysql -y

echo "${yellow} Copying mysql repo file ${close}"
cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo

echo "${green} Installing MySql ${close}"
dnf install mysql-community-server -y

echo "${yellow} Enabling and restarting mysql service ${close}"
systemctl enable mysqld && systemctl start mysqld

echo "${magenta} Setting up password for mysql DB ${close}"
mysql_secure_installation --set-root-pass RoboShop@1

echo "${blue} Checking the connection to DB ${close}"
mysql -uroot -pRoboShop@1

