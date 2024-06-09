echo "Installing redis rpm"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

echo "enabling the specific module"
dnf module enable redis:remi-6.2 -y

echo "Installing redis"
dnf install redis -y

echo "Updating the redis listen address"
sed -i 's/127.0.0.1/0.0.0.0/'  /etc/redis.conf   && sed -i 's/127.0.0.1/0.0.0.0/'  etc/redis/redis.conf

echo "enabling redis and restarting the service"
systemctl enable redis && systemctl start redis
