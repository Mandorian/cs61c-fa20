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
    addi t0, x0, 0
    lw t1, 0(a0)

loop_start:
    bge x0, a1, exception

loop_continue:
    beq t0, a1, loop_end
    slli t2, t0, 2
    add t3, a0, t2
    addi t0, t0, 1

    lw t2, 0(t3)
    bge t1, t2, loop_continue
    addi t1, t2, 0
    jal x0 loop_continue

loop_end:
    # Epilogue
    addi a0, t1, 0

    ret

exception:
    li a1, 77
    j exit2
