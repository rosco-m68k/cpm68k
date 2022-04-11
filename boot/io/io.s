* ----------------------------------------------------------------------------------
* Low level I/O routines - polyfill for rosco_m68k
* Malcolm Harrow April 2022 https://github.com/harrowm
* ----------------------------------------------------------------------------------

                    .include  "include/ascii.i"
                    .include  "include/polyfill.i"
                    .include  "../../bios/include/bios.i"   | for the traps

                    .text

                    .global   outch
                    .global   inch

* ----------------------------------------------------------------------------------
* Output a character from %D1.B
* ----------------------------------------------------------------------------------
outch:              MOVE.W    #IO_SENDCHAR,%D0
                    TRAP      #IO_TRAP
                    RTS
                    
* ----------------------------------------------------------------------------------
* Input a character into %D1.B
* ----------------------------------------------------------------------------------
inch:               MOVE.W    #IO_RECVCHAR,%D0
                    TRAP      #IO_TRAP
                    MOVE.B    %D0, %D1
                    RTS
