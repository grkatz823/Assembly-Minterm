; cntbl.asm count blanks in a string

%include  'cs224_util.inc'

section .data
str1	db	"test string 1 2 3 4",0
 
section .text
	global	main
        
main:   mov     edx,str1	; EAX <- address of string
        call    count_bl        ; Call count_bl
 
        mov	eax,1
	int	0x80
;
; Count the blanks in a string
;  EDX = addr of string (null terminated)
;  EAX on return = number of blanks
;
count_bl: push  ebx          	; Save regs
        push	edx
	mov	eax,0		; Init count	
cloop:  mov	bl,[edx]        ; Get a character
	inc	edx		; Point to next
        cmp	bl,0 		; See if last char
	je	done		; Done
        cmp	bl,' '		; See if blank
        jne	cloop		; Not - continue
        inc	eax		; count++
	jmp	cloop		; Continue
done: 	pop	edx             ; Restore regs
        pop	ebx
        ret		        ; Back to caller
       
