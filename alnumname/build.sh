#!/bin/sh
gcc -m32 -Wl,-z,execstack -Wl,-z,norelro -fno-stack-protector alnumname.c -o alnumname
