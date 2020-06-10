## Nginx Reverse Proxy Service
`nginx-rev-proxy` service is just a basic [Nginx](//www.nginx.com) server that I've configured as a reverse proxy to my other services and provides the SSL layer for these services.

#### Prerequisites

Follow the instructions on [generating SSL certs first](https://github.com/ikumen/durian-server#certbot-lets-encrypt-for-ssl-certificate), then come back here when done. After the certificates are generated, create the data directory to hold them&mdash;we'll eventually mount them as a volume for the container.

```bash
sudo mkdir -p /data/nginx/certs
sudo cp [some certbot/directory]/config/live/<domain>/\*.pem  /data/nginx/certs/
sudo chmod -R 700 /data/nginx
```

#### Configure

- modify the `config/nginx.conf` and `config/conf.d` to your needs

#### Install

Run the `durian-service` script to install our service.

```bash
# Install only
sudo ./durian-service -i nginx-rev-proxy

# Start the service
sudo systemctl start nginx-rev-proxy

# Check status
sudo systemctl status nginx-rev-proxy
--or--
sudo ./durian-service -s
```

#### Uninstall

```bash
sudo ./durian-service -u nginx-rev-proxy
```
