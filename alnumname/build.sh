#!/bin/sh
mkdir www/cgi-bin
gcc -m32 -O0 -Wl,-z,execstack -Wl,-z,norelro -Wl,-Ttext-segment=0x8000000 -fno-stack-protector alnumname.c -o www/cgi-bin/alnumname
