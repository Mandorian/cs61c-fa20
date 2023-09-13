#include "lfsr.h"
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

uint16_t getBit(uint16_t val, int n) { return val >> n & 1; }

void lfsr_calculate(uint16_t *reg) {
    /* YOUR CODE HERE */
    uint16_t val =
        getBit(*reg, 0) ^ getBit(*reg, 2) ^ getBit(*reg, 3) ^ getBit(*reg, 5);
    *reg >>= 1;
    *reg |= (val << 15);
}
