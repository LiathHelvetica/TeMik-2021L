ORG 0000H
	LJMP INIT

; P0 - okres
; P1 - wypełnienie
; F0 - if 0 odliczaj wypełnienie else odliczaj do okresu
; P2.0 - wyjście

ORG 0300H
INIT:	SETB F0				; najpierw odlicz do okresu
	COUNTER EQU 30H			; licznik
	PREVPERIOD EQU 31H		; zapamiętanie poprzedniego okresu
	PREVFILL EQU 32H		; zapamiętanie poprzedniego wypełnienia
	TLOW EQU 0F2H
	THIGH EQU 0FFH			; stałe timera
	MOV COUNTER, P1			; zacznij od odliczania do okresu
	MOV PREVPERIOD, P0
	MOV PREVFILL, P1		; początkowe wartości
	CLR P2.0			; zacznij od stanu niskiego
	MOV TMOD, #01h			; 16-bit timer
	MOV TL0, #TLOW
	MOV TH0, #THIGH			; czas timera
	SETB TR0			; zacznij liczyć
	SETB ET0			; maska timera
	SETB EA				; maska główna
MAIN:	LJMP MAIN			; mądry program

ORG 0000Bh
	LJMP TIMI

ORG 0400h
TIMI:	MOV TL0, #TLOW
	MOV TH0, #THIGH			; czas timera
	MOV A, P0
	CJNE A, PREVPERIOD, RESET
	MOV A, P1
	CJNE A, PREVFILL, RESET
	JB F0, PERIOD
	LJMP FILL

RESET:	SETB F0
	MOV COUNTER, P1			; zacznij od odliczania do okresu
	MOV PREVPERIOD, P0
	MOV PREVFILL, P1		; początkowe wartości
	CLR P2.0			; zacznij od stanu niskiego
	RETI

PERIOD:	MOV A, COUNTER
	SUBB A, P0
	JC SKIPP
	SETB P2.0
	MOV COUNTER, #01H
	CLR F0
	RETI

SKIPP:	INC COUNTER
	RETI

FILL:	MOV A, COUNTER
	SUBB A, P1
	JC SKIPF
	CLR P2.0
	SETB F0
SKIPF:	INC COUNTER
	RETI