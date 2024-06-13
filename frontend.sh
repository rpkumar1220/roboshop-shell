source common.sh
component=frontend


echo -e "${green} Installing the nginx server ${close}"
dnf install nginx -y   &>> ${log_file}
stat_check $?

echo -e "${yellow} Enabling and restarting nginx service ${close}"
systemctl enable nginx &>> ${log_file}
 systemctl start nginx &>> ${log_file}
 stat_check $?

echo -e "${red} Removing the default content from Index ${close}"
rm -rf /usr/share/nginx/html/* &>> ${log_file}
stat_check $?

echo -e "${blue} Downloading the ${component} content ${close}"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>> ${log_file}
stat_check $?

echo -e "${magenta} Extracting the content ${close}"
cd /usr/share/nginx/html  && unzip /tmp/${component}.zip &>> ${log_file}
stat_check $?

echo -e "${cyan} Copying the configuration file ${close}"
cp /home/centos/roboshop-shell/roboshop.conf  /etc/nginx/default.d/roboshop.conf  &>> ${log_file}
stat_check $?

echo -e "${yellow} restarting the nginx server ${close}"
systemctl restart nginx &>> ${log_file}
stat_check $?
