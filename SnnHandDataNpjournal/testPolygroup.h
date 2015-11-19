/*
 * testPolygroup.h
 *
 *  Created on: Jul 28, 2015
 *      Author: banafsheh
 */

#ifndef TESTPOLYGROUP_H_
#define TESTPOLYGROUP_H_

__global__ void testPolygroup(double* a, double* d, double* dpre[50], double* delay[22],
		double* ppre[50], double* post[22], double* pp[22], double* pre[50], double* s[22],
		bool* pngOutput, int* anchors[3], int* N, int* D, int* T,
		double* inputNeur, int* inputTime);


#endif /* TESTPOLYGROUP_H_ */
