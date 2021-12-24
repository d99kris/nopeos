#!/bin/bash

qemu-system-i386 -kernel output/kernel.bin -no-reboot

# alt: qemu-system-i386 -cdrom output/kernel.iso -curses -no-reboot
#      qemu-system-i386 -kernel output/kernel.bin -curses -no-reboot
#      qemu-system-i386 -drive file=output/kernel.img,format=raw -no-reboot
#

exit 0

