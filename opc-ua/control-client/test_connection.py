from asyncua import Client
import asyncio
import os

async def main():
    url = os.getenv("OPCUA_URL", "opc.tcp://localhost:4840")

    async with Client(url) as client:
        print(f"Connected to OPC UA server at {url}")

if __name__ == "__main__":
    asyncio.run(main())
