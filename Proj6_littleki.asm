TITLE Project 6     (Proj6_littleki.asm)

; Author: Kirby Little
; Last Modified: 06/02/2022
; OSU email address: littleki@oregonstate.edu
; Course number/section: CS271 Section 400
; Project Number: 6                 Due Date: 06/05/2022
; Description: Gets 10 user input numbers as strings, converts these to numerical values, stores them
; in an array, prints this array by converting them back to strings, calculates the sum and average of
; the array and prints these values.

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
mGetString MACRO	inPrompt, inputStr, bytesLen, count

; called to get one integer at a time for the array

; prompt
	mov		edx, inPrompt
	call	writestring
	call	crlf

	
; ReadString and store to mGetInput
	mov		edx, inputStr
	mov		ecx, count
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

mGetInput		byte		11	dup(0)							; input storage for mGetString
mGetCount		sdword		12									; max input string length for mGetString
mGetBytes		sdword		?									; number of input bytes read by mGetString

mDispInput		byte		11	dup(0)							; input storage for mDisplayString

readOut			sdword		?									; output storage for ReadVal
writeIn			sdword		?									; input storage for WriteVal

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


;	call	ReadVal		offset mGetInput, offset readOut, offset inputPrompt, offset mGetBytes, mGetCount


;	call	WriteVal	writeIn, offset mDispInput

;	mov		eax, mGetBytes
;	call	writedec

;	mov		edx, offset mGetInput
;	call	writestring

; ENDT---------------------------------------


	; loop ReadVal to get 10 user inputs
	mov		ecx, 10					; loop 10 times for 10 inputs
	mov		edi, inputArray			; set inputArray as destination address

_readLoop:
		; ReadVal gets one integer at a time w/ mGetString, converts, stores to readOut
		call	ReadVal		offset mGetInput, offset readOut, offset inputPrompt, offset mGetBytes, mGetCount

		; append readOut val to inputArray
		mov		eax, readOut
		mov		[edi], eax			; move numerical val to inputArray index
		add		edi, 4				; increment inputArray index
	loop	_readLoop



	; display the integers, their sum, and truncated average with WriteVal
	mov		esi, inputArray			; set inputArray as source address
	mov		ecx, 10					; set loop counter to 10 to go through all array elements

_writeLoop:
	; print inputArray one element at a time with WriteVal
		; pass element of inputArray to WriteVal through writeIn variable, converts to string, printed by mDisplayString
		mov		eax, [esi]
		mov		writeIn, eax
		call	WriteVal	writeIn, offset mDispInput
		; increment inputArray indexer
		add		esi, 4
		; pass next element of inputArray to WriteVal
	loop	_writeLoop


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
;	takes string, outputs integer
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
ReadVal PROC	inputStr, outputNum, prompt, bytes, count
	local	numChar:sdword

	; get user input from mGetString

	mGetString	prompt, inputStr, bytes, count


	; convert string to numbers
	mov		outputNum, 0		; clear output variable
	mov		ecx, [bytes]		; use number of bytes input as loop counter
	cld							; clear direction flag to have pointer increment
	mov		esi, inputStr		; move string to convert to esi
	lodsb						; store character in AL and increment esi
	cmp		al, 48				; check if char < 48
	jb		_notNum
	cmp		al, 57				; check if char > 57
	ja		_notNum
	sub		al, 48				; subtract character value to get numerical value
	movzx	eax, al				; store numeric value
	mov		numChar, eax
	mov		eax, [outputNum]	; move output value to eax for mult
	mov		ebx, 10
	imul	ebx
	add		eax, numChar		; add numerical value
	mov		outputNum, eax		; store final numerical value in outputNum


	; handle cases of + or - leading characters
	; validate no non-digits or +/- lead and not too large for 32-bit register
		; print error message if not valid
			; get new input
		; print error message if no input
			; get new input
_notNum:


_return:
	ret


ReadVal ENDP


; ---------------------------------------------------------------------------------
; Name: WriteVal
;
;	takes integer, outputs string
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
WriteVal PROC	numIn, strOut
	local	asciiVal:sdword, numNeg:sdword

	; works on one value at a time

	; convert SDWORD digits to ASCII
		; CHANGE THIS TO SET NUMNEG FLAG TO 1 OR 0 AND JUST USE ALL SAME CODE BLOCKS UNTIL END, CHECK FLAG AND DO NEG HANDLING IF 1
		; if SDWORD is negative
		cmp		numIn, 0
		jge		_posNum		; jump to positive integer handling
			; if SDWORD is greater than -10
			cmp		numIn, -10
			jle		_bigNeg		; jump to large negative handling

			; convert to positive, will add negative ASCII sign last
			mov		eax, -1
			mov		ebx, numIn
			mov		asciiVal, ebx
			imul	eax, asciiVal
			mov		asciiVal, eax

			; add SDWORD to 48 for ASCII value
			add		asciiVal, 48
			mov		eax, asciiVal
			mov		strOut, eax

			; pass strOut to mDisplayString to print
			mDisplayString	strOut

_bigNeg:
			; convert to positive, will add negative ASCII sign last
			mov		eax, -1
			mov		ebx, numIn
			mov		asciiVal, ebx
			imul	eax, asciiVal
			mov		asciiVal, eax
				; div SDWORD by 10, add remainder to 48 (ASCII 0) for last digit

					; append digit to output string
				; if result SDWORD >= 10, div by 10 again, add remainder to 48 for next digit
					; append digit to output string
				; repeat until result is < 10, result is first digit
					; append digit to output string
			; output string is in reverse order, so it must be reversed



		; if SDWORD is positive
_posNum:
			; if SDWORD is less than 10
			cmp		numIn, 10
			jg		_bigPos		; jump to large positive handling

				; add SDWORD to 48 for ASCII value
				mov		ebx, numIn
				mov		asciiVal, ebx
				add		asciiVal, 48
				mov		esi, offset asciiVal
				mov		edi, strOut
				std
				lodsb
				stosb

				; pass strOut to mDisplayString to print
				mDisplayString	strOut


			; if SDWORD is 10 or greater
_bigPos:

				; div SDWORD by 10, add remainder to 48 (ASCII 0) for last digit
				mov		eax, numIn
				cdq
				mov		ebx, 10
				idiv	ebx
				mov		asciiVal, edx		; move remainder to asciiVal
				add		asciiVal, 48		; add 48 to remainder for ASCII

					; append digit to output string
					std								; clear flag to work backwards from end of strOut
					mov		edi, strOut+11			; set destination as end of strOut
					mov		esi, offset asciiVal
					lodsb
					stosb
						; must use STOSB/LODSB and writechar for this
				; if result SDWORD >= 10, div by 10 again, add remainder to 48 for next digit
_divLoopPos:
				cmp		eax, 10
				jl		_finish		; if quotient is less than 10, do finish handling 
				cdq
				mov		ebx, 10
				idiv	ebx
				mov		asciiVal, edx
				add		asciiVal, 48
					; append digit to output string
				mov		esi, offset asciiVal
				std
				lodsb
				stosb
				; repeat until result is < 10, result is first digit
			jmp		_divLoopPos
					; append digit to output string
			; output string is in reverse order, so it must be reversed
_finishPos:
			; append quotient as final digit
			mov		asciiVal, eax
			add		asciiVal, 48
			mov		esi, offset asciiVal
			std
			lodsb
			stosb

	; pass ASCII string to mDisplayString to print

_return:
	ret


WriteVal ENDP


END main
