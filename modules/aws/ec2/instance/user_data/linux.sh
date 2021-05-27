#!/bin/bash
sudo yum -y install httpd
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --reload
echo "Hello Team" > /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd
