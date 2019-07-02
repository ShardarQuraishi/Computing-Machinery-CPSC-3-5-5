// CPSC 355 Assignment 1
// Name: Shardar Quraishi
//UCID: 30045559
// Version 1
// Calculate the minimum of y = -5x^3 - 31x^2 + 4x + 31
// Between the values of -6 to 5
/////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
/////////////////////||||||||||||||||||||||||||||||||||\\\\\\\\\\\\\\\\\\

fmt:	.string "X = %ld Y = %ld Max = %ld\n"  //format output
	.balign 4                           //ensures alignment of instructions
	.global main                        //make "main" visible to the OS

main:	stp x29, x30, [sp, -16]!           //allocate stack space
	mov x29, sp                        //update fp

	mov x19, -5                        //set x19 to -5
	mov x20, -6                        //set x20 to -6, initial value of x
	mov x21, 31                        //set x21 to 31
	mov x22, 4                         //set x22 to 4

first:                                    //calculate value for x = -6
	mul x23, x20, x20                 //=x^2
	mul x23, x23, x20                 //=x^2*x = x^3

	mul x24, x20, x20                 //x^2

	mul x25, x19, x23                 //-5x^3

	mneg x26, x21, x24                //-31x^2
	add x25, x25, x26                 //-5x^3-31x^2

	mul x26, x22, x20                 //4x

	add x25, x25, x26                 //-5x^3-31x^2+4x
	add x25, x25, x21                 //y= -5x^3-31x^2+4x+31
	mov x27, x25                      //setting initial value as primary max

loop:                                     //Start of loop

	cmp x20, 5                        //comparing value of x with 5
	b.gt done			              //if x20 is greater than 5, then goto done
	mul x23, x20, x20                 //x^2
    mul x23, x23, x20                 //x^3

    mul x24, x20, x20                 //x^2

    mul x25, x19, x23                 //-5x^3

    mul x26, x21, x24                 //31x^2
    sub x25, x25, x26                 //-5x^3-31x^2

    mul x26, x22, x20                 //4x

    add x25, x25, x26                 //-5x^3-31x^2+4x
    add x25, x25, x21                 //y=-5x^3-31x^2+4x+31

	cmp x25, x27                      //comparing current value of Y with the previous max
	b.lt next                         //if x25 is less than x27, goto next

	mov x27, x25                      //else set x27 as x25, new max value
next:

	adrp x0, fmt                     //set the 1st argument of printf() higher
    add x0, x0, :lo12:fmt            //set the 1st argument of printf() lower
    mov x1, x20                      //setting arguments of the printf
    mov x2, x25                      //setting arguments of the printf
	mov x3, x27			             //setting arguments of the printf
    bl printf			             //print statement

	add x20, x20, 1                  //increment X by 1
	b loop                           //End of loop



done:
	ldp x29, x30, [sp], 16          //restore FP and Lr from the stack, post-increment sp
	ret                             //return to caller
