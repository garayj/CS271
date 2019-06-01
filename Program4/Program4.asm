TITLE Composite Numbers	(Program4.asm)

; Author: Jose R Garay Jr
; Last Modified: 5/5/2019
; OSU email address: garayj@oregonstate.edu
; Course number/section: CS271
; Project Number: 4                 Due Date: 5/12/2019
; Description: This program calculates composite numbers.  The user is instructed to 
; enter the number of composites to be displayed(1-400).  The user enters a number
; and the program verifies that the number is in range.  If it is out of range, the user 
; is reprompted until s/he enters a value in the specified range.  The program then 
; calculates and displays all of the composite numbers up to and including the nth composite.  
; The results are displayed 10 composites per line. 

INCLUDE Irvine32.inc

UPPERLIM = 400
LOWERLIM = 1

.data

; Strings that will be shown to the user.
welcome			BYTE		"Composite Numbers by Jose Garay", 0
instruction_1	BYTE		"Enter the number of composite numbers you would like to see.", 0
instruction_2	BYTE		"I'll accept orders for up to 400 composites.", 0
prompt			BYTE		"Enter the number of composites to display [1 .. 400]: ", 0
out_of_range	BYTE		"Out of range.  Try again.", 0
end_message		BYTE		"Results verified by Jose Garay. Goodbye.", 0
spaces			BYTE		"    ", 0



; Counters for lines and number of integers entered.
spaceCounter	DWORD		0

; Variables to be defined by user or calculated.
currentNumber	DWORD		4
userNumber		DWORD		?
primeNumArray	DWORD		2,3,5,7,11,13,17,19,23,29
primeNumLen		DWORD		10
maxRowLen		DWORD		10
 


.code

main PROC
		call	introduction
		call	getUserData
		call	showComposites
		call	farewell
	exit	; exit to operating system
main ENDP
; *************************************************************************************************
; Description: Welcomes the user to the program and issues the instructions.
; Receives: Welcome, instruction_1 and instruction_1 as global variables.
; Returns: Nothing.
; Preconditions: Nothing.
; Registers Changed: edx
; *************************************************************************************************
introduction PROC
		mov		edx, OFFSET welcome
		call	WriteString
		call	Crlf
		call	Crlf
		mov		edx, OFFSET	instruction_1
		call	WriteString
		call	Crlf
		mov		edx, OFFSET	instruction_2
		call	WriteString
		call	Crlf
		ret		
introduction ENDP
; *************************************************************************************************
; Description: Get's an integer from the user to use as the number of composite numbers to display.
; Receives: prompt, and userNumber. Stores the user input in userNumber.
; Returns: Nothing
; Preconditions: None
; Registers Changed: edx, eax
; *************************************************************************************************
getUserData PROC

		mov		edx, OFFSET	prompt
		call	WriteString
		call	ReadDec
		call	validate
		mov		userNumber, eax

		ret
getUserData ENDP

; *************************************************************************************************
; Description: Validates the number entered is within specification.
; Receives: eax, out_of_range, prompt global variables.
; Returns: Nothing.
; Preconditions: A value must be in eax.
; Registers Changed: eax, edx
; *************************************************************************************************
validate PROC
	GET_NUMBER:
		cmp		eax, LOWERLIM
		jb		ERROR
		cmp		eax, UPPERLIM
		ja		ERROR	
		ret
	ERROR:
		mov		edx, OFFSET out_of_range 
		call	WriteString
		call	Crlf
		mov		edx, OFFSET prompt 
		call	WriteString
		call	ReadDec
		jmp		GET_NUMBER
validate ENDP

; *************************************************************************************************
; Description: Shows n composite numbers.
; Receives: userNumber, spaceCounter, maxRowLen global variables
; Returns: None
; Preconditions:
; Registers Changed:  
; *************************************************************************************************
showComposites PROC
		mov		ecx, userNumber
			
	EVALUATE_NUMBERS:
		call	isComposite
		mov		eax, spaceCounter
		cdq
		div		maxRowLen	
		cmp		edx, 0
		jnz		FINISH_EVAL	
		call	Crlf

	FINISH_EVAL:
		mov		eax, currentNumber
		call	WriteDec
		mov		edx, OFFSET spaces
		call	WriteString
		inc		spaceCounter
		inc		currentNumber
		loop	EVALUATE_NUMBERS

		call	Crlf			
		ret

showComposites ENDP

; *************************************************************************************************
; Description: Looks for the next composite number.
; Receives: currentNumber global variable.
; Returns: The next composite number.
; Preconditions: There is a number in the eax register.
; Registers Changed: None
; *************************************************************************************************
isComposite PROC
		push	ecx
		push	edi
		push	eax
		push	edx
		push	ebx
	RESTART_TEST:
		mov		edi, 0
		mov		ecx, primeNumLen
	DIVIDE:
		mov		eax, currentNumber
		cdq
		div		primeNumArray[edi]
		mov		ebx, primeNumArray[edi]
		cmp		ebx, currentNumber
		jz		NEXT_NUMBER
		cmp		edx, 0	
		jz		IS_DIVISIBLE
		add		edi, 4
		loop	DIVIDE
	NEXT_NUMBER:
		inc		currentNumber
		jmp		RESTART_TEST
	IS_DIVISIBLE:
		pop		ebx
		pop		edx
		pop		eax
		pop		edi
		pop		ecx
		ret
isComposite ENDP

; *************************************************************************************************
; Description: Farewell procedure closes out the program and displays a goodbye message to the user.
; Receives: end_message global variable 
; Returns: None
; Preconditions: None
; Registers Changed: edx
; *************************************************************************************************
farewell PROC
		mov		edx, OFFSET end_message
		call	WriteString
		call	Crlf
		ret		
farewell ENDP
END main

