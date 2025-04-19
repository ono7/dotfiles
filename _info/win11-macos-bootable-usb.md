## list usb drive

diskutil list

## format

diskutil eraseDisk MS-DOS "WIN11" MBR /dev/diskX

## unmount

sudo diskutil unmountDisk /dev/diskX

## flash

sudo dd if=/path/to/Windows11.iso of=/dev/rdifskX bs=1m
