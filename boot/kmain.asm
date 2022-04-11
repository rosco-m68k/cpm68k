; *--------------------------------------------------------------------------------
; * Load the srec file and jump to the start point to boot cpm68k
; * Malcolm Harrow March 2022  https://github.com/harrowm
; *--------------------------------------------------------------------------------

                    section .text

kmain::
                    LEA.L   strBootMsg,A0
                    MOVE.L  A0,-(A7)
                    JSR     mcPrintln
                    ADDQ.L  #4,A7

                    JMP     0x15000                                     ; hard code the cpm start address
                    RTS                                                 ; code never gets here
                    
                    incbin "../../cpmfs/target/boot15k.sr.bin"         ; include the CPM bios and boot file so it relocated

strBootMsg:         dc.b   "CPM68k boot manager for rosco_m68k v0.1", 0
