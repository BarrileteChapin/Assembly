.data
str1:		.asciiz "\n input a: "
str2:		.asciiz "\n input b: "
str3: 		.asciiz "\n ans = "
str4:		.asciiz " \n" 
str5:		.asciiz "-- program finished running -- \n"
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
	
	#set parameters for fn(_,_)
	add $a0, $zero,$s0 #a0->a
	add $a1, $zero,$s1 #a1->b
	jal _fn 

	add $s2, $zero, $v0  #set value of c 
	
	#print result
	la $a0, str3
	li $v0,4
	syscall
	
	li $v0, 1        # ready to print int
	move $a0, $s2    # load int value to $a0
	syscall	         # print
		
	#set parameters for re(_)
	add $a0, $zero, $s0 
	jal _re	
			
	add $s2, $s2, $v0  #c += re(a) 
	
	#print result
	la $a0, str3
	li $v0,4
	syscall
	
	li $v0, 1        # ready to print int
	move $a0, $s2    # load int value to $a0
	syscall	         # print
	
	j _exit	
		
_fn: 
	ble $a0, $zero, _f1 # x<=0
	ble $a1, $zero, _f1 #y <=0
	blt $a0,$a1, _f2    #x<y
	j _fnR

#recursive fn
_fnR:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $a0, 4($sp)  #x
	sw $a1, 8 ($sp) #y
	
	addi $a0, $a0, -1 # x-1
	jal _fn  #fn(x-1,y)
	
	lw $a0, 4($sp) #recover x
	sw $v0, 12($sp) #storage fn(x-1,y)
	addi $a1, $a1, 2 #y+2
	jal _fn  #fn(x,y+2)
	
	lw $a1, 8($sp) #recover y 
	addi $t3, $zero, 2 #temporal 
	mul $t2, $v0, $t3  #2*fn(x,y+2)
	
	lw $t1,12($sp) #recover fn(x+2,y)
	add $v0, $t1,$t2 #v0-> fn(x-1,y)+ 2*fn(x,y+2) 
	add $v0,$v0, $a1 #v0 -> fn(x-1,y)+ 2*fn(x,y+2) + y
	
	lw $ra, 0($sp) 
	add $sp, $sp, 16
	jr $ra


#return 0
_f1: 
	add $v0, $zero, $zero
	jr $ra

#return 1
_f2: 
	addi $v0, $zero, 1
	jr $ra

_re: 
	bgt $a0, $zero, _reR
	add $v0, $zero, $zero 
	jr $ra #return 0

#recursive re
_reR: 
	#making use of a stack
	addi $sp, $sp, -8
	sw $ra, 0($sp)	#return address
	sw $a0, 4($sp)	#actually, this instruction is unnecessary.   
	
	addi $a0, $a0, -1 #x-1
	jal _re #re(x-1)
	
	addi $t1, $v0, 1 #re(x-1) +1
	add $v0, $zero, $t1 #vo = t1
	
	#cleaning stack
	lw $a0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	
	jr $ra

_exit: 
	li   $v0, 10
  	syscall
