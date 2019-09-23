////////////////////////////////////////////////////////////CPSC 355 Assignment 5\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
/////////////////////////////////////////////////////////////////////Part A\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//////////////////////////////////////////////////////Name: Shardar Mohammed Quraishi\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////////////////////////////////////////////UCID: 30045559\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////////////////////////////////////////Date: 30/11/2018\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////////////////////////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////////////////////////////////////////////////  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




QUEUESIZE = 8				//set value of constant QUEUESIZE to 8
MODMASK = 0x7				//set value of MODMASK to 0x7
FALSE = 0				//set FALSE to 0
TRUE = 1				//set TRUE to 1

define(value, w15)			//set x15 to value

//labels for print statement
qFull:	.string "\nQueue overflow. Cannot enqueue into a full queue.\n"

qEmpty:	.string "\nQueue underflow. Cannot dequeue from an empty queue.\n"

emptyQ:	.string "\nEmpty queue\n"

currentQ:	.string "\nCurrent queue contents: \n"

cQueue:	.string " %d"

headQ:	.string " <-- head of queue"

tailQ:	.string " <-- tail of queue"

nLine:	.string "\n"


	.data					//put these variables in the data section

	.global queue
queue:	.skip QUEUESIZE*4			//init global array variable


	.global head				//head is global
head:	.word -1				//head = -1

	.global tail				//tail is global
tail:	.word -1				//tail = -1


	.text					//text section
	.balign 4				//align by 4 bits
	.global enqueue				//making enqueue function global
enqueue:
	stp x29, x30, [sp, -16]!		//allocating memory
	mov x29, sp				//update x29

	mov value, w0				//mov w0 to value
	bl queueFull				//call queueFull function
	cmp w0, TRUE 				//compare w0 and TRUE
	b.ne next				//if not equal branch to next

	adrp x0, qFull				//set arguments for printf lower
	add x0, x0, :lo12:qFull			//set arguments for printf higher
	bl printf				//call print function

next:
//	mov value, w0
	bl queueEmpty				//call queueEmpty function
	cmp w0, TRUE				//compare w0 and TRUE
	b.ne else				//if not equals branch to else

	adrp x9, head				//load head
	add x9, x9, :lo12:head
	str wzr, [x9]
	/////////////storing head = 0

	adrp x10, tail				//load tail
	add x10, x10, :lo12:tail
	str wzr, [x10]
	////////////storing tail = 0

	b end					//branch to end

else:
	adrp x11, tail				//load tail
	add x11, x11, :lo12:tail
	ldr w12, [x11]				//load tail into x12
	///pre incrementing//////
	add w12, w12, 1				//incrementing tail = tail++
	and w12, w12, MODMASK			//tail = tail ++ & MODMASK
	str w12, [x11]				//update tail

end:	adrp x9, tail				//load tail
	add x9, x9, :lo12:tail
	ldr w20, [x9]				//load tail into w20

	adrp x10, queue				//load queue
	add x10, x10, :lo12:queue
	str value, [x10, w20, SXTW 2]		//loading tail from queue
	ldp x29, x30, [sp], 16			//deallocate memory
	ret					//return

	.balign 4				//align instructions by 4 bytes
	.global dequeue				//make dequeue global
dequeue:
	stp x29, x30, [sp, -16]!		//allocating memory
	mov x29, sp				//updating x29

	bl queueEmpty				//calling queueEmpty function
	cmp w0, TRUE				//comparing w0 and TRUE
	b.ne next2				//if not equal, branch to next2
	adrp x0, qEmpty				//set argument for printf lower
	add x0, x0, :lo12:qEmpty		//set argument for printf higher
	bl printf				//call print function
	mov x0, -1				//move -1 to x0

	ldp x29, x30, [sp], 16			//deallocating memory
	ret					//return
next2:
	adrp x9, head				//get head address
	add x9, x9, :lo12:head
	ldr w20, [x9]				//load head into w20

	adrp x10, queue				//get queue address
	add x10, x10, :lo12:queue
	ldr value, [x10, w20, SXTW 2]		//loading head from queue

	adrp x11, head				//get head address
	add x11, x11, :lo12:head
	ldr w12, [x11]				//load head into w12

	adrp x13, tail				//get tail address
	add x13, x13, :lo12:tail
	ldr w14, [x13]				//load tail into w14

	cmp w12, w14				//compare w12 and w14
	b.ne else2				//if not equal, branch to else2

	//head = -1
	adrp x9, head				//get head address
	add x9, x9, :lo12:head
	mov w19, -1				//mov -1 to w19
	str w19, [x9]				//store head to w19
	//tail = -1
	adrp x10, tail				//get tail address
	add x10, x10, :lo12:tail
	str x19, [x10]				//store tail into x19
	b end2					//branch to end2
else2:
	adrp x9, head				//get head addresss
	add x9, x9, :lo12:head
	ldr w10, [x9]				//load head into w10
	add w10, w10, 1				//head++
	and w10, w10, MODMASK			//(head++) & MODMASK
	str w10, [x9]				//updating head
end2:
	mov w0, value				//move value to w0
	ldp x29, x30, [sp], 16			//deallocating memory
	ret


queueFull:
	stp x29, x30, [sp, -16]!		//allocate memory
	mov x29, sp				//update x29

	adrp x9, tail				//get tail address
	add x9, x9, :lo12:tail
	ldr w10, [x9]				//load tail into w10
	add w10, w10, 1				//tail + 1
	and w10, w10, MODMASK  			//(tail + 1) & MODMASK

	adrp x11, head				//get head address
	add x11, x11, :lo12:head
	ldr w12, [x11]				//load head into head

	mov w0, TRUE				//move TRUE to w0
	cmp w10, w12				//compare tail and head
	b.eq end3				//if equal, branch to end3
	mov w0, FALSE				//move FALSE to w0

end3:	ldp x29, x30, [sp], 16			//deallocating memory
	ret

queueEmpty:
	stp x29, x30, [sp, -16]!		//allocating memory
	mov x29, sp				//updating x29

	adrp x9, head				//get head address
	add x9, x9, :lo12:head
	ldr w10, [x9]				//load head into w10
	mov w0, TRUE				//move TRUE to w0
	cmp w10, -1				//compare head to w10
	b.eq end4				//if equal, branch to end4
	mov w0, FALSE				//move FALSE to w0

end4:	ldp x29, x30, [sp], 16			//deallocating memory
	ret

	.balign 4				//align by 4 bits
	.global display				//make display global
display:
	stp x29, x30, [sp, -16]!		//allocating memory
	mov x29, sp				//update x29

	bl queueEmpty				//call function queueEmpty
	cmp w0, TRUE				//compare w0 and TRUE
	b.ne next3				//if not equals, branch to next3

	adrp x0, emptyQ				//argument for printf lower
	add x0, x0, :lo12:emptyQ		//argument for printf higher
	bl printf				//call print function
	b done					//branch to done

next3:	adrp x9, head				//get head address
	add x9, x9, :lo12:head
	ldr w10, [x9]				//load head into w10

	adrp x9, tail				//get tail address
	add x9, x9, :lo12:tail
	ldr w11, [x9]				//load tail into w11

	sub w13, w11, w10			//count = tail - head
	add w13, w13, 1  			//count = count + 1


	cmp w13, 0				//compare count and 0
	b.gt next4				//if greater than, branch to next4
	add w13, w13, QUEUESIZE			//count = count + QUEUESIZE

next4:
	adrp x0, currentQ			//argument for printf lower
	add x0, x0, :lo12:currentQ		//argument for printf higher
	bl printf				//call print function

	mov w12, w10				//i = head
	mov w14, 0				//j = 0
	b test					//branch to test

loop:	adrp x0, cQueue				//argument for print lower
	add x0, x0, :lo12:cQueue		//argument for printf higher

	adrp x9, queue				//get queue address
	add x9, x9, :lo12:queue
	ldr x26, [x9]	//////////////			//load queue, in a register x26

	ldr w1, [x26, w12, SXTW 2]		//load i from queue in w1
	bl printf				//call print function

	cmp w12, w10				//compare i and head
	b.ne next5				//if not equals, branch to next5
	adrp x0, headQ				//argument for printf lower
	add x0, x0, :lo12:headQ			//argument for printf higher
	bl printf				//call print functiom

next5:	cmp w12, w11				//compare i and tail
	b.ne end5				//if not equals, branch to end5
	adrp x0, tailQ				//argument for printf lower
	add x0, x0, :lo12:tailQ			//argument for printf higher
	bl printf				//call print function

end5:	adrp x0, nLine				//argument for printf higher
	add x0, x0, :lo12:nLine			//argument for printf lower
	bl printf
	add w12, w12, 1				//i++
	and w10, w10, MODMASK			//i = i & MODMASK

	add w14, w14, 1				//j++

test:	cmp w14, w13				//compare j and count
	b.lt loop				//if less than, branch to loop

done:	ldp x29, x30, [sp], 16			//deallocating memory
	ret					//return
