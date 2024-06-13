source common.sh


echo -e "${green} Installing redis rpm ${close}"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> ${log_file}

echo -e "${yellow} enabling the specific module ${close}"
dnf module enable redis:remi-6.2 -y &>> ${log_file}

echo -e "${green} Installing redis ${close}"
dnf install redis -y &>> ${log_file}

echo -e "${yellow} Updating the redis listen address ${close}"
sed -i 's/127.0.0.1/0.0.0.0/'  /etc/redis.conf &>> ${log_file}
sed -i 's/127.0.0.1/0.0.0.0/'  /etc/redis/redis.conf  &>> ${log_file}

echo -e "${yellow} enabling redis and restarting the service ${close}"
systemctl enable redis &>> ${log_file}
 systemctl start redis &>> ${log_file}
