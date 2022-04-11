SUBDIRS := bios cpmfs boot

clean all: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)
	
.PHONY: clean all $(SUBDIRS)
