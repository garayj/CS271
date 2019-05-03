TITLE Fibonacci Numbers 		(Project2.asm)

; Author: Jose Garay
; Last Modified: 04212019
; OSU email address: garayj@oregonstate.edu
; Course number/section: CS271 400
; Project Number: 2                 Due Date: 04212019
; Description: Displays Fibonacci numbers to the degree of the user input.

INCLUDE Irvine32.inc

MAX = 46
MIN = 1

.data

intro_1		BYTE	"Fibonacci Numbers by Jose Garay", 0
intro_2		BYTE	"What's your name? ", 0
username	BYTE	MAX+1 DUP(?)
intro_3		BYTE	"Hello, ", 0
instruct_1	BYTE	"Enter the number of Fibonacci terms to be displayed", 0
instruct_2	BYTE	"Give the number as an integer in the range [1 .. 46].", 0
prompt_1	BYTE	"How many Fibonacci terms do you want? ", 0
space		BYTE	"     ", 0
error_1		BYTE	"Out of range.  Enter a number in [1 .. 46] ", 0
cert		BYTE	"Results certified by Jose Garay.", 0
goodbye		BYTE	"Goodbye, ", 0

current		DWORD	0	
last		DWORD	0	
column		DWORD	0


.code
main PROC
;Introduction
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_2
	call	WriteString
	mov		edx, OFFSET username	;Get username from the user.
	mov		ecx, MAX
	call	ReadString
	call	CrLf
;Welcome and introduce the user.
	mov		edx, OFFSET intro_3
	call	WriteString
	mov		edx, OFFSET username
	call	WriteString
	call	CrLf
;User Instructions
INSTRUCT:
	mov		edx, OFFSET instruct_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET instruct_2
	call	WriteString
	call	CrLf
	
;Get User Data
	call	ReadInt
	cmp		eax, MAX
	jg		NUM_ERROR				;If the number is greater than 46, report the error.
	cmp		eax, MIN
	jl		NUM_ERROR				;If the number is less than 1, report the error.
	mov		ecx, eax				;Move user input into ECX to be used as the counter.
	jmp		MAIN_LOOP	

NUM_ERROR:
	mov		edx, OFFSET error_1		;Display error message and jump back into the loop.
	call	WriteString
	call	CrLf
	jmp		INSTRUCT	

;Display Fibonacci Sequence
MAIN_LOOP:
	mov		eax, last				
	mov		ebx, current 
	add		eax, ebx				;The the last two integers to form the new current digit.
	cmp		eax, 0
	je		FIRST_TERM				;Special loop for the first term.
	mov		last, ebx
	mov		current, eax


;Column splitting
	inc		column					;Column counter. If the column is divisible by 5, go to a newline.
	mov		eax, column				
	cdq
	mov		ebx, 5
	div		ebx	
	cmp		edx, 0

	je		NEWLINE
	jmp		WRITE_NUMBER

NEWLINE:
	call	CrLf
	jmp		WRITE_NUMBER
FIRST_TERM:
	inc		eax						;The first number is incremented for the loop to start.
	mov		current, eax


;Responsible for printing the value in current to the console.
WRITE_NUMBER:						
	mov		eax, current
	call	WriteDec
	mov		edx, OFFSET space
	call	WriteString
	loop	MAIN_LOOP
	call	CrLf

;Farewell
FAREWELL:
	call	CrLf
	mov		edx, OFFSET cert
	call	WriteString
	call	CrLf
	mov		edx, OFFSET goodbye
	call	WriteString
	mov		edx, OFFSET username
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
