Text Scroll Routine
-------------------

Back in 1989 I sent several small programs into New Computer Express, a weekly magazine. Robin Alway managed the SPEX column, a precious half page dedicated to the ZX Spectrum.
Now my KS2 is here in 2024, I've decided to revisit my text scrolling program to re-learn Z80 programming.

Hopefully other enthusiasts will find this useful too.



Optional Tools
--------------
The ZX Next has everything you need. For advanced users, you may find the following tools useful:

VSCode    - Editing *.bas.txt files
NextSync  - download files from PC to the Next
z80dasm   - Z80 disassembler for Linux/MacOS
tail      - Utility to stream the contents of a file
Zeus      - Next Z80 assembler, see /apps/dev/Zeus

For Window's users I recommend you use Windows Subsystem for Linux for tail and z80dasm



Files
-----

The following files are scans of the New Computer Express magazine where the code was originally published

26BackPage.jpg
26FrontPage.jpg
26Spex.jpg

Original Source code, typed in from the magazine
scroll.bas
scroll.bas.txt

Disassembly of the machine code and annotated with lots of comments, explains how the routine works
Scroll.asm

Spectrum Next demo code
demo.bas.txt       - BASIC program, compile to BASIC using .txt2bas
Reactor.ch8        - Font by Damien Guard 
scroll.bin         - Machine code binary

Other
build.bas.txt      - Helper file to sync and compile the code
scroller.god       - Zeus Assembler source code file, useful for relocating the code



BASIC
-----
You can type in the code from the magazine listing, see 26Spex.jpg or you can copy scroll.bas to your Next's SD card's home folder.
On line 90, you will see the default message, change this to your own message.
Run the code to load the machine code into memory. 
To see the message scroll:
run 1000
To save the machine code:
RUN
SAVE "scroll.bin" CODE, 59990,200
Note for longer messages, increase the size from 200 to include your message



Next Demo
---------
A simple program showing you how to include the scroller into your own programs. It also uses a custom font by Damien Guard (https://damieng.com/typography/zx-origins/reactor/)
Copy the files to the home folder on your SD card:
demo.bas.txt
Reactor.ch8 
scroll.bin

Convert demo.bas.txt to BASIC
From BASIC enter:

.txt2bas demo.bas.txt
LOAD "demo.bas"



Disassembly
-----------
After typing in the original basic code, run the code to load the machine code into memory and then save the machine code:

From the Sprectrum:
SAVE "scroll.bin" CODE 59990,200

Take out the Next's SD card and copy scroll.bin to your PC

scroll.bin has a 128 byte header that needs to be stripped off:

From a Linux/MacOS/WSL command line:
tail -c 129 scroll.bin > mc.bin

From a Linux/MacOS/WSL command line:
z80dasm scroll.bin -a -l -g 59990 -t -o scroll.asm

The version of Scroll.asm contains plentiful comments and has been symbolised, use this to understand how the machine code works.



Zeus Assembler
--------------

You can use the Zeus assembler on the Next itself which is great when you don't have a PC to hand.
Copy the Zeus source file, scroller.god into the SD card folder /apps/dev/Zeus

From your Next's browser, open /apps/dev/Zeus/Zeus.bas

Zeus will ask you if you want to open an existing project, type in scroller

Press O for old, and then L for list. See ZeusAssembler.txt for more info.
Press A to assemble, this generates a scroller.bin file which you can later load from BASIC:
LOAD "scroller.bin" CODE 55000

On line 10, you can change the machine's code start address, currently is set at 55,000.
Note that the Zeus program itself is located from 57,000 onwards (hence why I had to relocate the program to 55000)
Your assembly source code will be located at 32768.

At the bottom of the source code you will find DEFM assembler declarations, you can place you message text here.
Remember to terminate the message with byte 255


