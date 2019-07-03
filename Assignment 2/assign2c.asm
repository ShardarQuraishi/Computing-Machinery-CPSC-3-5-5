////////////////////////////////////////////////////////////CPSC 355 Assignment 2\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
/////////////////////////////////////////////////////////////////version C\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//////////////////////////////////////////////////////Name: Shardar Mohammed Quraishi\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////////////////////////////////////////////UCID: 30045559\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////////////////////////////////////////Date: 11/10/2018\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////////////////////////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////////////////////////////////////////////////  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


fmt:	.string "multiplier = 0x%08x (%d) multiplicand = 0x%08x (%d)\n\n"//setting up first label for printing the multiplier and multiplicand hex and decimal values
	.balign 4							 //ensures alignment of instructions by 4 bits
prt:	.string "product = 0x%08x multiplier = 0x%08x\n"		 //setting up second label for printing the product and multiplier hex values
	.balign 4							 //ensures alignment of instructions by 4 bits
lrt:	.string "64-bit result = 0x%016lx (%ld)\n"			 //setting up third label for printing 64-bit result
	.balign 4							 //ensures alignment of instructions by 4 bit
	.global main							 //making "main" visible to the OS
	.global loop                                                     //making "loop" viaible to the OS

define(fp, x29)						//x29: frame pointer
define(lr, x30)						//x30: Link register
main:	stp fp, lr, [sp, -16]! 			//allocate stack space
	mov fp, sp					//update frame pointer

	define(multiplicand, w19)			//set w19 to "multiplicand" (32-bit register)
	define(multiplier, w20)				//set w20 to "multiplier" (32-bit register)
	define(product, w21)				//set w21 to "product" (32-bit register)
	define(negative, w22)				//set w22 to "negative"(32-bit register)
	define(i, w23)					//set w23 to "i"(32-bit register)
	define(temp1, x19)				//set x19 to "temp1"(64-bit register)
	define(temp2, x20)				//set x20 to "temp2"(64-bit register)
	define(result, x21)				//set x21 to "result"(64-bit register)

	mov multiplicand, -252645136 	//set multiplicand(w19) to -252645136
	mov multiplier, -256			//set multiplier(w20) to -256
	mov product, 0					//set product(w21) to 0

							//print first label(fmt)
	adrp x0, fmt					//set 1st arg of printf() higher
	add x0, x0, :lo12:fmt				//set 1st arg of printf() lower
	mov w1, multiplier				//set arg for hex value of "multiplier" of the printf
	mov w2, multiplier				//set arg for dec value of "multiplier" of the printf
	mov w3, multiplicand				//set arg for hex value of "multiplicand" of the printf
	mov w4, multiplicand				//set arg for dec value of "multiplicand" of the printf
	bl printf					//print statement

	cmp multiplier, 0				//comparing if multiplier is negative
	b.ge positive_ext				//if multiplier is greater or equals zero (POSITIVE) branch to else
	mov negative, 1					//if negative, set 1 to negative
	b i_init					//goto i_init
positive_ext:
	mov negative, 0					//if NOT negative, set 0 to negative

i_init:							//initializing "i"
	mov i, 0					//set 0 to i
	b loop_test					//goto loop_test

loop:
//tst performs a bitwise AND operation on the multiplier and 0x1. The N and Z files are updated according to the result
	tst multiplier, 0x1
	b.eq if_st					//if equals goto if_st
	add product, product, multiplicand		//carry out the operation: product = product + multiplicand

if_st:
	asr multiplier, multiplier, 1			//arithmetic shift right
	tst product, 0x1				//performs a bitwise AND operation on the product and 0x1
	b.eq else_st					//if equals branch to else_st
	orr multiplier, multiplier, 0x80000000		//OR operation executed, result stored in multiplier
	b next						//branch to next

else_st:
	and multiplier, multiplier, 0x7FFFFFFF		//AND operation executed, result stored in multiplier

next:
	asr product, product, 1				//arithmetic shift right
	add i, i, 1  					//increment i by 1


loop_test:						//test for checking the loop conditions
	cmp i, 32					//comparing i to 32
  	b.lt loop					//if i less than 32, goes back to loop
							//END of loop
	cmp negative, 0					//comparing negative with 0
	b.eq print_ext					//if equals, branch to print_ext
	sub product, product, multiplicand		//execute operation:: product = product - multiplicand

print_ext:						//print second label(prt)
	adrp x0, prt					//set 1st arg of printf() higher
	add x0, x0, :lo12:prt				//set 1st arg of printf() lower
	mov w1, product					//set arg for hex value of "product" of the printf
	mov w2, multiplier				//set arg for hex value of "multiplier" of the printf
	bl printf					//print statement

	sxtw temp1, product				//move value of product to temp1
	and  temp1, temp1, 0xFFFFFFFF			//AND operation executed, result stored in temp1 register
	lsl temp1, temp1, 32				//shift values of temp1 to left by 32 bits

	sxtw temp2, multiplier				//move multiplier to temp2
	and temp2, temp2, 0xFFFFFFFF			//AND operation executed, result stored in temp2 register

	add result, temp1, temp2			//
							//print third label(lrt)
	adrp x0, lrt					//set 1st arg of printf() higher
	add x0, x0, :lo12:lrt				//set 1st arg of printf() lower
	mov x1, result					//set arg for hex value of result of the printf
	mov x2, result					//set arg for dec value of result of the printf
	bl printf					//print statement

done:
	ldp x29, x30, [sp], 16				//restore FP and Lr from the stack, post-increment sp
	ret						//return to caller
