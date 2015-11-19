/*

 * FindingPossPNGs.cu
 *
 *  Created on: Sep 20, 2015
 *      Author: banafsheh
 */
#include "FindingPossPNGs.h"

int* FindigPossPNGs(int size) {
	int anchorSize = ((size * (size - 1) * (size - 2)) / 6)
			- (((size - 1) * (size - 2) * (size - 3)) / 6);

	int i = 0, j = 0, i1 = 0;

	int* anchors = new int[anchorSize * 3];
	/*for (i = 0; i < anchorSize; i++) {
	 anchors[i] = new int[3];
	 for (int j1 = 0; j1 <= 2; j1++) {
	 anchors[i][j1] = 0;
	 }
	 }*/
	//int anchors[size - 1][3];
	for (i = 1; i <= size - 2; i++) {
		for (j = i + 1; j <= size - 1; j++) {
			anchors[i1] = i;
			anchors[i1 + 1] =j;
			anchors[i1 + 2] =size;
			i1=i1+3;
		}
	}
	return anchors;
}
