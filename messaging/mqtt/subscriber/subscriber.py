#!/usr/bin/env python3
"""Subscribe to Raspberry Pi temperature telemetry."""

from __future__ import annotations

import argparse

import paho.mqtt.client as mqtt


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--broker", default="localhost")
    parser.add_argument("--port", type=int, default=1883)
    parser.add_argument("--topic", default="rpi/temperature")
    return parser.parse_args()


def main() -> None:
    args = parse_args()

    def on_connect(client, userdata, flags, reason_code, properties):
        del userdata, flags, properties
        if reason_code != 0:
            raise RuntimeError(f"Broker connection failed: {reason_code}")
        print(f"Connected to {args.broker}:{args.port}")
        client.subscribe(args.topic)

    def on_message(client, userdata, message):
        del client, userdata
        payload = message.payload.decode("utf-8", errors="replace")
        print(f"Received: {payload} °C")

    client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
    client.on_connect = on_connect
    client.on_message = on_message
    client.connect(args.broker, args.port, 60)
    client.loop_forever()


if __name__ == "__main__":
    main()
