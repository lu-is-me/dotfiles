#!/bin/bash

current_value=$(hyprctl getoption cursor:no_hardware_cursors -j | jq -r '.int')

# Disaple it temporarily
hyprctl eval 'hl.config({ cursor = { no_hardware_cursors = 0 }})'
sleep 2s
# Reaply old value
# hyprctl eval "hl.config({ cursor = { no_hardware_cursors = $current_value }})"
hyprctl eval "hl.config({ cursor = { no_hardware_cursors = 1 }})"
# hyprctl reload
