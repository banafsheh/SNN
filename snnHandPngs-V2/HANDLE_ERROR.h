/*
 * HANDLE_ERROR.h
 *
 *  Created on: Aug 5, 2015
 *      Author: banafsheh
 */

#ifndef HANDLE_ERROR_H_
#define HANDLE_ERROR_H_


static void HandleError( cudaError_t err,
                         const char *file,
                         int line );


#endif /* HANDLE_ERROR_H_ */
