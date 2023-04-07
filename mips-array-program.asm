# ----------------------------------------- #
.macro print_str %str
	.data
		msg: .asciiz %str
	.text
		la a0, msg
		li v0, 4
		syscall
.end_macro
# ----------------------------------------- #
.eqv ARR_SIZE 5
.eqv END_INDEX 4
# ----------------------------------------- #
.data
	arr: .byte 0 0 0 0 0
# ----------------------------------------- #
.text
.globl main
main:
	jal print_arr
	jal print_newline
	jal pop_arr
	jal print_newline
	jal print_arr
	jal print_newline
	jal print_arr_oneline
	jal print_newline
	jal sort_arr
	jal print_arr_oneline
	print_str "\n-----GOODBYE!-----\n"
	j exit


# ----------------------------------------- #
print_arr:
	push ra
	la t0, arr
	li s0, 0
	_loop:
		print_str "arr["
		
		# print index
		move a0, s0
		li v0, 1
		syscall
		
		print_str "] = "
		
		# print arr[i]
		add t1, t0, s0
		lb a0, (t1)
		li v0, 1
		syscall
		
		# print newline
		li a0, '\n'
		li v0, 11
		syscall
		
		# i++
		add s0, s0, 1
		blt s0, ARR_SIZE, _loop
	pop ra
	jr ra
	
# ----------------------------------------- #
pop_arr:
	push ra
	
	# i = s0 = 0
	li s0, 0
	
	_loop:
		print_str "enter a number: "
	
		# t0 = user inputted number
		li v0, 5
		syscall
		move t0, v0
	
		# t1 = &arr
		la t1, arr

		# store user input from t0 into arr[i]
		add t2, t1, s0
		sb t0, (t2)
		
		# i++
		add s0, s0, 1
		blt s0, ARR_SIZE, _loop
	
	pop ra
	jr ra

# ----------------------------------------- #
print_newline:
	push ra
	li a0, '\n'
	li v0, 11
	syscall
	pop ra
	jr ra

# ----------------------------------------- #
sort_arr:
	push ra
	la t0, arr
	li s0, 0 # s0 = i
	li s1, 1 # s1 = j = i+1
	_loop:
		# check and make sure s1 is not past the end of the array
	
		# t1 = &[arr + i]
		add t1, t0, s0
		
		# t2 = &[arr + i + 1]
		add t2, t0, s1
		
		# get byte at address held in t3
		lb t3, (t1)
		
		# get byte at address held in t4
		lb t4, (t2)
		
		# compare element at arr[i] and arr[i+1]
		# swap if arr[i] < arr[i+1]
		bgt t3, t4, _skip_swap
		
		# --- swap ---
		# arr[i] = t4
		sb t4, (t1)
		sb t3, (t2)
		
		_skip_swap:
		
		# i++ and j++
		add s0, s0, 1
		add s1, s1 ,1
		blt s1, ARR_SIZE, _loop
	pop ra
	jr ra

# ----------------------------------------- #
print_arr_oneline:
	push ra
	# print array on one line
	la t0, arr
	li s0, 0
	print_str "arr = {"
	_loop:
		# prints arr[i]
		add t1, t0, s0
		lb a0, (t1)
		li v0, 1
		syscall
		
		# if i < ARR_SIZE print ", ", else print "}\n"
		# END_INDEX
		blt s0, END_INDEX, _not_end
		
		# for printing last entry of array
		print_str "}\n"
		j _end
		
		_not_end:
		print_str ", "
		
		# i++
		add s0, s0, 1
		blt s0, ARR_SIZE, _loop
		
		_end:
	pop ra
	jr ra

# ----------------------------------------- #
exit:
	li v0, 10
	syscall