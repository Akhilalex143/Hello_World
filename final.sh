#!/bin/bash

# Install Docker and Docker Compose
sudo apt update
sudo apt install -y docker.io docker-compose

# Create the ERPNext Docker Compose file
sudo mkdir /opt/erpnext
sudo chown $USER:$USER /opt/erpnext
cd /opt/erpnext
cat <<EOT >> docker-compose.yml
version: '3'
services:
  erpnext:
    image: frappe/erpnext-worker:edge
    environment:
      - DB_ROOT_USER=root
      - DB_ROOT_PASSWORD=my-secret-pw
      - ADMIN_PASSWORD=my-secret-pw
      - DB_HOST=db
    volumes:
      - erpnext-assets:/assets
    depends_on:
      - db
    restart: always
  db:
    image: mariadb:10.5
    environment:
      - MYSQL_ROOT_PASSWORD=my-secret-pw
    volumes:
      - erpnext-db:/var/lib/mysql
    restart: always
volumes:
  erpnext-assets:
  erpnext-db:
EOT

# Start the ERPNext container
sudo docker-compose up -d

# Open the necessary ports in the firewall
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable





sudo docker ps
