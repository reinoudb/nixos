#!/bin/sh

wg=$(ifconfig | grep -o 'wg[0-9]*')

if [ -z "$wg" ]; then
  echo "leeg"
else
  echo "vol"
fi

