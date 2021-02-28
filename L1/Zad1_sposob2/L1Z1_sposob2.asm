INITIAL_VALUE SET 11111110B
IS_RUNNING: DBIT 1;0 - not running, 1 - running
RUNNING_SIDE: DBIT 1; 0 - left , 1 - right
CLR IS_RUNNING
CLR RUNNING_SIDE

ORG 0000h
	MOV A, #INITIAL_VALUE
	MOV P3, A
	LJMP READ

ALREADY_RUNNING:
	JB RUNNING_SIDE, RIGHT
	LJMP LEFT

READ:	JB P2.0, P20YES
	JB P2.1, LEFT
	JB IS_RUNNING, ALREADY_RUNNING
	LJMP READ

P20YES:	JNB P2.1, RIGHT
	JB IS_RUNNING, ALREADY_RUNNING
	LJMP READ

LEFT:	SETB IS_RUNNING
	CLR RUNNING_SIDE
	RL A
	MOV P3, A
	LJMP READ

RIGHT:	SETB IS_RUNNING
	SETB RUNNING_SIDE
	RR A
	MOV P3, A
	LJMP READ

END