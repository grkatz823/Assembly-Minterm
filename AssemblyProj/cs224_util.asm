; NASM utilities

	section	.text

	global	prt_str_lf

;Print a null terminated string, addr in edx
; Line feed printed at end
; Note sending a null string will print a lf

prt_str_lf:
	pushad
	mov	ebp,edx		; Copy addr. of string
	mov	ecx,edx		; Copy again
	dec	ebp		; Adjust
	mov	edx,0		; Init length
.loopp:	inc	ebp		; Point to next char
	inc	edx		; Increment length
   	mov	ah,[ebp]	; Get char	
	cmp	ah,0		; See if null
	jne	.loopp		; Local label :-}
	mov	ah,0x0a		; Line feed
	mov	[ebp],ah	; Save as last char	
	mov	ebx,1		; File handle (std out)
	mov	eax,4		; Write function code
	int	0x80		; Write the string
	mov	ah,0		; Restore null
	mov	[ebp],ah
	popad
	ret

	global	prt_str

;Print a null terminated string, addr in edx

prt_str:
	pushad
	mov	ebp,edx		; Copy addr. of string
	mov	ecx,ebp		; Copy again
	mov	edx,1		; Init length
.loopp:	inc	ebp		; Point to next char
	inc	edx		; Increment length
   	mov	ah,[ebp]	; Get char	
	cmp	ah,0		; See if null
	jne	.loopp		; Local label :-}
	;dec	edx		; Don't print null
	mov	ebx,1		; File handle (std out)
	mov	eax,4		; Write function code
	int	0x80		; Write the string
	popad
	ret

	global	prt_chr	

;Print the character in al
prt_chr:
	pushad
	mov	ebx,0		; Zero reg
	mov	bl,al		; Get char
	push	ebx		; Save to stack
	mov	edx,esp		; Copy stack ptr.
	call	prt_str		; Print it
	pop	ebx		; restore stack
	popad	
	ret

	global	get_str

;Get a string from the keyboard
;  EDX->buffer, ECX = max length

get_str:
	pushad
	push	ecx		; Save length
	mov	ecx,edx		; Copy addr
	pop	edx		; Get length
	mov	ebx,0		; Stdin file handle
	mov	eax,3		; Read function code
	int	0x80		; Call linux
	popad
	ret

	global	cmd_line

;Get command line parameters - call early in code
;  ECX->buffer
;  argc 8 bytes down on stack
;  argv[] 12 bytes down on stack	

cmd_line:
	mov	edx,ecx
	mov	ecx,[esp+8]
	mov	eax,[esp+12]
	dec	ecx		;Skip pgm name
	add	eax,4 		;Program name - discard
	cmp 	ecx,0		; See if any more
	jle	.done 
.loop1:	mov	ebp,[eax]	;Next argv[]
        add	eax,4
	call	.cat_argv	;Process it
	loop	.loop1		;For all argc

.done:	mov	ah,0
	mov	[edx],ah	;Null terminate

	ret

;Here with edx->where to put argv, ebx has length
;  ebp->argv [null terminated]
.cat_argv: 
	push	eax
.cloop:	mov	ah,[ebp]	;Get char
	cmp	ah,0		;See if done
	je	.cdone		;Yes
	mov	[edx],ah	;Save char
	inc	edx		;Up ptr to target
	inc	ebp		;Up ptr to source
	jmp	.cloop		;Continue
.cdone:	pop	eax
	ret
