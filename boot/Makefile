ROSCO_M68K_DIR=~/rosco_m68k

ifndef ROSCO_M68K_DIR
$(error Please set ROSCO_M68K_DIR to the top-level rosco_m68k directory to use for rosco_m68k building)
endif

-include $(ROSCO_M68K_DIR)/user.mk

AS       = m68k-elf-as
ASFLAGS += -m68000
ASFLAGS += -alms
ASFLAGS += -I../ 
ASFLAGS += --defsym IS_68000=1

CC       = m68k-elf-gcc
CCFLAGS += -Wall
CCFLAGS += -m68000
CCFLAGS += -nostdlib
CCFLAGS += -nodefaultlibs
CCFLAGS += -I../include

SYSINCDIR?=$(ROSCO_M68K_DIR)/code/software/libs/build/include
SYSLIBDIR?=$(ROSCO_M68K_DIR)/code/software/libs/build/lib

ifneq ($(ROSCO_M68K_HUGEROM),false)
LDSCRIPT?=$(SYSLIBDIR)/ld/serial/hugerom_rosco_m68k_program.ld
else
LDSCRIPT?=$(SYSLIBDIR)/ld/serial/rosco_m68k_program.ld
endif

GCC_LIBS=$(shell $(CC) --print-search-dirs 															\
	| grep libraries:\ =		\
	| sed 's/libraries: =/-L/g' 	\
	| sed 's/:/m68000\/ -L/g')m68000/

LD       = m68k-elf-ld
LDFLAGS   = -L $(SYSLIBDIR) --gc-sections --oformat=elf32-m68k
LDFLAGS  += $(GCC_LIBS)

DEFINES=-DROSCO_M68K
VASM=vasmm68k_mot
VASMFLAGS=-Felf -m68010 -quiet -Lnf $(DEFINES)

LIBS	  = -lrosco_m68k
LIBS	 += -lsdfat
LIBS	 += -lstart_serial
LIBS     += -lgcc

OBJDUMP = m68k-elf-objdump
OBJCOPY = m68k-elf-objcopy
SIZE = m68k-elf-size
NM = m68k-elf-nm
 
all: target/boot.bin

# --------------------------------------------------------------------------------
# M68000 CPM Boot Loader
# --------------------------------------------------------------------------------
obj/kmain.o: kmain.asm | obj
	$(VASM) $(VASMFLAGS) -L $(basename $@).lst -o $@ $<

obj/boot.elf: obj/kmain.o | obj
	#cp $(LDSCRIPT) obj/rosco.ld
	#cat obj/rosco.ld | sed -e 's/^ram.*/ram = 0x00014F38;/' > obj/boot.ld # HACK do we need to change ram size
	$(LD) -T $(LDSCRIPT) $(LDFLAGS) obj/kmain.o $(LIBS) -o $@
	$(NM) --numeric-sort $@ > obj/boot.sym
	$(SIZE) $@
	-chmod a-x $@

target/boot.bin: obj/boot.elf | target
	$(OBJCOPY) -O binary obj/boot.elf target/boot.bin
	
clean:
	rm -rf obj/* target/*

obj:
	mkdir -p $@

target:
	mkdir -p $@



