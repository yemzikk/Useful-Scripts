#!/bin/bash

# Check if user provided arguments
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <remote_user>@<remote_host> <domain>"
  exit 1
fi

# Variables
REMOTE="$1"   # e.g., user@remote_ip
DOMAIN="$2"   # e.g., example.com

# Run commands on the remote server to delete the reverse proxy site
ssh "$REMOTE" << EOF

# Check if the configuration exists
if [ -f /etc/nginx/sites-available/$DOMAIN ]; then

    # Remove the site configuration file and symbolic link
    sudo rm /etc/nginx/sites-available/$DOMAIN
    sudo rm /etc/nginx/sites-enabled/$DOMAIN

    # Ask user if they want to delete the SSL certificate and key
    read -p "Do you want to delete the SSL certificate and key for $DOMAIN? (y/n): " delete_cert
    if [ "\$delete_cert" == "y" ]; then
        # Remove the SSL certificate and key
        sudo rm /etc/ssl/${DOMAIN}_cert.pem
        sudo rm /etc/ssl/${DOMAIN}_key.pem
        echo "SSL certificate and key for $DOMAIN have been deleted."
    fi

    # Test Nginx configuration
    sudo nginx -t

    # If test is successful, reload Nginx
    if [ \$? -eq 0 ]; then
        sudo systemctl restart nginx
        echo "$DOMAIN has been removed successfully."
    else
        echo "Nginx configuration test failed!"
        exit 1
    fi

else
    echo "Configuration for $DOMAIN does not exist."
    exit 1
fi
EOF
