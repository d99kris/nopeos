#!/bin/bash

# Build kernel
CFLAGS="-m32 -Wall -O -fno-pie -fstrength-reduce -fomit-frame-pointer \
        -finline-functions -nostdinc -fno-builtin -ffreestanding      \
        -I./bkerndev/include -I./misc/include                         \
        -I./tinybasic/include -c"
mkdir -p output &&                                                    \
cd src &&                                                             \
nasm -f elf32 -o start.o       bkerndev/start.asm &&                  \
gcc ${CFLAGS} -o main.o        bkerndev/main.c &&                     \
gcc ${CFLAGS} -o scrn.o        bkerndev/scrn.c &&                     \
gcc ${CFLAGS} -o gdt.o         bkerndev/gdt.c &&                      \
gcc ${CFLAGS} -o idt.o         bkerndev/idt.c &&                      \
gcc ${CFLAGS} -o isrs.o        bkerndev/isrs.c &&                     \
gcc ${CFLAGS} -o irq.o         bkerndev/irq.c &&                      \
gcc ${CFLAGS} -o timer.o       bkerndev/timer.c &&                    \
gcc ${CFLAGS} -o kb.o          bkerndev/kb.c &&                       \
gcc ${CFLAGS} -o kbbuf.o       misc/kbbuf.c &&                        \
gcc ${CFLAGS} -o unistd.o      misc/unistd.c &&                       \
gcc ${CFLAGS} -o stdio.o       misc/stdio.c &&                        \
gcc ${CFLAGS} -o stdlib.o      misc/stdlib.c &&                       \
gcc ${CFLAGS} -o string.o      misc/string.c &&                       \
gcc ${CFLAGS} -o tinybasic.o   tinybasic/tinybasic.c &&               \
ld -nostdlib -m elf_i386 -T bkerndev/link.ld                          \
  -o ../output/kernel.bin                                             \
  start.o main.o scrn.o gdt.o idt.o isrs.o irq.o timer.o              \
  kb.o kbbuf.o unistd.o stdio.o stdlib.o string.o tinybasic.o &&      \
rm *.o &&                                                             \
cd - > /dev/null
if [ "${?}" != "0" ]; then
  echo "Build failed (kernel.bin), exiting."
  exit 1
fi

# Create ISO image
mkdir -p output/isodir/boot/grub &&                                   \
cp output/kernel.bin output/isodir/boot/kernel.bin &&                 \
cp src/grub/menu.lst output/isodir/boot/grub/ &&                      \
cp src/grub/stage2_eltorito output/isodir/boot/grub/ &&               \
cd output &&                                                          \
mkisofs -R -b boot/grub/stage2_eltorito -no-emul-boot -quiet          \
  -input-charset utf8                                                 \
  -boot-load-size 4 -boot-info-table -o kernel.iso isodir &&          \
rm -rf isodir &&                                                      \
cd - > /dev/null
if [ "${?}" != "0" ]; then
  echo "Build failed (kernel.iso), exiting."
  exit 1
fi

# Create IMG image
if [[ "${1}" == "-i" ]]; then
  if [[ "${2}" != "-y" ]]; then
    echo "Building img disk images is experimental and uses sudo. Proceed with"
    echo "caution, ideally only after reviewing the script content."
    echo ""
    read -p "Proceed to build img (y/n)? "
    echo ""
    if [[ "${REPLY}" != "y" ]]; then
      echo "Aborting"
      exit 1
    fi
  fi

  set -o pipefail
  # Disk image size is 2MB.
  # Root partition starts at 1MB with size 1MB (for MB alignment), and
  # contains grub (512KB) and the kernel (40KB).
  MB="2"
  IMG="output/kernel.img"
  sudo dd if=/dev/zero of=${IMG} count=${MB} bs=1M && \
  sudo parted --script ${IMG} mklabel msdos mkpart p ext2 1 ${MB} set 1 boot on && \
  LOOPNAME=$(sudo kpartx -av ${IMG} | awk '{print $3}')
  if [[ "${?}" == "0" ]]; then
    PART="/dev/mapper/${LOOPNAME}"
    DEV="/dev/${LOOPNAME::-2}"
    echo "Device:        ${DEV}"
    echo "Partition:     ${PART}"

    sudo mkfs.ext2 ${PART} && \
    mkdir -p output/usbmount && \
    sudo mount ${PART} output/usbmount
    if [[ "${?}" == "0" ]]; then
      sudo mkdir -p output/usbmount/boot/grub && \
      sudo cp output/kernel.bin output/usbmount/boot/kernel.bin && \
      sudo grub-menulst2cfg src/grub/menu.lst output/usbmount/boot/grub/grub.cfg && \
      sudo grub-install --target=i386-pc --boot-directory=`pwd`/output/usbmount/boot \
           --removable --install-modules="normal test legacycfg multiboot ext2" \
           --fonts= --themes= ${DEV} && \
      echo "Success!"

      sudo umount output/usbmount && \
      sudo rm -rf output/usbmount
    fi

    sudo kpartx -d ${IMG}
    sudo chown ${USER}:${USER} ${IMG}
  fi
fi

exit 0

