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

; (insert constant definitions here)
NAME_MAX = 40
MIN = -100
MAX = -1


.data

welcome		BYTE	"Welcome to the Integer Accumulator by Jose Garay", 0
name_prompt	BYTE	"What is your name? ", 0
username	BYTE	NAME_MAX+1 DUP(?)
hello		BYTE	"Hello, ", 0
instruct1	BYTE	"Please enter numbers in [-100, -1].", 0
instruct2	BYTE	"Enter a non-negative number when you are finished to see the results.", 0
num_prompt	BYTE	"Enter a number: ", 0
count_res1	BYTE	"You entered ", 0
count		DWORD	0
count_res2	BYTE	" valid numbers.", 0
sum_result	BYTE	"The sum of your valid numbers is ", 0
sum			SDWORD	?
ave_result	BYTE	"The rounded average is ", 0
ave			SDWORD	?
end_mess	BYTE	"Thank you for playing Integer Accumulator! It's been a pleasure to meet you, ", 0

err_range	BYTE	"Opps that wasn't in range!", 0


.code
main PROC

; (insert executable instructions here)

; Introduction
	mov		edx, OFFSET welcome
	call	WriteString
	call	Crlf
	

; Get Data from the user.

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

	; Instruction prompt
	mov		edx, OFFSET instruct1
	call	WriteString
	call	Crlf	
	mov		edx, OFFSET instruct2
	call	WriteString
	call	Crlf	

	; While loop for getting another integer
GET_NUMBER:
	mov		edx, OFFSET num_prompt
	call	WriteString
	call	ReadInt
	jns		RES_TO_CON							; If the number entered is positive jump to displaying results.

	cmp		eax, MIN						
	jl		MIN_ERROR							; If the number entered is less than the minimum number jump to error message.

	jmp		SUM_INT
	
MIN_ERROR:
	mov		edx, OFFSET err_range
	call	WriteString
	call	Crlf
	jmp		GET_NUMBER
	

; Calculate the sum of the integers.
SUM_INT:
	add		sum, eax
	inc		count
	jmp		GET_NUMBER

RES_TO_CON:
; Calculate the average of the integers.
	mov		eax, sum
	cdq
	mov		ebx, count
	idiv	ebx
	call	DumpRegs
	mov		ave, eax
	
	
	
; Display the results to the user.
	
	;Display the count results
	mov		edx, OFFSET count_res1
	call	WriteString
	mov		eax, count
	call	WriteDec
	mov		edx, OFFSET	count_res2
	call	WriteString
	call	Crlf

	;Display the sum results
	mov		edx, OFFSET sum_result
	call	WriteString
	mov		eax, sum
	call	WriteInt
	call	Crlf
	
	;Display the average results
	mov		edx, OFFSET	ave_result 
	call	WriteString
	mov		eax, ave
	call	WriteInt
	call	Crlf

; Exit message

	mov		edx, OFFSET end_mess
	call	WriteString
	mov		edx, OFFSET username 
	call	WriteString
	call	Crlf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
