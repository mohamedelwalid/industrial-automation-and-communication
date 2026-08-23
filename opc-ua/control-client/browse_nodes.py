from asyncua import Client
import asyncio
import os

async def browse(node, level=0):
    name = await node.read_browse_name()
    print("  " * level + f"{name.Name} | {node.nodeid}")

    for child in await node.get_children():
        await browse(child, level + 1)

async def main():
    url = os.getenv("OPCUA_URL", "opc.tcp://localhost:4840")

    async with Client(url) as client:
        objects = client.get_objects_node()
        await browse(objects)

if __name__ == "__main__":
    asyncio.run(main())
