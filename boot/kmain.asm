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

                    ; relocate the cpm srec file to $15000
                    LEA.L   srec_start,A0               ; start of srec file
                    LEA.L   $15000,A1                   ; absolute dest addr (CPM start)
                    MOVE.L  srec_length,D0              ; length
                    LSR.L   #2,D0                       ; convert to long words
                    SUBQ.L  #1,D0                       ; subtract 1 for dbra
.MOVE_LOOP:
                    MOVE.L  (A0)+,(A1)+                 ; copy long word from source to dest
                    DBRA    D0,.MOVE_LOOP               ; loop until end of srec

                    ; relocate the bios srec file to $1B000
                    LEA.L   bios_start,A0               ; start of srec file
                    LEA.L   $1B000,A1                   ; absolute dest addr (CPM start)
                    MOVE.L  bios_length,D0              ; length
                    LSR.L   #2,D0                       ; convert to long words
                    SUBQ.L  #1,D0                       ; subtract 1 for dbra
.MOVE_LOOP2:
                    MOVE.L  (A0)+,(A1)+                 ; copy long word from source to dest
                    DBRA    D0,.MOVE_LOOP2              ; loop until end of srec

                    ; and jump to it to start CPM !
                    JMP     $15000                                      
                    RTS                                                 
                    
srec_start:         incbin "../cpmfs/target/boot15k.sr.bin"
srec_end:      
srec_length = srec_end - srec_start

bios_start:         incbin "../bios/target/bios.sr.bin" 
bios_end:      
bios_length = bios_end - bios_start

strBootMsg:         dc.b   "CPM-68k loader for rosco_m68k v0.1", 0
