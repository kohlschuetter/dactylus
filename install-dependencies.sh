#!/bin/sh
# dactylus
# Make SFP+ DAC transceivers run at SFP28 speeds (25Gbps)
# Copyright 2026 Christian Kohlschütter
# SPDX-License-Identifier: Apache-2.0

modprobe i2c-dev
apk add i2c-tools i2csfp
apk add ethtool-full || apk add ethtool
