#include <unistd.h>
#include <stdio.h>
#include<cmath>
#include <iostream>
#include <fstream>
#include <curand.h>
#include <curand_kernel.h>
using namespace std;

#define N 100000
#define MAX 2000
#define two_pi 2.0*3.14159265358979323846

void streamOut (float *uniform_hostNums, float *gaussian_hostNums1 , float *gaussian_hostNums2);

// kernel takes array of states and seed and change in the device array of random numbers
__global__ void uniform_randoms(unsigned int seed, curandState_t* states, float* uniform_random_numbers) {
  // initialize the random states
   curand_init(seed, //must be different every run so the sequence of numbers change. 
    blockIdx.x, // the sequence number should be different for each core ???
    0, //step between random numbers
    &states[blockIdx.x]);
  
  uniform_random_numbers[blockIdx.x] = (curand(&states[blockIdx.x]) % MAX);
  uniform_random_numbers[blockIdx.x] = uniform_random_numbers[blockIdx.x] /MAX;
}
__global__ void uniform_random_distribution(float* uniform_random_numbers, float *uniform_deviceNums1 , float *uniform_deviceNums2, float * gaussian_random_numbers1, float * gaussian_random_numbers2 )
{  if (blockIdx.x < N/2){ //divind the unifrom device array into two arrays
  uniform_deviceNums1[blockIdx.x]=uniform_random_numbers[blockIdx.x];
  }
  else if (blockIdx.x >= N/2 && blockIdx.x < N ){
    uniform_deviceNums2[blockIdx.x-(N/2)]=uniform_random_numbers[blockIdx.x];
  }
 // else if (blockIdx.x >= N && blockIdx.x <= (N/2 +N)){
   // gaussian_random_numbers1[blockIdx.x]= sqrt(-2*log(uniform_deviceNums1[blockIdx.x-N]))*cos(two_pi*uniform_deviceNums2[blockIdx.x-((N/2)+N)]);
  //}
  //else if (blockIdx.x >= (N/2 +N) ){
    //gaussian_random_numbers2[blockIdx.x]= sqrt(-2*log(uniform_deviceNums1[blockIdx.x-N]))*sin(two_pi*uniform_deviceNums2[blockIdx.x-((N/2)+N)]);;
  //}
}



int main() {
  curandState_t* states;
  cudaMalloc((void**) &states, N * sizeof(curandState_t));
  float *uniform_hostNums= (float*)malloc(sizeof(float) * N);
  float *gaussian_hostNums1= (float*)malloc(sizeof(float) * (N/2));
  float *gaussian_hostNums2= (float*)malloc(sizeof(float) * (N/2));

  float* uniform_deviceNums;
  cudaMalloc((void**) &uniform_deviceNums, N * sizeof(float));
  float* uniform_deviceNums1;
  cudaMalloc((void**) &uniform_deviceNums1, (N/2) * sizeof(float));
  float* uniform_deviceNums2;
  cudaMalloc((void**) &uniform_deviceNums2, (N/2) * sizeof(float));
  float* gaussian_deviceNums1;
  cudaMalloc((void**) &gaussian_deviceNums1, (N/2) * sizeof(float));
  float* gaussian_deviceNums2;
  cudaMalloc((void**) &gaussian_deviceNums2, (N/2) * sizeof(float));

  uniform_randoms<<<N,1>>>( time(0), states, uniform_deviceNums);
  uniform_random_distribution<<<2*N,1>>>(uniform_deviceNums,uniform_deviceNums1, uniform_deviceNums2, gaussian_deviceNums1,gaussian_deviceNums2);
 // gaussian_random_distribution<<<N,1>>>(gaussian_deviceNums1,gaussian_deviceNums2,uniform_deviceNums1,uniform_deviceNums2);

  cudaMemcpy(uniform_hostNums, uniform_deviceNums, N * sizeof( float), cudaMemcpyDeviceToHost);
  cudaMemcpy(gaussian_hostNums1, gaussian_deviceNums1, (N/2) * sizeof( float), cudaMemcpyDeviceToHost);
  cudaMemcpy(gaussian_hostNums2, gaussian_deviceNums2, (N/2) * sizeof( float), cudaMemcpyDeviceToHost);


  streamOut(&uniform_hostNums[0],&gaussian_hostNums1[0],&gaussian_hostNums2[0]);

  cudaFree(states);
  cudaFree(uniform_deviceNums);
  cudaFree(gaussian_deviceNums1);
  cudaFree(gaussian_deviceNums2);
  cudaFree(uniform_deviceNums2);
  cudaFree(uniform_deviceNums1);


  free(uniform_hostNums);
  free(gaussian_hostNums1);
  free(gaussian_hostNums2);

  return 0;
}

void streamOut(float *uniform_hostNums, float *gaussian_hostNums1 , float *gaussian_hostNums2)
{
    std::ofstream resultFile;
    resultFile.open("randomNum.txt");
    if (resultFile.is_open())
    {   
      for (int i = 0; i <N ; i++)
      {
          resultFile << uniform_hostNums[i] << endl;
      }
        for (int i = 0; i <N/2 ; i++)
        {
            resultFile << gaussian_hostNums1[i] << endl;
        }
        for (int i = 0; i <N/2 ; i++)
        {
            resultFile << gaussian_hostNums2[i] << endl;
        }
        resultFile.close();
    }
    else
    {
        std::cout << "Unable to open file";
    }
}