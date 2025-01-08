#!/usr/bin/env bash
python3 -m esptool write_flash 0 ./zig-out/bin/$1.bin