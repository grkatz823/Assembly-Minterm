; b2hex - Convert binary to printable hex
       %include "cs224_util.inc"
       
section .data
num1    dd      -1
ascii   db      '0123456789ABCDEF'
outstr  times 8 db ' '
        db	0
	global	main
section .text
main 
        mov     eax,[num1]      ;Get number
        mov     edx,outstr      ;Point to string
        call    conv            ;Convert it
        mov     edx,outstr      ;Address of string
        call    prt_str_lf      ;Write it
        mov	eax,1           ;Exit
	int	0x80
;
;Convert integer in EAX to ASCII (hexadecimal)
; EDX points to 8 byte string
;
conv:   push    ebx              ;Save regs
        push    ecx
        push    edx
        push    edi
        add     edx,7           ;Point to last character
        mov     ecx,8           ;Loop count
        mov     bl,0            ;Init shift count
c_lp:   push    ecx             ;Save loop count
        mov     edi,eax         ;Copy number
        mov     cl,bl           ;Get shift count
        shr     edi,cl          ;Get nibble
        and     edi,0000000fh   ;Isolate nibble
        mov     bh,[ascii+edi]   ;Get ascii equivalent
        mov     [edx],bh        ;Save in string
        add     bl,4            ;Adjust shift count
        dec     edx             ;Point to next string location
        pop     ecx             ;Get loop count
        loop    c_lp            ;For all chars
        pop     edi             ;Restore regs
        pop     edx              
        pop     ecx
        pop     ebx
        ret                     ;Back to caller
      
