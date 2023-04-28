#!/bin/bash

# Update the package list and install required packages
sudo apt-get update
sudo apt-get -y install python3-minimal build-essential python3-setuptools python3-dev python3-wheel libffi-dev libssl-dev

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Create the ERPNext directory and navigate to it
sudo mkdir /opt/erpnext
cd /opt/erpnext

# Create the docker-compose.yml file
sudo tee docker-compose.yml <<EOF
version: '3'
services:
  erpnext:
    image: frappe/erpnext:latest
    ports:
      - "80:80"
    volumes:
      - erpnext-socket:/var/run/mysqld
      - erpnext-backups:/home/frappe/frappe-bench/sites/site1.local/private/backups
      - erpnext-conf:/etc/nginx/conf.d
      - erpnext-logs:/var/log
    environment:
      - "DB_ROOT_USER=root"
      - "DB_ROOT_PASSWORD=admin"
      - "MYSQL_ROOT_PASSWORD=admin"
      - "MYSQL_DATABASE=erpnext"
    restart: always
volumes:
  erpnext-socket:
  erpnext-backups:
  erpnext-conf:
  erpnext-logs:
EOF

# Start the ERPNext container
sudo docker-compose up -d

echo "ERPNext installation complete! You should now be able to access the site at http://localhost."
