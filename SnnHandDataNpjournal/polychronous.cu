/*
 * polychronous.cu
 *
 *  Created on: Jul 28, 2015
 *      Author: banafsheh
 */

#include <iostream>
#include <fstream>
#include <sstream>
#include <cstring>
#include "testPolygroup.h"

int main() {

	int i = 0, j = 0, k = 0, i1 = 0;
	double a[225];
	double d[225];
	double dpre[225][50];
	double delay[225][22];
	double ppre[225][50];
	double post[225][22];
	double pp[225][22];
	double pre[225][50];
	double s[225][22];
	bool pngOutput[1873200];
	int anchors[1873200][3];
	int N[1]= {225};
	int D[1] = {20};
	int T[1] = {300};
	//todo these are hard code, we have to change it
	int inputTime[53];
	double inputNeur[53];

	std::ifstream readera;
	std::ifstream readerd;
	std::ifstream readerdpre;
	std::ifstream readerdelay;
	std::ifstream readerppre;
	std::ifstream readerpost;
	std::ifstream readerpp;
	std::ifstream readerpre;
	std::ifstream readers;
	std::ifstream readerinputTime;
	std::ifstream readerinputNeur;

	readera.open("a.txt");
	readerd.open("d.txt");
	readerdpre.open("dpre.txt");
	readerdelay.open("delay.txt");
	readerdelay.open("ppre.txt");
	readerdelay.open("post.txt");
	readerdelay.open("pp.txt");
	readerdelay.open("pre.txt");
	readerdelay.open("s.txt");
	readerdelay.open("inputTime.txt");
	readerdelay.open("inputNeur.txt");

	while (!readera.eof()) {
		readera >> a[i++];
	}

	i = 0;

	while (!readerd.eof()) {
		readerd >> d[i++];
	}

	i = 0;

	while (!readerdpre.eof()) {
		std::string line;
		std::getline(readerdpre, line);
		std::stringstream reader(line);
		while (!reader.eof()) {
			reader >> dpre[i][j++];
		}
		j = 0;
		i++;
	}

	i = 0, j = 0;

	while (!readerdelay.eof()) {
		std::string line;
		std::getline(readerdelay, line);
		std::stringstream reader(line);
		while (!reader.eof()) {
			reader >> delay[i][j++];
		}
		j = 0;
		i++;
	}

	i = 0, j = 0;

	while (!readerppre.eof()) {
		std::string line;
		std::getline(readerppre, line);
		std::stringstream reader(line);
		while (!reader.eof()) {
			reader >> ppre[i][j++];
		}
		j = 0;
		i++;
	}

	i = 0, j = 0;

	while (!readerpost.eof()) {
		std::string line;
		std::getline(readerpost, line);
		std::stringstream reader(line);
		while (!reader.eof()) {
			reader >> post[i][j++];
		}
		j = 0;
		i++;
	}

	i = 0, j = 0;

	while (!readerpp.eof()) {
		std::string line;
		std::getline(readerpp, line);
		std::stringstream reader(line);
		while (!reader.eof()) {
			reader >> pp[i][j++];
		}
		j = 0;
		i++;
	}

	i = 0, j = 0;

	while (!readerpre.eof()) {
		std::string line;
		std::getline(readerpre, line);
		std::stringstream reader(line);
		while (!reader.eof()) {
			reader >> pre[i][j++];
		}
		j = 0;
		i++;
	}

	i = 0, j = 0;

	while (!readers.eof()) {
		std::string line;
		std::getline(readers, line);
		std::stringstream reader(line);
		while (!reader.eof()) {
			reader >> s[i][j++];
		}
		j = 0;
		i++;
	}

	i = 0;

	while (!readerinputNeur.eof()) {
		std::string line;
		std::getline(readerinputNeur, line);
		std::stringstream reader(line);
		while (!reader.eof()) {
			reader >> inputNeur[i++];
		}
	}

	i = 0;

	while (!readerinputTime.eof()) {
		std::string line;
		std::getline(readerinputTime, line);
		std::stringstream reader(line);
		while (!reader.eof()) {
			reader >> inputTime[i++];
		}
	}

	readera.close();
	readerdpre.close();
	readerd.close();
	readerdelay.close();
	readerppre.close();
	readerpost.close();
	readerpp.close();
	readerpre.close();
	readers.close();
	readerinputNeur.close();
	readerinputTime.close();

	for (i = 0; i < 222; i++) {
		for (j = i; j < 223; j++) {
			for (k = j; k < 224; k++) {
				anchors[i1][0] = i + 1;
				anchors[i1][1] = j + 1;
				anchors[i1][2] = k + 1;
				i1++;
			}
		}
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
	int* dev_inputTime;
	double* dev_inputNeur;

	cudaError_t err = cudaMalloc((void**) &dev_a, 225 * sizeof(double));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	err = cudaMalloc((void**) &dev_d, 225 * sizeof(double));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	err = cudaMalloc((void**) &dev_dpre, 225 * 50 * sizeof(double));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	err = cudaMalloc((void**) &dev_delay, 225 * 22 * sizeof(double));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	err = cudaMalloc((void**) &dev_ppre, 225 * 50 * sizeof(double));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	err = cudaMalloc((void**) &dev_post, 225 * 22 * sizeof(double));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	err = cudaMalloc((void**) &dev_pp, 225 * 22 * sizeof(double));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	err = cudaMalloc((void**) &dev_pre, 225 * 50 * sizeof(double));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	err = cudaMalloc((void**) &dev_s, 225 * 22 * sizeof(double));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	err = cudaMalloc((void**) &dev_pngOutput, 1873200 * sizeof(bool));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	err = cudaMalloc((void**) &dev_anchors, 1873200 * 3 * sizeof(int));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	err = cudaMalloc((void**) &dev_inputNeur, 53 * sizeof(double));
	if (err != cudaSuccess) {
		std::cerr << "Error: " << cudaGetErrorString(err) << std::endl;
		exit(1);
	}

	err = cudaMalloc((void**) &dev_inputTime, 53 * sizeof(int));
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

	cudaEvent_t start, end;
	cudaEventCreate(&start);
	cudaEventCreate(&end);

	cudaEventRecord(start, 0);
	//todo please complete this part
	cudaMemcpy(dev_a, a, 225 * sizeof(double), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_dpre, dpre, 225 * 50 * sizeof(double),
			cudaMemcpyHostToDevice);
	cudaMemcpy(dev_pngOutput, pngOutput, 1873200 * sizeof(double),
			cudaMemcpyHostToDevice);

	testPolygroup<<<100, 100>>>(dev_a, dev_d, &dev_dpre, &dev_delay, &dev_ppre,
			&dev_post, &dev_pp, &dev_pre, &dev_s, dev_pngOutput, &dev_anchors, dev_N,
			dev_D, dev_T, dev_inputNeur, dev_inputTime);

	  cudaEventRecord( end, 0 );
	  cudaEventSynchronize( end );

	  float elapsedTime;
	  cudaEventElapsedTime( &elapsedTime, start, end );

	  std::cout << "Yay! Your program's results are correct." << std::endl;
	  std::cout << "Your program took: " << elapsedTime << " ms." << std::endl;

	  // Cleanup in the event of success.
	  cudaEventDestroy( start );
	  cudaEventDestroy( end );

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

}

