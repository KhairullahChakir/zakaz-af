#!/bin/bash

# Zakaz-AF VPS Setup Script
# Ubuntu 24.04 / Laravel 12 / PHP 8.3

set -e

echo "🚀 Starting Zakaz-AF Server Setup..."

# Update System
apt update && apt upgrade -y

# Install Essential Tools
apt install -y software-properties-common curl git unzip zip ufw supervisor

# Add PHP Repository
add-apt-repository ppa:ondrej/php -y
apt update

# Install PHP 8.3 & Extensions
apt install -y php8.3-fpm php8.3-cli php8.3-mysql php8.3-gd php8.3-curl php8.3-xml php8.3-mbstring php8.3-zip php8.3-bcmath php8.3-intl php8.3-readline php8.3-msgpack php8.3-igbinary php8.3-redis php8.3-sqlite3

# Install Nginx
apt install -y nginx

# Install MySQL
apt install -y mysql-server

# Install Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Configure Firewall
ufw allow 'Nginx Full'
ufw allow OpenSSH
ufw --force enable

# Create Website Directory
mkdir -p /var/www/zakaz-af
chown -R www-data:www-data /var/www/zakaz-af

# Configure Nginx for Laravel
cat <<EOF > /etc/nginx/sites-available/zakaz-af
server {
    listen 80;
    server_name 185.197.31.25;
    root /var/www/zakaz-af/public;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";

    index index.php;

    charset utf-8;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$realpath_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
EOF

ln -sf /etc/nginx/sites-available/zakaz-af /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Restart Nginx
system_service nginx restart || service nginx restart

echo "✅ Server software installed successfully!"
echo "----------------------------------------"
echo "Next step: git clone your repository into /var/www/zakaz-af"
