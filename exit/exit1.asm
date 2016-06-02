%include "include/all.asm"
BITS 32

    push 'aaaa'
    pop eax
    xor eax, 'aaaa'
    push eax
    pop ecx
    inc ecx
    push ecx
    pop eax                     ; eax has value 1 = syscall exit

    ;; Begin popad setup.
    push eax                    ; no change to eax
    push ecx                    ; no change to ecx
    push eax                    ; edx will contain 1 after popad

    push eax
    pop ecx
    inc ecx
    inc ecx
    push ecx                    ; ebx will contain 3 after popad
    
    push esp                    ; no change to esp
    push ebp                    ; no change to ebp
    push eax                    ; esi will contain 1 after popad
    push eax                    ; edi will contain 1 after popad
    popad                       ; get values from the stack to registers
    ;; The exit code in ebx is now 3.
    
    int 0x80                    ; syscall exit
