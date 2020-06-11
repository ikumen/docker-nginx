## Zookeeper Service

[Zookeeper](https://zookeeper.apache.org/) server.

### Configure

- requires a `ZK_DATA_DIR` environment variable pointing to the directory where install script can create and mount to the container.
### Install / Uninstall

```bash
# Make sure we're in the services directory
cd <durian-server>/services

# Install the zookeeper service
sudo ./durian-service -i zookeeper

# Start the service
sudo systemctl start zookeeper

# Check the service status
sudo systemctl status zookeeper
--or--
sudo ./durian-service -s
```

To uninstall

```bash
cd <durian-server>/services

# uninstall
sudo ./durian-service -u zookeeper
```

The data directory (`ZK_DATA_DIR`) is left alone so you'll manually have to remove those.





