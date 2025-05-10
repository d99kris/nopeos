#!/bin/bash

qemu-system-i386 -kernel build/kernel.bin -no-reboot

# alt: qemu-system-i386 -cdrom build/kernel.iso -curses -no-reboot
#      qemu-system-i386 -kernel build/kernel.bin -curses -no-reboot
#      qemu-system-i386 -drive file=build/kernel.img,format=raw -no-reboot
#

exit 0

