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
; Displays a prompt for user to enter an integer. Then reads the string and stores it
; in inputStr.
;
; Preconditions: None
;
; Receives:
; inPrompt = message for prompting input
; inputStr = buffer for input string and output
; bytesLen = counter for number of bytes entered
; count = max length of string for readstring procedure
;
; Returns: 
; bytesLen = counter for number of bytes entered
; inputStr = user entered string
; ---------------------------------------------------------------------------------
mGetString MACRO	inPrompt, inputStr, bytesLen, count

	push	edx
	push	ecx

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

	pop		ecx
	pop		edx


ENDM


; ---------------------------------------------------------------------------------
; Name: mDisplayString
;
; Prints the input string, followed by a space.
;
; Preconditions: None
;
; Receives:
; inputStr = string to be written
;
; returns: None
; ---------------------------------------------------------------------------------
mDisplayString MACRO	inputStr

	push	edx
	push	eax

	; print the string, followed by a space
	mov		edx, inputStr
	call	writestring
	mov		al, ' '
	call	writechar

	pop		eax
	pop		edx

ENDM


.data


inputPrompt		byte		"Please enter an integer.",0								; prompt for mGetString input
errorInvalid	byte		"Your input is not valid.",0								; error message for invalid input
sumTitle		byte		"Sum: ",0													; title text for sum of array
avgTitle		byte		"Average: ",0												; title text for average of array
arrayTitle		byte		"Numbers entered: ",0										; title text for array of numbers entered

mGetInput		byte		12	dup(0)													; input storage for mGetString
mGetCount		sdword		12															; max input string length for mGetString
mGetBytes		sdword		?															; number of input bytes read by mGetString

mDispInput		byte		12	dup(?)													; input storage for mDisplayString

readOut			sdword		?															; output storage for ReadVal
writeIn			sdword		?															; input storage for WriteVal

inputArray		sdword		10	dup(?)													; array for main proc to store mGetString input into
inputSum		sdword		0															; variable for sum of input numbers
inputAvg		sdword		?															; variable for the average of input numbers
avgDivRem		sdword		?															; holder for remainder during average calculation


.code
; ---------------------------------------------------------------------------------
; Name: main
;
; Gets 10 valid integers from user input by calling ReadVal. Stores these values in an array.
; Then displays the integers, their sum, and the truncated average of them with WriteVal.
;
; Preconditions: None
;
; Postconditions: None
;
; Receives: registers used: ecx, edi, eax, esi, edx, ebx
; inputArray = array for storing user input integers
; errorInvalid = error message for invalid entries
; mGetCount = max input string length for mGetString
; mGetBytes = counter for number of bytes entered with mGetString macro
; inputPrompt = prompt message for user input for mGetString macro
; readOut = output of ReadVal proc
; mGetInput = input/output for mGetString macro
; arrayTitle = title for displaying array numbers with WriteVal proc
; writeIn = input integer for WriteVal conversion to string
; mDispInput = input string for mDisplayString macro
; sumTitle = title for displaying sum of values with WriteVal
; inputSum = input for WriteVal to display sum
; avgTitle = title for displaying average of inputs with WriteVal
; inputAvg = input for WriteVal to display average
;
; Returns: None
; ---------------------------------------------------------------------------------
main PROC
	; setup for ReadVal to get 10 values from user
	mov		ecx, 10							; loop 10 times for 10 inputs
	mov		edi, offset inputArray			; set inputArray as destination address

_readLoop:
		; call ReadVal 10 times to store values in the array
		push	offset errorInvalid
		push	mGetCount
		push	offset mGetBytes
		push	offset inputPrompt
		push	offset readOut
		push	offset mGetInput
		call	ReadVal

		; append readOut val to inputArray
		mov		eax, [readOut]
		mov		[edi], eax			; move numerical val to inputArray index
		add		edi, 4				; increment inputArray index
	loop	_readLoop

	; Setup to display the integers with WriteVal
	mov		esi, offset inputArray			; set inputArray as source address
	mov		ecx, 10							; set loop counter to 10 to go through all array elements
	mov		edx, offset arrayTitle
	call	writestring

_writeLoop:
	; print inputArray one element at a time with WriteVal
		; pass element of inputArray to WriteVal through writeIn variable, converts to string, printed by mDisplayString
		mov		eax, [esi]
		mov		writeIn, eax
		push	offset mDispInput
		push	writeIn
		call	WriteVal
		add		esi, 4		; increment inputArray indexer
		; pass next element of inputArray to WriteVal
	loop	_writeLoop

	call	crlf

	; show sum setup and title display
	mov		esi, offset inputArray
	mov		ecx, 10
	mov		edx, offset sumTitle
	call	writestring

_sumLoop:
		mov		eax, [esi]
		add		inputSum, eax		; add inputArray element val to inputSum
		add		esi, 4				; increment inputArray indexer
	loop _sumLoop					; add next element val to inputSum

	; call WriteVal on inputSum to convert and print with mDisplayString
	push	offset mDispInput
	push	inputSum
	call	WriteVal
	call	crlf

	; display average title
	mov		edx, offset avgTitle
	call	writestring

	; calculate average of the 10 values
	mov		eax, inputSum
	mov		ebx, 10
	cdq
	idiv	ebx
	mov		inputAvg, eax
	
	; call WriteVal on inputAvg to convert and print with mDisplayString
	push	offset mDispInput
	push	inputAvg
	call	WriteVal

	call	crlf

	Invoke ExitProcess,0	
main ENDP


; ---------------------------------------------------------------------------------
; Name: ReadVal
;
; Takes a string of number/s as input and converts it to an integer value. Gets input with
; mGetString macro. Validates that the input has no other characters than a leading
; + or - and that the number does not exceed SDWORD size. Stores converted number in 
; outputNum for later storing into the array.
;
; Preconditions: errorInvalid, mGetBytes, inputPrompt, readOut, and mGetInput
; must be passed by reference. mGetCount must be passed by value.
;
; Postconditions: Local variables numChar and outputHolder are not reset at the end.
;
; Receives: registers used(all preserved): ecx, esi, eax, ebx, edi, edx
; errorInvalid = by reference, error message for invalid input
; mGetCount = by value, count input for mGetString macro
; mGetBytes = input/output for byte count of input string for mGetString macro
; inputPrompt = prompt message for getting input with mGetString
; readOut = output for integer value once converted from string
; mGetInput = input/output string for mGetString macro
;
; Returns: 
; mGetInput = input/output string for mGetString macro
; readOut = value set to integer value of the converted string
; ---------------------------------------------------------------------------------
ReadVal PROC	inputStr, outputNum, prompt, bytes, count, errorMsg
	local	numChar:dword, outputHolder:sdword, negFlagRead:dword

	pushad

_getInput:
	mGetString	prompt, inputStr, bytes, count

	mov		[outputHolder], 0		; clear output variable
	mov		ecx, [bytes]			; use number of bytes input as loop counter
	cld								; clear direction flag to have pointer increment
	mov		esi, inputStr			; move string-to-convert address to esi

_readLoop:
		lodsb						; store character in AL and increment esi
		cmp		al, 48				; check if char < 48
		jb		_notNum
		cmp		al, 57				; check if char > 57
		ja		_notNum
		sub		al, 48				; subtract character value to get numeric value
		movzx	eax, al				; store numeric value
		mov		numChar, eax
		mov		eax, [outputHolder]	; move output value to eax for mult
		mov		ebx, 10
		imul	ebx
		jo		_invalid
		add		eax, numChar		; add numerical value
		jo		_invalid
		mov		outputHolder, eax	; store final numerical value in holder for next processing
		mov		edi, outputNum
		mov		[edi], eax			; store final integer in readOut
	loop _readLoop

	cmp		negFlagRead, 0
	je		_return					; check if negative value, go to return statement if positive

	; multiply by -1 if negative flag was set
	mov		ebx, -1
	mov		esi, outputNum
	mov		eax, [esi]
	imul	ebx
	mov		edi, outputNum
	mov		[edi], eax
	jmp		_return

_notNum:
	; if non-number character is first character, check if it is +/- indicator, otherwise it's invalid
	cmp		ecx, [bytes]
	jl		_invalid
	cmp		al, 45
	je		_negative
	cmp		al, 43
	je		_positive

_negative:
	; if negative, set flag and proceed to next character
	mov		negFlagRead, 1
	dec		ecx
	jmp		_readLoop

_positive:
	; if positive, clear flag and proceed to next character
	mov		negFlagRead, 0
	dec		ecx
	jmp		_readLoop

_invalid:
	; if invalid, display error message and get input again
	mov		edx, errorMsg
	call	writestring
	call	crlf
	jmp		_getInput

_return:
	mov		negFlagRead, 0

	popad

	ret


ReadVal ENDP


; ---------------------------------------------------------------------------------
; Name: WriteVal
;
; Takes a numeric SDWORD value and converts it to a string of character numbers. 
; Displays the string with mDisplayString macro.
;
; Preconditions: mDispInput must be passed by reference. writeIn must be passed
; by value. 
; 
; Postconditions: Local variable asciiVal is not reset at the end.
;
; Receives: registers used(all preserved): ebx, edi, eax, esi, edx
; mDispInput = input/output for mDisplayString
; writeIn = input numeric value to be converted to ASCII
;
; Returns: mDispInput is altered to store the ASCII converted integer for printing.
; ---------------------------------------------------------------------------------
WriteVal PROC	numIn, strOut
	local	asciiVal:sdword, negFlag:sdword

	pushad

	; setup for processing, working backwards through string
	mov		ebx, numIn
	mov		asciiVal, ebx		; asciiVal will hold value of each string character to be written to the string
	mov		edi, strOut
	add		edi, 11
	std
	mov		eax, 0
	mov		[edi], eax			; add null terminating 0 to end of string
	dec		edi

	; check if input is negative or zero
	cmp		asciiVal, 0
	jg		_posNum				; jump to positive integer handling if positive
	je		_zeroVal			; jump to handling for value of zero input if zero

	; since negative, convert to positive and set negFlag, will add negative ASCII sign last
	mov		negFlag, 1
	mov		eax, -1
	imul	eax, asciiVal
	mov		asciiVal, eax

_posNum:
	cmp		asciiVal, 10
	jge		_bigNum				; jump to large number handling if input is >= 10

	; add input to 48 for ASCII value
	mov		eax, asciiVal
	jmp		_finish
	add		asciiVal, 48
	lea		esi, asciiVal
	lodsb
	stosb

	jmp		_return				; pass strOut to mDisplayString to print since it is a single digit number

_bigNum:
	; if input is 10 or greater, div input by 10, add remainder to 48 (ASCII 0) for last digit
	mov		eax, asciiVal
	cdq
	mov		ebx, 10
	idiv	ebx
	mov		asciiVal, edx		; move remainder to asciiVal
	add		asciiVal, 48		; add 48 to remainder for ASCII value

	; append digit to output string
	lea		esi, asciiVal
	mov		ebx, eax			;store quotient to restore after loading string byte
	lodsb
	stosb
	mov		eax, ebx

_divLoop:
		; divide quotient by 10 until it is < 10, adding remainders to the string
		cmp		eax, 10			; if quotient of div is >= 10, div by 10 until <10, add remainder to 48 for next digit
		jl		_finish			; if quotient is less than 10, do finish handling 
		cdq
		mov		ebx, 10
		idiv	ebx
		mov		asciiVal, edx
		add		asciiVal, 48

		; append digit to output string
		lea		esi, asciiVal
		mov		ebx, eax
		lodsb
		stosb
		mov		eax, ebx

	jmp		_divLoop			; repeat until quotient is < 10, result is first digit

_finish:
	; append quotient as final digit
	mov		asciiVal, eax
	add		asciiVal, 48
	lea		esi, asciiVal
	lodsb
	stosb
	cmp		negFlag, 1			; check if negative for negative finishing
	je		_finishNeg
	jmp		_return

_finishNeg:
	; append negative sign if negative flag variable is set
	mov		asciiVal, 45
	lea		esi, asciiVal
	lodsb
	stosb
	jmp		_return

_zeroVal:
	mov		asciiVal, 48
	lea		esi, asciiVal
	lodsb
	stosb

_return:
	inc		edi					; inc edi to get to beginning of string since stosb dec'd
	mov		negFlag, 0		
	mov		strOut, edi			; use beginning of string as strOut address to pass to macro
	
	mDisplayString	strOut		; pass ASCII string to mDisplayString to print

	popad

	ret


WriteVal ENDP


END main
