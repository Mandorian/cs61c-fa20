.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#sd
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:
    # Prologue
    addi sp, sp, -28
    sw ra, 0(sp)
    sw t0, 4(sp)
    sw a3, 8(sp)
    sw s1, 12(sp)
    sw s2, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)

    add s1, a1, x0
    add s2, a2, x0
    addi s5, x0, -1

open_file:
    addi a1, a0, 0
    addi a2, x0, 0
    jal fopen
    beq a0, s5, exception90
    addi s4, a0, 0

to_read_rows_and_cols:
    add a1, s4, x0
    add a2, s1, x0
    addi a3, x0, 4

    addi sp, sp, -4
    sw a3, 0(sp)
    jal fread
    lw a3, 0(sp)
    bne a0, a3, exception91

    add a2, s2, x0
    jal fread
    lw a3, 0(sp)
    bne a0, a3, exception91
    addi sp, sp, 4

invoke_malloc:
    lw t1, 0(s1)
    lw t2, 0(s2)
    mul t0, t1, t2
    slli t0, t0, 2
    addi a0, t0, 0

    addi sp, sp, -4
    sw t0, 0(sp)
    jal malloc
    lw t0, 0(sp)
    addi sp, sp, 4
    beq a0, x0, exception88

to_read_matrix:
    add a1, s4, x0
    add a2, a0, x0
    add a3, t0, x0

    addi sp, sp, -4
    sw a0, 0(sp)

    addi sp, sp, -4
    sw a3, 0(sp)
    jal fread
    lw a3, 0(sp)
    addi sp, sp, 4
    bne a0, a3, exception91

    jal fclose
    beq a0, s5, exception92

    lw a0, 0(sp)
    addi sp, sp 4

return_cols_and_rows:
    add a1, s1, x0
    add a2, s2, x0

    # Epilogue
    lw ra, 0(sp)
    lw t0, 4(sp)
    lw a3, 8(sp)
    lw s1, 12(sp)
    lw s2, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28

    ret

exception90:
    li a1, 90
    j exit2

exception88:
    li a1, 88
    j exit2

exception91:
    li a1, 91
    j exit2

exception92:
    li a1, 92
    j exit2
