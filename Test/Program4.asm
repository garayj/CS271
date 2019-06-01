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


idArray WORD 3546, 1534, 12, 3481, 154, 6423
x DWORD LENGTHOF idArray
y DWORD SIZEOF idArray
z DWORD TYPE idArray
.code

main PROC
	mov		eax, y

	call	WriteDec
	call	Crlf
	exit	; exit to operating systemk
main ENDP
END main

