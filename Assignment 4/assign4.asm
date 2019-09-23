////////////////////////////////////////////////////////////CPSC 355 Assignment 4\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
/////////////////////////////////////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//////////////////////////////////////////////////////Name: Shardar Mohammed Quraishi\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////////////////////////////////////////////UCID: 30045559\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////////////////////////////////////////Date: 08/11/2018\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////////////////////////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////////////////////////////////////////////////  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

						//equates for point()
point_x = 0					//offset of point_x
point_y = 4					//offset of point_y
point_size = 8					//point size, 2 ints = 4 + 4 =8bytes

dimension_width = 0				//offset for dimension_width
dimension_height = 4				//offset for dimension_height
dimension_size = 8				//dimension size, 2 ints = 8 bytes

box_origin = 0					//offset for struct point, box_origin
box_size = box_origin + point_size		//offset for box_size
box_area = box_size + dimension_size		//offset for box_area
b_size = 20					//memory allocation for the box


alloc = -(16 + 2*box_size) & -16		//total memory allocation
dealloc = -alloc				//deallocation of memory
first_box = 16					//offset for first box
second_box = first_box + b_size			//offset of second box
TRUE = 1					//setting value of constant TRUE to 1
FALSE = 0					//setting value of constant FALSE to 0

//print label, for the printBox function
fmt:	.string "Box %s origin = (%d, %d) width = %d height = %d area = %d\n"

//print label, for string "Initial box values"
lmt:	.string "Initial box values:\n"

//print label, for string "first"
prt:	.string "first"

//print label, for string "second"
qrt:	.string "second"

//print label, for string "Changed box values"
nmt:	.string "Changed box values:\n"
	.Balign 4				//instruction aligned 4 bytes


newBox:	stp x29, x30, [sp, -16]!		//save x29 and x30 to stack, allocating by -16, pre-increment sp

	mov x29, sp				//update x29 to current sp


	mov w9, 0				//set w9 to 0
	str w9, [x8, box_origin + point_x]	//b.origin.x = 0

	mov w9, 0				//set w9 to 0
	str w9, [x8, box_origin + point_y]	//b.origin.y = 0

	mov w9, 1					//set w9 to 1
	str w9, [x8, box_size + dimension_width]	//b.size.width = 1

	mov w9, 1					//set w9 to 1
	str w9, [x8, box_size + dimension_height]	//b.size.height = 1

	mov w9, 1				//set w9 to 1
	str w9, [x8, box_area]			//b.size.area = 1

	mov w0, 0				//return w0 to 0

	ldp x29, x30, [sp], 16			//deallocate memory
	ret

move:	stp x29, x30, [sp, -16]!		//save x29 and x30 to stack, allocating by -16, pre-increment sp

	mov x29, sp				//update x29 to current sp

	ldr w9, [x0, box_origin + point_x]	//load b.origin.x in w9
	add w9, w9, w1				//add w9 = w9 + deltaX
	str w9, [x0, box_origin + point_x]	//store new value b.origin.x

	ldr w9, [x0, box_origin + point_y]	//load b.origin.y in w9
	add w9, w9, w2				//add w9 = w9 + deltaY
	str w9, [x0, box_origin + point_y]	//store new value b.origin.y


	mov x0, 0				//set x0 to 0
	mov w1, 0				//set w1 to 0
	mov w2, 0				//set w2 to 0

	ldp x29, x30, [sp], 16			//deallocate memory
	ret


expand:	stp x29, x30, [sp, -16]!		//save x29 and x30 to stack, allocating by -16, pre-increment sp

	mov x29,sp				//update x29 to current sp

	ldr w9, [x0, box_size + dimension_width]	//load b.size.width in w9
	mul w9, w9, w1					//multiply w9 = w9 * factor
	str w9, [x0, box_size + dimension_width]	//store new value b.size.width

	ldr w10, [x0, box_size + dimension_height]	//load b.size.height in w10
	mul w10, w10, w1				//multiply w10 = w10 * factor
	str w10, [x0, box_size + dimension_height]	//store new value b.size.height

	mul w9, w9, w10					// multiply w9 * 10 for box_area
	str w9, [x0, box_area]				//store box area

	mov x0, 0					//set x0 to 0
	mov w1, 0					//set w1 to 0

	ldp x29, x30, [sp], 16				//deallocate memory
	ret

printBox:	stp x29, x30, [sp, -16]!		//save x29 and x30 to stack, allocating by -16, pre-increment sp

		mov x29, sp				//update x29 to current sp



		ldr w2, [x1, box_origin + point_x]	//load b.origin.x
		ldr w3, [x1, box_origin + point_y]	//load b.origin.y
		ldr w4, [x1, box_size + dimension_width]	//load b.size.width
		ldr w5, [x1, box_size + dimension_height]	//load b.size.height
		ldr w6, [x1, box_area]				//load b.area
		mov 	x1, x0
		adrp	x0, fmt				//set 1st arg of printF() higher
		add 	x0, x0, :lo12:fmt		//set 1st arg of printf() lower
		bl printf				//print function

		mov x0, 0				//set x0 to 0
		ldp x29, x30, [sp], 16			//deallocate memory
		ret

equal:	stp x29, x30, [sp, -16]!			//save x29 and x30 to stack, allocating by -16, pre-increment sp
	mov x29, sp					//update x29 to current sp

	ldr x19, [x0, box_origin + point_x]		//load b1.origin.x in x19
	ldr x20, [x1, box_origin + point_x]		//load b2.origin.x in x20
	cmp x19, x20					//compare x19 and x20
	b.ne not_equals					//if x19 is not equal to x20, then branch to not_equal

	ldr x19, [x0, box_origin + point_y]		//load b1.origin.y in x19
	ldr x20, [x1, box_origin + point_y]		//load b2.origin.y in x19
	cmp x19, x20					//compare x19 and x20
	b.ne not_equals					//if x19 is not equal to x20, then branch to not_equals

	ldr x19, [x0, box_size + dimension_width]	//load b1.size.width in x19
	ldr x20, [x1, box_size + dimension_width]	//load b2.size.width in x20
	cmp x19, x20					//compare x19 and x20
	b.ne not_equals					//if x19 is not equal to x20, then branch to not_equals

	ldr x19, [x0, box_size + dimension_height]	//load b1.size.height in x19
	ldr x20, [x1, box_size + dimension_height]	//load b2.size.height in x20
	cmp x19, x20					//compare x19 and x20
	b.ne not_equals					//if x19 is not equal to x20, then branch to not_equals


	mov x0, TRUE 					//set x0 to TRUE = 1
	b next						//branch to next

not_equals:
	mov x0, FALSE					//set x0 to FALSE = 0

next:	ldp x29, x30, [sp], 16				//deallocate memory
	ret

		.global main				// Makes "main" visible to the OS

main:		stp x29, x30, [sp, alloc]!		//save x29 and x30 to stack, allocating by alloc, pre-increment sp
		mov x29, sp				//update x29 to current sp

		add x19, x29, first_box			//calculating address for first box
		add x20, x29, second_box		//calculating address for second box

		mov x8, x19				//base address for first box
		bl newBox				//call function newBox
		mov x8, x20				//base address for second box
		bl newBox				//call function newBox



init:		adrp x0, lmt				//Print string "Initial box values:"
		add w0, w0, :lo12:lmt			//set argument for printf lower

		bl printf				//call print function

		mov x1, x19				//base address for first box
		adrp x0, prt				//set argument for printf higher
		add x0, x0, :lo12:prt			//set argument for printf lower
		bl printBox				//call printBox() subroutine

		mov x1, x20				//base address for second box
		adrp x0, qrt				//set arg for printf higher
		add x0, x0, :lo12:qrt			//set arg for printf lower
		bl printBox				//call printBox() subroutine

		mov x0, x19				//set x0 to x19
		mov x1, x20				//set x1 to x20
		bl equal				//Branch to subroutine equal
		mov x0, x21				//mov result of equal to x21

		cmp x21, 0				//compare x21 to 0
		b.eq end				//If x21 = 0 then branch to next.

		add x0, x29, first_box			//calculating address for first box
		mov w1, -5				//set w1 to -5
		mov w2,	7				//set w2 to 7
		bl move					//branch to move subroutine

		add x0, x29, second_box			//calculating address for second box
		mov w1, 3				//set w1 to 3
		bl expand				//branch to expand



end:		adrp x0, nmt				// Print out "Changed box values"
		add w0, w0, :lo12:nmt
		bl printf


		add x1, x29, first_box			//calculating address for first box
		adrp x0, prt				//set arg for printf higher
		add x0, x0, :lo12:prt			//set arg for printf lower
		bl printBox				//call printBox()

		add x1, x29, second_box			//calculating address for second box
		adrp x0, qrt				//set arg for printf higher
		add x0, x0, :lo12:qrt			//set arg for printf lower
		bl printBox				//call printBox()

done:		mov w0, 0				//set w0 to 0
		ldp x29, x30, [sp], dealloc		//deallocate stack memory.

		ret
