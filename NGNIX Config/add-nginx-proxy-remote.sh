#!/bin/bash

# Check if user provided the correct number of arguments
if [ "$#" -ne 4 ]; then
  echo "Usage: $0 <remote_user>@<remote_host> <domain> <ssl_certificate> <ssl_certificate_key>"
  exit 1
fi

# Variables
REMOTE="$1"               # e.g., user@remote_ip
DOMAIN="$2"               # e.g., example.com
SSL_CERT="$3"             # Path to SSL certificate
SSL_KEY="$4"              # Path to SSL certificate key

echo "Enter the backend server (e.g., http://127.0.0.1:8080):"
read BACKEND

# Temporary file for the new site configuration
TEMP_FILE="/tmp/${DOMAIN}.conf"

# Create Nginx reverse proxy configuration locally
cat > "$TEMP_FILE" <<EOL
server {
    listen 80;
    listen [::]:80;
    server_name $DOMAIN;
    return 302 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    ssl_certificate         /etc/ssl/${DOMAIN}_cert.pem;
    ssl_certificate_key     /etc/ssl/${DOMAIN}_key.pem;

    server_name $DOMAIN;
    location / {
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_cache_bypass \$http_upgrade;
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Methods 'GET, OPTIONS';
        add_header Access-Control-Allow-Headers 'DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range';
        if (\$request_method = 'OPTIONS') {
            add_header Access-Control-Max-Age 1728000;
            add_header Content-Type 'text/plain; charset=utf-8';
            add_header Content-Length 0;
            return 204;
        }
        proxy_pass $BACKEND;
    }
}
EOL

# Check on the remote server if the configuration already exists before uploading
ssh "$REMOTE" << EOF
if [ -f /etc/nginx/sites-available/$DOMAIN ]; then
    echo "Configuration for $DOMAIN already exists! Exiting."
    exit 1
fi
EOF

# Only upload the configuration if it doesn't already exist
if [ $? -eq 0 ]; then
    # Upload the configuration file to /tmp/ on the remote server
    scp "$TEMP_FILE" "$REMOTE:/tmp/$DOMAIN.conf"

    # Upload the SSL certificate and key files to the remote server
    scp "$SSL_CERT" "$REMOTE:/tmp/${DOMAIN}_cert.pem"
    scp "$SSL_KEY" "$REMOTE:/tmp/${DOMAIN}_key.pem"

    # Run commands on the remote server to move the files to the correct location
    ssh "$REMOTE" << EOF
    # Move the configuration file from /tmp/ to /etc/nginx/sites-available/ with sudo
    sudo mv /tmp/$DOMAIN.conf /etc/nginx/sites-available/$DOMAIN

    # Move the SSL certificate and key files to /etc/ssl/
    sudo mv /tmp/${DOMAIN}_cert.pem /etc/ssl/${DOMAIN}_cert.pem
    sudo mv /tmp/${DOMAIN}_key.pem /etc/ssl/${DOMAIN}_key.pem

    # Enable the site by creating a symbolic link
    sudo ln -s /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/$DOMAIN

    # Test Nginx configuration
    sudo nginx -t

    # Reload Nginx if the test is successful
    if [ \$? -eq 0 ]; then
        sudo systemctl restart nginx
        echo "$DOMAIN is now being proxied to $BACKEND"
    else
        echo "Nginx configuration test failed!"
        exit 1
    fi
EOF

    # Clean up local temporary file
    rm "$TEMP_FILE"
else
    echo "Aborting as configuration already exists."
fi
