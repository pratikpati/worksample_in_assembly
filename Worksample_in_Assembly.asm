//This Program is only a worksample.
//Many Functions not Included In the Code Intentionally!
//Written In 20 Mins Just to get a desired Output from a small prototype.
//Microcontroller-AT89S52
//Skills Used- UART,RS232


//Working-
//THIS PROGRAM WILL READ A RFID CARD
//SHOW ON THE LCD IF ITS AUTHORISED OR NOT
//IF AUTHORISED- TURN ON THE RELAY
//IF UNAUTHORISED- SEND MESSAGE TO A NUMBER


	ORG		0000H
	ACALL		serial_Init
HOME:	ACALL		clear_lcdScreen
	CLR		A
	MOV		DPTR,	#WelComeMsg
	ACALL		PrintDptrOn_LCD

START:	MOV		R0,	#30H
	MOV		R1,	#12D
//.....................................................................//
AGAIN:	ACALL		RECEIVE		//Not Recomended
	MOV		@R0,	A	//Pointer
	INC		R0
	DJNZ		R1,	AGAIN	//Repete For 12 times
	MOV		R1,	#12D
	MOV		R0,	#30H
	MOV		A,	039H
	CJNE		A,	#"D",	UNAUTHORISED
	MOV		A,	03AH
	CJNE		A,	#"2",	UNAUTHORISED
	MOV		A,	03BH
	CJNE		A,	#"2",	UNAUTHORISED
	ACALL		Clear_LcdScreen
	CLR		A
	MOV		DPTR,	#Authorised_Msg
	ACALL		PrintDptrOn_LCD
	LJMP		0000H		//Infinity Loop


UNAUTHORISED: 
	ACALL		Clear_LcdScreen
	ACALL		serial_Init
	CLR		A
	MOV		DPTR,	#Unuthorised_Msg
	ACALL		PrintDptrOn_LCD
	CLR		A
	MOV		DPTR,	#ATC
	ACALL		SENDCOMMAND	//Send GSM Command
	ACALL		delay
	CLR		A
	MOV		DPTR,	#FORMAT	//Set GSM Formt
	ACALL		SENDCOMMAND
	ACALL		delay
	CLR		A
	MOV		DPTR,	#SENDN	//Number To Be sent
	ACALL		SENDCOMMAND
	ACALL		delay
	CLR		A
	MOV		DPTR,	#FNLMSG	//Predefined Msg To Be sent
	ACALL		SENDCOMMAND
	ACALL		delay
	LJMP		0000H		//Loop
