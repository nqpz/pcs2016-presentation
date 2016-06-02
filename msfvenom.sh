#!/bin/sh
#
# Convert to alphanumeric code with the metasploit framework.  Reads shell code
# from standard in.

msfvenom -a x86 --platform linux -p - -e x86/alpha_mixed -f c
