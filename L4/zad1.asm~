ORG 0000h
	LJMP INIT

ORG 0900h
NUMS:	DB 11000000b ;0
	DB 11111001b ;1
	DB 10100100b ;2
	DB 10110000b ;3
	DB 10011001b ;4
	DB 10010010b ;5
	DB 10000010b ;6
	DB 11111000b ;7
	DB 10000000b ;8
	DB 10010000b ;9

INIT:	;Czesc initu dot. timera
	MOV TMOD, #01h
	SETB TR0
	SETB ET0
	;Czesc initu dot. wyswietlacza/tablicy
	MOV DPTR, #NUMS
	MOV A, #0
	MOV R0, #0
	;Czesc initu testowa 2bajtowa liczba (licznik)
	;MOV #34h, #0h

ORG 000Bh ; Obsluga przerwania od timera
MAIN:	MOV A, R0
	MOVC A, @A+DPTR
	MOV P3, A
	INC R0
	CJNE R0, #100, BACK
	MOV R0, #0
BACK:	RETI
END
