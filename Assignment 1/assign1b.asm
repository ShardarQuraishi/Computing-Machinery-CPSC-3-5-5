// CPSC 355 Assignment 1
// Name: Shardar Quraishi
//UCID: 30045559
// Version 2 - Macros
// Calculate the minimum of y = -5x^3 - 31x^2 + 4x + 31
// Between the values of -6 to 5
//======================================================/|/
///====================================================/|/
//define the m4 macros
define(int_5, x19)       //set x19 to integer 5
define(int_x, x20)	 // value of x
define(int_31, x21)      //set x21 to integer 31
define(int_4, x22)       //set x22 to integer 4
define(s_r, x23)	 //=x^2
define(c_r, x24)	 //=x^2*x = x^3
define(y_r, x25) 	 //set x25 to the value of Y
define(d_r, x26) 	 //4x
define(int_m, x27)	 //maximum value of Y
define(fp, x29)          //x29 : Frame pointer
define(lr, x30)          //x30: Link register



fmt:    .string "X value = %ld  Y value = %ld Curent  Max = %ld\n"     //format output
        .balign 4                               //ensures alignment of instructions
        .global main                            //make "main" visible to the OS
main:   stp fp, lr, [sp, -16]!                  //allocate stack space
        mov fp, sp                              //update frame pointer

        mov int_5, -5                           //set x19 to -5
        mov int_x, -6                           //value of X
        mov int_31, 31                          //set x21 to 31
        mov int_4, 4                            //set x22 to 4
	mov int_m, -9999                        //setting the maximum to -9999

loop:                                           //Start of Loop
        cmp int_x, 5                            //comparing X with 5
        b.gt done                               //if x20 is greater than 5,then done
        mul s_r, int_x, int_x                   //x^2
        mul c_r, s_r, int_x                     //x^3

        mul y_r, int_5, c_r                     //-5x^3

        mneg d_r, int_31, s_r                   //-31x^2
        add y_r, y_r, d_r                       //-5x^3-31x^2

        madd d_r, int_4, int_x, int_31          //4x + 31

        add y_r, y_r, d_r                       //y= -5x^3-31x^2+4x+31


	cmp y_r, int_m                          //comparing value of Y with Max
	b.lt next                               //if x25 is less than x27, goto next

	mov int_m, y_r                          //else set x27 as x25, new Max
next:
	adrp x0, fmt                           //set 1st arg of printf() higher
	add x0, x0, :lo12:fmt                  //set 1st arg of printf() lower
	mov x1, int_x                          //setting arg for X of the prinf
	mov x2, y_r                            //setting arg for Y of the printf
	mov x3, int_m                          //setting arg for Max Y of the printf
	bl printf                              //print statement

        add int_x, int_x, 1                    //increment X by 1
        b loop                                 //End of Loop
done:
        ldp fp, lr, [sp], 16                   //restore FP and Lr from the stack, post-increment sp
        ret                                    //return to caller
