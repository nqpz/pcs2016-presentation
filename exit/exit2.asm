%include "include/all.asm"
BITS 32

    ;; Begin setting eax.
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

    ;; Push the 'int 0x80' code on the stack with two extra 'X' chars.
    push `XX\xcd\x80`
    inc esp
    inc esp
    ;; esp now points to `\xcd\x80`.

    ;; Call 'int 0x80'.
    push esp

    push esi
    pop ecx
    push 'aaaa'
    pop edx
    xor [ecx+80], dl
    db 0xc3                     ; ret
