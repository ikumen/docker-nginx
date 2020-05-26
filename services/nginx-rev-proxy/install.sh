#!/bin/bash
#
# Builds the nginx-rev-proxy service (docker container) and install it
# as a systemd service.
# 
# TODO: 
#   - pretty rough right now, makes a lot of assumptions
#   - error handling
#   - conditional build, take optional arguments to force build
#   - parameterized network
#   - uninstall option
#

# Grab the directory where this script is located and use that as working directory.
# https://stackoverflow.com/a/246128
WORKDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export NETWORK="$(hostname)"

# Get ready for installation.
cd $WORKDIR

# Pull the service name out of our docker compose file, and use it as the service name 
# for systemd. 
# https://stackoverflow.com/a/7451478 (gets line after services:)
# https://unix.stackexchange.com/a/205854 (trims the line)
# https://unix.stackexchange.com/a/187920 (removes the trailing ':')
s=$(sed -n '/services:/{n;p;}' docker-compose.yml | awk '{$1=$1};1')
SERVICE=${s%:} ${s##*}

# Create a Docker network (based on hostname)
/usr/bin/docker network inspect $NETWORK >/dev/null 2>&1 || \
  /usr/bin/docker network create --attachable --driver bridge $NETWORK

# Build the container image
cd $WORKDIR && mkdir -p config/certs && cp ${CERTS_DIRECTORY:?}/* config/certs/
/usr/bin/docker-compose -f docker-compose.yml up --no-start

# If applicable, install our service into systemd
SERVICE_FILE="/etc/systemd/system/${SERVICE}.service"
if [ -f $SERVICE_FILE ]; then
  echo "${SERVICE} already installed to systemd!"
else
  echo "Installing ${SERVICE} to systemd"
  cat > $SERVICE_FILE << EOL
[Unit]
Description=${NETWORK}'s Nginx reverse proxy service
After=docker.service
Wants=network-online.target docker.socket
Requires=docker.socket

[Service]
Restart=always
ExecStart=/usr/bin/docker start -a ${SERVICE}
ExecStop=/usr/bin/docker stop -t 2 ${SERVICE}

[Install]
WantedBy=multi-user.target
EOL
fi
 
