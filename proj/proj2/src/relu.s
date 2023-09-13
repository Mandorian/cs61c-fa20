.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    addi t0, x0, 0

loop_start:
    bge x0, a1, exception

loop_continue:
    beq t0, a1, loop_end
    slli t1, t0, 2
    add t2, a0, t1
    addi t0, t0, 1

    lw t1, 0(t2)
    bge t1, x0, loop_continue
    sw x0, 0(t2)
    jal x0, loop_continue

loop_end:
    # Epilogue
	ret

exception:
    li a1, 78
    j exit2
