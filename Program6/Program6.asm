TITLE Designing low-level I/O procedures	(Project6.asm)

; *************************************************************************************************
; Author: Jose Garay
; Last Modified: Today
; OSU email address: garayj@oregonstate.edu
; Course number/section: CS271
; Project Number:06                 Due Date: 6/9/2019
; Description: This program is a demonstration of a low-level IO procedure. ReadVal and WriteVal are
; the main procedures demonstrated in this program. ReadVal takes an unsigned 32 bit integer from the
; console. The WriteVal procedure writes a 32 bit unsigned integer to the console.
; *************************************************************************************************

INCLUDE Irvine32.inc


.data
; Maximum length for input into the console.
MAX_LEN = 100

; Takes a string as input and sets every byte of memory  as 0.
clearString		MACRO	clearString 
	LOCAL NEXT_VALUE_TO_CLEAR
		push	ebx
		push	ecx
		mov		ebx, 0 
		mov		ecx, LENGTHOF clearString
	NEXT_VALUE_TO_CLEAR:
		mov		clearString[ebx], 0
		inc		ebx	
		loop	NEXT_VALUE_TO_CLEAR	
		pop		ecx
		pop		ebx
ENDM

; Takes a string as input and displays it to the console.
displayString	MACRO	inputStr
		push	edx
		mov		edx, inputStr
		call	WriteString
		pop		edx
ENDM

; Takes a string and an integer as input and reads the string.
getString	MACRO	buffer, lenStr
		push	eax
		push	edx
		push	ecx
		mov		edx, buffer
		mov		ecx, MAX_LEN
		call	ReadString
		mov		lenStr, eax	
		pop		ecx
		pop		edx
		pop		eax	
ENDM

; Strings to be used.
intro1			BYTE	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures", 0
intro2			BYTE	"Written by: Jose Garay", 0
instruct1		BYTE	"Please procide 10 unsigned decimal integers.", 0
instruct2		BYTE	"Each number needs to be small enough to fit inside a 32 bit register.", 0
instruct3		BYTE	"After you have finished inputting the raw numbers I will display a list of the integers, their sum, and their average value.", 0
prompt			BYTE	"Please enter an unsigned number: ", 0
reprompt		BYTE	"Please try again: ", 0
error			BYTE	"ERROR: You did not enter an unsigned number or your number was too big.",0
dispArray		BYTE	"You entered the following numbers:", 0
dispSum			BYTE	"The sum of these numbers is: ", 0
dispAve			BYTE	"The average is: ", 0
thanks			BYTE	"Thanks for playing!", 0
commaSpace		BYTE	", ", 0

; Variables to be used.
array			DWORD	10 DUP(0)
buffer			BYTE	MAX_LEN DUP(0)
bufferLen		DWORD	?
average			DWORD	?
sum				DWORD	?




.code
main PROC
		push	OFFSET intro1
		push	OFFSET intro2
		call	introduction

		push	OFFSET instruct1
		push	OFFSET instruct2
		push	OFFSET instruct3
		call	instruction

		push	OFFSET array
		push	OFFSET buffer
		push	OFFSET error
		push	OFFSET reprompt
		push	OFFSET prompt
		call	getInput

		push	OFFSET sum
		push	OFFSET average
		push	LENGTHOF array
		push	OFFSET array
		call	calculate

		push	sum
		push	average
		push	OFFSET commaSpace
		push	OFFSET dispArray
		push	OFFSET dispSum
		push	OFFSET dispAve
		push	LENGTHOF array
		push	OFFSET array
		call	displayResults

		push	OFFSET thanks
		call	thankYou
	
	

	exit	
main ENDP

; *************************************************************************************************
; Description: Introduces the program to the user.
; Receives: Two instruction strings on the stack.
; Returns: Nothing.
; Preconditions: Nothing.
; Registers Changed: None.
; *************************************************************************************************
introduction PROC
		enter	0,0
		displayString	[ebp + 12]
		call Crlf
		displayString	[ebp + 8]
		call Crlf
		leave
		ret	8
introduction ENDP

; *************************************************************************************************
; Description: Prints instructions of the program to the console.
; Receives: Three instruction strings.
; Returns: Nothing.
; Preconditions: None.
; Registers Changed: None.
; *************************************************************************************************
instruction PROC
		enter 0,0
		displayString	[ebp + 16]
		call Crlf
		displayString	[ebp + 12]
		call Crlf
		displayString	[ebp + 8]
		call Crlf
		leave
		ret 12
instruction ENDP

; *************************************************************************************************
; Description: Gets integers from the user.
; Receives: Address of array, buffer, and address of strings for reprompting, errors and the prompt.
; Returns: A filled array.
; Preconditions: 
; Registers Changed: None
; *************************************************************************************************
getInput PROC
		enter 0,0
		push	ecx
		push	eax
		push	ebx

		mov		ecx, 10		
		mov		eax, [ebp + 24]			; Move the array into eax 
	GET_ANOTHER_NUM:	
		mov		ebx, [ebp + 8]
		mov		ebx, ebx
		displayString	[ebp + 8]

		push	[ebp + 12]				; Push the reprompt on the stack
		push	[ebp + 16]				; Push the error on the stack
		push	[ebp + 20]				; Push the buffer on the stack
		push	eax						; Push an empty location of the array on the stack
		call	ReadVal
		
		add		eax, 4
		
		loop	GET_ANOTHER_NUM

		pop		ebx
		pop		eax
		pop		ecx
		leave
		ret		20
	
getInput ENDP

; *************************************************************************************************
; Description: Calculates the sum and average of the array.
; Receives: The addresses of sum and average, the length of the array, and the address of the array.
; Returns: The values of the sum and average into the addresses of sum and average.
; Preconditions: None.
; Registers Changed: None.
; *************************************************************************************************
calculate PROC
		enter 0,0
		pushad

		mov		esi, [ebp + 8]
		mov		ecx, [ebp + 12]
		mov		eax, 0
	; First calculate the sum of all of the elements in the array.
	CALC_SUM:
		add		eax, [esi]	
		add		esi, 4
		loop	CALC_SUM
		mov		ebx, [ebp + 20]
		mov		[ebx], eax				; Move the value sum into sum.
		mov		ebx, [ebp + 12]
		xor		edx, edx
		div		ebx
		mov		ebx, [ebp + 16]
		mov		[ebx], eax				; move the sum into sum.

		popad
		leave
		ret		16
calculate ENDP

; *************************************************************************************************
; Description: Prints the array, the sum of the numbers in the array, and the average of the array
; to the console.
; Receives: The value of sum, the value of the average, three strings, the length of the array, and
; the memory location of the array.
; Returns: Nothing.
; Preconditions: The array must not be empty. 
; Registers Changed: None.
; *************************************************************************************************
displayResults PROC
		enter 0,0
		pushad	
		mov		esi, [ebp + 8]				; Display the array contents.
		displayString	[ebp + 24]
		call Crlf
		mov		ecx, [ebp + 12]	
	PRINT_ARRAY:
		mov		eax, [esi]
		push	eax
		call	WriteVal	
		cmp		ecx, 1
		je		NO_COMMA
		displayString	[ebp + 28]
		add		esi, 4
	NO_COMMA:
		loop	PRINT_ARRAY	
		call Crlf

		displayString	[ebp + 20]			; Display the sum.
		push	[ebp + 36]
		call	writeVal
		call	Crlf

		displayString	[ebp + 16]			; Display the average.
		push	[ebp + 32]
		call	writeVal
		call	Crlf
		popad
		leave
		ret		24
displayResults ENDP

; *************************************************************************************************
; Description: Prints the ending message to the console.
; Receives: A string on the stack.
; Returns: Nothing.
; Preconditions: None.
; Registers Changed: None.
; *************************************************************************************************
thankYou PROC
		enter	0,0
		displayString	[ebp + 8]
		call Crlf
		leave
		ret		4
thankYou ENDP

; *************************************************************************************************
; Description: This procedure takes a string and converts it to an unsigned integer. Also checks if
; it is not an unsigned integer or larger than 32-bits.
; Receives: The reprompt string, the error string, a buffer string, and an empty location in the
; array.
; Returns: An integer placed in the empty location in the array.
; Preconditions: None.
; Registers Changed: None.
; *************************************************************************************************
ReadVal PROC
	LOCAL	strLen:DWORD, accumulator:DWORD, rMultiplier:DWORD
		pushad
	GET_VALUE:
		mov		eax, 0
		mov		accumulator, 0
		mov		rMultiplier, 1
		getString	[ebp + 12], strLen
		mov		eax, strLen
		mov		ebx, 10
		; Check to see if there are too many digits in the string.
		cmp		eax, ebx 
		jg		ERROR_MESSAGE
		mov		ecx, strLen
		mov		esi, [ebp + 12]
		add		esi, ecx
		dec		esi
		mov		edi, esi

		; Convert the ascii symbol to a it's decimal value by subtracting 48, multiplying by it's place value,
		; and then adding it to the accumulator.
	CHECK_NUMS:
		mov		eax, 0
		std	
		lodsb
		cmp		al, 48
		jl		ERROR_MESSAGE
		cmp		al, 57
		jg		ERROR_MESSAGE
		sub		al, 48
		mov		ebx, rMultiplier
		mul		ebx
		add		accumulator, eax	
		mov		eax, accumulator

		; The case that the number is too large for the eax register aka it carries over to the edx register.
		jc		ERROR_MESSAGE
		cmp		edx, 0
		jne		ERROR_MESSAGE

		mov		ebx, 10
		mov		eax, rMultiplier
		mul		ebx
		mov		rMultiplier, eax
		loop	CHECK_NUMS
		
		; Move the total number into it's location in the array.
		mov		eax, [ebp + 8]
		mov		ebx, accumulator
		mov		[eax], ebx 
		
		popad
		ret		16
			
	ERROR_MESSAGE:
		displayString	[ebp + 16]
		call	Crlf
		displayString	[ebp + 20]
		jmp		GET_VALUE
		
ReadVal ENDP

; *************************************************************************************************
; Description: This procedure takes an integer and converts it to a string and displays it on the 
; console.
; Receives: A string on the stack.
; Returns: Nothing.
; Preconditions: A string must be pushed on the stack.
; Registers Changed: None
; *************************************************************************************************
writeVal PROC
		LOCAL	forward[11]:BYTE, reverse[11]:BYTE, wMultiplier:DWORD

		pushad
		; Set all the values in the forward and reverse local variables to 0.
		clearString forward
		clearString reverse	

		; Converts the value to a the ascii character and place it in forward. The number will be backwards string.
		mov		eax, [ebp + 8]
		mov		wMultiplier, 10
		mov		esi, 0
	CONVERT_VALUE:
		xor		edx, edx
		mov		ebx, wMultiplier
		div		ebx
		add		edx, 48
		mov		forward[esi], dl
		inc		esi	
		cmp		eax, 0
		jne		CONVERT_VALUE
		
		; Load forward into reverse in the correct orientation.
		mov		ecx, esi
		lea		esi, forward 
		add		esi, ecx
		dec		esi
		lea		edi, reverse
	REVERSE_STRING:
		std
		lodsb
		cld
		stosb
		loop	REVERSE_STRING
		lea		edx, reverse
		displayString edx 

		popad
		ret		4	
writeVal ENDP

END main
