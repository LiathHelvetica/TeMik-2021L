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
	RUN: DBIT 1		; flaga on/off (1/0)
	SETB RUN
	MOV COUNTER, #INITVAL	; wyzerowanie licznika
	MOV TMOD, #01h		; 16-bit timer
	MOV TL0, #timL
	MOV TH0, #timH		; czas timera
	SETB TR0		; zacznij liczyć
	SETB IT0		; przerwania na zboczu
	SETB IT1
	SETB ET0		; maska timera
	SETB EX0		; maska P3.2 (reset)
	SETB EX1		; maska P3.3 (start/stop)
	SETB PX0		; wysoki priorytet przycisków
	SETB PX1
	CLR PT0			; niski priorytet timera
	SETB EA			; maska główna

MAIN:	LJMP MAIN		; mądry program

ORG 0000Bh
	LJMP TIMI

ORG 00003h
	LJMP RESET

ORG 0013h
	LJMP ONOFF

ORG 0400h
TIMI:	MOV TL0, #timL
	MOV TH0, #timH		; reset czasu timera
	JNB RUN, PURGE		; jeśli off to nie rób nic
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
	MOV P1, A		; odpowiednia wartość na port jednostek
	INC COUNTER		; inkrementacja licznika
PURGE:	RETI

ORG 0500h
RESET:	MOV COUNTER, #INITVAL	; reset wartości countera
	MOV A, #00h		; reset wartości na liczniku
	MOVC A, @A+DPTR
	MOV P2, A
	MOV P1, A
	MOV A, #00h		; reset A w razie przerwania w trakcie przerwania timera
	RETI

ORG 0600h
ONOFF:	CPL RUN			; zmiana flagi działania licznika
	RETI

END