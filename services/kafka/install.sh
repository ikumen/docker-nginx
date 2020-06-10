#!/bin/bash
#
# Builds the Kafka docker container and installs it as a systemd service.
# 
source ../helpers

# Grab the directory where this script is located and use that as working directory.
# https://stackoverflow.com/a/246128
WORKDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Get ready for installation.
cd $WORKDIR

# Pull the service name out of our docker compose file, and use it as the service name 
# for systemd. 
SERVICE="$(get_dc_service_name $WORKDIR/docker-compose.yml)"
if [ -z $SERVICE ]; then
  echo "Could not determine service name"
  exit 1
fi

# Build the container image
/usr/bin/docker-compose -f docker-compose.yml up --no-start

# If applicable, install our service into systemd
SERVICE_FILE="/etc/systemd/system/${SERVICE}.service"
if [ -f $SERVICE_FILE ]; then
  echo "${SERVICE} already installed to systemd!"
else
  echo "Installing ${SERVICE} to systemd"
  cat > $SERVICE_FILE << EOL
[Unit]
Description=${NETWORK}'s Kafka service
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

# clean up
unset SERVICE_FILE
unset SERVICE
unset WORKDIR 
