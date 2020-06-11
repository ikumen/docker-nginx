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

- requires `CERTS_DIR` environment variable that points to the certificates generated above
- requires `NGINX_DATA_DIR` environment variable that points to the data directory for nginx
- optional, modify `config/nginx.conf` and `config/conf.d` to your needs

### Install / Uninstall

```bash
# Make sure we're in the services directory
cd <durian-server>/services

# Install the nginx service
sudo ./durian-service -i nginx

# Start the service
sudo systemctl start nginx

# Check the service status
sudo systemctl status nginx
--or--
sudo ./durian-service -s
```

To uninstall

```bash
cd <durian-server>/services

# uninstall
sudo ./durian-service -u nginx
```

The data directory (`NGINX_DATA_DIR`) is left alone so you'll manually have to remove those.





