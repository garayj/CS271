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
str1 BYTE "Introduction", 0

.code

main PROC
	mov	esi, OFFSET str1
	add	esi, 5
	mov	ecx, 4
	cld
more1:
	lodsb
	call	WriteChar
	loop	more1

	mov	ecx, 4
	std
more2:
	lodsb
	call	WriteChar
	loop	more2
	exit	; exit to operating systemk
main ENDP
END main

