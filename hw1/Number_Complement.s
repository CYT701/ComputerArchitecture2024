.data
num1:    .word 5                  
num2:    .word 1                  
num3:    .word 2147483647
ans1:    .word 2
ans2:    .word 0
ans3:    .word 0         
str1:    .string "\nCORRECT\n"
str2:    .string "\nWRONG ANSWER\n"   
str3:    .string "\nExpected: "
str4:    .string "\nYour answer is: "
.text
main:
    lw a0, num1         # load num1 to a0
    # findComplement
    jal ra, findComplement

    # checkResult                      
    lw t1, ans1
    jal ra, checkResult
    
    lw a0, num2         # load num2 to a0
    # findComplement
    jal ra, findComplement

    # checkResult                      
    lw t1, ans2
    jal ra, checkResult
    
    lw a0, num3         # load num3 to a0
    # findComplement
    jal ra, findComplement

    # checkResult                      
    lw t1, ans3
    jal ra, checkResult
    # Exit the program
    li a7, 10
    ecall
      
# a0: Input num
findComplement:
    add t0, zero, a0    # load a0 to t0             
# set all the bits to 1 starting from the first 1 that appears
    srli t1, t0, 1
    or t0, t0, t1 
    srli t1, t0, 2
    or t0, t0, t1
    srli t1, t0, 4
    or t0, t0, t1
    srli t1, t0, 8
    or t0, t0, t1 
    srli t1, t0, 16
    or t0, t0, t1      

    xor a0, a0, t0
    ret      

checkResult:
    mv a1, a0
    beq a0, t1, pass
    la a0, str2
    li a7, 4
    ecall
    la a0, str4
    li a7, 4
    ecall
    mv a0, a1
    li a7, 1
    ecall
    la a0, str3
    li a7, 4
    ecall 
    mv a0, t1
    li a7, 1
    ecall
    ret
pass:
    la a0, str1
    li a7, 4
    ecall
    ret 
    
