TITLE Integer Accumulator	(Program3.asm)

; Author: Jose R Garay Jr
; Last Modified: 5/5/2019
; OSU email address: garayj@oregonstate.edu
; Course number/section: CS271
; Project Number: 3                 Due Date: 5/5/2019
; Description: This program gathers prompts the user to an integer between the values -100 and
; -1 until a non-negative number is entered. Once the non-negative number is entered, all the
; previous values, bar the non-negative number are summed as well as averaged. The program then
; then thanks the user for playing and then exits.

INCLUDE Irvine32.inc

NAME_MAX = 40
MIN = -100

.data

; Strings that will be shown to the user.
welcome			BYTE		"Welcome to the Integer Accumulator by Jose Garay", 0
EC_1			BYTE		"**EC: Number the lines during user input.", 0
EC_2			BYTE		"**EC: Calculate and display the average as a floating-point number, rounded to the nearest .001", 0
name_prompt		BYTE		"What is your name? ", 0
hello			BYTE		"Hello, ", 0
instruct1		BYTE		"Please enter numbers in [-100, -1].", 0
instruct2		BYTE		"Enter a non-negative number when you are finished to see the results.", 0
num_prompt		BYTE		" Enter a number: ", 0
count_res1		BYTE		"You entered ", 0
count_res2		BYTE		" valid numbers.", 0
sum_result		BYTE		"The sum of your valid numbers is ", 0
ave_result		BYTE		"The rounded average is ", 0
ave_float		BYTE		"The float-point average is ", 0
point			BYTE		".", 0
end_mess		BYTE		"Thank you for playing Integer Accumulator! It's been a pleasure to meet you, ", 0
err_range		BYTE		"Opps that wasn't in range!", 0
error_zero		BYTE		"You didn't enter any numbers!", 0

; Variable constant because I can't multiply by an immediate operand.
thousand		DWORD		1000

; Counters for lines and number of integers entered.
count			DWORD		0
line_count		DWORD		1

; Variables to be defined by user or calculated.
username		BYTE		NAME_MAX+1 DUP(?)
sum				SDWORD		?
ave				DWORD		?
remain			DWORD		?
float_ave		DWORD		?
float_remain	DWORD		?

.code

main PROC

; Introduction
		mov		edx, OFFSET welcome
		call	WriteString
		call	Crlf
		call	Crlf
		mov		edx, OFFSET EC_1
		call	WriteString
		call	Crlf
		mov		edx, OFFSET EC_2
		call	WriteString
		call	Crlf
		call	Crlf

	; Get the user's name
		mov		edx, OFFSET name_prompt
		call	WriteString
		mov		edx, OFFSET username 
		mov		ecx, NAME_MAX
		call	ReadString	
		call	Crlf

	; Greeting
		mov		edx, OFFSET hello
		call	WriteString
		mov		edx, OFFSET username 
		call	WriteString
		call	Crlf


; Instructions prompt
		mov		edx, OFFSET instruct1
		call	WriteString
		call	Crlf	
		mov		edx, OFFSET instruct2
		call	WriteString
		call	Crlf	
		call	Crlf

; Get Numbers from the user.
	; While loop for getting another integer
	GET_NUMBER:
		mov		eax, line_count
		call	WriteDec
		inc		line_count
		mov		edx, OFFSET num_prompt
		call	WriteString
		call	ReadInt
		jns		CALCULATE_AVERAGE					; If the number entered is positive, jump to displaying results.
		cmp		eax, MIN						
		jb		MIN_ERROR							; If the number entered is less than the minimum number jump to error message.
		jmp		ADD_TO_SUM

	MIN_ERROR:
		mov		edx, OFFSET err_range
		call	WriteString
		call	Crlf
		jmp		GET_NUMBER

	; Calculate the sum of the integers.
	ADD_TO_SUM:
		add		sum, eax
		inc		count	
		jmp		GET_NUMBER

	; Calculate the average of the integers.
	CALCULATE_AVERAGE:
		cmp		count, 0
		je		ERR_ZERO
		mov		eax, sum
		cdq
		mov		ebx, count
		idiv	ebx
		mov		float_ave, eax
		mov		ave, eax

; Calculate the average of the integers with floats.
		mov		eax, edx
		mov		remain, eax
		neg		remain
		fld		remain	
		fdiv	count	
		fimul	thousand
		frndint
		fist	float_remain	
		call	Crlf

; Display the results to the user.
	;Display the count results.
		mov		edx, OFFSET count_res1
		call	WriteString
		mov		eax, count
		call	WriteDec	
		mov		edx, OFFSET	count_res2
		call	WriteString
		call	Crlf

	;Display the sum results.
		mov		edx, OFFSET sum_result
		call	WriteString
		mov		eax, sum
		call	WriteInt
		call	Crlf

	;Display the average results floating point style.
		mov		edx, OFFSET	ave_float
		call	WriteString
		mov		eax, float_ave
		call	WriteInt
		mov		edx, OFFSET	point
		call	WriteString
		mov		eax, float_remain
		call	WriteDec
		call	Crlf

	;Display the average results.
		mov		edx, OFFSET	ave_result 
		call	WriteString
		mov		eax, ave 
		call	WriteInt
		call	Crlf
		jmp		EXIT_MESS
		
; Exit message
	;Display error message if there were no valid inputs.
	ERR_ZERO:
		mov		edx, OFFSET error_zero
		call	WriteString	
		call	Crlf
	;Display exit message.
	EXIT_MESS:
		mov		edx, OFFSET end_mess
		call	WriteString
		mov		edx, OFFSET username 
		call	WriteString
		call	Crlf
	exit	; exit to operating system
main ENDP
END main
