TITLE CS271 Program 1   (271wetekamzP1.asm)

; Author: Zachary Wetekamm
; Last Modified: 4/15/18
; Course number/section: CS271-400
; Project Number: 1
; Description:	This program calculates the sum, difference, product, quotient, and remainder
; of two numbers.

INCLUDE Irvine32.inc

.data
programTitle		BYTE		"Programming Assignment 1			Author: Zachary Wetekamm", 0
instructions		BYTE		"Enter two numbers, and I'll show their sum, difference, product, quotient, and remainder.", 0
prompt_number1		BYTE		"What is the first number? ", 0
prompt_number2		BYTE		"What is the second number? ", 0
number1             DWORD		?
number2             DWORD		?
sum                 DWORD		?
difference			DWORD		?
product             DWORD		?
quotient			DWORD		?
remainder			DWORD		?
equalSign			BYTE		" = ", 0
sumSign             BYTE		" + ", 0
differenceSign		BYTE		" - ", 0
productSign         BYTE		" * ", 0
quotientSign		BYTE		" / ", 0
remainderString     BYTE		" remainder ", 0
goodbye             BYTE		"Impressed? Bye!", 0

.code
main PROC

; INTRODUCTION
    ; Display program title, author, and instructions
	mov	        edx, OFFSET		programTitle
	call		WriteString
	call		CrLf
	call		CrLf
	mov			edx, OFFSET		instructions
	call		WriteString
	call		CrLf

; GET DATA
	; Get number1 from user
	mov			edx, OFFSET		prompt_number1
	call		WriteString
	call		ReadInt
	mov			number1, eax

	; Get number2 from user
	mov			edx, OFFSET		prompt_number2
	call		WriteString
	call		ReadInt
	mov			number2, eax
	call		CrLf

; CALCULATIONS
	; Sum
	mov			eax, number1
	mov			ebx, number2
	add			eax, ebx
	mov			sum, eax

	; Difference
	mov			eax, number1
	mov			ebx, number2
	sub			eax, ebx
	mov			difference, eax

	; Product
	mov			eax, number1
	mul			number2
	mov			product, eax

	; Quotient and remainder
	mov			edx, 0
	mov			eax, number1
	mov			ebx, number2
	div			ebx
	mov			quotient, eax
	mov			remainder, edx

; DISPLAY RESULTS
	; Display sum
	mov			eax, number1
	call		WriteDec
	mov			edx, OFFSET		sumSign
	call		WriteString
	mov			eax, number2
	call		WriteDec
	mov			edx, OFFSET		equalSign
	call		WriteString
	mov			eax, sum
	call		WriteDec
	call		CrLf

	; Display difference
	mov			eax, number1
	call		WriteDec
	mov			edx, OFFSET		differenceSign
	call		WriteString
	mov			eax, number2
	call		WriteDec
	mov			edx, OFFSET		equalSign
	call		WriteString
	mov			eax, difference
	call		WriteInt
	call		CrLf

	; Display product
	mov			eax, number1
	call		WriteDec
	mov			edx, OFFSET		productSign
	call		WriteString
	mov			eax, number2
	call		WriteDec
	mov			edx, OFFSET		equalSign
	call		WriteString
	mov			eax, product
	call		WriteDec
	call		CrLf

	; Display quotient and remainder
	mov			eax, number1
	call		WriteDec
	mov			edx, OFFSET		quotientSign
	call		WriteString
	mov			eax, number2
	call		WriteDec
	mov			edx, OFFSET		equalSign
	call		WriteString
	mov			eax, quotient
	call		WriteDec
	mov			edx, OFFSET		remainderString
	call		WriteString
	mov			eax, remainder
	call		WriteDec
	call		CrLf

; GOODBYE MESSAGE
	call		CrLf
	mov			edx, OFFSET		goodbye
	call		WriteString
	call		CrLf
	call		CrLf

	exit
main ENDP

END main
