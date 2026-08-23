from asyncua import Client
import asyncio
import csv
from datetime import datetime
import os
from pathlib import Path

URL = os.getenv("OPCUA_URL", "opc.tcp://localhost:4840")
OUTPUT_FILE = Path(os.getenv("OPCUA_LOG_FILE", "data_log.csv"))

NODE_IDS = {
    "Photosensor1": "ns=2;i=106",
    "Photosensor5": "ns=2;i=130",
}

NODE_NAMES_BY_IDENTIFIER = {
    106: "Photosensor1",
    130: "Photosensor5",
}

class SubHandler:
    def __init__(self, writer):
        self.writer = writer

    def datachange_notification(self, node, val, data):
        del data
        timestamp = datetime.now().isoformat(timespec="milliseconds")
        sensor_name = NODE_NAMES_BY_IDENTIFIER.get(node.nodeid.Identifier, "Unknown")

        print(timestamp, sensor_name, val)
        self.writer.writerow([timestamp, sensor_name, val])

async def main():
    with OUTPUT_FILE.open("w", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)
        writer.writerow(["timestamp", "sensor", "value"])

        async with Client(URL) as client:
            handler = SubHandler(writer)
            sub = await client.create_subscription(100, handler)

            for node_id in NODE_IDS.values():
                await sub.subscribe_data_change(client.get_node(node_id))

            print("Logging Photosensor1 and Photosensor5...")
            print("Stop with Ctrl + C")

            while True:
                await asyncio.sleep(1)

if __name__ == "__main__":
    asyncio.run(main())
