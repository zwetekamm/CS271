TITLE CS271 Program 4    (271wetekamzP4.asm)

; Author: Zachary Wetekamm
; Last Modified: 05/13/18
; Course number/section: 271-400
; Project Number: 4
; Description:	Program calculates composite numbers up to a user-entered integer
; within range 1-400; also demonstrates use of PROC (procedure) calls.

INCLUDE Irvine32.inc

UPPERLIMIT = 400

.data
programTitle        BYTE		"Program 4: Composite Numbers ", 0
programAuthor       BYTE		"Programmed by: Zachary Wetekamm", 0
prompt_Instr        BYTE		"For this program, enter the number of composite numbers you want to display.", 0
prompt_Input        BYTE		"Enter the number of composites to display [1 - 400]: ", 0
prompt_Error        BYTE		"Out of range. Must be between 1 and 400.", 0
prompt_SDigit       BYTE		"     ", 0
prompt_DDigit       BYTE		"    ", 0
prompt_TDigit       BYTE		"   ", 0
prompt_Farewell     BYTE		"Results certified by Zachary.  Goodbye!", 0
prompt_EC1          BYTE		"**EC: Align the output columns"

input               DWORD		?
compNum             DWORD		4			; Since first composite is 4
line                DWORD		0
factor              DWORD		0
maxFactor           DWORD		0

.code
main PROC
	call        introduction
	call        getUserData
	call        showComposites
	call        farewell
	exit

main ENDP

; INTRODUCTION
introduction PROC
	; Display title and author
	mov         edx, OFFSET		programTitle
	call        WriteString
	call        CrLf
	mov         edx, OFFSET		programAuthor
	call        WriteString
	call        CrLf
	call        CrLf

	;EXTRA CREDIT 1
	mov         edx, OFFSET		prompt_EC1
	call        WriteString
	call        CrLf
	call        CrLf

	; USER INSTRUCTIONS
	mov         edx, OFFSET		prompt_Instr
	call        WriteString
	call        CrLf
	ret

introduction ENDP


; GET USER DATA
getUserData PROC
	mov         edx, OFFSET		prompt_Input
	call        WriteString
	call        ReadInt
	mov         input, eax
	call        validate
	ret

getUserData ENDP

; VALIDATE
validate PROC
	cmp         eax, 1
	jl          invalid
	cmp         eax, UPPERLIMIT
	jg          invalid
	jmp         valid                       ; if valid

	invalid:
		mov         edx, OFFSET		prompt_Error
		call        WriteString
		call        CrLf
		call        getUserData             ; return to request user data

	valid:
		ret

validate ENDP


; SHOW COMPOSITES
showComposites PROC
	mov         ecx, input                  ; set the counter to user input
	mov         compNum, 4
	mov         line, 1

	printComp:
		call        isComposite
		mov         eax, compNum
		call        WriteDec
		call        alignLine               ; procedure to align column
		inc         compNum
		cmp         line, 10                ; compare line space to 10 (max per line)
		jge         newLine
		inc         line
		jmp         compLoop

	newLine:
		call        CrLf
		mov         line, 1

	compLoop:
		loop        printComp

showComposites ENDP

; ALIGNMENT
alignLine	PROC
	; Aligns colums using spaces after checking if the current compNum
	; is a single-, double-, or triple-digit.
		cmp         compNum, 10
		jl          singleSpace
		cmp         compNum, 100
		jl          doubleSpace
		cmp         compNum, 1000
		jl          tripleSpace

		singleSpace:
			mov         edx, OFFSET			prompt_SDigit
			call        WriteString
			ret

		doubleSpace:
			mov         edx, OFFSET			prompt_DDigit
			call        WriteString
			ret

		tripleSpace:
			mov         edx, OFFSET			prompt_TDigit
			call        WriteString
			ret

alignLine	ENDP


; IS COMPOSITE
isComposite PROC
	tryFactor:
			mov         eax, compNum
			dec         eax
			mov         factor, 2
			mov         maxFactor, eax

	calcFactor:
			mov         eax, compNum
			cdq
			div         factor
			cmp         edx, 0                  ; if remainder is 0, then is composite
			je          compValid
			inc         factor
			mov         eax, factor
			cmp         eax, maxFactor
			jle         calcFactor              ; factor again
			inc         compNum                 ; increment the factor
			jmp         tryFactor

	compValid:
			ret

isComposite ENDP

; FAREWELL
farewell PROC
	call        CrLf
	mov         edx, OFFSET		prompt_Farewell
	call        WriteString
	call        CrLf
	ret

farewell ENDP

END main
