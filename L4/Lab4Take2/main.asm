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

ORG 0300h
INIT:	MOV DPTR, #NUMS		; init - Data pointer
	timL EQU 0F2H
	timh EQU 0FFH		; stałe timera
	COUNTER EQU 30h		; adres licznika
	DIVISOR EQU 0Ah		; 10
	MAX EQU 64h		; 100
	INITVAL EQU 00h		; 0
	MOV COUNTER, #INITVAL	; wyzerowanie licznika
	MOV TMOD, #01h		; 16-bit timer
	MOV TL0, #timL
	MOV TH0, #timH		; czas timera
	SETB TR0		; zacznij liczyć
	SETB ET0		; maska timera
	SETB EA			; maska główna

MAIN:	LJMP MAIN		; mądry program

ORG 0000Bh
	LJMP TIMI

ORG 0400h
TIMI:	MOV TL0, #timL
	MOV TH0, #timH		; reset czasu timera
	MOV A, COUNTER
	CJNE A, #MAX, CONT
	MOV COUNTER, #INITVAL	; overflow - reset wartości countera
	MOV A, COUNTER
CONT:	MOV B, #DIVISOR
	DIV AB			; dzielenie (10) - A (wynik dzielenia) | B (reszta)
	MOVC A, @A+DPTR
	MOV P2, A		; odpowiednia wartość na port dziesiątek
	MOV A, B
	MOVC A, @A+DPTR
	MOV P3, A		; odpowiednia wartość na port jednostek
	INC COUNTER		; inkrementacja licznika
	RETI

END