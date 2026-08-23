from asyncua import Client
import asyncio
import os

URL = os.getenv("OPCUA_URL", "opc.tcp://localhost:4840")

async def main():
    async with Client(URL) as client:
        mill = client.get_node("ns=2;i=71")
        drill = client.get_node("ns=2;i=88")

        mill_start = client.get_node("ns=2;i=77")
        mill_stop = client.get_node("ns=2;i=79")

        drill_start = client.get_node("ns=2;i=94")
        drill_stop = client.get_node("ns=2;i=96")

        print("Connected to OPC UA server")

        while True:
            print("\nChoose command:")
            print("1 = Start Mill")
            print("2 = Stop Mill")
            print("3 = Start Drill")
            print("4 = Stop Drill")
            print("q = Quit")

            choice = input("> ")

            if choice == "1":
                await mill.call_method(mill_start)
                print("Mill started")

            elif choice == "2":
                await mill.call_method(mill_stop)
                print("Mill stopped")

            elif choice == "3":
                await drill.call_method(drill_start)
                print("Drill started")

            elif choice == "4":
                await drill.call_method(drill_stop)
                print("Drill stopped")

            elif choice == "q":
                break

            else:
                print("Invalid choice")

if __name__ == "__main__":
    asyncio.run(main())
