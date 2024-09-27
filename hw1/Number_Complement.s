.data
num1:    .word 5                  
num2:    .word 1                  
num3:    .word 2147483647         
str1:    .string "The complement of "
str2:    .string " is "   

.text
main:
    lw a0, num1         # load num1 to a0
    # findComplement
    jal ra, findComplement

    # printResult
    mv a1, a0                     
    lw a0, num1                       
    
    jal ra, printResult
    
    lw a0, num2         # load num2 to a0
    # findComplement
    jal ra, findComplement

    # printResult
    mv a1, a0                     
    lw a0, num2                       
    
    jal ra, printResult
    
    lw a0, num3         # load num3 to a0
    # findComplement
    jal ra, findComplement

    # printResult
    mv a1, a0                     
    lw a0, num3                       
    
    jal ra, printResult
    # Exit the program
    li a7, 10
    ecall
      
# a0: Input num
findComplement:
    add t0, zero, a0    # load a0 to t0                 
    addi t1, zero, 1    # t1 is mask
                         
while:
    slli t1, t1, 1      # mask = mask << 1
    bltu t1, t0, while   # if(mask < num) goto while
    
done_while:             # else
    addi t1, t1, -1     # mask = mask - 1
    xor a0, t1, t0      # xor
    ret

printResult:
    mv t0, a0
    mv t1, a1
    
    la a0, str1
    li a7, 4
    ecall
    
    mv a0, t0
    li a7, 1
    ecall
    
    la a0, str2
    li a7, 4
    ecall
    
    mv a0, t1
    li a7, 1
    ecall
    
    ret