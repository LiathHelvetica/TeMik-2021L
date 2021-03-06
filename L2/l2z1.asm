ORG 0000h
	ljmp init	; Inicjalizacja programu

ORG 3000h
init:	MOV TMOD, #01h	; Inicjalizacja Timera
	SETB TR0	; "Uruchomienie" Timera
	SETB ET0	; Maska przerwania od T0
	SETB EAL	; Maska główna
	SEND SET 00h	; Ustawienie flagi przesyłania na "0"

main:	ljmp main	; "Pętla" główna programu

ORG 0000Bh 		; Obsługa przerwania od timera
	JB SEND, RETI	; Sprawdź czy ustawiona flaga aby przesyłać
	MOV P3, P2	; Przesłanie danej P2 (przyciski) na P3 (led)
	RETI		; Powrót z przerwania

ORG xxx			; Obsługa przerwania od przycisku P1.0
	SETB SEND	; Ustaw flagę przesyłania na "1"
	RETI		; Powrót z przerwania