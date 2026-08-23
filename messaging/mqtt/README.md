# MQTT temperature telemetry

The MQTT laboratory used a Raspberry Pi and DS18B20 temperature sensor to
demonstrate lightweight publish/subscribe communication.

The publisher and subscriber were reconstructed from my submission records and
include a later dry-run option so the message flow can be checked without the
original sensor hardware.

```text
DS18B20 → Raspberry Pi publisher → MQTT broker → subscriber
```

## Skills demonstrated

- reading a Linux 1-Wire sensor interface;
- converting raw sensor data to degrees Celsius;
- connecting to an MQTT broker;
- publishing values to `rpi/temperature`;
- subscribing to and decoding the same topic; and
- separating data producers from consumers.

## Run with a broker

```bash
mosquitto
python subscriber/subscriber.py
python publisher/publisher.py --simulate 22.5 --count 5
```

The simulation option allows the messaging path to be reviewed without the
physical sensor. On Raspberry Pi, omit `--simulate` to use the DS18B20 input.
