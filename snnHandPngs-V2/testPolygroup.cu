/*
 * testPolygroup.cu
 *
 *  Created on: Jul 28, 2015
 *      Author: banafsheh
 */

#include "testPolygroup.h"
#include <stdio.h>
#include "FindingPossPNGs.h"

__global__ void testPolygroup(double* a, double* d, double* dpre, double* delay,
		double* ppre, double* post, double* pp, double* pre, double* s,
		bool* pngOutput, int* anchors, int* N, int* D, int* T,
		double* inputNeur, double* inputTime, int* anchorSize) {

	int i = 0, j = 0, k = 0, tf = 0, t = 0, gr = 1;
	//hard code
	int v1[6];
	int v2[6];
	int v3[6];
	int t0[4];
	int anch[4];
	int numSynapse = (int) (0.1 * (*N));
	double* v = new double[(*N) + 1];
	double* u = new double[(*N) + 1];

	int* last_fired = new int[(*N) + 1];
	for (i = 0; i <= (*N) + 1; i++) {
		last_fired[i] = 0;
	}
	int* psp_times = new int[numSynapse + 1];
	for (i = 0; i <= numSynapse; i++) {
		psp_times[i] = 0;
	}
	int group_firings[300][3];
	int group_gr[300][6];

	for (i = 0; i <= 300; i++) {
		//printf("%d", i);

		for (int j2 = 0; j2 <= 2; j2++) {
			group_firings[i][j2] = 0;
		}
		for (int j2 = 0; j2 <= 5; j2++) {
			group_gr[i][j2] = 0;
		}
	}

	int* fired_path = new int[(*N) + 1];

	for (i = 0; i <= (*N) + 1; i++) {
		fired_path[i] = 0;
	}

	int min_group_path = 3;
	int longest_path;

	//int blockId = blockIdx.x;
	//int threadId = threadIdx.x;
	//TODO compute the actual index
	int inputIndex = threadIdx.x + blockIdx.x * blockDim.x;
	if (inputIndex >= (*anchorSize)) {
		return;
	}
	//if (inputIndex < (*anchorSize)) {
	//if ((inputIndex == 0 || inputIndex == 1 || inputIndex == 2
	//|| inputIndex == 3 || inputIndex == 4 ) && inputIndex < (*anchorSize)) {
	//if (inputIndex < (*anchorSize)) {
	//inputIndex++;
	anch[1] = anchors[inputIndex * 3];
	anch[2] = anchors[inputIndex * 3 + 1];
	anch[3] = anchors[inputIndex * 3 + 2];
	//printf("after for loop %d \n", inuputIndex);

	for (i = 1; i <= 5; i++) {
		v1[i] = ((((int) inputNeur[anch[1]] + 4) % 360) / 10) * 5 + i;
		v2[i] = ((((int) inputNeur[anch[2]] + 4) % 360) / 10) * 5 + i;
		v3[i] = ((((int) inputNeur[anch[3]] + 4) % 360) / 10) * 5 + i;
	}

	for (i = 1; i <= 3; i++) {
		t0[i] = inputTime[anch[i]];
	}

	volatile int t1 = 0;
	t1 = t0[1] + (anch[1] - 1) * 4;
	int t2 = t0[2] + (anch[2] - 1) * 4;
	int t3 = t0[3] + (anch[3] - 1) * 4;

	double** I = new double*[(*N) + 1];
	for (i = 1; i <= (*N); i++) {
		I[i] = new double[(*T) + (*D) + 301];
		for (int j1 = 1; j1 <= (*T) + (*D) + 300; j1++) {
			I[i][j1] = 0.0;
		}
	}

	for (i = 1; i <= (*N); i++) {
		v[i] = -70;
		u[i] = 0.2 * v[i];
		last_fired[i] = -(*T);

	}

	i = 1;

	for (i = 1; i <= 5; i++) {
		I[v1[i]][++t1] = 20;
		//printf("%d,%d,%d\n",I[v1[i]][t1],v1[i],t1);
		I[v2[i]][++t2] = 20;
		//printf("\n%d,%d,%d\n",I[v2[i]][t2],v2[i],t2);
		I[v3[i]][++t3] = 20;
		//printf("%d,%d,%d\n",I[v3[i]][t3],v3[i],t3);
		/*I[v1[i] * ((*T) + (*D) + 500) + (++t1)] = 20;
		 I[v2[i] * ((*T) + (*D) + 500) + (++t2)] = 20;
		 I[v3[i] * ((*T) + (*D) + 500) + (++t3)] = 20;*/
	}

	i = 0;
	t = 0;
	j = 0;
	for (t = 1; t <= (*T); t++) {
		int recent[51];
		for (int jj = 0; jj < 51; jj++) {
			recent[jj] = 0;
		}

		//v=v+0.5*((0.04*v+5).*v+140-u+ I(:,t));    % for numerical
		//v=v+0.5*((0.04*v+5).*v+140-u+ I(:,t));    % stability time
		//u=u+a.*(0.2*v-u);                   % step is 0.5 ms6
		for (i = 1; i <= (*N); i++) {

			v[i] += 0.5 * ((0.04 * v[i] + 5) * v[i] + 140 - u[i] + I[i][t]);
			v[i] += 0.5 * ((0.04 * v[i] + 5) * v[i] + 140 - u[i] + I[i][t]);
			u[i] += a[i] * (0.2 * v[i] - u[i]);
		}

		//fired = find(v>=30);                % indices of fired neurons
		//v(fired)=-65;
		//u(fired)=u(fired)+d(fired);
		//last_fired(fired)=t;

		for (i = 1; i <= (*N); i++) {
			if (v[i] >= 30) {
				if (anch[1] == 2) {
					//printf("%d,%d\n", i, t);
				}
				v[i] = -65.0;
				u[i] += d[i];
				last_fired[i] = t;

				//I(pp{fired(k)}+t*N)=I(pp{fired(k)}+t*N)+s(fired(k),:);
				for (k = 1; k <= numSynapse; k++) {
					int temp = pp[(i) * 23 + k] + t * (*N);

					//printf("%f\n",pp[(i)*23+k]);

					temp = (temp - post[i * 23 + k]) / (*N) + 1;

					int temp1 = post[i * 23 + k];
					I[temp1][temp] = I[temp1][temp] + s[i * 23 + k];
					//printf("%f\n",s[i*23+k]);
					if (anch[1] == 2 & i == 66) {
						//printf("%f,%d,%d\n", I[temp1][temp], temp1, temp);
						//printf("%f\n",s[i*23+k]);
					}

				}

				//50 is the second dimension of dpre and ppre (hard code)
				//PSP_times= last_fired(ppre{fired(k)}) + dpre{fired(k)}';
				int temp2;
				for (j = 1; j <= 50; j++) {
					temp2 = ppre[i * 51 + j];
					psp_times[j] = last_fired[temp2] + dpre[i * 51 + j];
					//printf("%d\n", psp_times[j]);
				}
				int r = 1;
				//recent=find(PSP_times < t & PSP_times > t-10 & s(pre{fired(k)})' > 0 );
				for (j = 1; j <= 50; j++) {
					int temp = pre[i * 51 + j];
					int temp1 = ppre[i * 51 + j];

					if (temp1 != 0) {

						temp = (temp - ppre[i * 51 + j]) / (*N) + 1;
						//printf("%d, %d,%f\n", temp1, temp,
						//s[temp1 * 23 + temp]);
						if (psp_times[j] < t & psp_times[j] > (t - 10)
								& s[temp1 * 23 + temp] > 0) {
							recent[r++] = j;
							if ((anch[1] == 2) & (anch[2] == 3)
									& (anch[3] == 4)) {
								//printf("recent: %d\n",j);
							}
						}
					}
				}
				// length of recent is r-1
				//group.gr = [group.gr; last_fired(ppre{fired(k)}(recent)),  ppre{fired(k)}(recent)', ...  % presynaptic (time, neuron #)
				//last_fired(ppre{fired(k)}(recent)) + dpre{fired(k)}(recent)',...   % arrival of PSP (time)
				//fired(k)*(ones(length(recent),1)), ...                            % postsynaptic (neuron)
				//t*(ones(length(recent),1))];
				//gr = 1;
				for (j = 1; j <= r - 1; j++) {
					int temp3 = ppre[i * 51 + recent[j]];
					group_gr[gr][1] = last_fired[temp3];
					group_gr[gr][2] = temp3;
					group_gr[gr][3] = last_fired[temp3]
							+ dpre[i * 51 + recent[j]];
					group_gr[gr][4] = i;
					group_gr[gr][5] = t;
					if (anch[1] == 2) {
						/*printf("%d,%d,%d,%d,%d\n", group_gr[gr][1],
						 group_gr[gr][2], group_gr[gr][3],
						 group_gr[gr][4], group_gr[gr][5]);*/
					}
					gr = gr + 1;
				}

				//group.firings=[group.firings; t, fired(k)];
				group_firings[tf][1] = t;
				group_firings[tf][2] = i;
				//printf("%d,%d\n",group_firings[tf][1],group_firings[tf][2]);

				tf = tf + 1;

			}
		}

	}
	//printf("%d",tf);
	//for j=1:length(gr.gr(:,2))
	//fired_path( gr.gr(j,4) ) = max( fired_path( gr.gr(j,4) ), 1+fired_path( gr.gr(j,2) ));
	//end;
	for (i = 1; i <= (gr - 1); i++) {
		fired_path[(int) group_gr[i][4]] =
				(fired_path[(int) group_gr[i][4]]
						> 1 + fired_path[(int) group_gr[i][2]]) ?
						(fired_path[(int) group_gr[i][4]]) :
						(1 + fired_path[(int) group_gr[i][2]]);
	}

	//longest_path = max(fired_path);
	int max = 0;
	for (i = 1; i <= (*N); i++) {
		if (fired_path[i] != 0 & (anch[1] == 2) & (anch[2] == 3)
				& (anch[3] == 4)) {

			//printf("%d,%d\n", i, fired_path[i]);
		}
		if (fired_path[i] > max)
			max = fired_path[i];
	}

	printf("max %d, %d, %d, %d /n", max, anch[1], anch[2], anch[3]);
	if (max >= min_group_path)
		pngOutput[inputIndex] = true;
	else
		pngOutput[inputIndex] = false;
	//printf("%d", inputIndex);

	for (i = 1; i <= (*N); i++)
		delete[] I[i];
	delete[] I;

}

