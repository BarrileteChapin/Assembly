.data
str1:		.asciiz "Round "
str2:		.asciiz " start...\n"
str3:		.asciiz "Please place a bet:\n"
str4:		.asciiz "Now, even(0) or odd(1)? \n"
str5:		.asciiz "correct!\n"
str6:		.asciiz "incorrect!\n"
str7:		.asciiz " marbles!\n"

str8:		.asciiz "now, you have: "
str9:		.asciiz "wow!, you win\n"
str10:		.asciiz "nah!, you loose\n"
str11: 		.asciiz "The game ended in the round: "
str12:		.asciiz " ,why so quick? \n" 
str13:		.asciiz "[tied] nobody wins, both lose \n"
.text

#########DONOT MODIFY HERE###########
#Setup initial marbles
addi $t0, $zero, 10	# your marbles
addi $t1, $zero, 10	# your emeny's marbles
addi $t2, $zero, 1	#round
########################################## 

addi $t6, $t6, 3  # t6 =3

######How to generate random number?######## 
#addi $a1, $zero, 10 # int range(1, 10)
#addi $v0, $zero, 42  #syscall for generating random int into $a0
#syscall
#move $t3, $a0 
#addi $t3, $t3, 1
##########################################

##########How to check odd/even?############ 
#addi $t5, $zero, 2    # Store 2 in $t0
#div $t5, $t4, $t5     # Divide input by 2
#mfhi $s1              # Save remainder in $s1
#if s1 = 1, it's odd
#if s1 = 0, it's even
##########################################

#Game start!      	
_Start:
	la $a0, str1	 # load address of string to print
	li $v0, 4	 # ready to print string
	syscall	         # print
	
	li $v0, 1        # ready to print int
	move $a0, $t2    # load int value to $a0
	syscall	         # print
	
	la $a0, str2	 # load address of string to print
	li $v0, 4	 # ready to print string
	syscall	         # print

	la $a0, str1	 # load address of string to print
	li $v0, 4	 # ready to print string
	syscall	         # print
	
	la $a0, str3	 # load address of string to print
	li $v0, 4	 # ready to print string
	syscall	 

	li $v0, 5 	#scanf
	syscall
	move $s1, $v0

	# check input
	ble $s1,$t0, _correctinputs #t2 <=t0 if the bet is less than the current marbles' quantity
	j _incorrectinputs
	
_correctinputs:
	#Generate random number
	addi $a1, $zero, 10 # int range(1, 10)
	addi $v0, $zero, 42  #syscall for generating random int into $a0
	syscall
	move $t4, $a0 
	addi $t4, $t4, 1 #if not add, the range will be (0, 10)
	
	#check odd/even
	addi $t5, $zero, 2    # Store 2 in $t0
    	div $t5, $t4, $t5     # Divide input by 2
    	mfhi $s2              # Save remainder in $s1 -> $s2
		
	la $a0, str4 #now, even or odd
	li $v0, 4
	syscall
	
	li $v0, 5 	#scanf
	syscall
	move $s3, $v0	#bet of marbles from player
	
	beq $s3,$s2, _correct
	j _incorrect
	
_incorrectinputs:
	la $a0, str6 #incorrect
	li $v0, 4
	syscall
	j _Gameprocessing	
	
_Gameprocessing:
	ble $t2,$t6, _Start #-> goes to read
	j _threeround  #ends the cycle
	
_incorrect:
	sub $t0, $t0, $t4 #substract your marbles
	add $t1, $t1, $t4 #and were added to the enemy's collection
	
	la $a0, str6 #"incorrect"
	li $v0, 4
	syscall
	
	la $a0, str8	#"now, you have ___"
	li $v0, 4
	syscall
	
	li $v0, 1 	#"number"
	move $a0, $t0
	syscall
	
	la $a0, str7  #" marbles \n"
	li $v0, 4
	syscall
	
	j _checkwinner
	
_correct:
	la $a0, str5 #"correct"
	li $v0, 4
	syscall
	
	add $t0, $t0, $s1
	sub $t1, $t1, $s1
	
	la $a0, str8	#"now, you have ___"
	li $v0, 4
	syscall
	
	li $v0, 1 	#"number"
	move $a0, $t0
	syscall
	
	la $a0, str7  #"marbles \n"
	li $v0, 4
	syscall
	
	j _checkwinner
	
_checkwinner:
	ble $t0, $zero,_nothreeround #t0<=0
	ble $t1, $zero,_nothreeround #t1<=0
	addi $t2, $t2, 1	#round+=1
	j _Gameprocessing
	
_threeround:
	bgt $t0,$t1, _winner 
	blt $t0,$t1, _beginner
	la $a0, str13	#nobody wins. 
	li $v0, 4
	syscall
	
	j _Exit

#when the game ends earlier than expected:
_nothreeround: 
	la $a0, str11	#the game ended in the round __
	li $v0, 4
	syscall

	li $v0, 1 	#number
	move $a0, $t2
	syscall
	
	la $a0, str12	#why so quick?:) 
	li $v0, 4
	syscall
	
	bgt $t0,$t1, _winner
	j _beginner


_winner: 
	la $a0, str9	#wow, you win
	li $v0, 4
	syscall

	
	j _Exit
	
_beginner:
	
	la $a0, str10	#nah, you loose
	li $v0, 4
	syscall
	
	j _Exit
	
#terminated	
_Exit:
	li   $v0, 10
  	syscall
