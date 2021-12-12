	.ORG 0000H
	ljmp SystemInit
	.ORG 000BH
	ljmp TIMER0_ISR
	.ORG 0100H

SystemInit:
	
	mov R0 , #0
	mov R1 , #0
	mov R2 , #0
	setb P3.1
	setb EA
	acall LcdInit
	acall TimerInit
	acall GameEntry

	ret

GameEntry:

	mov dptr , #0A001H
	movx A , @DPTR
	anl A , #0x01
	jz GameSelect
	sjmp GameEntry

GameSelect:

	mov A , R2
	mov B , #10
	div AB
	mov A , B
	jz Game1
	mov A , B
	subb A , #1
	jz Game2
	mov A , B
	subb A , #2
	jz Game3
	mov A , B
	subb A , #3
	jz Game4
	mov A , B
	subb A , #4
	jz Game5
	mov A , B
	subb A , #5
	jz Game6
	mov A , B
	subb A , #6
	jz Game7
	mov A , B
	subb A , #7
	jz Game8
	mov A , B
	subb A , #8
	jz Game9
	mov A , B
	subb A , #9
	jz Game10

	ret

Game1:

	mov 0048h , #1
	mov A , #40H
	mov DPTR , #Game1cards
	acall printLCD

	ljmp PlayGame

Game2:

	mov 0048h , #2
	mov A , #40H
	mov DPTR , #Game2cards
	acall printLCD

	ljmp PlayGame

Game3:

	mov 0048h , #3
	mov A , #40H
	mov DPTR , #Game3cards
	acall printLCD

	ljmp PlayGame

Game4:

	mov 0048h , #4
	mov A , #40H
	mov DPTR , #Game4cards
	acall printLCD

	ljmp PlayGame

Game5:

	mov 0048h , #5
	mov A , #40H
	mov DPTR , #Game5cards
	acall printLCD

	ljmp PlayGame

Game6:

	mov 0048h , #6
	mov A , #40H
	mov DPTR , #Game6cards
	acall printLCD

	ljmp PlayGame

Game7:

	mov 0048h , #7
	mov A , #40H
	mov DPTR , #Game7cards
	acall printLCD

	ljmp PlayGame

Game8:

	mov 0048h , #8
	mov A , #40H
	mov DPTR , #Game8cards
	acall printLCD

	ljmp PlayGame

Game9:

	mov 0048h , #9
	mov A , #40H
	mov DPTR , #Game9cards
	acall printLCD

	ljmp PlayGame

Game10:

	mov 0048h , #10
	mov A , #40H
	mov DPTR , #Game10cards
	acall printLCD

	ljmp PlayGame

PlayGame:

	clr TR0
	mov R0 , #0
	mov R1 , #1
	mov R2 , #2
	acall GameInit
	acall GameMain

	ret

GameInit:

	acall DelayA
	mov A , #40H
	mov DPTR , #Cover
	acall printLCD
	setb TR0
	mov 0031h,#0
	mov 0053h,#'0'
	mov 0040h,#'0'
	mov 0050h,#0
	mov 0060h,#0
	mov 0061h,#0
	mov 0062h,#0
	mov 0063h,#0
	mov 0064h,#0
	mov 0065h,#0
	mov 0066h,#0
	mov 0067h,#0
	mov 0068h,#0
	mov 0069h,#0

	ret

GameMain:

	acall ViewUpdate
	
	mov DPTR , #0A001H
	movx A , @DPTR
	anl A , #0x01
	jz ShiftLeft
	
	mov DPTR , #0A001H
	movx A , @DPTR
	anl A , #0x02
	jz ShiftRight

	mov DPTR , #0A001H
	movx A , @DPTR
	anl A , #0x08
	jz ShowAndCompareCard

	sjmp GameMain

ShiftLeft:

	mov A , 0031H
	cjne A , #0 , ShiftLeft_i
	mov A , #1
	acall DelayA
	acall Clear

	ljmp GameMain

ShiftLeft_i:

	mov A , 0031H
	dec A
	mov 0031H , A
	mov A , #1
	acall DelayA
	acall Clear

	ljmp GameMain

ShiftRight:

	mov A , 0031H
	cjne A , #9 , ShiftRight_i
	mov A , #1
	acall DelayA
	acall Clear

	ljmp GameMain
	
ShiftRight_i:

	mov A , 0031H
	inc A
	mov 0031H , A
	mov A , #1
	acall DelayA
	acall Clear

	ljmp GameMain

ShowAndCompareCard:
	
	acall CheckCard
	acall ShowAndCompare
	acall Clear
	ljmp GameMain

ShowAndCompare:
	
	mov A , 0048h
	xrl A , #1
	jz	Game1Compare
	mov A , 0048h
	xrl A , #2
	jz	Game2Compare
	mov A , 0048h
	xrl A , #3
	jz	Game3Compare
	mov A , 0048h
	xrl A , #4
	jz	Game4Compare
	mov A , 0048h
	xrl A , #5
	jz	Game5Compare
	mov A , 0048h
	xrl A , #6
	jz	Game6Compare
	mov A , 0048h
	xrl A , #7
	jz	Game7Compare
	mov A , 0048h
	xrl A , #8
	jz	Game8Compare
	mov A , 0048h
	xrl A , #9
	jz	Game9Compare
	mov A , 0048h
	xrl A , #10
	jz	Game10Compare

Game1Compare:
	
	mov	DPTR , #Game1cards
	ljmp I00

Game2Compare:

	mov	DPTR , #Game2cards
	ljmp I00

Game3Compare:

	mov	DPTR , #Game3cards
	ljmp I00

Game4Compare:

	mov	DPTR , #Game4cards
	ljmp I00

Game5Compare:

	mov	DPTR , #Game5cards
	ljmp I00

Game6Compare:

	mov	DPTR , #Game6cards
	ljmp I00

Game7Compare:

	mov	DPTR , #Game7cards
	ljmp I00

Game8Compare:

	mov	DPTR , #Game8cards
	ljmp I00

Game9Compare:

	mov	DPTR , #Game9cards
	ljmp I00

Game10Compare:

	mov	DPTR , #Game10cards
	ljmp I00

I00:

	mov A , 0031H
	movc A , @A+DPTR	
	mov 0040h , A
	mov A , 0031H
	mov DPH , A
	mov DPL , #1
	mov A , 0040H
	acall putcLCD

	mov A , 0050h ; check is card1 or card2
	xrl A , #1		
	jnz ret0
	mov A , 0031H
	mov 0052h , A
	ljmp Compare

ret0:

	mov A,#1
	mov 0050h,A
	mov A,0031H
	mov 0051h,A
	mov 0040H,0041H
	acall clear	
	ljmp GameMain

Compare:

	mov	A , 0051H ; avoid choose same position card
	xrl A , 0052H
	jz Goback
	mov	A , 0041H ; check two cards are idential or not
	xrl A , 0040H
	jnz Wrong
	inc 0053H
	mov A , 0053H ; check if all card are been pair
	xrl A , #'5'
	jz Win
	acall Save
	acall Save_i
	mov A , #0
	mov 0050H , A

Goback:
	
	acall Clear
	ljmp GameMain

Wrong:
	
	mov A , #50
	acall DelayA
	ljmp Wrong_i

Wrong_i:

	mov A , #0
	mov 0050h , A
	mov A , 0051h ; recover cards
	mov DPH , A
	mov	DPL , #1
	mov	A , #ffH
	acall putcLCD
	mov A , 0052h
	mov DPH , A
	mov	DPL , #1
	mov	A , #ffH
	acall putcLCD
	inc R0 ; punishment for incorrect ( lost 5s )
	inc R0
	inc R0
	inc R0
	mov A,R0 ; check if after losing 5s player still have time or not
	mov B,#10
	div AB
	xrl A,#6
	jz Lose
	ljmp Goback

Win:

	mov	A , 0053h
	mov	DPH , #13
	mov	DPL , #1
	acall putcLCD
	acall DelayA
	mov	dptr , #8000H
	mov	A , #01H ; Clear display
	movx @dptr , A

Win_i:
	
	mov	A , #00H
	mov	DPTR , #Winner
	acall printLCD
	sjmp Win_i

Lose:

	mov	A , 0053h
	mov	DPH , #13
	mov	DPL , #1
	acall putcLCD
	acall DelayA
	mov	dptr , #8000H
	mov	A , #01H ; Clear display
	movx @dptr , A

Lose_i:
	
	mov	A , #00H
	mov	DPTR , #Loser
	acall printLCD
	sjmp Lose_i

CheckCard: ; check whether the card player choose have been pair
	
	mov A , 0031h
	xrl A , #0
	jz	c0
	mov A , 0031h
	xrl A , #1
	jz	c1
	mov A , 0031h
	xrl A,#2
	jz	c2
	mov A , 0031h
	xrl A,#3
	jz	c3
	mov A , 0031h
	xrl A,#4
	jz	c4
	mov A , 0031h
	xrl A , #5
	jz	c5
	mov A , 0031h
	xrl A , #6
	jz	c6
	mov A , 0031h
	xrl A , #7
	jz	c7
	mov A , 0031h
	xrl A , #8
	jz	c8
	mov A , 0031h
	xrl A , #9
	jz	c9
	
	reti

Goback_i:

	ljmp Goback

c0:

	mov A , 0060h
	xrl A , #1
	jz Goback_i
	ret

c1:

 	mov A,0061h
	xrl A,#1
	jz Goback_i
	ret

c2:

	mov A,0062h
	xrl A,#1
	jz Goback_i
	ret

c3:

	mov A,0063h
	xrl A,#1
	jz Goback_i
	ret

c4:

	mov A,0064h
	xrl A,#1
	jz Goback_i
	ret

c5:

	mov A,0065h
	xrl A,#1
	jz Goback_i
	ret

c6:

	mov A,0066h
	xrl A,#1
	jz Goback_i
	ret

c7:

	mov A,0067h
	xrl A,#1
	jz Goback_i
	ret

c8:

	mov A,0068h
	xrl A,#1
	jz Goback_i
	ret

c9:

	mov A,0069h
	xrl A,#1
	jz Goback_i
	ret

Save:

	mov A , 0051h
	xrl A , #0
	jz s0
	mov A , 0051h
	xrl A , #1
	jz s1
	mov A , 0051h
	xrl A , #2
	jz s2
	mov A , 0051h
	xrl A , #3
	jz s3
	mov A , 0051h
	xrl A , #4
	jz s4
	mov A , 0051h
	xrl A , #5
	jz s5
	mov A , 0051h
	xrl A , #6
	jz s6
	mov A , 0051h
	xrl A , #7
	jz s7
	mov A , 0051h
	xrl A , #8
	jz s8
	mov A , 0051h
	xrl A , #9
	jz s9

Save_i:

	mov A , 0052h
	xrl A , #0
	jz s0
	mov A , 0052h
	xrl A , #1
	jz s1
	mov A , 0052h
	xrl A , #2
	jz s2
	mov A , 0052h
	xrl A , #3
	jz s3
	mov A , 0052h
	xrl A , #4
	jz s4
	mov A , 0052h
	xrl A , #5
	jz s5
	mov A , 0052h
	xrl A , #6
	jz s6
	mov A , 0052h
	xrl A , #7
	jz s7
	mov A , 0052h
	xrl A , #8
	jz s8
	mov A , 0052h
	xrl A , #9
	jz s9

s0:
	
	mov 0060h,#1
	ret

s1:

	mov 0061h,#1
	ret

s2:

	mov 0062h,#1
	ret

s3:

	mov 0063h,#1
	ret

s4:

	mov 0064h,#1
	ret

s5:

	mov 0065h,#1
	ret

s6:

	mov 0066h,#1
	ret

s7:

	mov 0067h,#1
	ret

s8:

	mov 0068h,#1
	ret

s9:

	mov 0069h,#1
	ret

ViewUpdate:

	mov	A , 0053h
	mov	DPH , #15
	mov	DPL , #1
	acall  putcLCD

	mov	A , 0031h
	mov	DPH , A
	mov	DPL , #0
	mov A , #ffh
	acall putcLCD
	
	mov	A , 0031h		
	add	A , #30H
	mov	DPH , #13
	mov	DPL , #1
	acall putcLCD
	
	mov A , #60
	subb A , R0
	mov	B , #10
	div AB
	
	add	A , #30H		
	mov	DPH , #14		
	mov	DPL , #0
	acall putcLCD
	
	mov	A , B
	add	A , #30H		
	mov	DPH , #15		
	mov	DPL , #0
	acall putcLCD

	mov	A , R1
	mov	B , #10
	div	AB
	
	add	A , #30H		
	mov	DPH , #11		
	mov	DPL , #0
	acall putcLCD
	
	mov	A , B
	add	A , #30H		
	mov	DPH , #12		
	mov	DPL , #0
	acall putcLCD

	ret

Clear:

	mov A , #0
	mov DPTR , #Cover_i
	acall printLCD

	ret

TimerInit:

	; start timer,interrup in every 10ms.
	; the oscallator on board is 22.1184MHz,so each 22.1184/12 = 1.8432 MCPS. 
	; counting 18432 ticks to cause 10ms delay

	mov	TMOD , #01H
	mov	IE , #82H	
	mov	TH0 , #184 ;(65536-18432)/256 = 184
	mov	TL0 , #0 ;(65536-18432)%256 = 0
	setb TR0
	
	ret

TIMER0_ISR:
	
	mov	TH0 , #184
	mov	TL0 , #0	
	inc	R2
	cjne R2 , #100 , TIMER0_ISR_END
	inc R0
	mov	R2 , #0
	cjne R0 , #60 , TIMER0_ISR_END
	inc R1
	mov R0 , #0
	cjne R1 , #0 , Lose_ii

TIMER0_ISR_END:

	reti

Lose_ii:

	ljmp Lose

LcdInit:

	mov	dptr , #8000H ; LCD Addres Mapping 0x8000
	mov	A , #38H ; Set 8-bit I/O, display in 2 line
	movx @dptr, A	
	mov	A , #1
	acall DelayA
	mov	A , #0EH ; Set display cursor, no flashing
	movx @dptr , A
	mov A , #1
	acall DelayA
	mov A , #06H ; Set move cursor in each write
	movx @dptr , A
	mov	A , #1
	acall DelayA
	mov A , #01H ; Clear display
	movx @dptr , A
	mov A , #1
	acall DelayA

	mov	A , #0BH
	mov	DPTR , #Aminute
	acall printLCD

	ret

putcLCD:

	push ACC
	mov A , DPL
	rr A
	rr A
	orl A , DPH
	orl A , #80H
	mov dptr , #8000H
	movx @dptr , A
	mov A , #2
	acall DelayA
	pop ACC
	mov dptr , #8001H
	movx @dptr , A
	mov A , #2
	acall DelayA

	ret

printLCD:

	orl	A , #80H
	mov	R4 , #0FFH
	push DPH		
	push DPL
	mov	dptr , #8000H
	movx @dptr , A	
	pop DPL		
	pop DPH

printLCD_i:

	mov A,R4
	movc A , @A+DPTR
	jz	printLCD_ii
	push	DPH
	push	DPL
	mov	dptr,#8001H
	movx	@dptr,A
	pop	DPL
	pop	DPH
	mov	A,#1
	acall	DelayA
	inc	R4
	ajmp	printLCD_i

printLCD_ii:

	ret

DelayA:

	mov R7 , A

DelayA_k:

	mov R6 , #100

DelayA_j:

	mov R5 , #50

DelayA_i:

	djnz R5 , DelayA_i
	djnz R6 , DelayA_j
	djnz R7 , DelayA_k

	ret

Game1cards:

	.DB "BDCEDABCAE"
	.DB 00H

Game2cards:

	.DB "ACDBEEBDAC"
	.DB 00H

Game3cards:

	.DB "EBACACEBDD"
	.DB 00H

Game4cards:

	.DB "CBACEDDABE"
	.DB 00H

Game5cards:

	.DB "DACCEEABBD"
	.DB 00H

Game6cards:

	.DB "BBDEEACDCA"
	.DB 00H

Game7cards:

	.DB "EDACBABECD"
	.DB 00H

Game8cards:

	.DB "AECABEDDBC"
	.DB 00H

Game9cards:

	.DB "DBAACDEBEC"
	.DB 00H

Game10cards:

	.DB "CBEEDABCDA"
	.DB 00H

Cover:

	.DB ffh,ffh,ffh,ffh,ffh,ffh,ffh,ffh,ffh,ffh
	.DB 00H

Cover_i:

	.DB feh,feh,feh,feh,feh,feh,feh,feh,feh,feh
	.DB 00H

Aminute:

	.DB "01:00"
	.DB 00H

Winner:
	
	.DB 'You win!'
	.DB 00H

Loser:

	.DB 'You lose!'
	.DB 00H