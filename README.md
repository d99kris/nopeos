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
Download the source code package:

    wget https://github.com/d99kris/nopeos/archive/master.zip

Extract package:

    unzip master.zip

Run the build script:

    cd nopeos-master
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

