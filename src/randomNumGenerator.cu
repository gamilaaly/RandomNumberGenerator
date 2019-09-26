#include <unistd.h>
#include <stdio.h>
#include <iostream>
#include <fstream>
#include <curand.h>
#include <curand_kernel.h>
using namespace std;

#define N 500
#define MAX 2000

void streamOut (float *hostNums);

// kernel takes array of states and seed and change in the device array of random numbers
__global__ void randoms(unsigned int seed, curandState_t* states, float* random_numbers) {
  // initialize the random states
   curand_init(seed, //must be different every run so the sequence of numbers change. 
    threadIdx.x, // the sequence number should be different for each core ???
    0, //step between random numbers
    &states[threadIdx.x]);
  
  random_numbers[threadIdx.x] = (curand(&states[threadIdx.x]) % MAX);
  random_numbers[threadIdx.x] = random_numbers[threadIdx.x] /MAX;
}

int main() {
  curandState_t* states;
  cudaMalloc((void**) &states, N * sizeof(curandState_t));
  float *hostNums= (float*)malloc(sizeof(float) * N);
  float* deviceNums;
  cudaMalloc((void**) &deviceNums, N * sizeof(float));

  randoms<<<1,N>>>( time(0), states, deviceNums);

  cudaMemcpy(hostNums, deviceNums, N * sizeof( float), cudaMemcpyDeviceToHost);

  streamOut(&hostNums[0]);

  cudaFree(states);
  cudaFree(deviceNums);
  free(hostNums);

  return 0;
}

void streamOut(float *hostNums)
{
    std::ofstream resultFile;
    resultFile.open("randomNum.txt");
    if (resultFile.is_open())
    {   resultFile << 1 << endl; // to have normal dist
        for (int i = 0; i <N ; i++)
        {
            resultFile << hostNums[i] << endl;
        }
        resultFile.close();
    }
    else
    {
        std::cout << "Unable to open file";
    }
}