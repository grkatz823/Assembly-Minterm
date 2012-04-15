%include "cs224_util.inc"

section	.text
	global	main

main:
	mov	edx,msg         ;Addr of msg
	call	prt_str_lf      ;Print with lf

	mov	eax,1		;Program exit
	int	0x80		;Call to Linux

section	.data

msg	db	'Hello World',0