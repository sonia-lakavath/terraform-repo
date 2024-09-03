#!/bin/bash
# Update packages
sudo yum update -y

# Install Apache
sudo yum install -y httpd

# Start Apache
sudo systemctl start httpd

# Enable Apache to start on boot
sudo systemctl enable httpd

# Create a simple HTML page
echo "<h1>Welcome to My Web Server!</h1>" | sudo tee /var/www/html/index.html
