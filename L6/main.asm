ORG 0000H
	LJMP INIT

; LEGENDA:

; P0 - okres (T)
; P1 - wypełnienie (F)
; F0 - if 0 odliczaj wypełnienie ||| else odliczaj do okresu
; AHI (cały czas stan wysoki) - 1 if F >= T ||| else 0
; P2.0 - wyjście

ORG 0300H
INIT:	SETB F0				; najpierw odlicz do okresu
AHI:	DBIT 1				; Always High - 1 jeśli T <= F wpp. 0
	COUNTER EQU 30H			; adres licznika
	PREVPERIOD EQU 31H		; zapamiętanie poprzedniego okresu
	PREVFILL EQU 32H		; zapamiętanie poprzedniego wypełnienia
	TLOW EQU 0F2H
	THIGH EQU 0FFH			; stałe timera
	MOV COUNTER, P1			; zacznij od odliczania do okresu
	INC COUNTER			; timer przesunięty o 1 (odliczanie od 1 do T+1)
	MOV PREVPERIOD, P0
	MOV PREVFILL, P1		; początkowe wartości
	MOV A, P0
	SUBB A, P1			; Czy T < F
	JNC ISEQU			; Jeśli nie to jump do ISEQU
BEGHI:	SETB P2.0			; stan wysoki na wyjściu
	SETB AHI			; Always High
	LJMP CONT
ISEQU:	MOV A, P0
	CJNE A, P1, BEGLOW		; Czy T != F
	LJMP BEGHI			; T == F - takie same czynności jakby T < F
BEGLOW:	CLR P2.0			; stan niski na wyjściu
	CLR AHI				; Not Always High
CONT:	MOV TMOD, #01h			; 16-bit timer
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
	CJNE A, PREVPERIOD, RESET	; Czy wartość T się zmieniła
	MOV A, P1
	CJNE A, PREVFILL, RESET		; Czy wartość F się zmieniła
	JB AHI, RETURN			; Jeśli Always High to nie przejmuj się niczym więcej
	JB F0, PERIOD			; Aktualnie - odliczanie okresu
	LJMP FILL			; Aktualnie - odliczanie wypełnienia
RETURN:	RETI

RESET:	SETB F0				; najpierw odlicz do okresu
	MOV COUNTER, P1			; zacznij od odliczania do okresu
	INC COUNTER			; timer przesunięty o 1 (odliczanie od 1 do T+1)
	MOV PREVPERIOD, P0
	MOV PREVFILL, P1		; początkowe wartości
	MOV A, P0
	SUBB A, P1			; Czy T < F
	JNC SETEQU			; Jump to SETEQU jeśli nie
SETHI:	SETB P2.0			; Stan wysoki na wyjściu
	SETB AHI			; Always High
	RETI
SETEQU: MOV A, P0
	CJNE A, P1, SETLOW		; Czy T == F
	LJMP SETHI			; T == F - sekwencja taka jak przy SETHI
SETLOW:	CLR P2.0			; zacznij od stanu niskiego
	CLR AHI				; not Always High
	RETI

PERIOD:	MOV A, COUNTER
	SUBB A, P0			; Czy COUNTER > T
	JC SKIPP			; nie
	SETB P2.0			; stan wysoki na wyjściu
	MOV COUNTER, #01H		; Odliczanie od 1 do T+1
	CLR F0				; odliczaj do wypełnienia
	RETI

SKIPP:	INC COUNTER			; inkrementuj COUNTER i return
	RETI

FILL:	MOV A, COUNTER
	SUBB A, P1			; Czy COUNTER > F
	JC SKIPF			; nie
	CLR P2.0			; stan niski na wyjściu
	SETB F0				; odliczaj do okresu
SKIPF:	INC COUNTER			; inkrementuj COUNTER i reti
	RETI

END