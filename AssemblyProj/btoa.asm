; btoa.asm  Binary to ASCII (decimal)

%include  'cs224_util.inc'

section .data
num1    dd      25
ascii   times 10 db ' '
        db      0

section .text
	global	main
        
main:   mov     eax,[num1]       ; AX <- binary number
        mov     edx,ascii        ; DX <- address of string
        call    conv             ; Convert to ASCII
        mov     edx,ascii        ; DX <- address of string
        call    prt_str_lf
        mov	eax,1
	int	0x80
;
; Convert binary to ASCII
;  EAX=binary word to convert
;  EDX=address of 10 byte string to recieve ASCII
;
conv:   mov     ebp,edx          ; Copy address of string
        add     ebp,9            ; Point to last character
        mov     ecx,10           ; Initialize counter
        mov     ebx,10           ; Initialize divisor
divide: mov     edx,0            ; Dividend = EDX,EAX - zero EDX
        div     ebx              ; (EDX,EAX)/EBX - Quotient->EAX Rem->EDX
        add     dl,0x30          ; Convert remainder to ASCII
        mov     [ebp],dl         ; Store in string
        dec     ebp              ; Point to next string character
        loop    divide           ; Do for all characters
        ret                      ; Back to caller
       
