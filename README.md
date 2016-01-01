# dBoot
A simple, light weight open source bootloader for the ESP8266 WiFi source

dBoot is forked from [Richard Burton's rBoot](https://github.com/raburton/rboot) but is significantly reworked for simplicity of both code and scope. Because it is incompatible with rBoot, I've changed the name, however, the GitHub fork is retained for history and license compliance.

## Purpose
Like rBoot, the goals of dBoot are to be light weight (occupies only one sector of flash, the minimum possible plus one for configuration but that one can be shared with application configuration data) and no stack space after jumping to the application and it's open source.

However, unlike rBoot, dBoot assumes that most of the Firmware Over The Air (FOTA) complexity will handled by the application code and the bootloader should be as minimal as possible. The less code there is in the bootloader, the less can be wrong with it. So far, I've found it to be quite bullet proof. This approach does require more care be taken on the application code since there's no "recovery image" but it simplifies the bootloader greatly.

rBoot also played some funny games with multiple linker scripts and build stages to make sure that it's final code was executing from a high RAM address so it doesn't overwrite itself when loading the program. In dBoot this is taken care of with linker attributes and a customized version of the `gen_appbin.py` tool from the SDK.

--------------------------------------------------------------------------------

## Building
Assuming you have the tool chain and SDK installed:
To build this project, adjust the SDK variable in the `build.sh` script as necessary and run `./build.sh`.

## Flashing
Because of the way `esptool.py` erases flash on the ESP8266, it is necessary to flash the bootloader and the firmware image in one invocation so `burn.sh` will need to be modified to include the firmware image file. Firmware with either new style or old style bootloader headers are supported. Since the bootloader will just jump to application code if there is no bootlaoder configuration in flash, you don't need to write any bootloader configuration. However, you can generate bootloader configuration images with the included `bootloaderConfig.py`.

--------------------------------------------------------------------------------

# Application Firmware

Include rboot.h
Write firmware out to unoccupied flash and then write the bootloader config data structure to the BOOT_CONFIG_SECTOR and reboot. The bootloader will copy the new firmware to the firmware starting address and the boot it. Application firmware is responsible for checking the integrity of the new image before writing the bootloader configuration and rebooting.

## Flash map

Section               | Starting address | Details
----------------------|------------------|----------------
BOOTLOADER_SECTOR     | 0x00001000        | Where the boot loader (this code) lives. 
FACTORY_SECTOR        | 0x00002000        | Where factory build information will be stored
BOOT_CONFIG_SECTOR    | 0x00003000        | Where the boot configuration is stored
FIRMWARE_START_SECTOR | 0x00004000        | Where the user firmware starts
ESP_INIT_DATA_SECTOR  | 0x001fc000        | Where the Espressif OS keeps it's init data, two sectors long
ESP_WIFI_CFG_SECTOR   | 0x001fe000        | Where the Espressif OS keeps it's wifi configuration data, two sectors long
