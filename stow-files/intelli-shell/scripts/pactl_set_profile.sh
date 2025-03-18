#!/bin/bash

## Sets pulseaudio profile for a convinient list of pre-defined cards
pactl set-card-profile \
  $(pactl -f json list | jq '.cards[] | select(.properties."device.alias"=="Jabra Evolve2 85")| .index') \
  $(pactl -f json list | jq '.cards[] | select(.properties."device.alias"=="Jabra Evolve2 85") | .profiles | to_entries[] | .key ' | tr -d '"' | fzf)
