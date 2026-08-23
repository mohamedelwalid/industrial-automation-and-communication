# OPC UA clients

These scripts document the E11 workflow:

- `test_connection.py` verifies the endpoint.
- `browse_nodes.py` recursively inspects the address space.
- `control_client.py` invokes the documented mill and drill methods.
- `data_logger.py` subscribes to two photo sensors and writes timestamped CSV rows.

Configure the endpoint without editing source:

```bash
export OPCUA_URL=opc.tcp://localhost:4840
python opc-ua/control-client/test_connection.py
```

The logger output can also be configured:

```bash
export OPCUA_LOG_FILE=results/sample-data/opcua_sensor_log.csv
python opc-ua/data-logger/data_logger.py
```

The node IDs are specific to the course information model and must be checked
in UaExpert or with `browse_nodes.py` before a new deployment.
