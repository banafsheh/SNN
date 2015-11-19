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
#include <vector>
#include "testPolygroup.h"
#include "earlyDetection.h"

#define SIZE 955

int main() {

	int i = 0, j = 0, k = 0, i1 = 0;
	double a[226];
	double d[226];
	double dpre[226][51];
	double delay[226][23];
	double ppre[226][51];
	double post[226][23];
	double pp[226][23];
	double pre[226][51];
	double s[226][23];
	//bool pngOutput[SIZE];
	//int anchors[SIZE - 1][3];
	int N = 225;
	int D = 20;
	int T = 300;
	//todo these are hard code, we have to change it
	double inputTime[54];
	double inputNeur[54];

	std::ifstream readera("a.txt");
	std::ifstream readerd("d.txt");
	std::ifstream readerdpre("dpre.txt");
	std::ifstream readerdelay("delay.txt");
	std::ifstream readerppre("ppre.txt");
	std::ifstream readerpost("post.txt");
	std::ifstream readerpp("pp.txt");
	std::ifstream readerpre("pre.txt");
	std::ifstream readers("s.txt");
	std::ifstream readerinNeur("neur.txt");
	std::ifstream readerinTime("time.txt");

	i = 1;
	while (!readera.eof()) {
		readera >> a[i++];
	}

	i = 1;

	while (!readerd.eof()) {
		readerd >> d[i++];
	}

	i = 1;
	j = 1;
	while (!readerdpre.eof()) {
		std::string line;
		std::getline(readerdpre, line);
		std::stringstream reader(line);
		while (!reader.eof()) {
			reader >> dpre[i][j++];
		}
		if (j < 51) {
			for (int jj = j; jj <= 50; jj++)
				dpre[i][jj] = 0.0;
		}
		j = 1;
		i++;
	}

	i = 1, j = 1;

	while (!readerdelay.eof()) {
		std::string line;
		std::getline(readerdelay, line);
		std::stringstream reader(line);
		while (!reader.eof()) {
			reader >> delay[i][j++];
		}
		j = 1;
		i++;
	}

	i = 1, j = 1;

	while (!readerppre.eof()) {
		std::string line;
		std::getline(readerppre, line);
		std::stringstream reader(line);
		while (!reader.eof()) {
			reader >> ppre[i][j++];
		}
		if (j < 51) {
			for (int jj = j; jj <= 50; jj++)
				ppre[i][jj] = 0.0;
		}
		j = 1;
		i++;
	}

	i = 1, j = 1;

	while (!readerpost.eof()) {
		std::string line;
		std::getline(readerpost, line);
		//std::cout<<line;
		std::stringstream reader(line);
		while (!reader.eof()) {
			reader >> post[i][j++];
		}
		j = 1;
		i++;
	}

	i = 1, j = 1;

	while (!readerpp.eof()) {
		std::string line;
		std::getline(readerpp, line);
		//std::cout << line << "**********\n" <<std::endl;
		std::stringstream reader(line);
		while (!reader.eof()) {
			reader >> pp[i][j++];
		}
		j = 1;
		i++;
	}

	i = 1, j = 1;

	while (!readerpre.eof()) {
		std::string line;
		std::getline(readerpre, line);
		std::stringstream reader(line);
		while (!reader.eof()) {
			reader >> pre[i][j++];
		}
		if (j < 51) {
			for (int jj = j; jj <= 50; jj++)
				pre[i][jj] = 0.0;
		}
		j = 1;
		i++;
	}

	i = 1, j = 1;

	while (!readers.eof()) {
		std::string line;
		std::getline(readers, line);
		//std::cout << line <<std::endl;
		std::stringstream reader(line);
		//std::cout << reader(line) <<std::endl;
		while (!reader.eof()) {
			reader >> s[i][j++];
		}
		j = 1;
		i++;
	}

	i = 1;
	while (!readerinTime.eof()) {
		std::string line;
		std::getline(readerinTime, line);
		//std::cout << line << std::endl;
		std::stringstream reader(line);
		while (!reader.eof()) {
			reader >> inputTime[i++];
		}
	}

	i = 1;
	while (!readerinNeur.eof()) {
		std::string line;
		std::getline(readerinNeur, line);
		//std::cout << line << std::endl;
		std::stringstream reader(line);
		while (!reader.eof()) {
			reader >> inputNeur[i++];
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
	readerinNeur.close();
	readerinTime.close();

	std::vector<std::string> currentModel;
	std::vector<double> inputNeuronVec;
	std::vector<double> inputTimeVec;

	inputNeuronVec.push_back(0);
	inputNeuronVec.push_back(inputNeur[1]);
	inputNeuronVec.push_back(inputNeur[2]);
	inputTimeVec.push_back(0);
	inputTimeVec.push_back(inputTime[1]);
	inputTimeVec.push_back(inputTime[2]);

	int classNum = 0;
	for (i = 3; i < 54; i++) {

		inputNeuronVec.push_back(inputNeur[i]);
		inputTimeVec.push_back(inputTime[i]);

		classNum = earlyDetection(inputNeuronVec, inputTimeVec, currentModel, a,
				d, dpre, delay, ppre, post, pp, pre, s, /*pngOutput,*/N, D, T);
		std::cout << i;
	}

}

