; Remove blanks from command line 
;  Make into null terminated string

%include 'cs224_util.inc'

section	.data

cmdln 	times 256 db	0

section	.text
	global	main

main:	
	mov	ecx,cmdln	;Beginning
	call	cmd_line
        mov	edx,cmdln
	call	prt_str_lf		;Print result

	mov	eax,1
	int	0x80





