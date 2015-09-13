#!/bin/bash

function get_res {
    echo $(xrandr -q | awk -F'current' -F',' 'NR==1 {gsub("( |current)","");print $2}')
}

res1=$(get_res)

while true; do
  sleep 5
  res2=$(get_res)
  if [ "$res1" != "$res2" ]; then
      echo "Running refresh"
      bash "$HOME/.conky/conky-startup.sh"
  fi
  res1=$res2
done
