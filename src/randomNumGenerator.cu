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

/* this GPU kernel takes an array of states, and an array of ints, and puts a random int into each */
__global__ void randoms(unsigned int seed, curandState_t* states, int* numbers) {
  // initialize the random states
   curand_init(seed, /* the seed can be the same for each core, here we pass the time in from the CPU */
    blockIdx.x, /* the sequence number should be different for each core (unless you want all
                   cores to get the same sequence of numbers for some reason - use thread id! */
    0, /* the offset is how much extra we advance in the sequence for each call, can be 0 */
    &states[blockIdx.x]);
  /* curand works like rand - except that it takes a state as a parameter */
  numbers[blockIdx.x] = curand(&states[blockIdx.x]) % MAX;
}

int main() {
  /* CUDA's random number library uses curandState_t to keep track of the seed value
     we will store a random state for every thread  */
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