; cntbl.asm count blanks in a string
;  print out results

%include  'cs224_util.inc'

section .data
str1	db	"test string 1 2 3 4 ",0
str2    times 10 db 0
	db	0
 
section .text
	global	main
        
main:   mov     edx,str1	; EAX <- address of string
        call    count_bl        ; Call count_bl

	mov	edx,str2
	call	conv

	call 	prt_str_lf
 
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
; Convert binary to ascii
;  EAX=binary word to convert
;  EDX=address of 10 byte string to recieve ASCII
;
conv:   pushad
	mov     ebp,edx          ; Copy address of string
        add     ebp,9            ; Point to last character
        mov     ecx,10           ; Initialize counter
        mov     ebx,10           ; Initialize divisor
divide: mov     edx,0            ; Dividend = EDX,EAX - zero EDX
        div     ebx              ; (EDX,EAX)/EBX - Quotient->EAX Rem->EDX
        add     dl,0x30          ; Convert remainder to ASCII
        mov     [ebp],dl         ; Store in string
        dec     ebp              ; Point to next string character
        loop    divide           ; Do for all characters
	popad
        ret                      ; Back to caller
       
