section	.text
	global	main

main:
	mov	edx,len		;Length of string
	mov	ecx,msg		;Addr of string
	mov	ebx,1		;STDIN file handle
	mov	eax,4		;Write to file
	int	0x80		;Call Linux

	mov	eax,1		;Program exit
	int	0x80		;Call to Linux

section	.data

msg	db	'Hello World',0x0a
len	equ	$ - msg