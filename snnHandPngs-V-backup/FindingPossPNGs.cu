/*

 * FindingPossPNGs.cu
 *
 *  Created on: Sep 20, 2015
 *      Author: banafsheh
 */

int* FinigPossPNGs(int size)
{

	int i = 0, j = 0, k = 0, i1 = 0;

	for (i = 1; i < size-2; i++) {
		for (j = i + 1; j < size-1; j++) {

				anchors[i1][0] = i;
				anchors[i1][1] = j;
				anchors[i1][2] = k;
				i1++;

		}
	}

	return anchors;
}
