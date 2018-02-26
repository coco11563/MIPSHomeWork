.data 
win: .asciiz "Success! Location:"
fail: .asciiz "Fail!"
.text  
.globl main  
#? word length[] = 4    

    move $t0, $sp
    
main:
    li $v0, 12  #when $v0 = 12 read character from input to $v0
    syscall  
    sub $t1, $v0, 63    # is '?" ?  
    beqz $t1, exit  
    sub $t1, $v0, 10    # is '\r\n'?
    beqz $t1, next  
    sw $v0, ($t0)       # sw the input
    add $t0, $t0, 4     
    j main
    
next:
    move $t4, $sp
    li $v0, 12  #when $v0 = 12 read character from input to $v0
    syscall  
    sub $t1, $v0, 63    # is '?" ?  
    beqz $t1, exit  
    add $t2, $zero, $v0
    j judge

judge:
    beq $t0, $t4, fail_exit
    lw $t3, ($t4)
    sub $t3, $t2, $t3    # 0 in ascii table
    beqz $t3, success_exit
    add $t4, $t4, 4
    j judge
    
fail_exit:
    li $v0, 11
    la $a0, 10
    syscall
    la $a0, fail    
    li $v0, 4  
    syscall  
    li $v0, 11
    la $a0, 10
    syscall
    j next
    
success_exit:
    li $v0, 11
    la $a0, 10
    syscall
    la $a0, win    
    li $v0, 4  
    syscall 
    sub $t4, $t4, $sp
    srl $t4, $t4, 2
    add $t4, $t4, 1 
    move $a0, $t4  
    li $v0, 1   
    syscall
    li $v0, 11
    la $a0, 10
    syscall 
    j next
    
exit:
    li $v0, 10  
    syscall  
