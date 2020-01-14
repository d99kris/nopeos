Nope OS
=======

| **Linux** |
|-----------|
| [![Build status](https://travis-ci.com/d99kris/nopeos.svg?branch=master)](https://travis-ci.com/d99kris/nopeos) |

Nope OS is a simple OS kernel bundled with a BASIC interpreter, bringing 
back the 80s home computing feeling.

![Nope OS Screenshot](/doc/nopeos-helloworld.png)

Supported Platforms
===================
x86 compatibles.

Compilation & Usage
===================
Pre-requisites (Ubuntu):

    sudo apt install git nasm build-essential qemu-system-x86

Download:

    git clone https://github.com/d99kris/nopeos && cd nopeos

Build:

    ./build.sh

Run in QEMU:

    ./run.sh

Stop emulation by pressing ESC.

Download Pre-Compiled ISO Image
===============================
Pre-compiled ISO image for use with physical PC or virtualization tool 
(like VMware Player): 

[Nope OS v0.1 ISO](https://github.com/d99kris/nopeos/releases/download/v0.1/nopeos-0.1.iso)

Design Notes
============
The implementation is based on [bkerndev - Bran's Kernel Development Tutorial](http://www.osdever.net/bkerndev/Docs/title.htm) and the [TinyBasic interpreter](http://www.ittybittycomputers.com/IttyBitty/TinyBasic/).

License
=======
Nope OS is distributed under GPLv2 license. See LICENSE file.

Keywords
========
simple kernel, BASIC interpreter.

