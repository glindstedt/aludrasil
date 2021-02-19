#!/bin/bash

if [[ -z "$VALHEIM_SERVER_NAME" ]]; then
    echo "Environment variable VALHEIM_SERVER_NAME must be set" 1>&2
    exit 1
fi
if [[ -z "$VALHEIM_WORLD" ]]; then
    echo "Environment variable VALHEIM_WORLD must be set" 1>&2
    exit 1
fi
if [[ -z "$VALHEIM_PASSWORD" ]]; then
    echo "Environment variable VALHEIM_PASSWORD must be set" 1>&2
    exit 1
fi

VALHEIM_DEDICATED_SERVER=896660
VALHEIM_INSTALL_DIR=/home/steam/valheim
VALHEIM_WORLD_LC=$(echo $VALHEIM_WORLD | tr '[:upper:]' '[:lower:]')
VALHEIM_SERVER_SCRIPT="/home/steam/${VALHEIM_WORLD_LC}_valheim_server.sh"
VALHEIM_SAVEDIR="/home/steam/${VALHEIM_WORLD_LC}_savedir"
VALHEIM_SYSTEMD_SERVICE="${VALHEIM_WORLD_LC}-valheim-server.service"

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

# Configure start script
cat > $VALHEIM_SERVER_SCRIPT << EOF
#!/bin/sh
export templdpath=\$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=./linux64:\$LD_LIBRARY_PATH
export SteamAppId=892970

echo "Starting server PRESS CTRL-C to exit"

# Tip: Make a local copy of this script to avoid it being overwritten by steam.
# NOTE: Minimum password length is 5 characters & Password cant be in the server name.
# NOTE: You need to make sure the ports 2456-2458 is being forwarded to your server through your local router & firewall.
./valheim_server.x86_64 \\
    -nographics \\
    -batchmode \\
    -port 2456 \\
    -name "$VALHEIM_SERVER_NAME" \\
    -world "$VALHEIM_WORLD" \\
    -savedir "$VALHEIM_SAVEDIR" \\
    -password "$VALHEIM_PASSWORD"

export LD_LIBRARY_PATH=\$templdpath
EOF

chmod +x $VALHEIM_SERVER_SCRIPT
EOT

sudo bash -c "cat > /etc/systemd/system/${VALHEIM_SYSTEMD_SERVICE} << EOF
[Unit]
Description=${VALHEIM_WORLD} Valheim Dedicated Server
Wants=network-online.target
After=syslog.target network.target nss-lookup.target network-online.target

[Service]
User=steam
WorkingDirectory=$VALHEIM_INSTALL_DIR
ExecStart=$VALHEIM_SERVER_SCRIPT

[Install]
WantedBy=multi-user.target
EOF"

sudo systemctl enable --now ${VALHEIM_SYSTEMD_SERVICE}
