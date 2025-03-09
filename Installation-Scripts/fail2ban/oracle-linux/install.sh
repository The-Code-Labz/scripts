#!/bin/bash

# Function to check for errors
check_error() {
    if [ $? -ne 0 ]; then
        echo "Error occurred during the installation process. Exiting."
        exit 1
    fi
}

# Update package list
echo "Updating package list..."
sudo dnf check-update
check_error

# Enable EPEL Repository
echo "Enabling EPEL repository..."
sudo dnf install -y oracle-epel-release-el8
check_error

# Install Fail2Ban
echo "Installing Fail2Ban..."
sudo dnf install -y fail2ban
if [ $? -ne 0 ]; then
    echo "Fail2Ban not found in the repository. Installing via pip..."
    
    # Install Required Dependencies
    echo "Installing Python3 and pip..."
    sudo dnf install -y python3 python3-pip
    check_error
    
    # Install Fail2Ban using pip
    echo "Installing Fail2Ban using pip..."
    sudo pip3 install fail2ban
    check_error
    
    # Create Fail2Ban systemd service file
    echo "Creating Fail2Ban service file..."
    sudo bash -c 'cat > /etc/systemd/system/fail2ban.service <<EOF
[Unit]
Description=Fail2Ban Service
After=network.target

[Service]
ExecStart=/usr/local/bin/fail2ban-server -b
ExecStop=/usr/bin/killall fail2ban-server
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF'
    check_error
fi

# Start and enable Fail2Ban service
echo "Starting and enabling Fail2Ban service..."
sudo systemctl daemon-reload
sudo systemctl start fail2ban
sudo systemctl enable fail2ban
check_error

# Check status of Fail2Ban service
echo "Checking Fail2Ban service status..."
sudo systemctl status fail2ban --no-pager
check_error

echo "Fail2Ban installation complete!"