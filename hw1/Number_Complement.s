.data
num1:    .word 5                  
num2:    .word 1                  
num3:    .word 2147483647         
str1:    .string "\nThe complement of "
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
    #addi t1, zero, 1    # t1 is mask
# branchless CLZ
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
# population count
    # x = x - ((x >> 1) & 0x55555555)
    #srli t1, t0, 1 
    #lui t2, 0x55555
    #addi t2, t2, 0x555  
    #and t1, t1, t2
    #sub t0, t0, t1
    # x = ((x >> 2) & 0x33333333) + (x & 0x33333333)
    #srli t1, t0, 2
    #lui t2, 0x33333
    #addi t2, t2, 0x333
    #and t1, t1, t2
    #and t3, t0, t2
    #add t0, t1, t3
    # x = ((x >> 4) + x) & 0x0f0f0f0f
    #srli t1, t0, 4
    #add t1, t0, t1
    #lui t2, 0x0f0f0
    #addi t2, t2, 0x7ff
    #addi t2, t2, 0x710
    #and t0, t1, t2
    # x += (x >> 8)
    #srli t1, t0, 8
    #add t0, t0, t1
    #x += (x >> 16)
    #srli t1, t0, 16
    #add t0, t0, t1
    # return (32 - (x & 0x3f))
    #andi t1, t0, 0x3f
    #addi t2, zero, 32
    #sub t0, t2, t1 
    
    #sub t0, t2, t0
    #addi t1, zero, 1
    #sll t1, t1, t0
    #addi t1, t1, -1
    xor a0, a0, t0
    ret      
#clz_while:
#    slli t1, t1, 1      # mask = mask << 1
#    bltu t1, t0, clz_while   # if(mask < num) goto clz_while
    
#done_while:             # else
#    addi t1, t1, -1     # mask = mask - 1
#    xor a0, t1, t0      # xor
#    ret

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
