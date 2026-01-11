#!/bin/bash

LAST_NOTIFY=0

while true
do
  
  BATTERY=$(cat /sys/class/power_supply/BAT1/capacity)
  STATUS=$(cat /sys/class/power_supply/BAT1/status)

  echo "$LAST_NOTIFY"
  
  if [[ "$STATUS" == "Discharging" ]] && [[ $LAST_NOTIFY -eq 0 ]]; then
    if [[ "$BATTERY" -eq '20' ]]; then
      notify-send "Bateria" "Al 20% de su capacidad"
      LAST_NOTIFY=6
    elif [[ "$BATTERY" -eq '10'  ]]; then
      notify-send "Bateria" "Al 10% de su capacidad"
      LAST_NOTIFY=6
    elif [[ "$BATTERY" -eq '5'  ]]; then
      notify-send "Bateria" "Al 5% de su capacidad"
      LAST_NOTIFY=6
    fi

  elif [[ $LAST_NOTIFY -gt 0 ]]; then
    LAST_NOTIFY=$((LAST_NOTIFY - 1))
  fi
  sleep 10s
done
