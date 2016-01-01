#!/usr/bin/env bash

esptool --port $1 --baud 115200 write_flash --flash_size 16m --flash_freq 80m \
        0x000000 firmware/rboot.bin
