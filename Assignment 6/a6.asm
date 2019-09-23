////////////////////////////////////////////////////////////CPSC 355 Assignment 6\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////////////////////////////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//////////////////////////////////////////////////////Name: Shardar Mohammed Quraishi\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////////////////////////////////////////////UCID: 30045559\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////////////////////////////////////////Date: 06/12/2018\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////////////////////////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////////////////////////////////////////////////  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

.data						//begin data section

constant: .double 0r1.0e-10			//float constant 1.0e-10
three: .double 0r3.0				//float constant 3.0

.text						//begin text section

buf_size = 8					//create buffer for reading 8 byte inputs
alloc = -(16 + buf_size) & -16			//memory allocation
dealloc = -alloc				//deallocation memory
buf_s = 16					//location of buffer in memory


define(argc_r, w20)				//argc_r:number of argument input in the command line
define(argv, x21)				//setting argv to x21
define(fd, w22)					//setting fle descriptor registor to w22
define(buffer, x23)				//base register of buffer
define(read, w24)


usage: .string "usage: a6 FILENAME\n"		//label for printing input error

file_error:
	.string "Error: FILENAME not found\n"	//label for printing file not found error

input_n:
	.string "Input Number: %0.10f \t"	//label for printing out the input

crt:	.string "Cube-root: %0.10f \n"		//label for printing out the result

	.balign 4				//align instruction by 4 bits
	.global main				//making main visible to the OS

main:	stp x29, x30, [sp, alloc]!		//memory allocation
	mov x29, sp				//updating sp

	adrp x26, three				//get address pointer for "three"
	add x26, x26, :lo12: three
	ldr d27, [x26]				//load float value 3.0 into d27

	mov argc_r, w0				//moving w0 to argc_r
	mov argv, x1				//moving x1 to argv

	cmp argc_r, 2				//compare number of arguments
	b.eq input_f				//if equals, branch to input_f

	adrp x0, usage				//if not equal, print usage error
	add x0, x0, :lo12:usage
	bl printf				//call print function
	b done					//branch to done

input_f:
	mov w0, -100				//reading input from file
	ldr x1, [argv, 8]			//place input string into x1
	mov w2, 0				//3rd argument read only
	mov w3, 0				//4th argument not used
	mov x8, 56				//openat I/O request
	svc 0					//call system function
	mov fd, w0				//move result into file descriptor

	cmp fd, wzr				//compare fd and 0
	b.ge next				//if fd > 0 branch to next

	adrp x0,file_error			//orelse print file name not found
	add x0, x0, :lo12:file_error
	bl printf				//call print function
	b done					//branch to done

next:
	add buffer, x29, buf_s			//setting base address for buffer

loop:

	mov w0, fd				//first argument --> file descriptor
	mov x1, buffer				//second argument--> buffer
	mov w2, buf_size			//third argument --> size of buffer
	mov x8, 63				//read I/O request
	svc 0					//call system function

	mov read, w0				//address of bytes read
	cmp read, buf_size			//error checking for read
	b.ne close_f				//if read is not equal to buf_size, branch to close_f
	ldr d19, [buffer]  			//loading input number into d19

	adrp x0, input_n			//print the input number
	add x0, x0, :lo12:input_n
	fmov d0, d19
	bl printf				//call the print function

	fdiv d20, d19, d27			//x = input/3
	bl execute				//call function execute

	adrp x0, crt				//print the result, cube root
	add x0, x0, :lo12:crt
	fmov d0, d28
	bl printf				//call the print function
	b loop					//branch to loop

execute:
	fmul d21, d20, d20
	fmul d21, d21, d20			//y = x*x*x

	fsub d22, d21, d19			//dy = y - input

	fmul d23, d20, d20
	fmul d23, d23, d27			//dy/dx = 3 * x * x

	fdiv d24, d22, d23			//dy/(dy/dx)

	fsub d20, d20, d24			//x = x - {dy/(dy/dx)}

test:
	fabs d25, d22				//|dy|
	adrp x25, constant			//get address pointer for constant
	add x25, x25, :lo12:constant
	ldr d26, [x25]				//load value of constant in d26

	fmul d26, d19, d26			//input * constant
	fcmp d25, d26				//compare |dy| and input*constant
	b.gt execute				//if greater then, branch to execute

	fmov d28, d20				//or move d20 to d28
	ret					//return

close_f:						//closing file
	mov w0, fd
	mov x8, 57
	svc 0					//call system function

done:
	ldp x29, x30, [sp], dealloc		//deallocate memory
	ret
