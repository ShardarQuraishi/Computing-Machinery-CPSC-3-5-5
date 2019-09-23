////////////////////////////////////////////////////////////CPSC 355 Assignment 5\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
/////////////////////////////////////////////////////////////////////Part B\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//////////////////////////////////////////////////////Name: Shardar Mohammed Quraishi\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////////////////////////////////////////////UCID: 30045559\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////////////////////////////////////////Date: 30/11/2018\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////////////////////////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////////////////////////////////////////////////  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

define(argc_r, w19)				//set argc_r to w19
define(argv, x20)				//set argv to x20
define(i_r, w24)				//set i_r to w24
define(month_r, w21)				//set month_r to w21
define(day_r, w22)				//set day_r to w22
	.text					//text section
jan:	.string "January"			//January
feb:	.string "February"			//February
mar:	.string "March"				//March
apr:	.string "April"				//April
may:	.string "May"				//May
jun:	.string "June"				//June
jul:	.string "July"				//July
aug:	.string "August"			//August
sept:	.string "September"			//September
oct:	.string "October"			//October
nov:	.string "November"			//November
dec:	.string "December"			//December

wnt:	.string "Winter"			//Winter
spr:	.string "Spring"			//Spring
sum:	.string "Summer"			//Summer
fall:	.string "Fall"				//Fall

suffix1:	.string "st"			//st
suffix2:	.string "nd"			//nd
suffix3:	.string "rd"			//rd
suffix4:	.string "th"			//th

usage:	.string "usage: a5b mm dd\n"		//print label for input error

fmt:	.string "%s %d%s is %s\n"		//print label for printing the result

wrong_entry:
	.string "Invalid entry\n"		//print label for wrong input

	.data					//data section
	.balign 8				//align by 8 bits

			//the month array
month:	.dword jan, feb, mar, apr, may, jun, jul, aug, sept, oct, nov, dec

			//the season array
season:	.dword wnt, spr, sum, fall

			//the suffix array
suffix:	.dword suffix1, suffix2, suffix3, suffix4


	.text					//text section
        .balign 4				//align by 4 bits
        .global main				//make main visible to the OS

main:   stp x29, x30, [sp, -16]!		//allocating memory
        mov x29, sp				//updating x29

        mov argc_r, w0				//mov w0 to argc_r(no. of arguments)
        mov argv, x1				//mov x1 to argv

        cmp argc_r, 3				//compare argc_r and 3
        b.ne error				//if not equals, branch to error

start:
	mov i_r, 1              		//i_r = 1, for first argument
        ldr x0, [argv, i_r, SXTW 3]		//load first argument
        bl atoi					//call atoi function
        mov month_r, w0             		//move w0 to month_r, first argument
        add i_r, i_r, 1             		//i_r = 2, for second argument
        ldr x0, [argv, i_r, SXTW 3]		//load second argument
        bl atoi					//call atoi function
        mov day_r, w0             		//move w0 to day_r, second argument
	b check_input				//branch to check_input


error:  adrp x0, usage				//print statement for printing error msg: usage
        add x0, x0, :lo12:usage
        bl printf
        b done					//branch to done

check_input:
	cmp month_r, 12				//compare month_r and 12
	b.gt wrong_input			//if greater than, branch to wrong input
	cmp month_r, 0				//compare month_r and 0
	b.le wrong_input			//if less than, branch to wrong_input

	cmp day_r, 31				//compare day_r and 31
	b.gt wrong_input			//if greater than, branch to wrong_input
	cmp day_r, 0				//compare day_r and 0
	b.le wrong_input			//if less than or equal, branch to wrong_input
	b month_check				//branch to month_check

wrong_input:
	adrp x0, wrong_entry			//print statement for wrong_input
	add x0, x0, :lo12:wrong_entry
	bl printf
	b done					//branch to done

month_check:
	cmp w21, 1				//checking if month is January
	b.eq jan_m

	cmp w21, 2				//checking if month is February
	b.eq feb_m

	cmp w21, 3				//checing if month is March
	b.eq mar_m

	cmp w21, 4				//checking if month is April
	b.eq apr_m

	cmp w21, 5				//checking if month is May
	b.eq may_m

	cmp w21, 6				//checking if month is June
	b.eq jun_m

	cmp w21, 7				//checking if month is July
	b.eq jul_m

	cmp w21, 8				//checking if month is August
	b.eq aug_m

	cmp w21, 9				//checking if month is September
	b.eq sept_m

	cmp w21, 10				//checking if month is October
	b.eq oct_m

	cmp w21, 11				//checking if month is November
	b.eq nov_m

	cmp w21, 12				//checking if month is December
	b.eq dec_m

jan_m:
	cmp w22, 31				//comparing w22 and 31
	b.le winter_s				//if less than or equal, branch to winter_s

feb_m:
	cmp w22, 29				//comparing w22 and 29
	b.le winter_s				//if less than or equal, branch to winter_s

mar_m:
	cmp w22, 20				//comparing w22 and 20
	b.le winter_s				//if less than or equal, branch to winter_s
	cmp w22, 21				//comparing w22 and 21
	b.ge spring_s				//if greater than or equal, branch to spring_s

apr_m:
	cmp w22, 31				//comparing w22, 31
	b.le spring_s				//if less than or equal, branch to spring_s

may_m:
	cmp w22, 31				//comparing w22 and 31
	b.le spring_s				//if less than or equal, brrtan jinv  22

jun_m:
	cmp w22, 20				//comparing w22 and 20
	b.le spring_s				//if less or equal, branch to spring_s
	cmp w22, 21				//comparing w22 and w21
	b.ge summer_s				//if greater than or equal, branch to summer_s

jul_m:
	cmp w22, 31				//comparing w22 and 31
	b.le summer_s				//if less than or equal, branch to summer_s

aug_m:
	cmp w22, 31				//comparing w22 and 31
	b.le summer_s				//if less than or equal, branch to summer_s

sept_m:
	cmp w22, 20				//comparing w22 and 20
	b.le summer_s				//if less than or equal, branch to summer_s
	cmp w22, 21				//comparing w22 and 21
	b.ge fall_s				//if greater than or equal, branch to fall_s

oct_m:
	cmp w22, 31				//comparing w22 and 31
	b.le fall_s				//if less than or equal, branch to fall_s

nov_m:
	cmp w22, 31				//comparing w22 and 31
	b.le fall_s				//if less than or equal, branch to fall_s

dec_m:
	cmp w22, 20				//comparing w22 and 20
	b.le fall_s				//if less than or equal, branch to fall_s
	cmp w22, 21				//comparing w22 and 21
	b.ge winter_s				//if greater or equal, branch to winter_s


winter_s:
	mov w19, 0				//mov 0 to w19
	b next

spring_s:
	mov w19, 1				//mov 1 to w19
	b next

summer_s:
	mov w19, 2				//mov 2 to w19
	b next

fall_s:
	mov w19, 3				//mov 3 to w19
	b next

next:	cmp w22, 1				//checking the dates for the right suffix
	b.eq suf1				//st
	cmp w22, 21
	b.eq suf1
	cmp w22, 31
	b.eq suf1

	cmp w22, 2				//nd
	b.eq suf2
	cmp w22, 22
	b.eq suf2

	cmp w22, 3				//rd
	b.eq suf3
	cmp w22, 23
	b.eq suf3

	mov w20, 3				//th
	b result

suf1:	mov w20, 0				//assigning the correct suffixes
	b result

suf2:	mov w20, 1
	b result

suf3:	mov w20, 2


result:
	sub month_r, month_r, 1			//month_r = month_r - 1
	adrp x25, month				//loading the month array
	add x25, x25, :lo12:month

	adrp x26, season			//loading the season array
	add x26, x26, :lo12:season

	adrp x23, suffix			//loading the suffix array
	add x23, x23, :lo12:suffix

	adrp x0, fmt				//print statements for printing out the result
	add x0, x0, :lo12:fmt
	ldr x1, [x25, month_r, SXTW 3]		//loading month from the array
	mov w2, day_r				//date entered
	ldr x3, [x23, w20, SXTW 3]		//loading the suffix from the array
	ldr x4, [x26, w19, SXTW 3]		//loading the season from array
	bl printf				//print statement


done:	mov w0, 0
	ldp x29, x30, [sp], 16			//deallocating memory
	ret
