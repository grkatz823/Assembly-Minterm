%include "cs224_util.inc"

section	.data		;Greg Katz

numLiterals	dd	0
numRows	dd	0
minTermNumber   dd	0
numTerms	dd	0
minTermResult   times	10 db ' '
		db	0
termArray	times	256 db 0
		db	0
internalArray	times	256 db 0
		db	0
buff		times	256 db ' '
		db	0
litArr		times	8 db ' '
		db	0	
msg		db	"Minterms = S("

section .text
	global  main

main:	
	mov	ecx,buff	;address of message
	call	cmd_line	;get message
	mov	edx,buff	;DX<-Address of Buff 
	mov	eax,litArr	;AX<-Address of LitArr
	mov	ecx,[numLiterals];get the number of literals
	call	getLit		;Place the literals into a string
	mov	[numLiterals],ecx;sets numLiterals
	mov	edx,buff	;Moves string into edx
	mov	eax,termArray	;AX<-Address of termArray
	call	getTerm	;Places terms into termArray
	mov	ecx,[numRows]	;sets numRows
	mov	edx,termArray	;AX<-Address of termArray
	mov	eax,0		;set flag
	call	getNumRows	;gets the number of rows,puts it in ecx
	mov	[numRows],ecx	;moves it back into numRows
	mov	edx,termArray	;Moves array of terms into edx
	mov	ebp,internalArray;bp<-Address of Internal Array
	call	getIntArr	;Gets internal format
	mov	edi,internalArray;DI<-Address of Internal Array
	mov	esi,litArr	;SI<-Address of Lit Array	
	call	printOutLit	;Print Out Lit Array	
	mov	esi,litArr	;Address of LitArr
	mov	edi,internalArray;Address of Internal Format
	call	printOutInt	;Print out terms
	mov	edx,msg
	call	prt_str		;prints minterm message
	call	print_minterms	;prints out the minterms
	mov	al,0x29		;makes a ')' sign
	call	prt_chr		;prints it
	mov	al,0x0a		;line feed
	call	prt_chr		;prints it
	mov	eax,1		;Exit
	int	0x80


getLit: 
	mov	ebx,0 		;move ebx to first char
	mov 	bl,[edx]	;get a char
	inc 	edx		;Point to next string character
	cmp	bl,0x3d		;compare to '=' sign
	je	getLit2		;if equal,jump
	cmp	bl,' '		;compare to blank space
	je	getLit		;skip it
	mov	[eax],bl	;move into litArr string
	add	ecx,1 		;increases number of literals
	inc 	eax		;point to next char in litArr
	jmp	getLit		;repeat
getLit2:ret			;return


getTerm: 
	 mov	ebx,0		;move ebx to first char
	 mov	bl,[edx]	;get a char
	 inc	edx		;point to next string char
	 cmp	bl,0x3d		;compare to '=' sign
	 jne	getTerm	;if equal copy rest of string in termArray
getTerm2:mov	ebx,0		;move ebx to first char
	 mov	bl,[edx]	;get a char
	 inc	edx		;point to next string char
	 cmp	bl,0		;see if end of string has been reached
	 je	getTerm3	;if true,return
	 cmp	bl,' '		;check for spaces
	 je	getTerm2	;ignores them 
	 mov	[eax],bl	;copy char into array
	 inc 	eax		;points to next char in eax
	 jmp	getTerm2	;loop
getTerm3:ret			;return to sender

getNumRows:mov	ebx,0		;sets ebx to first char
	   mov	bl,[edx]	;move string into bl
	   inc	edx		;points to next char in term array
	   cmp	bl,0		;checks if at end of array
	   je	getNumRows2	;jump to end
	   mov	eax,1		;set flag
	   cmp	bl,0x2b		;checks for '+' sign
	   jne	getNumRows	;if not, skip
	   add	ecx,1		;if it is add one to counter
	   jmp	getNumRows	;repeat
getNumRows2:cmp eax,0		;see if there were any non-zero numbers
	    je	getNumRows3	;if false, return
	    add	ecx,1		;if true, add one to counter
getNumRows3:ret

getIntArr: 
	   mov	al,1		;Set al to 1
	   mov	ebx,0		;Move ebx to first char
	   mov	edi,0		;Move edi to a zero
	   mov	esi,litArr	;String of literals
	   mov	bl,[edx]	;get a char
	   inc	edx		;point to next string char
	   cmp	bl,0		;see if end of string has been reached
	   je	getIntArr5	;return if true
	   cmp	bl,'+'		;see if end of term has been reached
	   jne	getIntArr2	;if not,move on
	   add	ebp,8		;if so, go to next term string
	   jmp	getIntArr	;loop back
getIntArr2:mov  ecx,0		;Move ecx to first char
	   mov	cl,[esi]	;get a literal
	   cmp  bl,cl		;see if the term char is this literal
	   je	getIntArr3	;if true, move on
	   inc	esi		;if false, get next literal,
	   inc	edi		;increase counter
	   jmp	getIntArr2	;and repeat
getIntArr3:add	ebp,edi		;point to correct place in string
	   mov	bl,[edx]	;moves next char into bl
	   cmp	bl,0		;see if end of string is reached
	   je	getIntArr4	;return to sender
	   cmp	bl,0x27		;checks if next character is a ' sign
	   jne	getIntArr4	;if it isn't move on
	   neg	al		;makes the char -1	
	   inc  edx		;points to next char
getIntArr4:mov	[ebp],al	;moves a 1 or -1 into that character
	   sub  ebp,edi		;points eax back to beginning of term line	   	   
	   jmp	getIntArr	;repeat 
getIntArr5:ret


printOutLit: 
	     mov ebx,0 	;move ebx to first char
	     mov al,[esi]	;get a char from lit Array
	     inc esi		;Point to next string character
	     cmp al,' '	;compare to ' ' sign
	     je	printOutLit2	;if equal,jump
	     cmp al,0
	     je printOutLit2
	     call prt_chr	;points to next char in eax
	     jmp printOutLit	;loop
printOutLit2:mov ebx,0		;move ebx to first char
	     mov ebp,0		;move flag to zero
	     mov al,0x3d	;place = sign in bl
	     call prt_chr	;points to next char in eax
	     ret


printOutInt2:cmp ebp,0		;see if flag is not set
	     je  printOutInt4	;if it has, return to sender
	     mov ebp,0		;set flag to zero
	     mov ebx,0		;move ebx to first char
	     mov ecx,0		;set counter to zero
	     dec edi		;I have no idea why this works
	     mov esi,litArr	;Move esi to beginning of Literal Array
printOutInt: mov al,[esi]	;move char of litArr to al
	     mov bl,[edi]	;if false, move internal Array char into bl
	     inc edi		;point to next char in internal Array
	     cmp al,0  	;see if end of lit Array has been reached
	     je  printOutInt2	;if true, jump up
	     cmp bl,0		;see if it is a zero
	     je printOutInt3	;if true repeat
	     inc ecx		;increase counter
	     cmp ecx,1		;check if first
	     jne printOutInt5	;if not move on
	     mov al,'+'	;if first, add a plus sign
	     call prt_chr	;print it
	     mov al,[esi]	;move char of litArr to al
printOutInt5:call prt_chr       ;move to next char in eax
	     mov ebp,1		;set flag
	     cmp bl,1		;chack if char is a 1
	     je printOutInt3	;if true, jump
	     mov al,0x27	;place ' in ebx
	     call prt_chr 	;point to next char in eax
printOutInt3:inc esi		;point to next char in litArr
	     jmp printOutInt ;repeat
printOutInt4:mov al,0x0a	;move line feed into al
	     call prt_chr	;print line feed
	     ret    		;return
	

;-----------------------------------------------------------------------------------------------------------------------
;eax as numliterals, ebx as numrows, edx as an array of 8 bytes representing a line in a truth table, edi as term array.
;set the nested loops by compares - each loop should loop once per go-around, but should be skipped depending
;on numliterals.  in the innermost loop have a call to a subroutine that checks that line of the truth table
;against all of the rows of the term array. Eight nested for-loop idea taken from Matt "The GZA Genius" Baker"s Code  
;with his permission
;-----------------------------------------------------------------------------------------------------------------------
print_minterms:
        pushad
	mov 	   eax,[numLiterals]	;move numLit into eax
	mov	   ebx,[numRows]
        mov        ecx, 2                ;loop twice
	cmp	   eax,7		;check for 8th literal
	jle	   .b1st		;if false, print out signal
	mov	   byte[edx],0		;if true print out zero
	jmp	   .1st

.b1st:	mov	   byte[edx],'5'

.1st:	cmp	   eax,6
	jle	   .b2nd
        mov        byte[edx + 1],0 
	jmp	   .2nd

.b2nd:	mov	   byte[edx+1],'5'

.2nd:	cmp	   eax,5
	jle	   .b3rd
        mov        byte[edx + 2], 0
	jmp	   .3rd

.b3rd:	mov	   byte[edx+2],'5'

.3rd:	cmp	   eax,4
	jle	   .b4th
        mov        byte[edx + 3], 0
	jmp	   .4th

.b4th:	mov	   byte[edx+3],'5'

.4th:	cmp	   eax,3
	jle	   .b5th
        mov        byte[edx + 4], 0
	jmp	   .5th

.b5th:	mov	   byte[edx+4],'5'

.5th:	cmp	   eax,2
	jle	   .b6th
        mov        byte[edx + 5], 0
	jmp	   .6th

.b6th:	mov	   byte[edx+5],'5'

.6th:	cmp	   eax,1
	jle	   .b7th
        mov        byte[edx + 6], 0
	jmp	   .7th

.b7th:	mov	   byte[edx+6],'5'

.7th:  	cmp	   eax,0
	jle	   .b8th 
        mov        byte[edx+7], 0
	jmp	   .8th

.b8th:	mov	   byte[edx+7],'5'

.8th:
        call       .print_line
	mov	   [numRows],ebx
        cmp        byte[edx+7], 1        ;check if it's already been set to one
        je        .jmp_back_7th                ;if it has, go to the more outer loop
        mov        byte[edx+7], 1
	cmp	   eax,0
	je	   .complete2
        jmp        .8th
   

.jmp_back_7th:

        cmp        byte[edx + 6], 1        ;check if it's already been set to one
        je        .jmp_back_6th                ;if it has, go to the more outer loop
        mov        byte[edx + 6], 1
	cmp	   eax,1
	je	   .complete2
        jmp        .7th
.complete2:jmp	.complete3         

.jmp_back_6th:

        cmp        byte[edx + 5], 1        ;check if it's already been set to one
        je        .jmp_back_5th                ;if it has, go to the more outer loop
        mov        byte[edx + 5], 1
	cmp	   eax,2
	je	   .complete3
        jmp        .6th        
.complete3:jmp	.complete4

.jmp_back_5th:

        cmp        byte[edx + 4], 1        ;check if it's already been set to one
        je        .jmp_back_4th                ;if it has, go to the more outer loop
        mov        byte[edx + 4], 1
	cmp	   eax,3
	je	   .complete4
        jmp        .5th
.complete4:jmp	.complete5     

.jmp_back_4th:

        cmp        byte[edx + 3], 1        ;check if it's already been set to one
        je        .jmp_back_3rd                ;if it has, go to the more outer loop
        mov        byte[edx + 3], 1
	cmp	   eax,4
	je	   .complete5
        jmp        .4th
.complete5:jmp	.complete6

.jmp_back_3rd:        

        cmp        byte[edx + 2], 1        ;check if it's already been set to one
        je        .jmp_back_2nd                ;if it has, go to the more outer loop
        mov        byte[edx + 2], 1
	cmp	   eax,5
	je	   .complete6
        jmp        .3rd
.complete6:jmp	.complete7

.jmp_back_2nd:

        cmp        byte[edx + 1], 1        ;check if it's already been set to one
        je        .jmp_back_1st                ;if it has, go to the outer loop
        mov        byte[edx + 1], 1
	cmp	   eax,6
	je	   .complete7
        jmp        .2nd
.complete7:jmp	.complete

.jmp_back_1st:

        cmp        byte[edx], 1                ;check if it's already been set to one
        je        .complete                ;if it has, it's done
        mov        byte[edx], 1
	cmp	   eax,7
	je	   .complete7
        jmp        .1st

        
.complete:
        popad
        ret



;-------------------------------------------------------------------------
;checks a line of a truth table against the rows of the term array
;        takes same arguments as print_minterms
;-------------------------------------------------------------------------


.print_line:
        pushad
	mov ecx,0
	mov esi,0		;set counter

.print_line5:
	mov edi,internalArray	;move internal array to next row	
	add edi,esi		;move edi to next row
	add esi,8		;reset counter
	mov ebp,litArr		;move the array of literals into ebp
	sub edx,ecx		;move edx back to the beginning
	mov ecx,[numRows]	;check the number of rows
	cmp ecx,0		;check if it is equal to zero
	je  .finished		;if true, get out w/out printing
	sub ecx,1		;decease by 1 (is actually adding two)
	mov [numRows],ecx
	mov ecx,0		;set counter to zero
	
.print_line2:
	mov bl,[ebp]		;move first char of litArr into bl
	mov al,[edx]		;move first char of minterm into edx
	cmp bl,' '		;See if at end of array
	je .print_line4		;print the minterm if true
	cmp bl,0		;see if at end of lit array
	je .print_line4		;print the minterm if true
	inc edx			;point to next char in edx
	inc ecx			;increase counter by 1
	cmp al,'5'		;see if edx is not applicable
	je .print_line2		;if true, skip it
	inc ebp			;point to next literal
	mov bl,[edi]		;point to character in internal array
	inc edi			;point to next char in internal array
	cmp bl,0		;see if this is a "don't care"
	je .print_line2		;if it is skip it
	cmp bl,1		;see if internal array holds a 1
	jne .print_line3	;if it doesn't, jump down
	cmp al,1		;see if minterm holds a 1 in that spot
	jne .print_line5	;if it doesn't return and do not print minterm
	jmp .print_line2	;if it is equal jump back up and do for next term
.print_line3:
	cmp al,0		;see if al is a zero
	jne .print_line5	;if this is not true,return to caller
	jmp .print_line2	;if this is equal jump back up


.finished:
	jmp	.prtloop2

.print_line4:	
	mov ebx,[numTerms]
	mov ecx,10		;set loop counter
	mov edi,0		;set zero counter
	mov esi,0
	sub edx,8		;move edx to first char
	push edx		;push edx
	mov eax,[minTermNumber] ;move minterm number into eax
	mov edx,minTermResult	;DX<-Address of String binary
	call conv		;convert to binary
	mov edx,minTermResult	;DX<-Address of String Binary
	mov eax,[minTermNumber] ;Minterm Number
	cmp eax,100		;see if less than 100
	jge .prtloop		;
	add edi,1		;if true, increase counter
	cmp eax,10		;see if less than 10
	jge .prtloop
	add edi,1		;if true increase counter
	jmp .prtloop

.bprtloop:
	inc	   edx		;point to next char in edx

.prtloop:
	mov        al,[edx]	;move char into al
	sub	   ecx,1	;decrease counter
	cmp	   al,' '	;see if blank
	je	   .bprtloop	;skip it
	cmp	   ecx,0	;check if at end of string
	jle	   .prtloop3	;go to end
	sub	    edi,1	;decrease counter
	cmp	    edi,0	;see if counter is finished
	jge	   .bprtloop	;if not, skip and don't print
	add	    esi,1	;
	cmp	    esi,1	;check if this is first char in term
	jne	   .prtloop4	;if false,skip
	cmp	    ebx,0	;check if this is the first term
	je	   .prtloop4	;if true,skip
	mov	    al,0x2C	;place comma in char
        call        prt_chr	;print out comma
	mov	    al,[edx]	;place char into al

.prtloop4:
        call       prt_chr	;print out character
	jmp	    .bprtloop	;jump back

.prtloop3:
	add	    byte[numTerms],1
	pop	    edx		;pop edx


.prtloop2:
	add	byte[minTermNumber],1 ;add one to minterm number
        popad			;pop a-d registers
        ret			;return to sender



conv:	push	ebx	
	push	ecx	
	mov     ebp,edx          ; Copy address of string
        add     ebp,3            ; Point to last character
        mov     ecx,3           ; Initialize counter
        mov     ebx,10           ; Initialize divisor
divide: mov     edx,0            ; Dividend = EDX,EAX - zero EDX
        div     ebx              ; (EDX,EAX)/EBX - Quotient->EAX Rem->EDX
        add     dl,0x30          ; Convert remainder to ASCII
        mov     [ebp],dl         ; Store in string
        dec     ebp              ; Point to next string character
        loop    divide           ; Do for all characters
	pop	ecx
	pop	ebx
        ret                      ; Back to caller
       

