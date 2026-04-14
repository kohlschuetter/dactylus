# dactylus

Make SFP+ DAC transceivers run at SFP28 speeds (25Gbps).

## How we got here

See the corresponding blog post: [Unlocking 25 Gigabit/s on 10 GbE Direct Attach Copper](https://kohlschuetter.github.io/blog/posts/2026/03/22/unlock25/).

## How to run this

This works best with OpenWrt 25.12, but as long as you have [`i2csfp`](https://github.com/ericwoud/i2csfp), you should be good. 

```sh
# Install dependencies (only needed once)
./install-dependencies.sh

# Dumps the current EEPROM data and config, then sets the cable to 25G speeds
# Important: Edit file to set the correct i2c device!!!
./info-and-update.sh

# Alternatively, just update directly (change the device as required)
./update-sfp.sh /dev/i2c-2
```

Make sure to run the update script for both ends of the DAC cable.

Test the cable performance with `iperf3`, including `--bidir` to saturate the connection. You should be getting speeds north of 23GBit/s on both directions when working with NVIDIA Mellanox ConnectX/4 cards.

## How to get from here

Please file a [Github issue](https://github.com/kohlschuetter/dactylus/issues) if you're having problems with certain cables.

## License

Copyright 2026 Christian Kohlschütter<br>
Apache 2.0
