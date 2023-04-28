#!/bin/bash

# Update the package list and install required packages
sudo apt-get update
sudo apt-get -y install python3-minimal build-essential python3-setuptools python3-dev python3-wheel libffi-dev libssl-dev mariadb-server

# Start the MySQL server and enable it to start on boot
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Secure the MySQL installation
sudo mysql_secure_installation <<EOF

y
admin
admin
y
y
y
y
EOF

# Create a new user and database for ERPNext
sudo mysql -u root -padmin -e "CREATE DATABASE erpnext;"
sudo mysql -u root -padmin -e "CREATE USER 'erpnext'@'localhost' IDENTIFIED BY 'password';"
sudo mysql -u root -padmin -e "GRANT ALL PRIVILEGES ON erpnext.* TO 'erpnext'@'localhost';"

# Install Node.js and Redis
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs redis-server

# Install ERPNext
sudo mkdir /opt/erpnext
cd /opt/erpnext
sudo git clone https://github.com/frappe/bench.git
sudo python3 -m pip install -e ./bench

# Create a new ERPNext site
sudo bench new-site erpnext.local --db-name erpnext --mariadb-root-password admin --admin-password admin

# Install and start the ERPNext service
sudo systemctl enable supervisor
sudo systemctl start supervisor
sudo bench setup production erpnext

echo "ERPNext installation complete! You should now be able to access the site at http://localhost:8080."
