%include "include/all.asm"
BITS 32

    ;; Setup exit arguments.
    xor eax, eax
    mov al, SYS_exit
    xor ebx, ebx
    mov ebx, 3                  ; exit code 1
    int 0x80                    ; syscall exit
