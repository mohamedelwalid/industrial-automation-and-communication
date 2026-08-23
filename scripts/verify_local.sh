#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tcp_dir="$repo_root/networking/tcp-ip"
c_foundations_dir="$repo_root/foundations/c/concurrency"
c_build_dir="$(mktemp -d -t industrial-automation-c.XXXXXX)"
port="${PORT:-5077}"
server_log="$(mktemp -t industrial-automation-server.XXXXXX)"
server_pid=""

cleanup() {
  if [[ -n "$server_pid" ]]; then
    kill "$server_pid" 2>/dev/null || true
    wait "$server_pid" 2>/dev/null || true
  fi
  make -C "$tcp_dir" clean >/dev/null
  rm -f "$server_log"
  rm -rf "$c_build_dir"
}

trap cleanup EXIT

echo "[1/5] Compiling selected C foundations"
cc -std=c11 -Wall -Wextra -Wpedantic \
  "$c_foundations_dir/process_memory.c" -o "$c_build_dir/process_memory"
cc -std=c11 -Wall -Wextra -Wpedantic -pthread \
  "$c_foundations_dir/thread_memory.c" -o "$c_build_dir/thread_memory"
cc -std=gnu11 -Wall -Wextra -Wpedantic -pthread \
  "$c_foundations_dir/mutex_sync.c" -o "$c_build_dir/mutex_sync"

"$c_build_dir/process_memory" >/dev/null
"$c_build_dir/thread_memory" >/dev/null
"$c_build_dir/mutex_sync" >/dev/null

echo "[2/5] Compiling TCP/IP client and server"
make -C "$tcp_dir" clean all

echo "[3/5] Running local TCP/IP round-trip"
"$tcp_dir/server/socket_server" "$port" >"$server_log" 2>&1 &
server_pid=$!

for _ in {1..30}; do
  if response=$("$tcp_dir/client/socket_client" 127.0.0.1 "$port" "Portfolio verification" 2>/dev/null); then
    echo "$response"
    break
  fi
  sleep 0.1
done

if [[ "${response:-}" != *"portfolio verification"* ]]; then
  echo "TCP/IP round-trip failed" >&2
  cat "$server_log" >&2
  exit 1
fi

echo "[4/5] Checking Python and MQTT dry-run"
python3 -m compileall -q "$repo_root/opc-ua" "$repo_root/messaging"
python3 "$repo_root/messaging/mqtt/publisher/publisher.py" --simulate 22.5 --count 1 --dry-run

echo "[5/5] Checking original PLC evidence"
test -s "$repo_root/plc/ladder/ld-schematic.png"
test -s "$repo_root/plc/ladder/ld-variable-table.png"
test -s "$repo_root/plc/sfc/sfc-schematic.png"
test -s "$repo_root/plc/sfc/sfc-variable-table.png"

echo "Local verification passed"
