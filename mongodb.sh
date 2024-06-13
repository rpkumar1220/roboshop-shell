source common.sh
component=mongodb

echo -e "${green} Setting up mongo repo ${close}"
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> ${log_file}
stat_check $?


echo -e  "${yellow} Installing MongoDB ${close}"
dnf install mongodb-org -y  &>> ${log_file}
stat_check $?

echo -e "${cyan} Enabling and restarting mongod service ${close}"
systemctl enable mongod && systemctl start mongod  &>> ${log_file}
stat_check $?

echo -e "${magenta} Updating the listening address ${close}"
sed -i 's/127.0.0.1/0.0.0.0/'  /etc/mongod.conf  &>> ${log_file}
stat_check $?

echo -e "${yellow} Restarting the mongod service ${close}"
systemctl restart mongod  &>> ${log_file}
stat_check $?
