TITLE Introduction to MASM		(Project1.asm)

; Author: Jose Garay
; Last Modified: Today
; OSU email address: garayj@oregonstate.edu
; Course number/section: CS271
; Project Number:01                 Due Date: April 14th, 2019
; Description: This program will ask for two integers and then calculate the sum, difference
;product and quotient/remainder of the integers.

INCLUDE Irvine32.inc

.data

intro_1		BYTE	"Introduction to MASM by Jose Garay", 0
extra_1		BYTE	"**EC: Repeats until the user chooses to quit.", 0
extra_2		BYTE	"**EC: Validates that the second number is larger than the first.", 0
instruct	BYTE	"In this program, you will enter 2 integers and the sum, difference, product, quotient and remainder will be displayed.", 0
number_1	DWORD	?
number_2	DWORD	?
prompt_1	BYTE	"What is the first number? ", 0
prompt_2	BYTE	"What is the second number? This number needs to be smaller than the first.", 0
sum			DWORD	?
diff		DWORD	?
product		DWORD	?
quo			DWORD	?
remain		DWORD	?
plus		BYTE	" + ", 0
minus		BYTE	" - ", 0
equals		BYTE	" = ", 0
divide		BYTE	" / ", 0
multi		BYTE	" * ", 0
remainder	BYTE	" remainder ", 0

goodBye		BYTE	"Goodbye",0

retry		BYTE	"Would you like to do this again? Enter 1 to go again or 0 to exit.", 0
tooSmall	BYTE	"Whoops! Looks like the second number was larger than the first.", 0
retryNumber	DWORD	?




.code
main PROC
;Display name and program title to the user
	mov		EDX, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov		EDX, OFFSET extra_1
	call	WriteString
	call	CrLf
	mov		EDX, OFFSET extra_2
	call	WriteString
	call	CrLf

EC1:
;Display instructions for the user
	mov		EDX, OFFSET instruct
	call	WriteString
	call	CrLf


;Prompt the user to enter two numbers
	mov		EDX, OFFSET prompt_1 
	call	WriteString
	call	ReadInt
	mov		number_1, eax
	call	CrLf

	mov		EDX, OFFSET prompt_2
	call	WriteString
	call	ReadInt
	mov		number_2, eax
	call	CrLf

	mov		eax, number_1
	cmp		eax, number_2
	jl		EC2

;Calculate the sum, difference, product, (integer) quotient and remainder of the numbers.

	mov		eax, number_1
	add		eax, number_2
	mov		sum, eax

	mov		eax, number_1
	sub		eax, number_2
	mov		diff, eax

	mov		eax, number_1
	mul		number_2
	mov		product, eax

	mov		eax, number_1
	cdq
	mov		ebx, number_2
	div		ebx
	mov		quo, eax
	mov		remain, edx

;Display the sum.
	mov		eax, number_1
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, number_2
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, sum
	call	WriteDec
	call	CrLf
	
;Display the difference.
	mov		eax, number_1
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, number_2
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, diff 
	call	WriteDec
	call	CrLf

;Display the product.
	mov		eax, number_1
	call	WriteDec
	mov		edx, OFFSET multi
	call	WriteString
	mov		eax, number_2
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, product 
	call	WriteDec
	call	CrLf

;Display the quotient and remainder.
	mov		eax, number_1
	call	WriteDec
	mov		edx, OFFSET divide
	call	WriteString
	mov		eax, number_2
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, quo
	call	WriteDec
	mov		edx, OFFSET remainder
	call	WriteString
	mov		eax, remain
	call	WriteDec
	call	CrLf

	mov		EDX, OFFSET retry
	call	WriteString
	call	CrLf
	call	ReadInt
	mov		retryNumber, eax
	call	CrLf
	
	cmp		retryNumber, 1
	jz		EC1
	jmp		THEEND

EC2:
	mov		EDX, OFFSET tooSmall
	call	WriteString
	call	CrLf


THEEND:
;Display the terminating message.
	mov		EDX, OFFSET goodBye
	call	WriteString
	call	CrLf
	

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
