TITLE	(Project5.asm)

; Author: Jose Garay
; Last Modified: Today
; OSU email address: garayj@oregonstate.edu
; Course number/section: CS271
; Project Number:05                 Due Date: 
; Description: 

INCLUDE Irvine32.inc

MAX = 200
MIN = 10
HI = 999
LO = 100
.data

intro_1			BYTE		"Sorting Random Integers by Jose Garay", 0
intro_2			BYTE		"This program generates random numbers in the range [100 .. 999], ",
							"displays the original list, sorts the list, and calculates the median value.",
							" Finally, it displays the list sorted in descending order.", 0
EC_1			BYTE		"** EC: Display the numbers ordered by column instead of by row.", 0
EC_2			BYTE		"** EC: Use a recursive sorting algorithm.", 0
too_large		BYTE		"Looks like you entered a number over 200.", 0
too_small		BYTE		"Looks like you entered a number under 10.", 0
instruction		BYTE		"How many numbers should be generated? [10 .. 200]: ", 0
invalid_input	BYTE		"Invalid Input", 0
result_1		BYTE		"The unsorted random numbers:", 0
result_2		BYTE		"The median is ", 0
result_3		BYTE		"The sorted list:", 0
result_4		BYTE		"The sorted list in columns:", 0
array			DWORD		200 DUP(0)
spaces			BYTE		"    ", 0

median			DWORD		?
userInput		DWORD		?
highQS			DWORD		?
lowQS			DWORD		0
part			DWORD		?


.code
main PROC
		call	Randomize
		push	OFFSET EC_2
		push	OFFSET EC_1
		push	OFFSET intro_2
		push	OFFSET intro_1
		call	introduction

		push	OFFSET too_small
		push	OFFSET too_large
		push	OFFSET instruction
		push	OFFSET userInput
		call	getData

		push	userInput	
		push	OFFSET array
		call	fillArray

		push	OFFSET spaces
		push	OFFSET result_1
		push	userInput	
		push	OFFSET array
		call	displayList


		push	userInput
		pop		eax	
		dec		eax
		
		push	OFFSET part
		push	eax
		push	0
		push	OFFSET array
		call	quickSort	

		push	userInput
		push	OFFSET array
		call	sortList
		

		push	OFFSET result_2
		push	userInput
		push	OFFSET	median
		push	OFFSET array
		call	displayMedian

		push	OFFSET spaces
		push	OFFSET result_3
		push	userInput	
		push	OFFSET array
		call	displayList

		push	OFFSET spaces
		push	OFFSET result_4
		push	userInput	
		push	OFFSET array
		call	columnList
	exit	; exit to operating system
main ENDP

; *************************************************************************************************
; Description: The introduction procedure introduces the program and tells the user the purpose
; of the program.
; Receives: intro_1 and intro_2 on the stack.
; Returns: Nothing.
; Precondition: None
; Registers Changed: edx
; *************************************************************************************************


introduction PROC
		push	ebp
		mov		ebp, esp
		
		mov		edx, [ebp + 8]
		call	WriteString
		call	Crlf
		mov		edx, [ebp + 16]
		call	WriteString
		call	Crlf
		mov		edx, [ebp + 20]
		call	WriteString
		call	Crlf
		call	Crlf
		mov		edx, [ebp + 12]
		call	WriteString
		call	Crlf
		call	Crlf
		pop		ebp
		ret		8
introduction ENDP



; *************************************************************************************************
; Description: This procedure prompts the user for the number of random numbers to generate.
; Receives: Instruction string and a reference of the userInput as well as three error strings.
; Returns: A user inputted value into the memory that address ebp + 8 is pointing to.
; Precondition: None
; Registers Changed: eax, edx
; *************************************************************************************************

getData PROC
		push	ebp
		mov		ebp, esp
	PROMPT:
		mov		edx, [ebp + 12]
		call	WriteString
		call	ReadDec
		cmp		eax, MAX
		jg		TOO_BIG_ERROR
		cmp		eax, MIN
		jl		TOO_SMALL_ERROR
	GET_DATA_RETURN:
		mov		ebx, [ebp + 8]
		mov		[ebx], eax
		pop		ebp
		call	Crlf
		ret		16

	TOO_BIG_ERROR:
		mov		edx, [ebp + 16]
		jmp		PRINT_ERROR
	TOO_SMALL_ERROR:
		mov		edx, [ebp + 20]
		jmp		PRINT_ERROR
	PRINT_ERROR:
		call	WriteString
		call	Crlf
		jmp		PROMPT
		
getData ENDP




; *************************************************************************************************
; Description: Adds random numbers to an array.
; Receives: userInput and an array. 
; Returns: The array with userInput number of integers in it.
; Precondition: userInput > 0, array must be an array.
; Registers Changed: ecx, eax, esi
; *************************************************************************************************

fillArray PROC
		push	ebp
		mov		ebp, esp
		mov		ecx, [ebp + 12]	
		mov		esi, [ebp + 8]

	PUSH_TO_ARRAY:
		mov		eax, HI
		sub		eax, LO
		inc		eax
		call	RandomRange
		add		eax, LO
		mov		[esi], eax
		add		esi, 4	
		loop	PUSH_TO_ARRAY	
		pop		ebp
		ret		8
fillArray ENDP





; *************************************************************************************************
; Description: The procedure sorts an unsorted array from high to low.
; Receives: userInput and an array on the stack
; Returns: A sorted array in the array passed on the stack.
; Precondition: userInput > 0, array must be an array.
; Registers Changed: eax, ecx, esi, ebx
; *************************************************************************************************

sortList PROC
		LOCAL	i:DWORD, j:DWORD, k:DWORD

		mov		ecx, [ebp + 12] 
		dec		ecx
		mov		esi, [ebp + 8]	
		mov		k, 0		
	OUTER:
		; Preserve the loop counter.
		push	ecx

		; i = k
		push	k
		pop		i

		; k = j + 1
		push	i
		pop		j
		inc		j	

		INNER:			

			; Push the value of array[j] on the stack.
			mov		eax, j
			push	[esi + eax * 4]
			
			; Get the value of array[i].
			mov		eax, i
			mov		eax, [esi + eax * 4]
		
			; Compare array[j] and array[i]. Swap if necessary.
			pop		ebx
			cmp		ebx, eax
			jle		SKIP	
			push	j
			pop		i		
		SKIP:
			inc		j	
			jle		NEXT_THING
		NEXT_THING:
		loop	INNER


		; Push array[k] to the stack.

		mov		eax, k
		mov		ebx, 4
		mul		ebx
		add		eax, esi
		push	eax

		; Push array[i] to the stack.
		mov		eax, i
		mov		ebx, 4
		mul		ebx
		add		eax, esi
		push	eax

		call	exchangeElements

		; Bring back the counter to continue the loop.
		pop		ecx
		inc		k
		loop	OUTER		
		call	Crlf

		ret		8
sortList ENDP




; *************************************************************************************************
; Description: Swaps the values in the addresses that are passed into it.
; Receives: address of array[i] and address of array[k] 
; Returns: The values in each address swapped.
; Precondition: None.
; Registers Changed: eax, ebp, ebx 
; *************************************************************************************************

exchangeElements PROC
		LOCAL	temp:DWORD

		; Place the value of what's in array[k] in temp.
		mov		eax, [ebp + 8]
		push	eax
		mov		eax, [eax]
		mov		temp, eax

		; Place the value of array[j] in array[k]
		mov		ebx, [ebp + 12]
		mov		eax, [ebx]
		pop		ebx
		mov		[ebx], eax

		; Place the value of temp in array[j]
		mov		ebx, [ebp + 12]
		mov		eax, temp
		mov		[ebx], eax

		ret		8
exchangeElements ENDP


; *************************************************************************************************
; Description: Sorts an array with a quicksort algorithm from high to low.
; Receives: An array, two integers and the address of the part variable.
; Returns: A sorted array.
; Precondition: None.
; Registers Changed: eax, ebx, ecx, edx, esi
; *************************************************************************************************
quickSort PROC
		LOCAL l:DWORD, h:DWORD, p:DWORD
		mov		esi, [ebp + 8]  ; Array
		mov		eax, [ebp + 12] ; Low
		mov		ebx, [ebp + 16] ; High
		mov		edx, [ebp + 20]	; pi
		
		; Store the values of the current high and low values into h and l.
		mov		l, eax
		mov		h, ebx
		
		push	edx				; Holds the addres of part
		push	h				; Value of high
		push	l				; Value of Low
		push	esi				; Holds the address of the start of the arrray.
		
		mov		eax, l
		; If l < h
		cmp		eax, h
		jge		END_POINT
		; part = partition(array, low, high)	
		call	partition

		mov		esi, [ebp + 8]  ; Array
		mov		eax, [ebp + 12] ; Low
		mov		ebx, [ebp + 16] ; High
		mov		edx, [ebp + 20]	; pi
		mov		ecx, [edx]
		mov		p, ecx
		
		; quickSort(array, low, part)
		push	edx				; Holds the address of part
		push	p				; New High
		push	l				; low 
		push	esi				; Holds the address of the start of the arrray.
		call	quickSort

		mov		esi, [ebp + 8]  ; Array
		mov		edx, [ebp + 20]	; Address of part

		mov		ecx, [edx]
		inc		ecx
		mov		p, ecx

		; quickSort(array, part + 1, high)
		push	edx				; Holds address of part 
		push	h				; High
		push	p				; The new low
		push	esi				; Holds the address of the start of the arrray.

		call	quickSort
		ret		16
	END_POINT:
		pop		esi
		pop		eax
		pop		ebx
		pop		edx
		ret		16
quickSort ENDP

; *************************************************************************************************
; Description: Place the pivot number in the correct index of the array and return a new index that
; will be used as high and low in subsequent calls to quicksort.
; Receives: The address of the array, two integers, and the address to store a new index value.
; Returns: An integer value is placed into the address stored at [ebp + 20]
; Precondition: Array must not be empty.
; Registers Changed: eax, ebx, ecx, edx, esi
; *************************************************************************************************
partition PROC
		LOCAL	pivot:DWORD, i:DWORD, j:DWORD

		mov		esi, [ebp + 8]	; Address of the start of the array.
		mov		eax, [ebp + 12] ; low
		mov		ebx, [ebp + 16] ; high	
		mov		edx, [ebp + 20] ; the address of part
		
		; pivot = array[low]		
		mov		ecx, 4
		mul		ecx
		add		eax, esi
		mov		eax, [eax]
		mov		pivot, eax		; Pivot is array[low]
		
		; i = low
		mov		eax, [ebp + 12] ; Address of low
		mov		i, eax
		dec		i

		; j = high
		mov		j, ebx
		inc		j	
	
	; Loop until i >= j
	PARTITION_LOOP_TOP:
		; While array[i] > pivot
	MOVE_I:
		inc		i
		mov		eax, i
		mov		ebx, 4
		mul		ebx
		add		eax, esi
		mov		eax, [eax]
		cmp		eax, pivot
		jle		MOVE_J
		jmp		MOVE_I

		; While array[j] < pivot
	MOVE_J:
		dec		j
		mov		eax, j
		mov		ebx, 4
		mul		ebx
		add		eax, esi
		mov		eax, [eax]
		cmp		eax, pivot
		jge		SWAP_AND_CONTINUE
		jmp		MOVE_J

		; If i < j exchange the elements and continue. 
		; Else, return j in part.
	SWAP_AND_CONTINUE:
		mov		eax, i
		cmp		eax, j
		jge		BREAK

		mov		eax, i
		mov		ebx, 4
		mul		ebx
		add		eax, esi
		push	eax 

		mov		eax, j
		mov		ebx, 4
		mul		ebx
		add		eax, esi
		push	eax 
		call	exchangeElements
		jmp		PARTITION_LOOP_TOP

		; Return j by placing it into part.
	BREAK:
		mov		eax, j
		mov		ebx, [ebp + 20]
		mov		[ebx], eax
		
		ret		16
partition ENDP


; *************************************************************************************************
; Description: Calculates and displays the median of the array.
; Receives: The length of the array and the array, the address of the median variable, and the
; address of a string.
; Returns: The median of the array.
; Precondition: None.
; Registers Changed: eax, ebx, ecx, edx, esi
; *************************************************************************************************

displayMedian PROC
		enter	0,0
		mov		esi, [ebp + 8]
		mov		eax, [ebp + 16]
		cdq
		mov		ebx, 2
		div		ebx
		mov		ebx, [esi + eax * 4]
		push	ebx

		; If the array has an even set of integers, calculate the average.
		cmp		edx, 0
		je		AVE_MEDIAN
		
		PRINT_MEDIAN:
		; Move the value of median into the median variable.
		mov		ebx, [ebp + 12]
		pop		eax
		mov		[ebx], eax
		
		; Print put the string stating the median.		
		mov		edx, [ebp + 20]
		call	WriteString
		mov		eax, [ebp + 12]
		mov		eax, [eax]
		call	WriteDec
		call	Crlf
		call	Crlf
		leave

		ret		12
		
		AVE_MEDIAN:
		dec		eax
		mov		ebx, [esi + eax * 4]
		pop		eax
		add		eax, ebx
		cdq
		mov		ebx, 2
		div		ebx
		
		
		cmp		edx, 0
		je		PUSH_EAX	
		inc		eax
		PUSH_EAX:
		push	eax	
		jmp		PRINT_MEDIAN
		
displayMedian ENDP






; *************************************************************************************************
; Description: Print the array to to console.
; Receives: A string of spaces, a title string, an array, and the length of the array.
; Returns: Nothing.
; Precondition: None.
; Registers Changed:  ecx, esi, edx, 
; *************************************************************************************************

displayList PROC
		LOCAL	counter:DWORD
		mov		ecx, [ebp + 12]
		mov		esi, [ebp + 8]

		mov		edx, [ebp + 16]
		call	WriteString
		call	Crlf

		mov		counter, 0

		; Loop through each value in the array, move them to the eax register and print them to the 
		; console and print spaces to the console. Once counter is divisible by 10, call Crlf.
	PRINT_INT:
		mov		eax, [esi]
		call	WriteDec
		add		esi, 4	

		; The number of things printed.
		inc		counter	
		mov		eax, counter
		cdq		
		mov		ebx, 10
		div		ebx

		cmp		edx, 0
		je		NEXT_LINE

		mov		edx, [ebp + 20]
		call	WriteString
		jmp		CONTINUE

	NEXT_LINE:
		call	Crlf

	CONTINUE:
		loop	PRINT_INT
		call	Crlf
		ret		12
displayList ENDP

; *************************************************************************************************
; Description: Print the array ordered by column instead of by row.
; Receives: A string of spaces, a title string, an array, and the length of the array.
; Returns: Nothing.
; Precondition: None.
; Registers Changed:  ecx, esi, edx, eax, ebx
; *************************************************************************************************
columnList PROC
		LOCAL	row:DWORD, column:DWORD, offsetNum:DWORD, counter:DWORD, offsetCount:DWORD
		mov		ecx, [ebp + 12]
		mov		esi, [ebp + 8]

		mov		edx, [ebp + 16]
		call	WriteString
		call	Crlf

		mov		row, 0
		mov		eax, ecx
		cdq
		mov		ebx, 10
		div		ebx
		mov		offsetNum, eax
		mov		offsetCount, edx

		; Loop through each value in the array, move them to the eax register and print them to the 
		; console and print spaces to the console. Once counter is divisible by 10, call Crlf.
	CHANGE_ROW:
		push	row
		pop		column	
		mov		counter, 0
	PRINT_COL:

		mov		eax, column
		mov		eax, [esi + eax * 4]

		call	WriteDec

		; Move column over to another 
		mov		eax, offsetNum
		mov		ebx, offsetCount

		cmp		counter, ebx 
		jge		NO_OFFSET
		inc		eax	
	NO_OFFSET:
		add		column, eax 
		inc		counter

		mov		eax, column 
		mov		ebx, [ebp + 12]
		cmp		eax, ebx
		jge		NEXT_LINE

		mov		edx, [ebp + 20]
		call	WriteString
		loop	PRINT_COL
		jmp		LOOP_DONE	

	NEXT_LINE:
		call	Crlf
		inc		row
		loop	CHANGE_ROW
	LOOP_DONE:
		call	Crlf
		ret		12
columnList ENDP

END main
