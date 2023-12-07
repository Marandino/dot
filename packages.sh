#!/bin/bash

# Update mirror list
echo "Optimizing mirror list..."
sudo pacman-mirrors --continent --fasttrack 5 && sudo pacman -Syyu

# Installing Core Packages
echo "Installing core packages..."
sudo pacman -S --needed base-devel yay snapd lightdm obsidian zsh flameshot
sudo snap install core

# Enabling and starting the snapd service
sudo systemctl enable --now snapd.socket

# Creating a symlink for snap
sudo ln -s /var/lib/snapd/snap /snap

# Installing Zsh
echo "Installing Zsh..."
sudo pacman -S zsh

# Change default shell to zsh for the current user
chsh -s $(which zsh)

# Now we will switch to zsh and install NVM and Oh My Zsh
echo "Switching to Zsh to install nvm, Node.js, npm, and Oh My Zsh..."

# Using zsh to execute the install commands for nvm and Oh My Zsh
zsh << 'EOF'
    # Install nvm (Node Version Manager), Node.js, and npm
    echo "Installing nvm, Node.js, and npm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | zsh
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install 18

    # Install Oh My Zsh
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # Make sure the current shell instance has access to nvm and other cmds
    source $HOME/.zshrc
EOF

# Installing Work Related Packages
echo "Installing work-related packages..."
sudo pacman -S github-cli openvpn3 pkg-config slack-desktop

# Bluetooth Stuff
sudo pacman -S bluez bluez-utils
sudo systemctl enable --now bluetooth.service

# Optional Package Prompt
read -p "Do you want to install optional packages (Handbrake, Android Studio, Partition Manager)? [y/N] " response
if [[ "$response" =~ ^[yY]$ ]]
then
    echo "Installing optional packages..."
    sudo pacman -S handbrake android-studio partitionmanager
fi

# Android Studio, Stremio, Steam, GParted, Ngrok, Pavucontrol, Thunderbird
echo "Installing essential entertainment and utility packages..."
sudo pacman -S stremio steam gparted ngrok pavucontrol thunderbird

# Install Snap Packages
echo "Installing Docker, Discord, Spotify, Super Productivity, and Postman..."
sudo snap install docker discord spotify superproductivity postman
echo "Installing Heroku and VS Code..."
sudo snap install heroku code --classic
