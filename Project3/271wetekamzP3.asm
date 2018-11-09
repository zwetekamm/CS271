TITLE CS271 Program 3    (271wetekamzP3.asm)

; Author: Zachary Wetekamm
; Last Modified: 05/06/18
; Course number/section: 271-400
; Project Number: 3
; Description: User repeatedly enters numbers between -100 and -1 until non-negative
; integer is entered; Total numbers entered, including the sum and average, are displayed.

INCLUDE Irvine32.inc

LOWERLIMIT = -100

.data
programTitle		BYTE		"Program 3: Integer Accumulator", 0
programAuthor		BYTE		"Programmed by: Zachary Wetekamm", 0
prompt_UserName     BYTE		"What's your name?", 0
prompt_Greet		BYTE		"Hello, ", 0
prompt_Instr1		BYTE		"Please enter numbers in [-100, -1].", 0
prompt_Instr2		BYTE		"Enter a non-negative number when you are finished to see the results.", 0
prompt_Input		BYTE		"Enter Number: ", 0
prompt_Invalid		BYTE		"Must be between -100 and -1, or positive to exit", 0
prompt_ValidCount	BYTE		"Valid numbers entered: ", 0
prompt_ValidSum     BYTE		"The sum of your valid numbers is: ", 0
prompt_ValidAvg     BYTE		"The rounded average is: ", 0
prompt_Goodbye		BYTE		"Thank you for playing Integer Accumulator!", 0

nameBuffer			BYTE		21 DUP(0)
userName			DWORD		?
count				DWORD		0
number				DWORD		0
total				DWORD		0
numAvg				DWORD		0

.code
main PROC

; INTRODUCTION
	; Display title and author
	mov			edx, OFFSET		programTitle
	call		WriteString
	call		CrLf
	mov			edx, OFFSET		programAuthor
	call		WriteString
	call		CrLf
	call		CrLf

	; Prompt and get user name
	mov			edx, OFFSET		prompt_UserName
	call		WriteString
	call		CrLf
	mov			edx, OFFSET		nameBuffer
	mov			ecx, SIZEOF		nameBuffer
	call		Readstring
	mov			userName, eax

	mov			edx, OFFSET		prompt_Greet
	call		WriteString
	mov			edx, OFFSET		nameBuffer
	call		WriteString
	call		CrLf
	call		CrLf

	; User instructions
	mov			edx, OFFSET		prompt_Instr1
	call		WriteString
	call		CrLf
	mov			edx, OFFSET		prompt_Instr2
	call		WriteString
	call		CrLf

; USER INPUT
userInput:
	; Request user input and compare to -100 and -1. If positive, exit.
	mov			edx, OFFSET		prompt_Input
	call		WriteString
	call		ReadInt

	cmp			eax, LOWERLIMIT					; if out of range
	jl			invalid
	cmp			eax, 1							; if positive integer
	jge			calcAvg
	jmp			calcAccum						; if valid input

invalid:
	; If user input is invalid, display error message and return to input
	mov			edx, OFFSET		prompt_Invalid
	call		WriteString
	call		CrLf
	jmp			userInput

calcAccum:
	; Increase the valid input count
	inc			count

	; Add sum to total
	mov			number, eax
	mov			total, ebx
	add			eax, ebx
	mov			total, eax
	jmp			userInput

calcAvg:
	mov			edx, 0
	mov			eax, total
	mov			ebx, count
	div			ebx
	mov			numAvg, eax
	jmp			displayResults

; DISPLAY RESULTS
displayResults:
	; Display valid negative inputs
	mov			edx, OFFSET		prompt_ValidCount
	call		WriteString
	mov			eax, count
	call		WriteDec
	call		CrLf

	; Display sum of valid inputs
	mov			edx, OFFSET		prompt_ValidSum
	call		WriteString
	mov			eax, total
	call		WriteInt
	call		CrLf

	; Display average of the accumulator
	mov			edx, OFFSET		prompt_ValidAvg
	call		WriteString
	mov			eax, numAvg
	call		WriteInt
	call		CrLf

; GOODBYE
	mov			edx, OFFSET		prompt_Goodbye
	call		WriteString
	call		CrLf

	exit
main ENDP

END main
