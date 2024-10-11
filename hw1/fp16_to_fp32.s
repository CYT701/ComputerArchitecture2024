.data
num1:    .word 0x3C00
num2:    .word 0xBC00
num3:    .word 0x7C00
ans1:    .word 0x3F800000
ans2:    .word 0xBF800000
ans3:    .word 0x47800000
str1:    .string "CORRECT\n"
str2:    .string "WRONG ANSWER\n"
str3:    .string "\nExpected: "
str4:    .string "\nYour answer is:"
.text
main:
    lw a0, num1
    jal ra, fp16_to_fp32
    #mv a1, a0
    #lw a0, num1
    lw t1, ans1
    jal ra, checkResult
    
    lw a0, num2
    jal ra, fp16_to_fp32
    #mv a1, a0
    #lw a0, num2
    lw t1, ans2
    jal ra, checkResult
    
    lw a0, num3
    jal ra, fp16_to_fp32
    #mv a1, a0
    #lw a0, num3
    lw t1, ans3
    jal ra, checkResult
    
    li a7, 10
    ecall
fp16_to_fp32:
    add t0, x0, a0
    slli t0, t0, 16      # w = h << 16
    li t1, 0x80000000
    and t1, t0, t1       # t1 is sign (sign = w & 0x80000000)
    li t2, 0x7FFFFFFF
    and t2, t0, t2       # t2 is nonsign (nonsign = w & 0x7FFFFFFF)
    #jal ra, my_clz
my_clz:
    li t3, 0             # Load t3 as count
    li t4, 31            # Load t4 as i in for loop
    li t5, 1             # Load t5 as the 1 that we want to left shift

clz_loop:                # renorm_shift = my_clz(nonsign)
    sll t6, t5, t4       # t6 = 1 << i 
    and t6, t2, t6       # t6 = x & (1 << i) 
    bnez t6, clz_done    # if t6 is not zero, break

    addi t3, t3, 1       # count ++
    addi t4, t4, -1      # i--
    bgez t4, clz_loop    # for loop

clz_done:
    addi t3, t3, -5      # t3 is renorm_shift
    bgt t3, x0, continue # if (renorm_shift-5 > 0) branch
    addi t3, x0, 0       # else renorm_shift=0
continue:
    li t4, 0x04000000
    add t4, t2, t4       
    srli t4, t4, 8
    li t5, 0x7F800000
    and t4, t4, t5       # t4 is inf_nan_mask
    addi t5, t2, -1
    srli t5, t5, 31      # t5 is zero_mask
    li t6, 0xFFFFFFFF
    xor t5, t5, t6       # t5 is ~zero_mask
    sll t2, t2, t3
    srli t2, t2, 3       # (nonsign << renorm_shift >> 3)
    li t6, 0x70
    sub t3, t6, t3
    slli t3, t3, 23      # (0x70 - renorm_shift) << 23
    add t2, t2, t3       
    or t2, t2, t4
    and t2, t2, t5
    or a0, t1, t2
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
    li a7, 34
    ecall
    la a0, str3
    li a7, 4
    ecall 
    mv a0, t1
    li a7, 34
    ecall
    ret
pass:
    la a0, str1
    li a7, 4
    ecall
    ret 
#printResult:
    #mv t0, a0
    #mv t1, a1
    #la a0, str1
    #li a7, 4
    #ecall
    
    #mv a0, t0
    #li a7, 34
    #ecall
    
    #la a0, str2
    #li a7, 4
    #ecall
    
    #mv a0, t1
    #li a7, 34
    #ecall
    #ret
    
