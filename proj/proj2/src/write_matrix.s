.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:
    # Prologue
    addi sp, sp, -24
    sw ra, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)

    add s1, a1, x0
    add s2, a2, x0
    add s3, a3, x0
    addi s5, x0, -1

open_file:
    add a1, a0, x0
    addi a2, x0, 1
    jal fopen
    beq a0, s5, exception93
    add s4, a0, x0

write:
    add a1, x0, s4
    addi a3, x0, 2
    addi a4, x0, 4
    addi sp, sp, -12
    sw s2, 0(sp)
    sw s3, 4(sp)
    sw a3, 8(sp)
    add a2, sp, x0
    jal fwrite
    lw s2, 0(sp)
    lw s3, 4(sp)
    lw a3, 8(sp)
    addi sp, sp, 12
    blt a0, a3, exception94

    add a1, s4, x0
    add a2, s1, x0
    mul a3, s2, s3
    addi sp, sp, -8
    sw a3, 0(sp)
    sw a4, 4(sp)
    jal fwrite
    lw a3, 0(sp)
    lw a4, 4(sp)
    blt a0, a3, exception94
    addi sp, sp, 8

close:
    add a1, s4, x0
    jal fclose
    beq a0, s5, exception95

    lw ra, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    addi sp, sp, 24
    # Epilogue

    ret

exception93:
    li a1, 93
    j exit2

exception94:
    li a1, 94
    j exit2

exception95:
    li a1, 95
    j exit2
