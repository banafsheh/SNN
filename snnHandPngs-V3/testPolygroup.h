/*
 * testPolygroup.h
 *
 *  Created on: Jul 28, 2015
 *      Author: banafsheh
 */

#ifndef TESTPOLYGROUP_H_
#define TESTPOLYGROUP_H_

__global__ void testPolygroup(double* a, double* d, double* dpre,
		double* delay, double* ppre, double* post,
		double* pp, double* pre, double* s,
		bool* pngOutput, int* anchors, int* N, int* D, int* T,
		double* inputNeur, double* inputTime, int* anchorSize,double* I);

#endif /* TESTPOLYGROUP_H_ */
