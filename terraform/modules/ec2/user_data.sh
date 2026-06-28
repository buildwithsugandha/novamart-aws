#!/bin/bash
set -e

# Update system and install dependencies
dnf update -y
dnf install -y nodejs npm git

# Create app directory
mkdir -p /opt/novamart
cd /opt/novamart

# Write environment config
cat > /opt/novamart/.env << ENV
NODE_ENV=${environment}
PORT=3000
DB_HOST=${db_host}
DB_NAME=${db_name}
DB_USER=${db_username}
DB_PASSWORD=${db_password}
ENV

# Create a minimal health-check app (replaced by real app in later phases)
cat > /opt/novamart/index.js << 'APP'
const http = require('http');
require('dotenv').config();

const server = http.createServer((req, res) => {
  if (req.url === '/health') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ status: 'ok', env: process.env.NODE_ENV }));
    return;
  }
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('NovaMart is running\n');
});

server.listen(process.env.PORT || 3000, () => {
  console.log('Server started on port ' + (process.env.PORT || 3000));
});
APP

# Install dotenv
npm install dotenv

# Create systemd service
cat > /etc/systemd/system/novamart.service << 'SERVICE'
[Unit]
Description=NovaMart Node.js Application
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/novamart
ExecStart=/usr/bin/node index.js
Restart=on-failure
EnvironmentFile=/opt/novamart/.env

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable novamart
systemctl start novamart