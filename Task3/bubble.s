.section .data
    array: .word 5, 2, 9, 1, 5, 6, 3, 7, 8, 4
    space : .string " "
.section .text
    .global _start 

_start:
    la t0, array       # 加载数组地址到t0
    li t1, 40          # 加载数组长度到t1
    li t2, 0           # 外循环计数器 i

outer_loop:
    beq t2, t1, print_array # 外循环结束条件
    li t3, 0                # 内循环计数器 j

inner_loop:
    add t4, t0, t3     # t4 = &array[j]
    lw t5, 0(t4)       # t5 = array[j]
    lw t6, 4(t4)       # t6 = array[j+1]
    blt t5, t6, no_swap # If array[j] < array[j+1], no swap
    sw t6, 0(t4)       # array[j] = array[j+1]
    sw t5, 4(t4)       # array[j+1] = array[j]

no_swap:
    addi t3, t3, 4     # j+=4
    blt t3, t1, inner_loop # If j < length, 继续内循环

    addi t2, t2, 4     # i+=4;
    j outer_loop       # 继续外循环

print_array:
    la t0, array       # 加载数组地址到t0
    li t1, 40          # 加载数组长度到t1
    li t2, 0           # 计数器 i

print_loop:
    beq t2, t1, end_print # 如果 i == length, 结束打印
    add t3, t0, t2     # t3 = &array[i]
    lw a0, 0(t3)       # a0 = array[i]
    li a7, 1           # 调用代码 1 (print integer)
qwq:
    # ecall            # 系统调用会莫名卡死，调试后也没有排除问题，所以输出采用的是gdb交叉调试追踪寄存器的方式
    la a0, space       # 打印空格
    li a7, 4           # 调用代码 4 (print string)
    # ecall

    addi t2, t2, 4     # i++
    j print_loop       # 继续打印循环

end_print:
    j end              # 跳转到结束
end:
    li a7, 93
    li a0, 0          # 退出系统调用
    # ecall
