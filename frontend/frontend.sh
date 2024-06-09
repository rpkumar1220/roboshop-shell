echo "Installing the nginx server"
dnf install nginx -y

echo "Enabling and restarting nginx service"
systemctl enable nginx && systemctl start nginx

echo "Removing the default content from Index"
rm -rf /usr/share/nginx/html/*

echo "Downloading the frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo "Extracting the content"
cd /usr/share/nginx/html  && unzip /tmp/frontend.zip

echo "Copying the configuration file"
cp /home/centos/roboshop-shell/frontend/roboshop.conf  /etc/nginx/default.d/roboshop.conf

echo "restarting the nginx server"
systemctl restart nginx

