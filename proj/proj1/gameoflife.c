/************************************************************************
 **
 ** NAME:        gameoflife.c
 **
 ** DESCRIPTION: CS61C Fall 2020 Project 1
 **
 ** AUTHOR:      Justin Yokota - Starter Code
 **				YOUR NAME HERE
 **
 **
 ** DATE:        2020-08-23
 **
 **************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
    //YOUR CODE HERE
    Color* color = (Color*)malloc(sizeof(Color));

    int countR = 0, countG = 0, countB = 0;
    for (int i = row - 1; i <= row + 1; ++ i) {
        for (int j = col - 1; j <= col + 1; ++ j) {
            if (i == row && j == col) continue;

            int x = (i + image->rows) % image->rows;
            int y = (j + image->cols) % image->cols;
            Color temp = image->image[x][y];
            if (temp.R == 255) countR ++ ;
            if (temp.G == 255) countG ++ ;
            if (temp.B == 255) countB ++ ;
        }
    }

    Color temp = image->image[row][col];
    int isLiveR = temp.R == 255;
    int isLiveG = temp.G == 255;
    int isLiveB = temp.B == 255;

    int offsetR = 9 * isLiveR + countR;
    int offsetG = 9 * isLiveG + countG;
    int offsetB = 9 * isLiveB + countB;

    if (rule & (1 << offsetR)) {
        color->R = 255;
    } else color->R = 0;
    if (rule & (1 << offsetG)) {
        color->G = 255;
    } else color->G = 0;
    if (rule & (1 << offsetB)) {
        color->B = 255;
    } else color->B = 0;

    return color;
}

//The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
//You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
{
    //YOUR CODE HERE
    Image* newImage = (Image*)malloc(sizeof(Image));
    newImage->rows = image->rows;
    newImage->cols = image->cols;
    newImage->image = (Color**)malloc(sizeof(Color*) * newImage->rows);

    for (int i = 0; i < newImage->rows; ++ i) {
        newImage->image[i] = (Color*)malloc(sizeof(Color) * newImage->cols);
        for (int j = 0; j < newImage->cols; ++ j) {
            Color* color = evaluateOneCell(image, i, j, rule);
            newImage->image[i][j] = *color;
            free(color);
        }
    }

    return newImage;
}

/*
   Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

   argc stores the number of arguments.
   argv stores a list of arguments. Here is the expected input:
   argv[0] will store the name of the program (this happens automatically).
   argv[1] should contain a filename, containing a .ppm.
   argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
   You may find the function strtol useful for this conversion.
   If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
   Otherwise, you should return from main with code 0.
   Make sure to free all memory before returning!

   You may find it useful to copy the code from steganography.c, to start.
   */
int main(int argc, char **argv)
{
    //YOUR CODE HERE
    if (argc != 3) {
        printf("usage: ./gameOfLife filename rule\nfilename is an ASCII PPM file (type P3) with maximum value 255.\nrule is a hex number beginning with 0x; Life is 0x1808.");
        return 1;
    }

    Image *img = readData(argv[1]);
    uint32_t rule = strtol(argv[2], NULL, 16);
    Image *newImg = life(img, rule);
    writeData(newImg);

    freeImage(img);
    freeImage(newImg);
    return 0;
}
