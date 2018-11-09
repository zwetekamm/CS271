TITLE CS271 Program 2   (271wetekamzP2.asm)

; Author: Zachary Wetekamm
; Last Modified: 04/22/18
; Course number/section: 271-400
; Project Number: 2
; Description: Program calculates and displays the Fibonacci sequence for
; any number (up to 47) that the user inputs:

INCLUDE Irvine32.inc

FIBLIMIT = 47					; constant for out-of-bounds input

.data
programTitle        BYTE		"Program 2: Fibonacci Numbers", 0
programAuthor       BYTE		"Programmed by: Zachary Wetekamm", 0
prompt_UserName     BYTE		"What's your name?", 0
prompt_Greet        BYTE		"Hello, ", 0
prompt_Instr1       BYTE		"Enter the number of Fibonacci terms to be displayed.", 0
prompt_Instr2       BYTE		"Give the number as an integer in the range [1 . . 46].", 0
prompt_Fib          BYTE		"How many Fibonacci terms do you want? ", 0
prompt_Error        BYTE		"Out of range.  Enter a number [1 . . 46]", 0
prompt_Confirm      BYTE		"Results certified by ", 0
prompt_Goodbye      BYTE		"Goodbye ", 0

nameBuffer          BYTE		21 DUP(0)
spaceBuffer         BYTE		"     ", 0
userName            DWORD		?
fibNum              DWORD		?
val1                DWORD		?
val2                DWORD		?
temp                DWORD		?
ifNewline           DWORD		5

.code
main PROC
; INTRODUCTION
	; Display title and author
	mov         edx, OFFSET		programTitle
	call        WriteString
	call        CrLf
	mov         edx, OFFSET		programAuthor
	call        WriteString
	call        CrLf
	call        CrLf

	; Prompt and get user name
	mov         edx, OFFSET		prompt_UserName
	call        WriteString
	call        CrLf
	mov         edx, OFFSET		nameBuffer
	mov         ecx, SIZEOF		nameBuffer
	call        Readstring
	mov         userName, eax

	mov         edx, OFFSET		prompt_Greet
	call        WriteString
	mov         edx, OFFSET		nameBuffer
	call        WriteString
	call        CrLf
	call        CrLf

; USER INSTRUCTIONS
	mov         edx, OFFSET		prompt_Instr1
	call        WriteString
	call        CrLf
	mov         edx, OFFSET		prompt_Instr2
	call        WriteString
	call        CrLf
	call        CrLf

; GET USER DATA
	; Get input from user
input:
	mov         edx, OFFSET		prompt_Fib
	call        WriteString
	call        ReadInt
	mov         fibNum, eax

	; Validate the input
	cmp         eax, FIBLIMIT
	jg          ifInvalid
	cmp         eax, 1
	jl          ifInvalid
	je          isOne
	cmp         eax, 2
	je          isTwo
	jmp         sequence            ; if valid

ifInvalid:
	; If input is invalid
	mov         edx, OFFSET		prompt_Error
	call        WriteString
	call        CrLf
	call        CrLf
	jmp         input               ; return to GET USER DATA

isOne:
	call        WriteDec
	call        CrLf
	call        CrLf
	jmp         goodbye

isTwo:
	mov         eax, 1
	call        WriteDec
	mov         edx, OFFSET		spaceBuffer
	call        WriteString
	call        WriteDec
	call        CrLf
	call        CrLf
	jmp         goodbye

; DISPLAY FIBS
sequence:
	mov         ecx, fibNum
	sub         ecx, 3                  ; since 1 and 2 are preconditions, begin at 3
	mov         eax, 1
	call        WriteDec                ; first sequence
	mov         edx, OFFSET		spaceBuffer
	call        WriteString
	call        WriteDec                ; second sequence
	call        WriteString
	mov         val1, eax
	mov         eax, 2                  ; third sequence
	call        WriteDec
	mov         edx, OFFSET		spaceBuffer
	call        WriteString
	mov         val2, eax               ; store previous value as new variable

fibLoop:

	add         eax, val1               ; add previous values
	call        WriteDec
	mov         edx, OFFSET		spaceBuffer
	call        WriteString
	mov         temp, eax               ; begin swap of previous values
	mov         eax, val2               ; -
	mov         val1, eax               ; -
	mov         eax, temp               ; -
	mov         val2, eax               ; end of swap
	mov         edx, ecx
	cdq
	div         ifNewline
	cmp         edx, 0                  ; compare, if the 5th sequence per line
	jne         newLine
	call        CrLf

newLine:
	mov         eax, temp
	loop        fibLoop
	call        CrLf
	jmp         goodbye

; FAREWELL
goodbye:
	mov         edx, OFFSET		prompt_Confirm
	call        WriteString
	call        CrLf
	mov         edx, OFFSET		prompt_Goodbye
	call        WriteString
	mov         edx, OFFSET		nameBuffer
	call        WriteString
	call        CrLf

	exit
main ENDP

END main
