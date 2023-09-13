/************************************************************************
 **
 ** NAME:        imageloader.c
 **
 ** DESCRIPTION: CS61C Fall 2020 Project 1
 **
 ** AUTHOR:      Dan Garcia  -  University of California at Berkeley
 **              Copyright (C) Dan Garcia, 2020. All rights reserved.
 **              Justin Yokota - Starter Code
 **				YOUR NAME HERE
 **
 **
 ** DATE:        2020-08-15
 **
 **************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

//Opens a .ppm P3 image file, and constructs an Image object. 
//You may find the function fscanf useful.
//Make sure that you close the file with fclose before returning.
Image *readData(char *filename) 
{
    FILE *fp = fopen(filename, "r");
    if (fp == NULL) {
        printf("Fail to open .ppm file");
        return NULL;
    }

    Image* img = (Image*)malloc(sizeof(Image));
    char flag[3];
    uint32_t colorNum;

    fscanf(fp, "%s", flag);
    if (flag[0] != 'P' || flag[1] != '3') {
        printf("Wrong .ppm file format");
        return NULL;
    }

    fscanf(fp, "%u %u %u", &img->cols, &img->rows, &colorNum);
    if (img->cols < 0 || img->rows < 0 || colorNum != 255) {
        printf("Wrong .ppm file format");
        return NULL;
    }

    img->image = (Color**)malloc(sizeof(Color*) * img->rows);
    for (int i = 0; i < img->rows; ++ i) {
        img->image[i] = (Color*)malloc(sizeof(Color) * img->cols);
        for (int j = 0; j < img->cols; ++ j) {
            fscanf(fp, "%hhu %hhu %hhu", &img->image[i][j].R, &img->image[i][j].G, &img->image[i][j].B);
        }
    }

    fclose(fp);
    return img;
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
    //YOUR CODE HERE
    printf("P3\n%u %u\n255\n", image->cols, image->rows);

    Color** p = image->image;
    for (int i = 0; i < image->rows; ++ i) {
        for (int j = 0; j < image->cols - 1; ++ j) {
            printf("%3hhu %3hhu %3hhu   ", p[i][j].R, p[i][j].G, p[i][j].B);
        }
        printf("%3hhu %3hhu %3hhu\n", p[i][image->cols - 1].R, p[i][image->cols - 1].G, p[i][image->cols - 1].B);
    }
}

//Frees an image
void freeImage(Image *image)
{
    //YOUR CODE HERE
    for (int i = 0; i < image->rows; ++ i)
        free(image->image[i]);

    free(image->image);
    free(image);
}
