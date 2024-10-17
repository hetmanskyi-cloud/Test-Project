#!/bin/bash

# Update the system and install necessary packages
apt-get update && apt-get upgrade -y
apt-get install -y nginx mysql-server php-fpm php-mysql

# Start and enable Nginx
systemctl start nginx
systemctl enable nginx

# Install WordPress
cd /tmp
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
cp -a /tmp/wordpress/. /var/www/html/

# Set permissions for WordPress
chown -R www-data:www-data /var/www/html
chmod -R 750 /var/www/html

# Configure Nginx for WordPress
cat > /etc/nginx/sites-available/wordpress << 'EOF'
server {
    listen 80;
    server_name your_domain_or_IP;

    root /var/www/html;
    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

# Enable the Nginx configuration for WordPress
ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
nginx -t && systemctl reload nginx

# Display a welcome message on the server
echo "<h1>Welcome to the WordPress Server</h1>" > /var/www/html/index.html
