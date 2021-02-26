	ORG	0000h
	ljmp	setup

	ORG	0100h
setup:
	isLeft	EQU	0b
	isFirst EQU	1b
	MOV	A, #0FEh
	ljmp start
main:
	jb	P2.0, P20tak
	jb	P2.1, P20nieP21tak
	ljmp	P20nieP21nie
start:
	jb isFirst, main
	jb isLeft, P20takP21nie
	ljmp P20nieP21tak

P20tak:
	jb	P2.1, P20takP21tak
	ljmp	P20takP21nie

P20takP21nie: ;w lewo
	SETB	isLeft
	MOV	P0, A
	RL	A
	ljmp	start

P20nieP21tak: ;w prawo
	CLR	isLeft
	MOV	P0, A
	RR	A
	ljmp	start

P20nieP21nie: ;bez zmian
P20takP21tak: ;bez zmian
	ljmp start


END
