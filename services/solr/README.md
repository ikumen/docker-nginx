## Solr Service

[Solr](https://lucene.apache.org/solr/) server.

### Configure

- requires a `SOLR_DATA_DIR` environment variable pointing to the directory where install script can create and mount to the container.
- to add cores (at the moment can be done after the service is installed):
  - stop the container `sudo systemctl stop solr` 
  - copy over the core config files (e.g, conf, core.properties) in the `SOLD_DATA_DIR/data/<core-name>`
  - restart the container `sudo systemctl start solr`

### Install / Uninstall

```bash
# Make sure we're in the services directory
cd <durian-server>/services

# Install the solr service
sudo ./durian-service -i solr

# Start the service
sudo systemctl start solr

# Check the service status
sudo systemctl status solr
--or--
sudo ./durian-service -s
```

To uninstall

```bash
cd <durian-server>/services

# uninstall
sudo ./durian-service -u solr
```

The data directory (`SOLR_DATA_DIR`) is left alone so you'll manually have to remove those.





