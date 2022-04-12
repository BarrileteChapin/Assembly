.data
str1:		.asciiz "\n input a:"
str2:		.asciiz "\n input b:"
str3:		.asciiz "\n input c:"
str4:		.asciiz "\n input d:"
str5: 		.asciiz "\n result = "
str6:		.asciiz " \n" 
str7:		.asciiz "-- program finished running -- \n"

str8:		.asciiz "\n    Here: "
.text 

#start

_main: 
	#print
	la $a0, str1
	li $v0,4
	syscall
	
	#scan a
	li $v0, 5
	syscall 
	move $s0, $v0

	#print
	la $a0, str2
	li $v0,4
	syscall
	
	#scan b
	li $v0, 5
	syscall 
	move $s1, $v0
	
	#print
	la $a0, str3
	li $v0,4
	syscall
	
	#scan c
	li $v0, 5
	syscall 
	move $s2, $v0
	
	#loading arguments for add(_,_)
	add $a0, $zero, $s0 # x= a
	add $a1, $zero, $s1 # y= b
	jal _add
	
	#updating values for mmod(_,_) 
	add $a0, $zero, $v1 
	add $a1, $zero, $s2 
	jal _mmod  #calling mmod
	
	add $t0, $zero, $v1
	
	#printing 
	la $a0, str5
	li $v0,4
	syscall
	
	li $v0, 1        # ready to print int
	move $a0, $t0    # load int value to $a0
	syscall	         # print

	la $a0, str6
	li $v0,4
	syscall
	
	la $a0, str7
	li $v0,4
	syscall
	
	j _exit
	
_add: 
	add $v1, $a0, $a1
	jr $ra
	
_mmod: 
	#for convenience, we use a2 (2) and a3 as registers 
	#t1-> divisor t2 -> dividend  t3-> 4 (multiple functionality)
	addi $t3, $zero, 4
	addi $a2, $zero, 2

	ble $a0, $a1,_P1
	div  $a1,$t3 
	mfhi $a3 #get "y%4"	
	addi $a3, $a3, -1 #real value for shifting left
	sllv  $t4, $a2, $a3 #shifting left <-> pow(2,y%4)
	
	add $t1, $zero, $t4 #divisor
	add $t2, $zero, $a0 #dividend (x)
	
	div  $t2, $t1
	mfhi $v1
	jr $ra	 #return
	   
_P1:
	div  $a0,$t3
	mfhi $a3 #get "x%4"
	addi $a3, $a3, -1 #real value for shifting left
	sllv  $t4, $a2, $a3 #shifting left <-> pow(2,x%4)
	
	add $t1, $zero, $t4 #divisor
	add $t2, $zero, $a1 #dividend (y)
	
	div  $t2, $t1
	mfhi $v1
	jr $ra	 #return
	
_exit: 
	li   $v0, 10
  	syscall
