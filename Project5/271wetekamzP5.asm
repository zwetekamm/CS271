TITLE CS271 Program 5    (271wetekamzP5.asm)

; Author: Zachary Wetekamm
; Last Modified: 5//28/18
; Course number/section: 271-400
; Project Number: 5
; Description: Program generates random integers between a specified range and
; stores them into an array. The integers are displayed, sorted, and displayed
; as sorted. The median value of the array is also displayed.

INCLUDE Irvine32.inc

MIN = 10
MAX = 200
LO = 100
HI = 999

.data
programTitle        BYTE		"Program 5: Sorting Random Integers", 0
programAuthor       BYTE		"Programmed by: Zachary Wetekamm", 0
prompt_Instr1       BYTE		"This program generates random numbers in the range 100-999.", 0
prompt_Instr2       BYTE		"It displays the original list, sorts the list, and calculates the median. Then, displays the sorted list in descending order.", 0
prompt_Input        BYTE		"How many numbers should be generated? [10...200]: ", 0
prompt_Error        BYTE		"Invalid input.", 0
prompt_Unsorted     BYTE		"The original, unsorted list of random numbers:", 0
prompt_Median       BYTE		"The median is ", 0
prompt_Sorted       BYTE		"The new, sorted list of random numbers:", 0
prompt_Farewell     BYTE		"Goodbye!", 0
spaceBuffer         BYTE		"   ", 0

request             DWORD		?
array               DWORD		MAX DUP(?)
arraySize           DWORD		?
temp                DWORD		?

; @ comments indicate calls by reference and not value

.code
main PROC
	; Introduction
	call        Randomize
	call        introduction

	; Get user data
	push        OFFSET	prompt_Input            ; @
	push        OFFSET	prompt_Error            ; @
	push        OFFSET	request                 ; @
	call        getData

	; Fill the array based on input value
	push        OFFSET	temp                    ; @
	push        request                         ; value
	push        OFFSET	array                   ; @
	push        OFFSET	arraySize               ; @
	call        fillArray

	; Display the unsorted list
	mov         edx, OFFSET		prompt_Unsorted
	call        WriteString
	call        CrLf
	push        OFFSET	array                   ; @
	push        arraySize                       ; value
	call        displayList

	; Sort the original list
	push        OFFSET array                    ; @
	push        arraySize                       ; value
	call        sortList
	call        CrLf

	; Display the new, sorted list
	mov         edx, OFFSET		prompt_Sorted
	call        WriteString
	call        CrLf
	push        OFFSET array                    ; @
	push        arraySize                       ; value
	call        displayList

	; Display the median value
	push        OFFSET prompt_Median            ; @
	push        OFFSET array                    ; @
	push        arraySize                       ; value
	call        displayMedian

	; Display farewell
	push        OFFSET		prompt_Farewell     ; @
	call        farewell
main ENDP

;-----------------------------------------------------------------------------
; Procedure: Introduction
; Description: Displays the program title and author, then the program
; instructions.
;-----------------------------------------------------------------------------
introduction PROC
	mov         edx, OFFSET		programTitle
	call        WriteString
	call        CrLf
	mov         edx, OFFSET		programAuthor
	call        WriteString
	call        CrLf
	call        CrLf
	mov         edx, OFFSET		prompt_Instr1
	call        WriteString
	call        CrLf
	mov         edx, OFFSET		prompt_Instr2
	call        WriteString
	call        CrLf
	ret
introduction ENDP

;-----------------------------------------------------------------------------
; Procedure: getData
; Description: Asks user for how many random numbers to be generated and
; validates the input. Input must be a number between 10 and 400.
;-----------------------------------------------------------------------------
getData PROC
   push         ebp
   mov          ebp, esp

	requestInput:
		mov         edx, [ebp+16]
		call        WriteString
		call        ReadInt
		mov         [ebp+8], eax
		call        CrLf

		; Validate the input
		cmp         eax, MIN
		jl          invalid
		cmp         eax, MAX
		jg          invalid
		jmp         valid

	invalid:
		mov         edx, [ebp+12]
		call        WriteString
		call        CrLF
		jmp         requestInput

	valid:
		mov         request, eax                ; Stores valid input
		pop         ebp
		ret         12
getData ENDP


;-----------------------------------------------------------------------------
; Procedure: fillArray
; Description: Generates random numbers up to the amount requested by the user
; and stores the values into an array.
;-----------------------------------------------------------------------------
fillArray PROC
	push        ebp
	mov         ebp, esp
	mov         eax, HI
	sub         eax, LO
	inc         eax
	mov         ebx, [ebp+20]
	mov         [ebx], eax
	mov         ecx, [ebp+16]
	mov         esi, [ebp+12]

		fill:
		   mov          ebx, [ebp+20]
		   mov          eax, [ebx]
		   call         RandomRange         ; Randomize
		   add          eax, LO             ; Adjust to LO limit

		   mov          [esi], eax          ; Store random number in array
		   add          esi, 4

		   mov          ebx, [ebp+8]        ; Increment array size by 1
		   mov          eax, 1
		   add          [ebx], eax
		   loop         fill

	pop         ebp
	ret         16
fillArray ENDP

;-----------------------------------------------------------------------------
; Procedure: displayList
; Description: Displays the elements of the array organized with 10 numbers
; per line.
;-----------------------------------------------------------------------------
displayList PROC
	push        ebp
	mov         ebp, esp
	mov         ebx, 0
	mov         ecx, [ebp+8]
	mov         esi, [ebp+12]

	displayLoop:
		mov         eax, [esi]              ; Current element
		call        WriteDec
		mov         edx, OFFSET spaceBuffer
		call        WriteString
		inc         ebx
		cmp         ebx, MIN
		jl          sameLine                ; If element is on same line
		call        CrLf                    ; Else, begin new line
		mov         ebx, 0

	sameLine:
		add         esi, 4
		loop        displayLoop

	call        CrLf
	pop         ebp
	ret         12
displayList ENDP


;-----------------------------------------------------------------------------
; Procedure: sortList
; Description: Sorts the elements of the array by decreasing value.  The
; procedure swaps elements in the array to sort among the stack.
;-----------------------------------------------------------------------------
sortList PROC
	push        ebp
	mov         ebp, esp
	mov         ecx, [ebp+8]                ; Array size to counter
	L1:
		mov         esi, [ebp+12]           ; Current array element
		mov         edx, ecx
	L2:
		mov         eax, [esi]
		mov         ebx, [esi+4]
		cmp         ebx, eax                ; Compare current element to next element
		jle         L3
		mov         [esi], ebx              ; Swap current element and next element
		mov         [esi+4], eax
	L3:
		add         esi, 4
		loop        L2
		mov         ecx, edx
		loop        L1

	pop         ebp
	ret         8
sortList ENDP

;-----------------------------------------------------------------------------
; Procedure: displayMedian
; Description: Displays the median value of the array elements. The procedure
; checks whether the total number of elements is even or odd, and determines
; the median by division is even.
;-----------------------------------------------------------------------------
displayMedian PROC
	push        ebp
	mov         ebp, esp

   ; Determine whether the number of elements are even or odd
	mov         esi, [ebp + 12]
	mov         eax, [ebp + 8]
	mov         edx, 0
	mov         ebx, 2
	div         ebx
	mov         ecx, eax

	checkLoop:
		add         esi, 4
		loop        checkLoop

	cmp         edx, 0
	je          isEven                      ; If even
	mov         eax, [esi]                  ; Continue since odd
	jmp         output

	isEven:
		mov         eax, [esi-4]
		add         eax, [esi]
		mov         edx, 0
		mov         ebx, 2
		div         ebx
		jmp         output

	output:
		mov         edx, OFFSET prompt_Median
		call        WriteString
		call        WriteDec
		call        CrLf

	pop         ebp
	ret         12
displayMedian ENDP

;-----------------------------------------------------------------------------
; Procedure: farewell
; Description: Outputs a goodbye message to the user to notify the program
; has ended.
;-----------------------------------------------------------------------------
farewell PROC
	call        CrLf
	mov         edx, OFFSET		prompt_Farewell
	call        WriteString
	call        CrLf
	exit
farewell ENDP

END main
