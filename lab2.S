
	.data
	.type	v, %object
	.type	n, %object
	.size	v, 8
	.size	n, 1

n:
	.xword 8

v:
	.xword 79, 55, 94, 48, 19, 13, 45, 21

	.text
	.global main
	.arch armv8-a+fp+simd
	.type main, %function

main:
			ADRP	X0, v				//get the address of array a
			ADD		X0, X0, :lo12:v
			ADRP	X4, n				//get address of n
			ADD		X4, X4,	:lo12:n
			LDUR	X4, [X4, #0]		//load n(7) into X4
			SUB		X3, X3, X3			//initialize i to 0
			SUB		X11, X11, X11		//initialize j to 0
			SUB		X8, X8, X8			//initialize sum to 0
			SUB		X9, X9, X9			//initialize large to 0
			SUB		X10, X10, X10		//initialize small to 0
			SUB		X13, X13, X13		//initialize index to 0
			ADD		X10, X10, #100		//set small to a value larger than array

	wloop:	SUB		X11, X11, X11
			ADD		X11, X11, X3		//set j = i
	lloop:	LDUR	X5, [X0, #0]		//load a[j] into X2
			ADD		X8, X8, X5			//sum = sum +a[j]
			SUBS	X6, X5, X9			// if a[j] > large
			B.LE	Elsea

	Thena:	SUB		X9, X9, X9			//set large to 0
			ADD		X9, X9, X5			//set large to a[j]
			SUB		X13, X13, X13
			ADD		X13, X13, X11		//set index = j

	Elsea:	ADD		X11, X11, #1
			ADD		X0, X0, #8
			SUBS	X6, X4, X11
			B.LE	lloop

	Swapa:	SUB		X12, X12, X12
			ADD		X12, X12, X2
			SUB		X2, X2, X2
			ADD		X2,	X5, X2
			SUB		X5, X5, X5
			ADD		X5, X12, X5

			SUB		X11, X11, X11
			ADD		X11, X11, X3		//set j = i
	sloop:	LDUR	X5, [X0, #0]		//load a[j] into X9
			ADD		X8, X8, X5			//sum = sum +a[j]
			SUBS	X6, X5, X9			// if a[j] > large
			B.LE	Elseb

	Thenb:	SUB		X10, X10, X10			//set large to 0
			ADD		X10, X10, X8			//set large to a[j]
			SUB		X13, X13, X13
			ADD		X13, X13, X11			//set index = j

	Elseb:	ADD		X11, X11, #1
			ADD		X0, X0, #8
			SUB		X6, X4, X11
			B.LE	sloop

	Swapb:	SUB		X12, X12, X12
			ADD		X12, X12, X2
			SUB		X2, X2, X2
			ADD		X2,	X5, X2
			SUB		X5, X5, X5
			ADD		X5, X12, X5

			ADD		X3, X3, #1
			SUB		X4, X4, #1

			SUB		X5, X4, X11
			CBNZ	X5, wloop

	Exit:
