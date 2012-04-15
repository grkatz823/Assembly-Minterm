; mov_str.asm
; Move a string        
	%include "cs224_util.inc"
        
section .data
str1    db      "This is a test string"
        db	0
str2    db      "A different test str."
        db      0
  	global	main
section	.text
main: 
;print strings
	mov	edx,str1
        call    prt_str_lf	;print
	mov	edx,str2
	call	prt_str_lf
;copy string        
        mov     ecx,21          ;length
        mov     esi,str1        ;source
        mov     edi,str2        ;destination
        cld                     ;clear direction flag
        rep movsb               ;repeat ecx times - move a byte
;print strings
	mov	edx,str1
        call    prt_str_lf     ;print
	mov	edx,str2
	call	prt_str_lf
;exit to Linux
        mov	eax,1
        int	0x80
