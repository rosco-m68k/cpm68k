DIR_TARGET		:= target
SAMPLES_DIR     := samples
CMODEM_DIR		:= cmodem
CPM_1_2_SRC		:= cpm_1_2
CPM_1_2_ZIP     := 68kv1_2.zip
CPM_1_3_SRC		:= cpm_1_3
CPM_1_3_ZIP     := 68kv1_3.zip
CMDS			:= ./cmds
BIOS_DIR        := ../bios
BIOS_TARGET     := $(BIOS_DIR)/target
BIOS_SRC        := $(BIOS_TARGET)/bios.s $(BIOS_TARGET)/ldbios.s $(BIOS_TARGET)/buffer.s $(BIOS_DIR)/PUTBOOT.S
BIOS_SUB        := $(BIOS_DIR)/sub/*.sub
BIOS_FILE       := $(BIOS_DIR)/target/bios.srec
BOOT_FILE       := $(DIR_TARGET)/boot15k.sr
BOOT_START_ADDR := 0x15000
BOOT_HEADER     := $(shell srec_info $(BIOS_FILE) | grep "^Header:" | sed 's/^Header: "\(.*\)"/\1/')

BOOT_LOADER     := ../boot/m68000/target/boot.bin

MD    			:= mkdir
RM    			:= rm
#SHELL 			:= sh
SHELL 			:= /bin/bash

#all: $(DIR_TARGET)/disk1.img $(DIR_TARGET)/disk10.img $(DIR_TARGET)/diskBase.img $(DIR_TARGET)/diskAll.img $(DIR_TARGET)/drive_a.img $(DIR_TARGET)/drive_b.img $(DIR_TARGET)/drive_c.img $(DIR_TARGET)/drive_d.img
all: $(DIR_TARGET)/disk1.img 

clean:
	$(RM) -rf $(DIR_TARGET)/*

$(DIR_TARGET)/disk1.img: $(DIR_TARGET) $(CPM_1_3_SRC)/DISK1 $(BOOT_FILE)
	$(SHELL) $(CMDS)/formatPartitionedImage.sh $@ 1
	$(SHELL) $(CMDS)/copyDisks.sh $@ 1 $(CPM_1_3_SRC)
	$(SHELL) $(CMDS)/installSystem.sh $@ $(BOOT_FILE)
	$(SHELL) $(CMDS)/copyFiles.sh $@ 4mb-hd-0 $(BOOT_LOADER)

#$(DIR_TARGET)/disk10.img: $(DIR_TARGET) $(CPM_1_3_SRC)/DISK1 $(BOOT_FILE)
#	$(SHELL) $(CMDS)/formatPartitionedImage.sh $@ 10
#	$(SHELL) $(CMDS)/copyDisks.sh $@ 10 $(CPM_1_3_SRC)
#	$(SHELL) $(CMDS)/installSystem.sh $@ $(BOOT_FILE)

# 10 partitions with full CP/M distribution copied to partition 0, bios sources to partition 1 and cmodem source to partition 2
#$(DIR_TARGET)/diskAll.img: $(DIR_TARGET) $(CPM_1_3_SRC)/DISK1 $(BOOT_FILE)
#	$(SHELL) $(CMDS)/formatPartitionedImage.sh $@ 10
#	$(SHELL) $(CMDS)/copyAll.sh $@ 0 10 $(CPM_1_3_SRC)
#	$(SHELL) $(CMDS)/installSystem.sh $@ $(BOOT_FILE)
#	$(SHELL) $(CMDS)/copyFiles.sh $@ 4mb-hd-1 $(BIOS_SRC) $(BIOS_SUB) $(SAMPLES_DIR)/*
#	$(SHELL) $(CMDS)/copyFiles.sh $@ 4mb-hd-2 $(CMODEM_DIR)/*

# 10 partitions with curated CP/M distribution copied to partition 0 and bios sources to partition 1 and cmodem source to partition 2
#$(DIR_TARGET)/diskBase.img: $(DIR_TARGET) $(CPM_1_3_SRC)/DISK1 $(CPM_1_2_SRC)/DISK3 $(BOOT_FILE)
#	$(SHELL) $(CMDS)/formatPartitionedImage.sh $@ 10
#	$(SHELL) $(CMDS)/copyBase.sh $@ 0 10 $(CPM_1_3_SRC)
#	$(SHELL) $(CMDS)/installSystem.sh $@ $(BOOT_FILE)
#	$(SHELL) $(CMDS)/copyFiles.sh $@ 4mb-hd-0 $(CPM_1_2_SRC)/DISK3/SGTTY.H
#	$(SHELL) $(CMDS)/copyFiles.sh $@ 4mb-hd-1 $(BIOS_SRC) $(BIOS_SUB) $(SAMPLES_DIR)/*
#	$(SHELL) $(CMDS)/copyFiles.sh $@ 4mb-hd-2 $(CMODEM_DIR)/*

# 1 bootable partition with curated CP/M distribution copied to partition 0
#$(DIR_TARGET)/drive_a.img: $(DIR_TARGET) $(CPM_1_3_SRC)/DISK1
#	$(SHELL) $(CMDS)/formatImage.sh $@ 4mb-hd-0
#	$(SHELL) $(CMDS)/copyBase.sh $@ 0 10 $(CPM_1_3_SRC)
#	$(SHELL) $(CMDS)/installSystem.sh $@ $(BOOT_FILE)
	
# 1 partition with BIOS sources
#$(DIR_TARGET)/drive_b.img: $(DIR_TARGET)
#	$(SHELL) $(CMDS)/formatImage.sh $@ 4mb-hd
#	$(SHELL) $(CMDS)/copyFiles.sh $@ 4mb-hd $(BIOS_SRC) $(BIOS_SUB)
	
# 1 empty partition
#$(DIR_TARGET)/drive_c.img: $(DIR_TARGET)
#	$(SHELL) $(CMDS)/formatImage.sh $@ 4mb-hd
	
# 1 partition with full CP/M distribution copied to partition 0
#$(DIR_TARGET)/drive_d.img: $(DIR_TARGET) $(CPM_1_3_SRC)/DISK1
#	$(SHELL) $(CMDS)/formatImage.sh $@ 4mb-hd
#	$(SHELL) $(CMDS)/copyAll.sh $@ 0 10 $(CPM_1_3_SRC)
	
$(BOOT_FILE): $(BIOS_FILE) $(DIR_TARGET)/cpm15000.sr
	cat $(DIR_TARGET)/cpm15000.sr | sed -n '/\x1a/q;p' | grep -v "^S9" | srec_cat $(BIOS_FILE) - -header "$(BOOT_HEADER)" -execution-start-address=$(BOOT_START_ADDR) > $@
	m68k-elf-objcopy -I srec -O binary $(BOOT_FILE) $(BOOT_FILE).bin
	unix2dos $@

$(DIR_TARGET)/cpm15000.sr: $(CPM_1_3_SRC)/DISK8/CPM15000.SR
	cat $< | sed -e 's/S12304606000/S12304606200/' | sed -e 's/00010000F5/00010000F3/' > $@
		
$(CPM_1_2_SRC)/DISK3: $(CPM_1_2_SRC)/$(CPM_1_2_ZIP)
	cd $(CPM_1_2_SRC); unzip -q -o $(CPM_1_2_ZIP)

$(CPM_1_2_SRC)/$(CPM_1_2_ZIP): | $(CPM_1_2_SRC)
	rm -rf $(CPM_1_2_SRC)/*
	wget -O $(CPM_1_2_SRC)/$(CPM_1_2_ZIP) http://cpm.z80.de/download/$(CPM_1_2_ZIP) 
	touch $(CPM_1_2_SRC)/$(CPM_1_2_ZIP)

$(CPM_1_2_SRC):
	mkdir -p $@
		
$(CPM_1_3_SRC)/DISK1: $(CPM_1_3_SRC)/$(CPM_1_3_ZIP)
	cd $(CPM_1_3_SRC); unzip -q -o $(CPM_1_3_ZIP)

$(CPM_1_3_SRC)/$(CPM_1_3_ZIP): | $(CPM_1_3_SRC)
	rm -rf $(CPM_1_3_SRC)/*
	wget -O $(CPM_1_3_SRC)/$(CPM_1_3_ZIP) http://cpm.z80.de/download/$(CPM_1_3_ZIP) 
	touch $(CPM_1_3_SRC)/$(CPM_1_3_ZIP)

$(CPM_1_3_SRC):
	mkdir -p $@
	
$(DIR_TARGET):
	mkdir -p $@
	
