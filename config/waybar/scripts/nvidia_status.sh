#!/usr/bin/env bash

# Check the line "Suspended" vs "Active" in supergfxctl output
state=$(cat /sys/bus/pci/devices/0000:01:00.0/power/runtime_status 2>/dev/null)

if grep -q "suspended" <<<"$state"; then
  printf '{"text":"󰢮","class":"suspended"}'
else
  printf '{"text":"󰢮","class":"active"}'
fi
