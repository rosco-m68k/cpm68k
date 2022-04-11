
SPI_TRAP            =         13                                      | Trap no. to call the SD Card routines
IO_TRAP             =         14                                      | Trap no. to call the IO routines

SPI_CHECK           =         0x0                                     | Function 0: check support
SPI_INIT            =         0x1                                     | Function 1: init
SPI_READ            =         0x2                                     | Function 2: read block
SPI_WRITE           =         0x3                                     | Function 3: write block 
SPI_READ_REGISTER   =         0x4                                     | Function 4: read sd card register

IO_SENDCHAR         =         0x2                                     | Function 2: Print a character
IO_RECVCHAR         =         0x3                                     | Function 3: Receive a character
IO_CHECKCHAR        =         0x6                                     | Function 6: Check is character at console

DISK_COUNT          =         10                                      | this BIOS currently supports 10 drives

DPH_LEN             =         26                                      | length of disk parameter header

TRAP_3              =         0x8C                                    | Trap 3 - the trap used by CPM

          .ifne               _GNU_
_ccp                =         0x150BC                                 | From CPM15000.MAP
          .endif
