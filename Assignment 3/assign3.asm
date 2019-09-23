////////////////////////////////////////////////////////////CPSC 355 Assignment 3\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
/////////////////////////////////////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//////////////////////////////////////////////////////Name: Shardar Mohammed Quraishi\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////////////////////////////////////////////UCID: 30045559\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////////////////////////////////////////Date: 26/10/2018\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////////////////////////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////////////////////////////////////////////////  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

define(i, w19)                                  // setting i to w19
define(j, w22)                                  // setting j to w22
define(temp, w25)                               // setting temp to w25

size = 50                                       //setting value of constant size to 50
v_size = size * 4                               // Base address of the array
i_size = 4                                      //size of integer i, 4 bytes
j_size = 4                                      //size of integer j, 4 bytes
temp_s = 4					//size of temp, 4 bytes
var_size = v_size + i_size + j_size
alloc = -(16 + var_size) & -16                  //set the preincrement value alloc
dealloc = -alloc                               // set the post increment value

fp  .req x29                                    //define fp as x29
lr  .req x30                                    //define lr as x30
fmt: .string "v[%d]: %d\n"                    //print label, for printing each line in the array
lmt: .string "\nSorted array: \n"            //print label to print out "Sorted array: "
    .balign 4                                   // Align instructions 4 byte
    .global main                                // Make "main" visible to OS
main:
    stp     fp, lr, [sp, alloc]!              //save fp and lr to stack, allocating by alloc, pre-increment sp
    mov     fp, sp                             //update fp to current sp
    add     x28, fp, v_size                  // Calculate v_size address

    mov     i, 0                                //set i to 0
    str     i, [fp, i_size]                     // Write i to stack
    mov     j, 0				//set j to 0
    str     j, [fp, j_size]			//write j to stack
    b       test1                               //branch to test1

loop1:                                          // Generate random arrays
    bl      rand                                // Generate the random number from the random number generator

    and     w20, w0, 0xFF                    	// Rand() & 0xFF
   //add     x21, fp, v_size
    ldr     i, [fp, i_size]		   	//get current value of i
    str     w20, [x28, i, SXTW 2]          	// Write random to array
    ldr     i, [fp, i_size]			//get current value of i

    adrp    x0, fmt                          //set 1st arg of printF() higher
    add     w0, w0, :lo12:fmt                //set 1st arg of printf() lower
    mov     w1, i                            //set arg for i value
    mov     w2, w20                          //set arg for v[i]
    bl      printf                           //print function

    add     i, i, 1                             //increment i by 1
    str     i, [fp, i_size]                     //store new i in memeory

test1:
    cmp     i, size                             //comparing i and size
    b.lt    loop1                               //if i is less than 50, branch to loop1

    b       test2				//branch to test2

loop2:                                          //sorting the array
    ldr     	w23, [x28, j, SXTW 2]           //load register w23 from array
    sub     	w24, j, 1                       //minimum value of j, j-1
    ldr     	w20, [x28, w24, SXTW 2]      //loading random from array
    cmp     	w20, w23                      //comparing random with w23
    b.le    	increment_J			//if w20<w23 branch to increment_J

    add     	sp, sp, -4 & -16
    mov     	temp, w20                     //moving random to temp
    str     	temp, [x29, temp_s]              //storing temp to stack
    mov     	w20, w23                      //moving w23 to w20(random number)
    str     	w20, [x28, w24, SXTW 2]      //storing w20(random number) on array
    mov     	w23, temp                       //moving temp to w23
    str     	w23, [x28, j, SXTW 2]           //storing w23 on array
    add     	sp, sp, 16                      //incrementing sp by 16

increment_J:
    add     	j, j, 1                         //incrementing j

loop2_test:
    cmp     	j, i         			//comparing j with i
    b.le    	loop2                  		//branching to loop2 if less than
    sub     	i, i, 1                         //decrementing i

test2:
    mov    	j, 1                   		 //moving 1 in j
    str     	j, [fp, j_size]              	 //storing j to stack

    cmp     	i, 0                            //compare i with 0
    b.ge    	loop2_test      		//if i>0 branch to loop2_test
    mov     	i, 0                            //setting i to 0
    str     	i, [fp, i_size]               //storing i to stack

    adrp    	x0, lmt               		//print label for "sorted" title
    add     	w0, w0, :lo12:lmt
    mov     	w1, 0
    bl      	printf
    b       	loop3_test                      // Branch to loop3_test

loop3:                               		//printing the sorted array
    ldr     	w26, [x28, i, SXTW 2]
    adrp    	x0, fmt
    add     	w0, w0, :lo12:fmt
    mov     	w1, i                    	 //moving i to w1
    mov     	w2, w26                		 //moving w26 to w2
    bl      	printf
    add     	i, i, 1
loop3_test:
    cmp    	i, size
    b.lt    	loop3				//if i<size, branch to loop3

exit:
    mov     	w0, 0 				//restoring state
    ldp     	fp, lr, [sp], dealloc           //deallocate stack memory
    ret                                         //return call in OS
