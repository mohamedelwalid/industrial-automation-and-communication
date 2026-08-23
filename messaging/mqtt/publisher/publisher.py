#!/usr/bin/env python3
"""Publish DS18B20 temperature readings over MQTT."""

from __future__ import annotations

import argparse
import glob
import time
from pathlib import Path


DEFAULT_SENSOR_ROOT = Path("/sys/bus/w1/devices")


def discover_sensor(root: Path = DEFAULT_SENSOR_ROOT) -> Path:
    matches = glob.glob(str(root / "28*" / "w1_slave"))
    if not matches:
        raise FileNotFoundError(f"No DS18B20 sensor found below {root}")
    return Path(matches[0])


def read_temperature(sensor_file: Path) -> float:
    lines = sensor_file.read_text(encoding="utf-8").splitlines()
    if len(lines) < 2 or not lines[0].strip().endswith("YES"):
        raise ValueError("Sensor CRC check failed or sensor data is incomplete")

    marker = lines[1].find("t=")
    if marker < 0:
        raise ValueError("Temperature marker missing from sensor output")
    return float(lines[1][marker + 2 :]) / 1000.0


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--broker", default="localhost")
    parser.add_argument("--port", type=int, default=1883)
    parser.add_argument("--topic", default="rpi/temperature")
    parser.add_argument("--interval", type=float, default=2.0)
    parser.add_argument("--sensor-file", type=Path)
    parser.add_argument("--simulate", type=float, metavar="CELSIUS")
    parser.add_argument("--count", type=int, default=0, help="0 publishes until interrupted")
    parser.add_argument("--dry-run", action="store_true", help="print without connecting")
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    sensor_file = args.sensor_file
    if args.simulate is None and sensor_file is None:
        sensor_file = discover_sensor()

    client = None
    if not args.dry_run:
        import paho.mqtt.client as mqtt

        client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
        client.connect(args.broker, args.port, 60)
        client.loop_start()

    published = 0
    try:
        while args.count == 0 or published < args.count:
            temperature = (
                args.simulate if args.simulate is not None else read_temperature(sensor_file)
            )
            payload = f"{temperature:.2f}"
            if args.dry_run:
                print(f"{args.topic}: {payload} °C")
            else:
                assert client is not None
                result = client.publish(args.topic, payload)
                result.wait_for_publish()
                print(f"Published: {payload} °C")
            published += 1
            if args.count == 0 or published < args.count:
                time.sleep(args.interval)
    finally:
        if not args.dry_run:
            assert client is not None
            client.loop_stop()
            client.disconnect()


if __name__ == "__main__":
    main()
