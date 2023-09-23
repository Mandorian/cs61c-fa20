.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    # Prologue
    bge x0, a1, exception77

    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)

    add s0, a0, x0
    addi s1, x0, 0
    addi t0, x0, 0

loop_start:
    beq t0, a1, loop_end
    slli t1, t0, 2
    add t1, s0, t1
    lw t1, 0(t1)
    addi t0, t0, 1

    bge s1, t1, loop_start
    add s1, t1, x0
    add a0, t0, x0
    addi a0, a0, -1

    j loop_start

loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
    ret

exception77:
    li a1, 77
    j exit2
