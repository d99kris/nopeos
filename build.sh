#!/bin/bash

# Build kernel
CFLAGS="-m32 -Wall -O -fstrength-reduce -fomit-frame-pointer          \
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

# Build tags
etags -o ./TAGS `find src -regex ".*\.[cha]\(sm\)?" -print`
if [ "${?}" != "0" ]; then
  echo "Etags failed, exiting."
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

exit 0

