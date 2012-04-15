; add2.asm

section	.data

num1    dd      20
num2    dd      17
sum1    dd      0
       
section	.text
        global  main

main:
	mov     eax,[num1]
        add     eax,[num2]
        mov     [sum1],eax
	mov	eax,1
        int	0x80
       
