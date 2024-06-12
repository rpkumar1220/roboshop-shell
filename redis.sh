source common.sh


echo "${green} Installing redis rpm ${close}"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

echo "${yellow} enabling the specific module ${close}"
dnf module enable redis:remi-6.2 -y

echo "${green} Installing redis ${close}"
dnf install redis -y

echo "${yellow} Updating the redis listen address ${close}"
sed -i 's/127.0.0.1/0.0.0.0/'  /etc/redis.conf   && sed -i 's/127.0.0.1/0.0.0.0/'  /etc/redis/redis.conf

echo "${yellow} enabling redis and restarting the service ${close}"
systemctl enable redis && systemctl start redis
