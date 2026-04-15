#!/bin/sh
#
# dactylus
# Make SFP+ DAC transceivers run at SFP28 speeds (25Gbps)
# Copyright 2026 Christian Kohlschütter
# SPDX-License-Identifier: Apache-2.0
# Also see: https://kohlschuetter.github.io/blog/posts/2026/03/22/unlock25/

dev="$1"
if [[ -z "$dev" ]]; then
  echo "Syntax: $0 <i2c-device, e.g., /dev/i2c-2>" >&2
  exit 1
fi
if [[ ! -e "$dev" ]]; then
  echo "Not found: $dev" >&2
  exit 1
fi

(
set -x
i2csfp "$dev" byte write 0x50 0x0c 0xff
i2csfp "$dev" byte write 0x50 0x42 0x68
#i2csfp "$dev" byte write 0x50 0x24 0x00
i2csfp "$dev" byte write 0x50 0x24 0x0d
)

hexA=
hexB=
IFS=$'\n'
for a in $(i2csfp "$dev" eepromfix 2>&1 | grep ", but should be"); do
  case "$a" in
    "Checksum 0x00-0x3e"*)
      hexA=${a#*should be }
      i2csfp "$dev" byte write 0x50 0x3f "0x$hexA"
     ;;
    "Checksum 0x40-0x5e"*)
      hexB=${a#*should be }
      i2csfp "$dev" byte write 0x50 0x5f "0x$hexB"
     ;;
  esac
done

if [[ -z "$hexA" ]]; then
  echo "Warning: Checksum at 0x3f did not change (either already changed or cannot write)" >&2
fi
if [[ -z "$hexB" ]]; then
  echo "Warning: Checksum at 0x5f did not change (either already changed or cannot write)" >&2
fi

for a in $(i2csfp "$dev" eepromfix 2>&1 | grep Checksum); do
  case "$a" in
    "Checksum 0x00-0x3e"*)
      hex=${a#*matched }
      if [[ -n "$hexA" && "$hexA" == "$hex" ]]; then
        echo "Checksum at 0x3f successfully changed to $hex"
      fi
     ;;
    "Checksum 0x40-0x5e"*)
      hex=${a#*matched }
      if [[ -n "$hexB" && "$hexB" == "$hex" ]]; then
        echo "Checksum at 0x5f successfully changed to $hex"
      fi
     ;;
  esac
done
