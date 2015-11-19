/*

 * HANDLE_ERROR.cu
 *
 *  Created on: Aug 5, 2015
 *      Author: banafsheh
 */
#include <stdio.h>
#include <iostream>
#include "HANDLE_ERROR.h"

static void HandleError( cudaError_t err, const char *file, int line ) {
	if (err != cudaSuccess) {
		printf( "%s in %s at line %d\n", cudaGetErrorString( err ),
				file, line );
		exit( EXIT_FAILURE );
	}
}

#define HANDLE_ERROR( err ) (HandleError( err, __FILE__, __LINE__ ))


