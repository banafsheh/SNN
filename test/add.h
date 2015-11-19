/*
 * add.h
 *
 *  Created on: Jul 27, 2015
 *      Author: banafsheh
 */

#ifndef ADD_H_
#define ADD_H_


// This is the number of elements we want to process.
#define N 1024

// This is the declaration of the function that will execute on the GPU.
__global__ void add(int*, int*, int*);


#endif /* ADD_H_ */
