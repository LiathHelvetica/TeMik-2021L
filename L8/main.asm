ORG 0900H
SCODE:	DB 10110111B
	DB 11010111B
	DB 11011110B
	DB 11101011B

; F0 - 1 jeśli poprawny kod, 0 jeśli nie poprawny
; P2.1 - FAIL
; P2.0 - SUCCESS
; P1 - klawiatura macierzowa

ORG 0000H
	LJMP INIT

ORG 0100h
INIT:	MOV DPTR, #SCODE
	COUNTER EQU 030H
	QUERY EQU 031H
CLEAR:	DBIT 1
	INIQUERY EQU 01111111B
	ITERNUM EQU 04D
MAIN:	SETB F0			; załóż, że kod poprawny
	MOV COUNTER, #00H	; reset countera
ITER:	LJMP WAIT_FOR_INPUT	; czekaj dopóty pusty numpad
ENDW:	MOV A, COUNTER
	MOVC A, @A+DPTR		; A <- kolejna wartość kodu
	CJNE A, P1, NOFUT	; A != P1 - no future
	LJMP CONT		; na razie wszystko ok
NOFUT:	CLR F0			; F0 <- 0 - błędny kod
CONT:	LJMP WAIT_FOR_EMPTY	; poczekaj aż numpad bedzie wyzerowany
ENDV:	INC COUNTER
	MOV A, COUNTER
	CJNE A, #ITERNUM, ITER	; Czy koniec iterowania - 4 cyfry sprawdzone
	JNB F0, FAIL		; wprowadzono zły kod
	SETB P2.1
	CLR P2.0
	LJMP MAIN
FAIL:	SETB P2.0
	CLR P2.1
	LJMP MAIN

WAIT_FOR_INPUT:
	MOV QUERY, #INIQUERY
QAG1:	MOV A, QUERY		; rotacja QUERY
	RL A			; rotacja QUERY
	MOV QUERY, A		; rotacja QUERY
	MOV A, QUERY
	MOV P1, A		; odpytaj numpad
	MOV A, P1		; wynik w A
	CJNE A, QUERY, ENDF	; A != QUERY - coś zaznaczono
	LJMP QAG1
ENDF:	MOV P1, A
	LJMP ENDW

WAIT_FOR_EMPTY:
	MOV QUERY, #INIQUERY
	CLR CLEAR		; załóż, że numpad jest wyczyszczony
AGAIN:	MOV A, QUERY
	MOV P1, A		; odpytaj numpad
	MOV A, P1		; wynik w A
	CJNE A, QUERY, STH	; A != QUERY - coś zaznaczono
	LJMP ROT		; na razie wszystko w porządku
STH:	SETB CLEAR
ROT:	MOV A, QUERY		; rotacja QUERY
	RL A			; rotacja QUERY
	MOV QUERY, A		; rotacja QUERY
	MOV A, #INIQUERY
	CJNE A, QUERY, AGAIN	; Jeśli query != początkowe query to kontynuuj
	JB CLEAR, WAIT_FOR_EMPTY ; CLEAR == 1 - numpad nie wyczyszczony
	LJMP ENDV

END