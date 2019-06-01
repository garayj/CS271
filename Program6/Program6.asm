TITLE Designing low-level I/O procedures	(Project6.asm)

; Author: Jose Garay
; Last Modified: Today
; OSU email address: garayj@oregonstate.edu
; Course number/section: CS271
; Project Number:06                 Due Date: 6/9/2019
; Description: This program is a demonstration of a low-level IO procedure. ReadVal and WriteVal are
; the main procedures demonstrated in this program. ReadVal takes an unsigned 32 bit integer from the
; console. The WriteVal procedure writes a 32 bit unsigned integer to the console.

INCLUDE Irvine32.inc

.data
MAX = 4294967295
MIN	= 0
getString	MACRO	dispString, buf 
	push	edx
	push	ecx
	push	eax
	mov		edx, OFFSET dispString
	call	WriteString
	call	Crlf
	mov		edx, OFFSET buf
	mov		ecx, SIZEOF buf
	call	ReadString
	pop		eax
	pop		ecx
	pop		edx
	
ENDM


intro1		BYTE	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures", 0
intro2		BYTE	"Written by: Jose Garay", 0
instruct1	BYTE	"Please procide 10 unsigned decimal integers.", 0
instruct2	BYTE	"Each number needs to be small enough to fit inside a 32 bit register.", 0
instruct3	BYTE	"After you have finished inputting the raw numbers I will display a list of the integers, their sum, and their average value.", 0
prompt		BYTE	"Please enter an unsigned number: ", 0
reprompt	BYTE	"Please try again: ", 0
ERROR		BYTE	"ERROR: You did not enter an unsigned number or your number was too big.",0
dispArray	BYTE	"You entered the following numbers:", 0
dispSum		BYTE	"The sum of these numbers is: ", 0
dispAve		BYTE	"The average is: ", 0
thanks		BYTE	"Thanks for playing!", 0

array		DWORD	10 DUP(0)

buffer		BYTE	11 DUP(0)




.code
main PROC
	mov		eax, 0
	getString	prompt, buffer
	mov		al, buffer
	call	WriteDec
	
	

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
