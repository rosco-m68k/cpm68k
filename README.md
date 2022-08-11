# rosco-cpm68k

This project implements cpm-68k on the rosco_m68k single board computer.  At the moment its WIP and is non-funtional.

### My development environment:
Windows 11 machine running VirtualBox 6.1 and Ubuntu 21.1

rosco development toolchain from: https://rosco-m68k.com/docs/toolchain-installation

mame emulator from here: https://github.com/roscopeco/mame

Mame is extremely useful (i.e. essential) so you can run the debugger and trace the execution through the boot loader and cpm.


### Getting started
You will need to install dos2unix and cpmtools using brew or apt.

Add the cpm disk defintions used to /etc/cpmtools/diskdefs.txt, e.g.:

sudo cat 68k-diskdefs.txt >> /etc/cpmtools/diskdefs.txt



Type 'make' in the top level directory, this will use the makefile in lower directories to build:

bios - the bios - this will build the bios.sr.bin file which is a modification of Damian Wildie's bios that assume the rosco support code is loaded and maps the cpm bios calls to the correct TRAP 13, 14, 15 calls.

cpmfs - this will create disk1.img a cpm68k disk image.  Use Balena Etcher of similar to format a sd card with this image.

boot - the boot loader - this generates boot.bin which is the program used to start cpm68k.  This follows the standard rosco assember prohram template.  It loads the bios and cpm base files and then relocates cpm to 15000 and the bios to 1B000.  It then makes a jump to cpm start at 15000

After building and creating your cpm68k sd card, start the rosco_m68k with the sd card installed.  The normal rosco boot program will say that the sd card format isnt recognised but you can continue and use the kermit program to start boot.bin.

To start under mame: ./sbc rosco_classicv2 -quik ../rosco-cpm68k/boot/target/boot.bin -debug

This assumes mame stored at the same directory level as rosco-cpm68k and the command issued from the mame directory. Running mame on my PC is slower than the hardware (it reports a 68010 running at 3.7MHz), so I suggest immediately setting a breakpoint at 15000 ("bp 15000") and start execution ("go").  Mame will then stop at the cpm entry point (15000 or "cpm" in CPM15000.MAP).

At the time of writing:
- printing to the screen works !  I had confused D0 and D1 in bios.s ... Sigh
- the program is executing through the cpm code and bios but fails to recognise the sd card

The file CPM15000.MAP is the function/address map for cpm68k.  This is very useful to trace which function in cpm are being called etc.


My next step is to change the bios code to get it to print details of every bios call that is being made ..

### Interesting links:

Details on the board:
https://rosco-m68k.com/

Links to documents on cpm68k and Damian Wildie's work on a S100 SBC on which this code is derived.
http://www.s100computers.com/Software%20Folder/CPM68K/CPM68K%20Software.htm
https://github.com/dwildie/cpm-68k

General info, hints and tips:
https://www.retrobrewcomputers.org/forum/index.php?t=msg&th=222&goto=3703&

The main source for all things cpm:
http://www.cpm.z80.de/
