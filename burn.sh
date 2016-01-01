#!/usr/bin/env bash

SDK_BASE=/opt/Expressif/sdk-1.5.0

esptool --port $1 --baud 115200 write_flash --flash_size 16m --flash_freq 80m \
        0x000000 firmware/rboot.bin \
        0x001000 <FACTORY BINARY DATA> \       # Optional "Factory" data like custom serial number etc.
        0x002000 $SDK_BASE/bin/blank.bin \     # Optionally replace with bootloader configuration data from bootloaderConfig.py
        0x003000 <APPLICATION FIRMWARE IMAGE>  # Your application firmware
        0x1fc000 $SDK_BASE/bin/esp_init_data_default.bin \ # Espressif flash configuration information
        0x1fe000 $SDK_BASE/bin/blank.bin # Espressif flash configuration information
