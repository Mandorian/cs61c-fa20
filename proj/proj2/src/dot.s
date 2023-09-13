.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    bge x0, a2, exception1
    bge x0, a3, exception2
    bge x0, a4, exception2
    # Prologue
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)

    addi t0, x0, 0
    addi s0, x0, 0

loop_start:
    beq t0, a2, loop_end

    slli t1, t0, 2
    mul t1, t1, a3
    add t2, a0, t1
    lw s1, 0(t2)

    slli t1, t0, 2
    mul t1, t1, a4
    add t2, a1, t1
    lw s2, 0(t2)

    mul t1, s2, s1
    add s0, s0, t1
    addi t0, t0, 1

    jal x0, loop_start

loop_end:
    add a0, x0, s0

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 12

    ret

exception1:
    addi a1, x0, 75
    j exit2

exception2:
    addi a1, x0, 76
    j exit2
