## Nginx Service
[Nginx](//www.nginx.com) server that I've configured as a reverse proxy to my other services and provides the SSL layer for these services.

#### Prerequisites

Follow the instructions on [generating SSL certs first](../../#certbot-lets-encrypt-for-ssl-certificate), then come back here when done. After the certificates are generated, create the data directory to hold them&mdash;we'll eventually mount them as a volume for the container.

```bash
sudo mkdir -p /data/nginx/certs
sudo cp [some certbot/directory]/config/live/<domain>/\*.pem  /data/nginx/certs/
sudo chmod -R 700 /data/nginx
```

#### Configure

Modify the `config/nginx.conf` and `config/conf.d` to your needs.

#### Install

Run the `durian-service` script to install our service.

```bash
# Install only
sudo ./durian-service -i nginx

# Start the service
sudo systemctl start nginx

# Check status
sudo systemctl status nginx
--or--
sudo ./durian-service -s
```

#### Uninstall

```bash
sudo ./durian-service -u nginx
```
