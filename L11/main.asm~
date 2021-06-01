ORG 0000H
	LJMP INIT

ORG 00003h
	LJMP RESET

ORG 0000Bh
	LJMP TIMI

ORG 0013h
	LJMP ROLL

; P2 - dziesiątki
; P1 - jedności
; P3.2 - reset
; P3.3 - roll

ORG 0100H
INIT:	MOV DPTR, #NUMS		; init - Data pointer
	TIML EQU 0F8H
	TIMH EQU 0FFH		; stałe timera
	COUNTER EQU 30H
	SUM EQU 31H
	DIVI EQU 06H
	DIVO EQU 010D
	MAX EQU 100D
	MOV SUM, #0H
	MOV COUNTER, #0H
	ACALL SHOW
	MOV TMOD, #01h		; 16-bit timer
	MOV TL0, #TIML
	MOV TH0, #TIMH		; czas timera
	SETB TR0		; zacznij liczyć
	SETB IT0		; przerwania na zboczu
	SETB IT1
	SETB ET0		; maska timera
	SETB EX0		; maska P3.2 (reset)
	SETB EX1		; maska P3.3 (roll)
	SETB EA			; maska główna

MAIN:	LJMP MAIN		; mądry program

TIMI:	INC COUNTER
	MOV TL0, #TIML
	MOV TH0, #TIMH		; czas timera
	RETI

RESET:	MOV SUM, #0H
	ACALL SHOW
	RETI

ROLL:	MOV A, COUNTER
	MOV B, #DIVI
	DIV AB
	INC B			; B - outcome
	MOV A, SUM
	ADD A, B
	MOV SUM, A
	MOV A, SUM
	SUBB A, #MAX
	JC NORES
	MOV SUM, A
NORES:	ACALL SHOW
	RETI

SHOW:	MOV A, SUM
	MOV B, #DIVO
	DIV AB			; dzielenie (10) - A (wynik dzielenia) | B (reszta)
	MOVC A, @A+DPTR
	MOV P2, A		; odpowiednia wartość na port dziesiątek
	MOV A, B
	MOVC A, @A+DPTR
	MOV P1, A		; odpowiednia wartość na port jednostek
	RET

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

END