source common.sh
component=frontend


echo -e "${greeen} Installing the nginx server ${close}"
dnf install nginx -y  

echo -e "${yellow} Enabling and restarting nginx service ${close}"
systemctl enable nginx && systemctl start nginx

echo -e "${red} Removing the default content from Index ${close}"
rm -rf /usr/share/nginx/html/*

echo -e "${blue} Downloading the ${component} content ${close}"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

echo -e "${magenta} Extracting the content ${close}"
cd /usr/share/nginx/html  && unzip /tmp/${component}.zip

echo -e "${cyan} Copying the configuration file ${close}"
cp /home/centos/roboshop-shell/roboshop.conf  /etc/nginx/default.d/roboshop.conf

echo -e "${yellow} restarting the nginx server ${close}"
systemctl restart nginx
