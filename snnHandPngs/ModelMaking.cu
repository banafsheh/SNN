/*
 * ModelMaking.cu
 *
 *  Created on: Oct 25, 2015
 *      Author: banafsheh
 */
#include "ModelMaking.h"
#include "math.h"
#include <cstring>
#include <string>
#include <vector>
#include <sstream>

void ModelMaking(bool* pngOutput, int* anchors, int anchorSize,
		double* inputNeur, double* inputTime,
		std::vector<std::string>& currentModel) {

	//std::vector<std::string> currentModel;
	int i1 = 0;
	for (int i = 0; i < anchorSize; i++) {
		if (pngOutput[i] == true) {
			int numDigit1 = 0, numDigit2 = 0;
			/////////////////////////////////////round angle
			double digit1 = inputNeur[anchors[i1]] - 5;
			if (digit1 < 0) {
				digit1 = digit1 + 360;
			}
			digit1 = ceil((float) digit1 / (float) 10) * 10 + 5;
			if (digit1 > 360) {
				digit1 = (int) digit1 % 10;
			}
			////////////////////////////////////////
			double digit2 = inputNeur[anchors[i1 + 1]] - 5;
			if (digit2 < 0) {
				digit2 = digit2 + 360;
			}
			digit2 = ceil((float) digit2 / (float) 10) * 10 + 5;
			if (digit2 > 360) {
				digit2 = (int) digit2 % 10;
			}
			////////////////////////////////////////
			double digit3 = inputNeur[anchors[i1 + 2]] - 5;
			if (digit3 < 0) {
				digit3 = digit3 + 360;
			}
			digit3 = ceil((float) digit3 / (float) 10) * 10 + 5;
			if (digit3 > 360) {
				digit3 = (int) digit3 % 10;
			}
			////////////////////////////////////////
			long digit1_l = digit1;
			long digit2_l = digit2;
			/////////////////////////////////////
			//if (number < 0)
			//digits = 1; // remove this line if '-' counts as a digit
			while (digit1) {
				digit1 = (int) digit1 / 10;
				numDigit1++;
			}

			while (digit2) {
				digit2 = (int) digit2 / 10;
				numDigit2++;
			}

			//fg=c11*power(10,e2+e3+2);
			//fg1=c22*power(10,e3+1);
			//fg2=c33;
			//fgg=fg+fg1+fg2;

			digit1_l = digit1_l * pow(10, numDigit1 + numDigit2 + 2);
			digit2_l = digit2_l * pow(10, numDigit2 + 1);
			long pngInd = (long) (digit1_l + digit2_l + digit3);

			std::string number;
			std::stringstream strstream;
			strstream << pngInd;
			strstream >> number;
			currentModel.push_back(number);
			int a;
			int b;
			a = a + b;


		}
		i1 = i1 + 3;
	}

}

