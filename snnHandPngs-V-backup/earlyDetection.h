/*
 * earlyDetection.h
 *
 *  Created on: Sep 16, 2015
 *      Author: banafsheh
 */

#include <vector>
#ifndef EARLYDETECTION_H_
#define EARLYDETECTION_H_

int  earlyDetection(std::vector<double>& inputNeuronVec, std::vector<double>& inputTimeVec,
		std::vector<std::string>& currentModel, double* a, double* d, double dpre[][51],
		double delay[][23], double ppre[][51], double post[][23], double pp[][23], double pre[][51],
		double s[][23], bool* pngOutput, int anchors[][3], int N, int D, int T);


#endif /* EARLYDETECTION_H_ */
