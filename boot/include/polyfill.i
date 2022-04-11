*
* Polyfill the file functions to rosco_m68k sd library
*

fOpen = fl_fopen
fRead = fl_fread
fClose = fl_fclose

* polyfill the OS running under

_GNU_ = 0
_CPM_ = 1
