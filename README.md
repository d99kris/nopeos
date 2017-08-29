Nope OS
=======
Nope OS is a simple OS kernel bundled with a BASIC interpreter, bringing 
back the 80s home computing feeling.

![Nope OS Screenshot](/doc/nopeos-helloworld.png)

Supported Platforms
===================
x86 compatibles.

Compilation & Usage
===================
Download:

    git clone https://github.com/d99kris/nopeos && cd nopeos

Run the build script:

    ./build.sh

Run in QEMU:

    ./run.sh

Stop emulation by pressing ESC.

Download Pre-Compiled ISO Image
===============================
Pre-compiled ISO image for use with physical PC or virtualization tool 
(like VMware Player): 

[Nope OS v0.1 ISO](http://nope.se/download/nopeos/nopeos-0.1.iso)

Design Notes
============
The implementation is based on [bkerndev - Bran's Kernel Development Tutorial](http://www.osdever.net/bkerndev/Docs/title.htm) and the [TinyBasic interpreter](http://www.ittybittycomputers.com/IttyBitty/TinyBasic/).

License
=======
Refer to each component's LICENSE file in their respective subdirectory under
src.

Keywords
========
simple kernel, BASIC interpreter.

