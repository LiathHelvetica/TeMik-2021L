ORG 0000H
	LJMP INIT

; F0 - stan w poprzednim ticku

ORG 0200H
INIT:
	TLOW EQU 0F2H
	THIGH EQU 0FFH
	COUNTER EQU 030H
	MEMC EQU 031H
	MEML EQU 032H
	MEMH EQU 080H
	MOV COUNTER, 00H
	MOV MEMC, #MEML
	CLR F0
	JNB P1.0, SKIP
	SETB F0
SKIP:	MOV TL0, #TLOW
	MOV TH0, #THIGH			; czas timera
	SETB TR0			; zacznij liczyć
	SETB ET0			; maska timera
	SETB EA				; maska główna
MAIN:	LJMP MAIN			; mądry program

ORG 0000Bh
	LJMP TIMI

ORG 0300H
TIMI:	MOV TL0, #TLOW
	MOV TH0, #THIGH
	INC COUNTER
	JB F0, F0BIT
F0CLR:	JB P1.0, CHNG
	RETI

F0BIT:	JNB P1.0, CHNG
	RETI

CHNG:	CPL F0
	MOV R0, MEMC
	MOV @R0, COUNTER
	MOV COUNTER, #00H
	INC MEMC
	MOV A, MEMC
	CJNE A, #MEMH, ENDCH
	MOV MEMC, #MEML
ENDCH:	RETI

END