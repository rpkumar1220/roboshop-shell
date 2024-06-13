source  common.sh

echo -e "${cyan} Configuring YUM repo from script vendor ${close}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash  &>> ${log_file}

echo -e "${magenta} configuring yum repo for Rabbitmq ${close}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> ${log_file}

echo -e "${green} Installing Rabbitmq ${close}"
dnf install rabbitmq-server -y &>> ${log_file}

echo -e "${yellow} Enabling and Starting rabbitmq service ${close}"
systemctl enable rabbitmq-server && systemctl start rabbitmq-server &>> ${log_file}

echo -e "${blue} creating user and setting permissions ${close}"
rabbitmqctl add_user roboshop roboshop123 && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>> ${log_file}