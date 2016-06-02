#!/bin/sh
gcc -m32 -Wl,-z,execstack -Wl,-z,norelro -Wl,-Ttext-segment=0x8000000 -fno-stack-protector alnumname.c -o alnumname
