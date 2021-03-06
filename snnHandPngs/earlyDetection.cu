/*
 * earlyDetection.cu

 *
 *  Created on: Sep 16, 2015
 *      Author: banafsheh
 */

#include <stdio.h>
#include <iostream>
#include <fstream>
#include <sstream>
#include <cstring>
#include <vector>
#include <cmath>
#include <set>
#include "testPolygroup.h"
#include "FindingPossPNGs.h"
#include "ModelMaking.h"

int earlyDetection(std::vector<double>& inputNeuronVec,
		std::vector<double>& inputTimeVec,
		std::vector<std::string>& currentModel, double* a, double* d,
		double dpre[][51], double delay[][23], double ppre[][51],
		double post[][23], double pp[][23], double pre[][51],
		double s[][23]/*, bool* pngOutput, int anchors[][3]*/, int N, int D,
		int T) {
	int SIZE = 955;
	//double* inputNueronArray = new double[inputNeuronVec.size()];
	//int* inputTimeArray = new int[inputTimeVec.size()];
	double* inputNeur = &inputNeuronVec[0];
	double* inputTime = &inputTimeVec[0];
	//double* inputNueronArray= new double [inputNeuronVec.size()];
	int i = 0, j = 0, k = 0, i1 = 0;

	/*for (i = 1; i < 8; i++) {
	 for (j = i + 1; j < 9; j++) {
	 for (k = j + 1; k < 10; k++) {
	 anchors[i1][0] = i;
	 anchors[i1][1] = j;
	 anchors[i1][2] = k;
	 i1++;
	 }
	 }
	 }*/
	int size = inputTimeVec.size() - 1;
	int anchorSize = ((size * (size - 1) * (size - 2)) / 6)
			- (((size - 1) * (size - 2) * (size - 3)) / 6);
	int* anchors = FindigPossPNGs(size);
	bool* pngOutput = new bool[anchorSize];
	for (i = 0; i < anchorSize; i++) {
		pngOutput[i] = false;
	}

	double* dev_a;
	double* dev_d;
	double* dev_dpre;
	double* dev_delay;
	double* dev_ppre;
	double* dev_post;
	double* dev_pp;
	double* dev_pre;
	double* dev_s;
	bool* dev_pngOutput;
	int* dev_anchors;
	int* dev_N;
	int* dev_D;
	int* dev_T;
	double* dev_inputTime;
	double* dev_inputNeur;
	int* dev_anchorSize;
	double* dev_I;
	//int* dev_psp_times;

	cudaError_t err = cudaMalloc((void**) &dev_a, 226 * sizeof(double));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	err = cudaMalloc((void**) &dev_d, 226 * sizeof(double));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	err = cudaMalloc((void**) &dev_dpre, 226 * 51 * sizeof(double));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	err = cudaMalloc((void**) &dev_delay, 226 * 23 * sizeof(double));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	err = cudaMalloc((void**) &dev_ppre, 226 * 51 * sizeof(double));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	err = cudaMalloc((void**) &dev_post, 226 * 23 * sizeof(double));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	err = cudaMalloc((void**) &dev_pp, 226 * 23 * sizeof(double));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	err = cudaMalloc((void**) &dev_pre, 226 * 51 * sizeof(double));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	err = cudaMalloc((void**) &dev_s, 226 * 23 * sizeof(double));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	err = cudaMalloc((void**) &dev_pngOutput, anchorSize * sizeof(bool));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	err = cudaMalloc((void**) &dev_anchors, anchorSize * 3 * sizeof(int));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	err = cudaMalloc((void**) &dev_inputNeur,
			inputNeuronVec.size() * sizeof(double));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	err = cudaMalloc((void**) &dev_inputTime,
			inputTimeVec.size() * sizeof(double));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	err = cudaMalloc((void**) &dev_N, 1 * sizeof(int));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}
	err = cudaMalloc((void**) &dev_D, 1 * sizeof(int));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}
	err = cudaMalloc((void**) &dev_T, 1 * sizeof(int));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	err = cudaMalloc((void**) &dev_anchorSize, 1 * sizeof(int));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	cudaEvent_t start, end;
	cudaEventCreate(&start);
	cudaEventCreate(&end);

	cudaEventRecord(start, 0);
	//todo please complete this part

	cudaMemcpy(dev_a, a, 226 * sizeof(double), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_d, d, 226 * sizeof(double), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_dpre, dpre, 226 * 51 * sizeof(double),
			cudaMemcpyHostToDevice);
	cudaMemcpy(dev_delay, delay, 226 * 23 * sizeof(double),
			cudaMemcpyHostToDevice);
	cudaMemcpy(dev_ppre, ppre, 226 * 51 * sizeof(double),
			cudaMemcpyHostToDevice);
	cudaMemcpy(dev_post, post, 226 * 23 * sizeof(double),
			cudaMemcpyHostToDevice);
	cudaMemcpy(dev_pp, pp, 226 * 23 * sizeof(double), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_pre, pre, 226 * 51 * sizeof(double), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_s, s, 226 * 23 * sizeof(double), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_pngOutput, pngOutput, anchorSize * sizeof(bool),
			cudaMemcpyHostToDevice);
	cudaMemcpy(dev_anchors, anchors, anchorSize * 3 * sizeof(int),
			cudaMemcpyHostToDevice);
	cudaMemcpy(dev_N, &N, 1 * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_D, &D, 1 * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_T, &T, 1 * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_inputTime, inputTime, inputTimeVec.size() * sizeof(double),
			cudaMemcpyHostToDevice);
	cudaMemcpy(dev_inputNeur, inputNeur, inputNeuronVec.size() * sizeof(double),
			cudaMemcpyHostToDevice);
	cudaMemcpy(dev_anchorSize, &anchorSize, 1 * sizeof(int),
			cudaMemcpyHostToDevice);
	//(SIZE + 255) / 256, 256
	//int blockSize = floor(anchorSize / 64) + 1;
	int blockSize = (anchorSize + 31) / 32;
	int threadSize = 32;
	//int blockSize = 32;
	//int threadSize = floor(anchorSize / blockSize) + 1;

	cudaDeviceSetLimit(cudaLimitMallocHeapSize, 1024 * 1024 * 200);
	//cudaDeviceSetLimit(cudaLimitStackSize,1024 * 1024 * 1800);

	err = cudaMalloc((void**) &dev_I,
			226 * (T + D + 301) * blockSize * threadSize * sizeof(double));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	/*err = cudaMalloc((void**) &dev_psp_times,
	 ((0.1*N)+1) * blockSize * threadSize * sizeof(int));
	 if (err != cudaSuccess) {
	 std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
	 exit(1);
	 }*/

	testPolygroup<<<blockSize, threadSize>>>(dev_a, dev_d, dev_dpre, dev_delay,
			dev_ppre, dev_post, dev_pp, dev_pre, dev_s, dev_pngOutput,
			dev_anchors, dev_N, dev_D, dev_T, dev_inputNeur, dev_inputTime,
			dev_anchorSize, dev_I);

	cudaMemcpy(pngOutput, dev_pngOutput, anchorSize * sizeof(bool),
			cudaMemcpyDeviceToHost);

	cudaEventRecord(end, 0);
	cudaEventSynchronize(end);

	float elapsedTime;
	cudaEventElapsedTime(&elapsedTime, start, end);

	std::cout << "\n Yay! Your program's results are correct." << std::endl;
	//std::cout << "Your program took: " << elapsedTime << " ms." << std::endl;

	//Model Making
	ModelMaking(pngOutput, anchors, anchorSize, inputNeur, inputTime,
			currentModel);
	//string* currentMod=&currentMod[0];
	/*for (k = 0; k < currentModel.size(); k++) {
	 std::cout << currentModel[k] <<",";
	 }*/
	//unique function
	std::set<std::string> uniqueCurrentModel(currentModel.begin(),
			currentModel.end());
	/*for (k = 0; k < uniqueCurrentModel.size(); k++) {
		std::cout << uniqueCurrentModel[k] << ",";
	}*/

	  while (!uniqueCurrentModel.empty()) {
	    std::cout << ' ' << *uniqueCurrentModel.begin();
	    uniqueCurrentModel.erase(uniqueCurrentModel.begin());
	  }

	// Cleanup in the event of success.
	cudaEventDestroy(start);
	cudaEventDestroy(end);

	cudaFree(dev_a);
	cudaFree(dev_d);
	cudaFree(dev_dpre);
	cudaFree(dev_delay);
	cudaFree(dev_ppre);
	cudaFree(dev_post);
	cudaFree(dev_pp);
	cudaFree(dev_pre);
	cudaFree(dev_s);
	cudaFree(dev_pngOutput);
	cudaFree(dev_anchors);
	cudaFree(dev_N);
	cudaFree(dev_D);
	cudaFree(dev_T);
	cudaFree(dev_inputTime);
	cudaFree(dev_inputNeur);
	cudaFree(dev_anchorSize);
	cudaFree(dev_I);

	return 1;

}

