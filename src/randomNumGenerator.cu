#include <unistd.h>
#include <stdio.h>
#include <iostream>
#include <fstream>
#include <curand.h>
#include <curand_kernel.h>
using namespace std;

#define N 500
#define MAX 2000

void streamOut (int *hostNums);

// kernel takes array of states and seed and change in the device array of random numbers
__global__ void randoms(unsigned int seed, curandState_t* states, int* random_numbers) {
  // initialize the random states
   curand_init(seed, //must be different every run so the sequence of numbers change. 
    blockIdx.x, // the sequence number should be different for each core ???
    0, //step between random numbers
    &states[blockIdx.x]);
  
  random_numbers[blockIdx.x] = curand(&states[blockIdx.x]) % MAX;
}

int main() {
  curandState_t* states;
  cudaMalloc((void**) &states, N * sizeof(curandState_t));
  int *hostNums= (int*)malloc(sizeof(int) * N);
  int* deviceNums;
  cudaMalloc((void**) &deviceNums, N * sizeof(int));

  randoms<<<N, 1>>>( time(0), states, deviceNums);

  cudaMemcpy(hostNums, deviceNums, N * sizeof( int), cudaMemcpyDeviceToHost);

  streamOut(&hostNums[0]);

  cudaFree(states);
  cudaFree(deviceNums);
  free(hostNums);

  return 0;
}

void streamOut(int *hostNums)
{
    std::ofstream resultFile;
    resultFile.open("randomNum.txt");
    if (resultFile.is_open())
    {   resultFile << MAX << endl;
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