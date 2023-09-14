.globl classify

.data

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    addi t0, x0, 5
    bne a0, t0, exception89

    addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw ra, 28(sp)

    add s0, a0, x0
    add s1, a1, x0
    add s2, a2, x0

    # =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
    addi sp, sp, -8
    lw a0, 4(s1)
    addi a1, sp, 0
    addi a2, sp, 4
    jal read_matrix
    add s3, a0, x0

    # Load pretrained m1
    addi sp, sp, -8
    lw a0, 8(s1)
    addi a1, sp, 0
    addi a2, sp, 4
    jal read_matrix
    add s4, a0, x0

    # Load input matrix
    addi sp, sp, -8
    lw a0, 12(s1)
    addi a1, sp, 0
    addi a2, sp, 4
    jal read_matrix
    add s5, a0, x0

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    lw a0, 16(sp)
    lw a1, 4(sp)
    mul a0, a0, a1
    slli a0, a0, 2
    jal malloc
    beq a0, x0, exception88

    lw a1, 16(sp)
    lw a2, 20(sp)
    lw a4, 0(sp)
    lw a5, 4(sp)
    add a3, s5, x0
    add s6, a0, x0
    add a6, a0, x0
    add a0, s3, x0
    jal matmul


    lw a1, 4(sp)
    lw a0, 16(sp)
    mul a1, a1, a0
    add a0, s6, x0
    jal relu

    lw a0, 8(sp)
    lw a1, 4(sp)
    mul a0, a0, a1
    slli a0, a0, 2
    jal malloc
    beq a0, x0, exception88

    lw a1, 8(sp)
    lw a2, 12(sp)
    add a3, s6, x0
    lw a4, 16(sp)
    lw a5, 4(sp)
    add s0, a0, x0
    add a6, a0, x0
    add a0, s4, x0
    jal matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================

    # Write output matrix
    lw a0, 16(s1)
    add a1, s0, x0
    lw a2, 8(sp)
    lw a3, 4(sp)
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================

    # Call argmax
    lw a1, 8(sp)
    lw a0, 4(sp)
    mul a1, a1, a0
    add a0, s0, x0
    jal argmax

    # Print classification
    bne s2, x0, else
    add a1, a0, x0
    jal print_int

    # Print newline afterwards for clarity
    addi a1, x0, '\n'
    jal print_char

    else:
    add a0, s3, x0
    jal free
    add a0, s4, x0
    jal free
    add a0, s5, x0
    jal free
    add a0, s6, x0
    jal free
    add a0, s0, x0
    jal free
    addi sp, sp, 24

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32

    ret

exception88:
    li a1, 88
    jal exit2

exception89:
    li a1, 89
    jal exit2
