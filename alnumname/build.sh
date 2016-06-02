#!/bin/sh
mkdir -p www/cgi-bin
gcc -m32 -O0 -Wl,-z,execstack -Wl,-z,norelro -Wl,-Ttext-segment=0x8002000 -fno-stack-protector -fno-inline-functions alnumname.c -o www/cgi-bin/alnumname
