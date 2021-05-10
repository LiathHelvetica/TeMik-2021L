ORG 0000H
	LJMP INIT

; P3.2 - przycisk sterowania
ORG 00003h
	LJMP STER

ORG 0000Bh
	LJMP TIMI

; P1 - brama
; P3.2 - przycisk sterowania
; P3.3 - czujnik - ciągły - jeśli jest zapalony to cały czas przełączanie na stan otwierania
; STOP - brama ma być bezwzględnie zatrzymana
; OPEN - jeśli 1 to brama jest otiwerana, jeśli 0 to brama jest zamykana
; IN_OK - input może być przyjęty (P0.0)

ORG 0100H
INIT:
	OPENED EQU 11111111B
	CLOSED EQU 00000000B
	TLOW EQU 0F2H
	THIGH EQU 0FFH
	TWO EQU 00000010B
STOP:	DBIT 1
OPEN:	DBIT 1
	SETB STOP
	CLR OPEN
	MOV P1, #CLOSED
	MOV TL0, #TLOW
	MOV TH0, #THIGH			; czas timera
	SETB TR0			; zacznij liczyć
	SETB IT0			; przerwania na zboczu
	SETB ET0			; maska timera
	SETB EX0			; maska P3.2 (reset)
	SETB PX0			; wysoki priorytet przycisków
	CLR PT0				; niski priorytet timera
	SETB EA				; maska główna
MAIN:	LJMP MAIN

ORG 0300H
TIMI:	MOV TL0, #TLOW
	MOV TH0, #THIGH			; czas timera
	JB P3.3, NOSENS
	CLR STOP
	SETB OPEN
NOSENS:	JB STOP, ENDT
	JB OPEN, OPROC
	LJMP CPROC
ENDT:	RETI

OPROC:	MOV A, P1
	MOV B, #TWO
	MUL AB
	INC A
	MOV P1, A
	MOV A, P1
	CJNE A, #OPENED, ENDT
	SETB STOP
	RETI

CPROC:	MOV A, P1
	MOV B, #TWO
	DIV AB
	MOV P1, A
	MOV A, P1
	CJNE A, #CLOSED, ENDT
	SETB STOP
	RETI

STER:	JB STOP, GGO
	SETB STOP
	RETI
GGO:	CPL OPEN
	CLR STOP
	RETI

END
