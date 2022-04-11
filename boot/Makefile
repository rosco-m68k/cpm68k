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
#LDFLAGS  += -L../../fat/target
#LDFLAGS  += -L../../baselibc/target
LDFLAGS   = -T $(LDSCRIPT) -L $(SYSLIBDIR) --gc-sections --oformat=elf32-m68k
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
 
IO_AS_SRC = $(wildcard ../io/*.s)
IO_AS_OBJ = $(patsubst ../io/%.s, obj/io/%.o, $(IO_AS_SRC))

LIB_AS_SRC = $(wildcard ../lib/*.s)
LIB_AS_OBJ = $(patsubst ../lib/%.s, obj/lib/%.o, $(LIB_AS_SRC))

SREC_AS_SRC = $(wildcard ../s-record/*.s)
SREC_AS_OBJ = $(patsubst ../s-record/%.s, obj/s-record/%.o, $(SREC_AS_SRC))

OBS = $(LIB_AS_OBJ) $(IO_AS_OBJ) $(SREC_AS_OBJ) 

all: target/boot.bin

obj/io/%.o:	../io/%.s | obj/io
	$(AS) $(ASFLAGS) -a=$(@:.o=.lst) -o $@ $<

obj/lib/%.o:	../lib/%.s | obj/lib
	$(AS) $(ASFLAGS) -a=$(@:.o=.lst) -o $@ $<

obj/s-record/%.o:	../s-record/%.s | obj/s-record
	$(AS) $(ASFLAGS) -a=$(@:.o=.lst) -o $@ $<

# --------------------------------------------------------------------------------
# M68000 CPM Boot Loader
# --------------------------------------------------------------------------------
obj/kmain.o: kmain.asm | obj
	$(VASM) $(VASMFLAGS) -L $(basename $@).lst -o $@ $<

obj/boot.elf: obj/kmain.o $(OBS) | obj
	#$(LD) $(LDFLAGS) -T boot.lnk obj/kmain.o $(OBS) $(LIBS) -Map $(@:.srec=.map) -o $@
	#$(LD) $(LDFLAGS) obj/kmain.o $(OBS) $(LIBS) -Map $(@:.srec=.map) -o $@
	$(LD) $(LDFLAGS) obj/kmain.o $(OBS) $(LIBS) -o $@
	$(NM) --numeric-sort $@ > obj/boot.sym
	$(SIZE) $@
	-chmod a-x $@

target/boot.bin: obj/boot.elf | target
	$(OBJCOPY) -O binary obj/boot.elf target/boot.bin
	
clean:
	rm -rf obj/* target/*

obj:
	mkdir -p $@

obj/io: obj
	mkdir -p $@

obj/lib: obj
	mkdir -p $@

obj/s-record: obj
	mkdir -p $@

target:
	mkdir -p $@



