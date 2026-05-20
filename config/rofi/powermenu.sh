#!/bin/bash

entries="⇠\tLogout\n⏾\tSuspend\n⭮\tReboot\n⏻\tShutdown"

selected=$(echo -e $entries | rofi -dmenu -i | awk '{print tolower($2)}')

case $selected in
logout)
  # hyprctl dispatch exit && uwsm stop
  exec hyprshutdown
  # hyprctl dispatch exit
  ;;
suspend)
  exec systemctl suspend
  ;;
reboot)
  exec hyprshutdown -t 'Restarting...' --post-cmd 'reboot'
  ;;
shutdown)
  exec hyprshutdown -t 'Shutting down...' --post-cmd 'shutdown -P 0'
  ;;
esac
