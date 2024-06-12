source common.sh


echo -e "${green} Installing redis rpm ${close}"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

echo -e "${yellow} enabling the specific module ${close}"
dnf module enable redis:remi-6.2 -y

echo -e "${green} Installing redis ${close}"
dnf install redis -y

echo -e "${yellow} Updating the redis listen address ${close}"
sed -i 's/127.0.0.1/0.0.0.0/'  /etc/redis.conf   && sed -i 's/127.0.0.1/0.0.0.0/'  /etc/redis/redis.conf

echo -e "${yellow} enabling redis and restarting the service ${close}"
systemctl enable redis && systemctl start redis
