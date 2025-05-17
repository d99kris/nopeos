Nope OS
=======

| **Linux** |
|-----------|
| [![Linux](https://github.com/d99kris/nopeos/workflows/Linux/badge.svg)](https://github.com/d99kris/nopeos/actions?query=workflow%3ALinux) |

Nope OS is a simple OS kernel bundled with a BASIC interpreter, bringing
back the 80s home computing feeling.

Try Nope OS in the browser at [https://copy.sh/v86/?profile=nopeos](https://copy.sh/v86/?profile=nopeos)

![Nope OS Screenshot](/doc/nopeos-helloworld.png)

Supported Platforms
===================
x86 compatibles.

Project Scope
=============
Nope OS is a minimal bootable BASIC interpreter with no device support for
I/O (disk, serial, audio, network, etc) except for keyboard input and text mode
VGA display.

Compilation & Usage
===================
Pre-requisites (Ubuntu):

    sudo apt install git nasm build-essential qemu-system-x86

Download:

    git clone https://github.com/d99kris/nopeos && cd nopeos

Build (outputs `kernel.bin` and `kernel.iso`):

    ./build.sh

Run in QEMU:

    ./run.sh

Stop emulation by pressing ESC.

Optionally build and generate img disk image (`kernel.img`):

    ./build.sh -i

Download Pre-Compiled Disk Images
=================================
Download links:
- [Nope OS v0.2 IMG](https://github.com/d99kris/nopeos/releases/download/v0.2/nopeos-0.2.img) (2MB)
- [Nope OS v0.2 ISO](https://github.com/d99kris/nopeos/releases/download/v0.2/nopeos-0.2.iso) (0.5MB)

These disk images may be used in a virtualized environment or on a physical
machine.

**Warning:** For usage on a physical machine, take note that Nope OS is just a
proof-of-concept and may contain bugs that could corrupt your system.

Booting a Physical Machine from USB Drive
-----------------------------------------
Download the IMG disk image above and use for example `dd` or
[balenaEtcher](https://www.balena.io/etcher) to write the image to a drive.

Design Notes
============
The implementation is based on
[bkerndev - Bran's Kernel Development Tutorial](http://www.osdever.net/bkerndev/Docs/title.htm)
and the
[TinyBasic interpreter](http://www.ittybittycomputers.com/IttyBitty/TinyBasic/).

License
=======
Nope OS is distributed under GPLv2 license. See LICENSE file.

Keywords
========
simple kernel, BASIC interpreter.

