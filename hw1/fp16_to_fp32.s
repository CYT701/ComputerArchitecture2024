.data
num1:    .word 0x3C00
num2:    .word 0xBC00
num3:    .word 0x7c00
str1:    .string "\nThe fp32 value of fp16 number "
str2:    .string " is "
.text
main:
    lw a0, num1
    jal ra, fp16_to_fp32
    mv a1, a0
    lw a0, num1
    jal ra, printResult
    
    lw a0, num2
    jal ra, fp16_to_fp32
    mv a1, a0
    lw a0, num2
    jal ra, printResult
    
    lw a0, num3
    jal ra, fp16_to_fp32
    mv a1, a0
    lw a0, num3
    jal ra, printResult
    
    li a7, 10
    ecall
fp16_to_fp32:
    add t0, x0, a0
    slli t0, t0, 16
    li t1, 0x80000000
    and t1, t0, t1    # t1 is sign
    li t2, 0x7FFFFFFF
    and t2, t0, t2    # t2 is nonsign
    #jal ra, my_clz
my_clz:
    li t3, 0             # Load t3 as count
    li t4, 31            # Load t4 as i in for loop
    li t5, 1             # Load t5 as the 1 that we want to left shift

clz_loop:
    sll t6, t5, t4       # t3 = 1 << i 
    and t6, t2, t6       # t3 = x & (1 << i) 
    bnez t6, clz_done    # if t3 is not zero, break

    addi t3, t3, 1       # count ++
    addi t4, t4, -1      # i--
    bgez t4, clz_loop    # for loop

clz_done:
    #mv t2, t3             
    #ret
    addi t3, t3, -5
    bgt t3, x0, continue
    addi t3, x0, 0    # t3 is renorm_shift
continue:
    li t4, 0x04000000
    add t4, t2, t4
    srli t4, t4, 8
    li t5, 0x7F800000
    and t4, t4, t5    # t4 is inf_nan_mask
    addi t5, t2, -1
    srli t5, t5, 31   # t5 is zero_mask
    li t6, 0xFFFFFFFF
    xor t5, t5, t6    # t5 is ~zero_mask
    sll t2, t2, t3
    srli t2, t2, 3
    li t6, 0x70
    sub t3, t6, t3
    slli t3, t3, 23
    add t2, t2, t3 
    or t2, t2, t4
    and t2, t2, t5
    or a0, t1, t2
    ret  
#my_clz:
#    li t3, 0             # Load t3 as count
#    li t4, 31            # Load t4 as i in for loop
#    li t5, 1             # Load t5 as the 1 that we want to left shift

#clz_loop:
#    sll t6, t5, t4       # t3 = 1 << i 
#    and t6, t2, t6       # t3 = x & (1 << i) 
#    bnez t6, clz_done    # if t3 is not zero, break

#    addi t3, t3, 1       # count ++
#    addi t4, t4, -1      # i--
#    bgez t4, clz_loop    # for loop

#clz_done:
    #mv t2, t3             
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
    
