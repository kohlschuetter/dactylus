#!/bin/sh
# dactylus
# Make SFP+ DAC transceivers run at SFP28 speeds (25Gbps)
# Copyright 2026 Christian Kohlschütter
# SPDX-License-Identifier: Apache-2.0
# Also see: https://kohlschuetter.github.io/blog/posts/2026/03/22/unlock25/

# Defaults for BananaPi BPI-R3, "SFP2" slot
# Change these settings as necessary
gpio="i2c-gpio-1"
dev="/dev/i2c-2"
eth="sfp2"

dirn=$(dirname $0)
set -x
set -e
yes | i2cdetect "$gpio"
i2csfp "$dev" i2cdump 0x50
i2csfp "$dev" i2cdump 0x51
ethtool -m "$eth"
"$dirn/update-sfp.sh" "$dev"
