#!/bin/bash

VALHEIM_DEDICATED_SERVER=896660
VALHEIM_INSTALL_DIR=/home/steam/valheim

sudo su - steam <<EOT
cd ~

# Install valheim
steamcmd +login anonymous +force_install_dir $VALHEIM_INSTALL_DIR +app_update $VALHEIM_DEDICATED_SERVER validate +quit
EOT
