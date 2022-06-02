TITLE Project 6     (Proj6_littleki.asm)

; Author: Kirby Little
; Last Modified: 06/02/2022
; OSU email address: littleki@oregonstate.edu
; Course number/section: CS271 Section 400
; Project Number: 6                 Due Date: 06/05/2022
; Description: This file is provided as a template from which you may work
;              when developing assembly projects in CS271.

INCLUDE Irvine32.inc


; These macros should use Irvine’s ReadString to get input from the user, 
; and WriteString procedures to display output. 


; ---------------------------------------------------------------------------------
; Name: mGetString
; 
; mGetString:  Display a prompt (input parameter, by reference), then get the user’s keyboard input 
; into a memory location (output parameter, by reference). You may also need to provide a count 
; (input parameter, by value) for the length of input string you can accommodate and a provide a 
; number of bytes read (output parameter, by reference) by the macro.
;
; Preconditions: do not use eax, ecx, esi as arguments
;
; Receives:
; arrayAddr = array address
; arrayType = array type
; arraySize = array length
;
; returns: arrayAddr = generated string address
; ---------------------------------------------------------------------------------
mGetString MACRO	inPrompt, inputStr, bytesLen

; called to get one integer at a time for the array

; prompt
	mov		edx, inPrompt
	call	writestring
	call	crlf

	
; ReadString and store to mGetInput
	mov		edx, inputStr
	mov		ecx, sizeof inputStr
	call	readstring
	call	crlf

; store number of bytes read to mGetBytes
	mov		[bytesLen], eax


ENDM


; ---------------------------------------------------------------------------------
; Name: mDisplayString
;
; mDisplayString:  Print the string which is stored in a specified memory location 
; (input parameter, by reference).
;
; Preconditions: do not use eax, ecx, esi as arguments
;
; Receives:
; arrayAddr = array address
; arrayType = array type
; arraySize = array length
;
; returns: arrayAddr = generated string address
; ---------------------------------------------------------------------------------
mDisplayString MACRO	inputStr

	mov		edx, inputStr
	call	writestring
	mov		al, ' '
	call	writechar

ENDM

; constants
LO_LIMIT	=	-2147483648
HI_LIMIT	=	+2147483647


.data

; (insert variable definitions here)

inputPrompt		byte		"Please enter an integer.",0		; prompt for mGetString input
errorInvalid	byte		"Your input is not valid.",0		; error message for invalid input

mGetInput		byte		"***********",0						; input storage for mGetString
mGetCount		sdword		11									; max input string length for mGetString
mGetBytes		sdword		?									; number of input bytes read by mGetString

readOut			sdword		?									; output storage for ReadVal

inputArray		sdword		10	dup(?)							; array for main proc to store mGetString input into
inputSum		sdword		0									; variable for sum of input numbers
inputAvg		sdword		?									; variable for the average of input numbers


.code
; ---------------------------------------------------------------------------------
; Name: main
;
; Write a test program (in main) which uses the ReadVal and WriteVal procedures above to:
;
;    1) Get 10 valid integers from the user. Your ReadVal will be called within the loop in main. Do not put your counted loop within ReadVal.
;    2) Stores these numeric values in an array.
;    3) Display the integers, their sum, and their truncated average.
;
; Your ReadVal will be called within the loop in main. Do not put your counted loop within ReadVal.
;
; Preconditions: Preconditions are conditions that need to be true for the
; procedure to work, like the type of the input provided or the state a
; certain register need to be in.
;
; Postconditions: Postconditions are any changes the procedure makes that are not
; part of the returns. If any registers are changed and not restored, they
; should be described here.
;
; Receives: Receives is like the input of a procedure; it describes everything
; the procedure is given to work. Parameters, registers, and global variables
; the procedure takes as inputs should be described here.
;
; Returns: Returns is the output of the procedure. Because assembly procedures don’t
; return data like high-level languages, returns should describe all the data
; the procedure intended to change. Parameters and global variables that the
; procedure altered should be described here. Registers should only be mentioned
; if you are trying to pass data back in them.
; ---------------------------------------------------------------------------------
main PROC


; TESTING------------------------------------

	mov		eax, offset inputPrompt
	mov		ebx, offset mGetInput
	mov		edx, offset mGetBytes

	mGetString	offset inputPrompt, offset mGetInput, offset mGetBytes

; ENDT---------------------------------------


; loop ReadVal to get 10 user inputs
	; ReadVal gets one integer at a time w/ mGetString, converts, stores to readOut
	; append readOut val to inputArray

; display the integers, their sum, and truncated average with WriteVal
	; print inputArray one element at a time with WriteVal
		; pass element of inputArray to WriteVal, converts to string, printed by mDisplayString
		; increment inputArray indexer
		; pass next element of inputArray to WriteVal
	; show sum
		; add inputArray element val to inputSum
		; increment inputArray indexer
		; add next element val to inputSum
		; call WriteVal on inputSum to convert and print with mDisplayString
	; show average
		; div inputSum by 10
		; figure out rounding
		; store rounded average to inputAvg
		; call WriteVal on inputAvg to convert and print with mDisplayString


	Invoke ExitProcess,0	; exit to operating system
main ENDP


; ---------------------------------------------------------------------------------
; Name: ReadVal
;
;    1) Invoke the mGetString macro (see parameter requirements above) to get user input in the form of a string of digits.
;    2) Convert (using string primitives) the string of ascii digits to its numeric value representation (SDWORD), validating
;    the user’s input is a valid number (no letters, symbols, etc).
;    3) Store this one value in a memory variable (output parameter, by reference). 
;
; Preconditions: Preconditions are conditions that need to be true for the
; procedure to work, like the type of the input provided or the state a
; certain register need to be in.
;
; Postconditions: Postconditions are any changes the procedure makes that are not
; part of the returns. If any registers are changed and not restored, they
; should be described here.
;
; Receives: Receives is like the input of a procedure; it describes everything
; the procedure is given to work. Parameters, registers, and global variables
; the procedure takes as inputs should be described here.
;
; Returns: Returns is the output of the procedure. Because assembly procedures don’t
; return data like high-level languages, returns should describe all the data
; the procedure intended to change. Parameters and global variables that the
; procedure altered should be described here. Registers should only be mentioned
; if you are trying to pass data back in them.
; ---------------------------------------------------------------------------------
ReadVal PROC

; get user input from mGetString

; convert string to numbers
	; handle cases of + or - leading characters
	; validate no non-digits or +/- lead and not too large for 32-bit register
		; print error message if not valid
			; get new input
		; print error message if no input
			; get new input
ReadVal ENDP


; ---------------------------------------------------------------------------------
; Name: WriteVal
;
;
;    1) Convert a numeric SDWORD value (input parameter, by value) to a string of ASCII digits.
;    2) Invoke the mDisplayString macro to print the ASCII representation of the SDWORD value to the output.
;
;
; Preconditions: Preconditions are conditions that need to be true for the
; procedure to work, like the type of the input provided or the state a
; certain register need to be in.
;
; Postconditions: Postconditions are any changes the procedure makes that are not
; part of the returns. If any registers are changed and not restored, they
; should be described here.
;
; Receives: Receives is like the input of a procedure; it describes everything
; the procedure is given to work. Parameters, registers, and global variables
; the procedure takes as inputs should be described here.
;
; Returns: Returns is the output of the procedure. Because assembly procedures don’t
; return data like high-level languages, returns should describe all the data
; the procedure intended to change. Parameters and global variables that the
; procedure altered should be described here. Registers should only be mentioned
; if you are trying to pass data back in them.
; ---------------------------------------------------------------------------------
WriteVal PROC

; works on one value at a time

; convert SDWORD digits to ASCII

; pass ASCII string to mDisplayString to print

WriteVal ENDP


END main
