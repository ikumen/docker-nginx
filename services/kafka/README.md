## Kafka Service

[Kafka](https://kafka.apache.org/) server.

### Configure

- requires a `KAFKA_HOST_DATA_DIR` environment variable pointing to the directory where install script can create and mount to the container.

### Install / Uninstall

```bash
# Make sure we're in the services directory
cd <durian-server>/services

# Install the kafka service
sudo ./durian-service -i kafka

# Start the service
sudo systemctl start kafka

# Check the service status
sudo systemctl status kafka
--or--
sudo ./durian-service -s
```

To uninstall

```bash
cd <durian-server>/services

# uninstall
sudo ./durian-service -u kafka
```

The data directory (`KAFKA_DATA_DIR`) is left alone so you'll manually have to remove those.





