source common.sh

echo -e "${red} Disabling the default mysql repo version ${close}"
dnf module disable mysql -y &>> ${log_file}
stat_check $?

echo -e "${yellow} Copying mysql repo file ${close}"
cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo  &>> ${log_file}
stat_check $?

echo -e "${green} Installing MySql ${close}"
dnf install mysql-community-server -y  &>> ${log_file}
stat_check $?

echo -e "${yellow} Enabling and restarting mysql service ${close}"
systemctl enable mysqld && systemctl start mysqld  &>> ${log_file}
stat_check $?

echo -e "${magenta} Setting up password for mysql DB ${close}"
mysql_secure_installation --set-root-pass RoboShop@1  &>> ${log_file}
stat_check $?

echo -e "${blue} Checking the connection to DB ${close}"
mysql -uroot -pRoboShop@1  &>> ${log_file}
stat_check $?
