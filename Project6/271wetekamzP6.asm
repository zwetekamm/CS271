TITLE CS271-400 Program     (271wetekamzP6.asm)

; Author: Zachary Wetekamm
; Last Modified: 6/10/18
; Course number/section: 271-400
; Project Number: 6
; Description:	Program demonstrates macro functions; User input is read
; as a string and converted to numeric form. Parameters are passed on the
; stack, registers are saved and restored, and the stack is cleaned.

INCLUDE Irvine32.inc

MAX = 10				; number of inputs to loop
MAX_STR = 20			; max size of input strings

;--------------------------------------------------------------------
;	getString	MACRO	buffer, prompt_string
;	Description: Prompts user for input, then saves string into memory.
;	Receives:	buffer, prompt_string
;	Registers Changed: ecx, edx
;--------------------------------------------------------------------
getString	MACRO	buffer, prompt_string
	push		edx									; save registers
	push		ecx
	displayString	OFFSET	prompt_string
	mov			edx, buffer
	mov			ecx, MAX_STR - 1					; adjust to carried 0
	call		ReadString
	pop			ecx									; restore registers
	pop			edx
ENDM

;--------------------------------------------------------------------
;	displayString	MACRO	buffer
;	Description: Displays a string in a specific memory location.
;	Receives: Address of string (buffer)
;	Registers Changed: edx
;--------------------------------------------------------------------
displayString	MACRO	buffer
	push		edx									; save register
	mov			edx, buffer
	call		WriteString
	pop			edx									; restore register
ENDM

;------------------------------------------------------------------

.data
programTitle	BYTE		"Program 6a: Designing low-level I/O procedures", 13, 10, 0
programAuthor	BYTE		"Programmed by: Zachary Wetekamm", 13, 10, 0
EC1             BYTE		"EC1: Number each line of input and keep running total.", 13, 10, 0
EC2             BYTE		"EC2: ReadVal and WriteVal procedures are recursive.", 13, 10, 13, 10, 0
intro1			BYTE		"Please provide 10 unsigned decimal integers.", 13, 10, 0
intro2			BYTE		"Each number needs to be small enough to fit inside a 32 bit register.", 13, 10, 0
intro3			BYTE		"After you have finished inputting the numbers, I will display a list", 13, 10, 0
intro4			BYTE		"of the integers, their sum, and their average value", 13, 10, 13, 10, 0
promptInput     BYTE		"Please enter an unsigned number: ", 0
valuesTotal     BYTE		" values entered. Running total: ", 0
error			BYTE		"ERROR: Not an unsigned integer, or is too big. Please try again.", 13, 10, 0
displayNums     BYTE		"You entered the following numbers: ", 0
displaySum      BYTE		"The sum of these numbers is: ", 0
displayAverage	BYTE		"The average is: ", 0
goodbye         BYTE		"Thanks for playing!", 13, 10, 0
spaceBuffer     BYTE		", ", 0

array			DWORD		MAX DUP(?)
count			DWORD		0
runningTotal	DWORD		0

.code
main PROC
	; Display program instructions
	displayString	OFFSET	programTitle
	displayString	OFFSET	programAuthor
	displayString	OFFSET	EC1
	displayString	OFFSET	EC2
	displayString	OFFSET	intro1
	displayString	OFFSET	intro2
	displayString	OFFSET	intro3
	displayString	OFFSET	intro4
	mov			ecx, MAX
	mov			edi, OFFSET		array			; set the array

mainLoop:
	; loop to track a running total while incrementing the array
	mov			eax, count
	call		WriteDec						; display count for running total
	displayString	OFFSET	valuesTotal
	mov			eax, runningTotal
	call		WriteDec
	call		CrLf
	push		edi								; push the array
	call		ReadVal
	call		CrLf
	inc			count
	mov			eax, [edi]
	add			edi, 4							; increment array
	mov			ebx, runningTotal
	add			eax, ebx
	mov			runningTotal, eax
	loop		mainLoop						; repeat label
	jmp			continue

continue:
	; if input is valid, continue
	push		MAX
	push		OFFSET		array
	call		Results
	call		CrLf
	displayString	OFFSET	goodbye
	exit

main ENDP

;--------------------------------------------------------------------
;	ReadVal PROC
;	Description: Converts a string of user input to an integer by
;		comparing to ascii values.
;	Receives: address of integer
;	Returns: user-specified integer in address
;	Registers changed: eax, ebx, edx, al, ah
;--------------------------------------------------------------------
ReadVal PROC
	push		ebp								; save register
	mov			ebp, esp						; set base
	jmp			setInput

ifError:
	displayString	OFFSET	error

setInput:
	mov			esi, [ebp+8]
	getString	esi, promptInput
	mov			eax, 0
	push		eax

convertInput:
	mov			eax, 0
	lodsb									; load string byte
	cmp			al, 0
	je			endReadVal
	pop			ebx							; restore calculated value
	push		eax							; save ascii character
	mov			eax, ebx
	mov			ebx, 10
	mul			ebx							; multiply result by 10
	jc			ifError
	mov			edx, eax					; store result in edx
	pop			eax
	cmp			al, 48						; compare ascii to 0
	jl			ifError
	cmp			al, 57						; compare ascii to 9
	jg			ifError
	mov			ah, 48
	sub			al, ah						; convert ascii to decimal
	mov			ah, 0
	add			eax, edx
	jc			ifError
	push		eax							; save calculated value
	jmp			convertInput

endReadVal:
	pop			eax
	mov			esi, [ebp+8]
	mov			[esi], eax
	pop			ebp
	ret	4

ReadVal ENDP

;--------------------------------------------------------------------
;	WriteVal PROC
;	Description: Converts a numeric value to a string of digits and
;   displays output using recursion.
;	Receives: address of unsigned integer
;	Returns: String of integers to console output
;	Registers Changed: eax, ebx, edx, edi
;--------------------------------------------------------------------
WriteVal PROC
	push		ebp
	mov			ebp, esp
	pushad									; save all registers
	sub			esp, 2
	mov			eax, [ebp+8]
	lea			edi, [ebp-2]				; LEA to access the local address
	mov			ebx, 10
	mov			edx, 0
	div			ebx							; divide input by 10
	cmp			eax, 0
	jle			endWriteVal					; end recursion when eax equals 0
	push		eax
	call		WriteVal

endWriteVal:
	mov			eax, edx
	add			eax, 48						; convert to ascii
	stosb									; store in edi
	mov			eax, 0						; null terminator
	stosb
	sub			edi, 2						; reset edi
	displayString	edi						; display the specific integer
	add			esp, 2
	popad
	pop			ebp
	ret 4

WriteVal ENDP

;--------------------------------------------------------------------
;	Results PROC
;	Description: Displays the results of the 10 integers entered,
;	and their average and sum.
;	Receives: address of array, size of array
;	Returns: Output of 10 integers entered by user, sum of the
;	integers, and average of the integers.
;	Registers Changed: ebx, ecx, edx, esp
;--------------------------------------------------------------------
Results PROC
	push		ebp									; save register
	mov			ebp, esp							; set base
	mov			esi, [ebp+8]
	mov			ecx, [ebp+12]
	sub			esp, 4
	mov			edx, 0
	displayString	OFFSET	displayNums
	call		CrLf
	jmp			displayResults

spaceLoop:
	displayString	OFFSET	spaceBuffer

displayResults:
	; display each entered integer
	push		[esi]
	call		WriteVal
	mov			ebx, [esi]
	add			edx, ebx
	add			esi, 4
	loop		spaceLoop							; return, to make a space buffer
	call		CrLf
	displayString	OFFSET	displaySum
	push		edx
	call		WriteVal
	call		CrLf
	displayString	OFFSET	displayAverage
	mov			eax, edx
	mov			edx, 0
	mov			ebx, [ebp+12]
	div			ebx
	push		eax
	call		WriteVal
	call		CrLf
	add			esp, 4
	pop			ebp									; restore
	ret	8

Results ENDP

END main
