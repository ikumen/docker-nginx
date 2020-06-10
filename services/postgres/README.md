## Postgres Service
PostgreSQL server 

#### Prerequisites

Create the data directory.

```bash
sudo mkdir /data/postgres
sudo chmod -R 700 /data/postgres
```

#### Configure

Add any initialization script to `scripts` directory.

#### Install

Run the `durian-service` script to install our service.

```bash
# Install only
sudo POSTGRES_PASSWORD='...' ./durian-service -i postgres

# Start the service
sudo systemctl start postgres

# Check status
sudo systemctl status postgres
--or--
sudo ./durian-service -s
```

#### Uninstall

```bash
sudo ./durian-service -u postgres
```
