echo "Configuring YUM repo from script vendor"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

echo "configuring yum repo for Rabbitmq"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo "Installing Rabbitmq"
dnf install rabbitmq-server -y

echo "Enabling and Starting rabbitmq service"
systemctl enable rabbitmq-server && systemctl start rabbitmq-server

echo "creating user and setting permissions"
rabbitmqctl add_user roboshop roboshop123 && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"