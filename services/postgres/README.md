## Postgres Service
[PostgreSQL](https://www.postgresql.org) server 

### Configure

- requires a `POSTGRES_PASSWORD` environment variable for the super `postgres` admin password
- requires a `POSTGRES_DATA_DIR` environment variable pointing to the directory where install script can create and mount to the container.
- optional, add any initialization scripts to the `<postgres>/scripts` directory 

### Install / Uninstall

```bash
# Make sure we're in the services directory
cd <durian-server>/services

# Install the postgres service
sudo ./durian-service -i postgres
--or--
sudo POSTGRES_DATA_DIR=... ./durian-service -i postgres

# Start the service
sudo systemctl start postgres

# Check the service status
sudo systemctl status postgres
--or--
sudo ./durian-service -s
```

To uninstall

```bash
cd <durian-server>/services

# uninstall
sudo ./durian-service -u postgres
```

The data directory (`POSTGRES_DATA_DIR`) is left alone so you'll manually have to remove those.

