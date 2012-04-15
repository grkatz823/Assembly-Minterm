;
; prtdb - for debug use - prints literals and internal array
;    of terms
;  esi = @ of literal array, edi = @ of internal array 
;
prtdb:  push    eax
        push    ecx
        push    edx
        push    ebp
        push    edi
        push    esi
;print literal array  (4 times)
        mov     ebp,esi
        mov     ecx,4
dblp0:  push    ecx
        mov     ecx,8
        mov     esi,ebp
dblp1:  mov     al,[esi]
        call	prt_chr
        inc     esi
        loop    dblp1
        mov     al,' '
        call	prt_chr
	pop	ecx
        loop    dblp0
        call    prtlf
;print internal term array
        mov     ecx,8
dblpa:  push    ecx
        mov     ecx,4
dblp2:  push    ecx
        mov     ecx,8
dblp3:  mov     al,[edi]
        add     al,30h
        call	prt_chr
        inc     edi
        loop    dblp3
        mov     al,' '
        call	prt_chr
        pop     ecx
        loop    dblp2
        call    prtlf
        pop     ecx
        loop    dblpa
        pop     esi
        pop     edi
        pop     ebp
        pop     edx
        pop     ecx
        pop     eax
        ret
;Print a carriage return and line feed
prtlf:  push    eax
        mov     al,0x0a
        call	prt_chr
        pop     eax
        ret
