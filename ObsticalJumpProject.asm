;COAL FINAL PROJECT BY:
;HIRA IJAZ 19L-2377
;RIVA NOUMAN 19L-1117
[org 0x0100]
jmp start
tickcount: dw 0 
oldkbsir: dd 0
initialPosition: dw 2110 ;2110=base,1955=neck(|),1795=haed(>) 
beak: dw 0
jumpCount: dw 4
jumpPosistion: dw 0
jumpdifference: dw 480
dinoAscii: db 0xDB,0x3E
space: db ' '
yellow: db '>'
score: dw 'Score: '
scorelength: dw 7
obsticalInitialPosition: dw 2240 ;screen right most of line 13th
obsticalOnePosition: dw 2238
obsticalTwoPosition: dw 2238 
obsticalThreePosition: dw 2238
distance:  ;40;65
obsticalOneHeight: dw 3
obsticalTwoHeight: dw 4
obsticalThreeHeight: dw 3
obs2flag: dw 0
obs3flag: dw 0
counter: dw 0
jumpflag: dw 0
jumpcounter: dw 0
jumpUp1: dw 1
collision: dw 0
gameOver: dw 'Game Over!'
gameOverLen: dw 10
oldTime: dd 0
gamestart: dw 'Press Any Key To Start'
gameStartLen: dw 22
StarPos: dw 210,330,390,480,500,590,730,880,68,148,650,400,798,600
starCount: dw 14
clrscr:
		push es
		push ax
		push di
		mov ax,0xb800
		mov es,ax
		mov di, 0


nextloc: 
		mov word [es:di],0x0720
		add di,2
		cmp di,4000
		jne nextloc
		pop di
		pop ax
		pop es
ret
printstr:
		 push bp
		 mov bp, sp
		 push es
		 push ax
		 push cx
		 push si
		 push di
		 mov ax, 0xb800
		 mov es, ax ; point es to video base
		 mov al, 80 ; load al with columns per row
		 
		 mul byte [bp+10] ; multiply with y position
		 add ax, [bp+12] ; add x position
		 shl ax, 1 ; turn into byte offset
		 mov di,ax ; point di to required location
		 mov si, [bp+6] ; point si to string
		 mov cx, [bp+4] ; load length of string in cx
		 mov ah, [bp+8] ; load attribute in ah
		 
	nextchar: 
		 mov al, [si] ; load next char of string
		 mov [es:di], ax ; show this char on screen
		 add di, 2 ; move to next screen location
		 add si, 1 ; move to next char in string
		 loop nextchar ; repeat the operation cx times
		 pop di
		 pop si
		 pop cx
		 pop ax
		 pop es
		 pop bp
		 
ret 10 

 
 printnum:
			 push bp
			 mov bp, sp
			 push es
			 push ax
			 push bx
			 push cx
			 push dx
			 push di
			 mov ax, 0xb800
			 mov es, ax ; point es to video base
			 mov ax, [bp+4] ; load number in ax
			 mov bx, 10 ; use base 10 for division
			 mov cx, 0 ; initialize count of digits
			 
		nextdigit: mov dx, 0 ; zero upper half of dividend
			 div bx ; divide by 10
			 add dl, 0x30 ; convert digit into ascii value
			 push dx ; save ascii value on stack
			 inc cx ; increment count of values
			 cmp ax, 0 ; is the quotient zero
			 jnz nextdigit ; if no divide it again
			 
			 mov di, 620 ; point di to top left column
		nextpos: pop dx ; remove a digit from the stack
			 mov dh, 0x07 ; use normal attribute
			 mov [es:di], dx ; print char on screen
			 add di, 2 ; move to next screen location
			 loop nextpos ; repeat for all digits on stack
			 pop di
			 pop dx
			 pop cx
			 pop bx
			 pop ax
			 pop es
			 pop bp
ret 2 
delay:
		 push cx
		 mov cx,0xffff
		 l2:
		 sub cx,1
		 jnz l2
		 pop cx

 ret
 ;----------------------- Sound Functions -----------------
sound1:

		push ax
		push bx

		mov al,182
		out 43h,al
		mov ax,2711

		out 42h,al
		mov al,ah
		out 42h,al
		in al,61h

		or al,00000011b
		out 61h,al
		mov bx,2

	pas1:
		mov cx,65535

	pas2:
		dec cx
		jne pas2
		dec bx
		jne pas1
		in al,61h
		and al,11111100b
		out 61h,al


		pop bx
		pop ax

ret
gameOverBeep:

		push ax
		push bx

		mov al,182
		out 43h,al
		mov ax,4831

		out 42h,al
		mov al,ah
		out 42h,al
		in al,61h

		or al,00000011b
		out 61h,al
		mov bx,2

	pas3:
		mov cx,65535

	pas4:
		dec cx
		jne pas4
		dec bx
		jne pas3
		in al,61h
		and al,11111100b
		out 61h,al


		pop bx
		pop ax

ret
;-------------- Printing Functions ------------
printScore:
			 pusha 
			 mov ax,60;x-position
			 push ax
			 mov ax, 3;y-position
			 push ax
			 mov ax,7 ;white
			 push ax
			 mov ax,score
			 push ax
			 push word [scorelength]
			 call printstr
			 popa
ret
 
printBackground:
        pusha
		mov ax,0xb800
		mov es,ax
		mov di, 2240 ;line no.15
		
		mov ah,10001111b
		mov al,'*'
		mov bx,0
		mov cx,[starCount]
		call clrscr
		
star:
	mov di,[StarPos+bx]
	mov [es:di],ax
	add bx,2
loop star
	mov bh,1011b
	mov bl,0xDB
	mov di, 2240 ;line no.15
line:

		mov word [es:di],bx ;print underscore
		add di,2
		
		cmp di,4000
		
jne line
popa
ret

printgameover:

	push ax
	mov ax, 30; x position
	push ax
	mov ax, 10; y position
	push ax
	mov ax,10000101b; red colour
	push ax
	mov word ax, gameOver ;blink in magenta
	push ax
	push word [gameOverLen]
	call printstr
	pop ax

ret

gameStart:
	 push ax
	 mov ax,30
	 push ax
	 mov ax,10
	 push ax
	 mov ax,10000101b ;blink in magenta
	 push ax
	 mov word ax,gamestart
	 push ax
	 mov word ax,[gameStartLen]
	 push ax
	 call printstr
	 pop ax
 ret
 

;----------------- Dino Printing ----------------
dino:
pusha

	mov word di,[initialPosition] ;get body poisyion
	mov cx,5
	mov dh,'>'
	mov dl,0xDB
	
	body:
		mov word [es:di],dx
		add di,2
		dec cx
		cmp cx,0
	jne body
	mov di,[initialPosition]
	mov dl,0xDB
	sub di,152 ;neck
	mov word [es:di],dx
	sub di,160
	mov word [es:di],dx
	add di,2
	mov dh,0x07
	mov dl,0x3E
	mov word [es:di],dx ;beak
	mov word[beak],di
	
popa
ret	

blankdino:
pusha

	mov word di,[initialPosition] ;get body poisyion
	mov cx,5
	mov dh,0x07
	mov dl,0x20
	
	blankbody:
		mov word [es:di],dx
		add di,2
		
	loop blankbody
	mov word di,[initialPosition]
	mov dx,0x0720
	sub di,152 ;neck
	mov word [es:di],dx
	sub di,160
	mov word [es:di],dx
	add di,2
	mov dh,0x07
	mov dl,0x20
	mov word [es:di],dx
	
popa
ret

;------------------------- 0bsticale Printing ----------------------

printObsticle:

		push bp
		mov bp,sp
		push ax
		push bx
		push cx
		push dx
		push di
		push es


		mov word di,[bp+6] ;initialposition
		mov word cx,[bp+4] ;height
		mov dh,02
		mov dl,0xDB

	print:
		mov [es:di],dx
		sub di,160
		loop print
		pop es
		pop di
		pop dx
		pop cx
		pop bx
		pop ax
		pop bp

ret 4 

removeObsticle:
		push bp
		mov bp,sp
		push ax
		push bx
		push cx
		push dx
		push di
		mov dh,0x07
		mov dl,0x20
		cmp word [bp+6],2238 ;leftmostside
		jne ignore
		mov word cx,[obsticalTwoHeight]
		mov word di,2082
		remove1:

		mov [es:di],dx
		sub di,160
		loop remove1

	ignore:
		mov word di,[bp+6] ;initialposition
		;add di,2
		mov word cx,[bp+4] ;height


	remove:

		mov [es:di],dx
		sub di,160
		loop remove

		pop di
		pop dx
		pop cx
		pop bx
		pop ax
		pop bp

ret 4 ;pop initialposition and height

;------------------- Collision Functions -----------------

collisionCaseOne:
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	mov dx, [beak]
	mov bx, [bp+4]; obstical initiall position
	sub word bx, 320
	cmp dx, bx
	jne false
	mov word [collision], 1
false:
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	
ret 2	
collisionCaseTwo:
		pusha
		mov word di,[initialPosition]
		mov word cx,5
		 
	check:
		mov word dx,[es:di]
		cmp dl,0x20 ;compare with space ascii
		jne setflag
		add di,2
		loop check

		mov di,[initialPosition]
		sub di,152
		mov word dx,[es:di]
		cmp dl,0x20 ;compare with space ascii
		jne setflag

		sub di,160
		mov word dx,[es:di]
		cmp dl,0x20 ;compare with space ascii
		jne setflag
		add di,2
		mov word dx,[es:di]
		cmp dl,0x20 ;compare with space ascii
		jne setflag

	continue:
popa
ret
collisionCaseThree:
push bp
mov bp,sp
push di
push cx

		mov di,[bp+6] ;obs position
		mov cx,[bp+4] ;obs height
	check2:
		mov dx,[es:di]
		cmp dl,0x20
		jne setflag2
		sub di,160
		loop check2
	continue2:
pop cx
pop dx
pop bp
ret 4 ;pop obs position and height

setflag:

	mov word [collision],1
	
jmp continue
setflag2:

	mov word [collision],1
	
jmp continue2


 ;------------------------- Key Board Interrupt ---------------
 mykbisr:

		push ax
		push es
		push cs
		pop ds

		in al,0x60
		
		cmp al,0x39 ;check if space is pressed
		jne exit
		mov word[jumpflag],1
		call sound1
		
		
					exit:
					mov al,0x20
					out 0x20,al
		pop es
		pop ax
 jmp far [cs:oldkbsir] 
;------------------------ Timer Interrupt ---------------------
timer:
		push ax
		cmp word [collision], 1
		je khatam
		mov ax,0xb800
		mov es,ax
		pop ax

		 push ax
		 
		 inc word[cs:counter]
		 cmp word[cs:counter],3
		 je  printdino
		
	khatam:
		 cmp word[collision],1
		 jne skipover
		 call printgameover
		
		
	skipover:

		 mov al, 0x20
		 out 0x20, al ; end of interrupt
		 pop ax
		 iret 
	printdino:
		 
		 cmp word[jumpflag],1
		 
		 jne label1
		 
		 cmp word[jumpUp1],1
		 jne jumpdown1
		 inc word[jumpcounter]
		 cmp word[jumpcounter],9
		 jne lol1
		 mov word[jumpcounter],0
		 mov word[jumpUp1],0
		 jmp label1
		 lol1:
		 call blankdino
		 
		 push ax
		 mov ax,0xb800
		 mov es,ax
		 pop ax
		 sub word [initialPosition],160
		 call collisionCaseTwo
		 call dino
		 jmp label1
		 
	jumpdown1:
		 inc word[jumpcounter]
		 cmp word[jumpcounter],9
		 jne lol2
		 mov word [jumpflag],0
		 mov word[jumpcounter],0
		 mov word[jumpUp1],1
		 jmp label1
		 lol2:
		 call blankdino
		 
		 push ax
		 mov ax,0xb800
		 mov es,ax
		 pop ax
		 add word [initialPosition],160
		 call collisionCaseTwo
		 call dino
		 
		 
		 
		 
		 
	label1:
	
			mov word[cs:counter],0
			cmp word[cs:obs2flag],1 ;incase flag is already true
			je TwoalreadySet
			cmp word[cs:obsticalOnePosition],2200 ;60th column 
			jg donotSet
			mov word[cs:obs2flag],1

			TwoalreadySet:

			cmp word[cs:obs3flag],1 ;incase flag is already true
			je ThreealreadySet
			cmp word[cs:obsticalTwoPosition],2180 ;50th column 
			jg donotSet
			mov word[cs:obs3flag],1
			ThreealreadySet:
			donotSet:

		move:
			push word[obsticalOnePosition] ;initialposition of obsticalOne
			push word[cs:obsticalOneHeight] 
			call removeObsticle
			sub word [cs:obsticalOnePosition],2 ;update obstical One Position
			push word[obsticalOnePosition] ;initialposition of obsticalOne
			push word[cs:obsticalOneHeight] 
			call collisionCaseThree

			cmp word[cs:obs2flag],1  
			jne skip2
			push word [obsticalTwoPosition] ;initialposition of obstical two
			push word [cs:obsticalTwoHeight] 
			call removeObsticle
			sub word [cs:obsticalTwoPosition],2 ;update obstical two Position
			push word [obsticalTwoPosition] ;initialposition of obstical two
			push word [cs:obsticalTwoHeight] 
			call collisionCaseThree

			cmp word [cs:obs3flag],1     
			jne skip2
			push word [cs:obsticalThreePosition] ;initialposition of obstical three
			push word [cs:obsticalThreeHeight]
			call removeObsticle
			sub word [cs:obsticalThreePosition],2 ;update obstical three Position
			push word [cs:obsticalThreePosition] ;initialposition of obstical three
			push word [cs:obsticalThreeHeight]
			call collisionCaseThree
			
		skip2:
			;---------print---------
			push word[cs:obsticalOnePosition] ;initialposition of obsticalOne
			push word[cs:obsticalOneHeight] 
			call printObsticle ;for obsticalOne
			push word [cs:obsticalOnePosition]
			call collisionCaseOne
			
			;check for obstical Two
			cmp word[cs:obs2flag],1 
			jne skip1 ;to remove obstical one
			push word[obsticalTwoPosition];initialposition of obstical two
			push word [cs:obsticalTwoHeight] 
			call printObsticle
			push word [cs:obsticalTwoPosition]
			call collisionCaseOne
			
			cmp word [cs:obs3flag],1 
			jne skip1 ;to remove obstical2
			push word [obsticalThreePosition] ;initialposition of obstical three
			push word [cs:obsticalThreeHeight]
			call printObsticle
			push word [cs:obsticalThreePosition]
			call collisionCaseOne
			
		skip1:
			

			cmp word[cs:obsticalOnePosition],2082
			jne skip3
			push dx
			mov word dx,[cs:obsticalInitialPosition]
			mov word[cs:obsticalOnePosition],dx
			pop dx
			
			;jmp cont

		skip3:
			cmp word[cs:obsticalTwoPosition],2082
			jne skip4
			push dx
			mov word dx,[cs:obsticalInitialPosition]
			mov word[cs:obsticalTwoPosition],dx
			pop dx
			;jmp cont

		skip4:
			cmp word[cs:obsticalThreePosition],2082
			jne skip5
			push dx
			mov word dx,[cs:obsticalInitialPosition]
			mov word[cs:obsticalThreePosition],dx
			pop dx
			skip5:
			
			
		 
	cont:
		 
		 inc word [cs:tickcount]; increment tick count
		 push word [cs:tickcount]
		 call printnum ; print tick count
		 

		 mov al, 0x20
		 out 0x20, al ; end of interrupt
		 pop ax
	 
 iret 
 
 
 
 
start:
		call clrscr
		clrsc1:

        call sound1
		call sound1
		call sound1
		call sound1
		
		call gameStart
		
		call sound1
		call sound1
		call sound1
		call sound1
		call sound1
		call sound1
		
			 mov ah, 0 ; service 0 – get keystroke
			 int 0x16
		 
		call clrscr
		
        call printBackground
		
		call printScore
		
		call dino


		xor ax,ax
		mov es,ax
		mov ax,[es:9*4]
		mov [oldkbsir],ax
		mov ax,[es:9*4+2]
		mov [oldkbsir+2],ax
		mov ax,[es:8*4]
		mov [oldTime],ax
		mov ax,[es:8*4+2]
		mov [oldTime+2],ax
		cli
		mov word[es:9*4],mykbisr
		mov [es: 9*4+2],cs
		mov word [es:8*4], timer; store offset at n*4
		mov [es:8*4+2], cs

		sti
	l1:
		 
		 cmp word [collision],1
		 je Haargai

		jmp l1
		
	Haargai:
		call gameOverBeep
		call gameOverBeep
		call gameOverBeep
		call gameOverBeep
		cli                           ; disable interrupts
		 
		 xor ax, ax
		 mov es, ax   
		 
		 mov ax,[oldkbsir]                ; store offset at n*4
		 mov bx,[oldkbsir+2]              ; store segment at n*4+2
		 mov word [es:9*4], ax         ; store offset at n*4
		 mov word [es:9*4+2], bx       ; store segment at n*4+2

		 mov ax,[oldTime]              ; store offset at n*4
		 mov bx,[oldTime+2]            ; store segment at n*4+2
		 mov word [es:8*4], ax         ; store offset at n*4
		 
		 mov word [es:8*4+2], bx       ; store segment at n*4+2
		 sti 



mov ax, 0x4c00 ; terminate and stay resident
int 0x21 
