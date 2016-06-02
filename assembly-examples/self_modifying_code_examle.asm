%include "include/all.asm"
BITS 32

    xor eax, eax
    mov al, SYS_exit
    xor ebx, ebx
    mov ebx, 3                  ; exit code 1
    jmp bytes

modifying_code:
    pop edx                     ; address of the bytes
    mov byte [edx], 0xcd
    inc edx
    mov byte [edx], 0x80
    dec edx
    jmp edx

bytes:
    call modifying_code
    db 0x00, 0x00
