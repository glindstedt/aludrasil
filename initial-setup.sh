#!/bin/bash

VALHEIM_DEDICATED_SERVER=896660
VALHEIM_INSTALL_DIR=/home/steam/valheim

# Setup dependencies
sudo add-apt-repository multiverse
sudo dpkg --add-architecture i386
sudo apt-get update
# Steam has some interactive license agreement here
sudo apt-get install -y lib32gcc1 steamcmd

# Create user
sudo useradd -s /bin/bash -m steam
sudo su - steam <<EOT
cd ~

# Install valheim
steamcmd +login anonymous +force_install_dir $VALHEIM_INSTALL_DIR +app_update $VALHEIM_DEDICATED_SERVER validate +quit
EOT
