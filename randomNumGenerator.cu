#include <unistd.h>
#include <stdio.h>
#include <iostream>
#include <fstream>
using namespace std;

/* we need these includes for CUDA's random number stuff */
#include <curand.h>
#include <curand_kernel.h>

#define N 25

#define MAX 100

void streamOut (int *cpu_nums);

/* this GPU kernel function is used to initialize the random states */
__global__ void init(unsigned int seed, curandState_t* states) {

  /* we have to initialize the state */
  curand_init(seed, /* the seed can be the same for each core, here we pass the time in from the CPU */
              blockIdx.x, /* the sequence number should be different for each core (unless you want all
                             cores to get the same sequence of numbers for some reason - use thread id! */
              0, /* the offset is how much extra we advance in the sequence for each call, can be 0 */
              &states[blockIdx.x]);
}

/* this GPU kernel takes an array of states, and an array of ints, and puts a random int into each */
__global__ void randoms(curandState_t* states, int* numbers) {
  /* curand works like rand - except that it takes a state as a parameter */
  numbers[blockIdx.x] = curand(&states[blockIdx.x]) % 100;
}

int main() {
  /* CUDA's random number library uses curandState_t to keep track of the seed value
     we will store a random state for every thread  */
  curandState_t* states;

  /* allocate space on the GPU for the random states */
  cudaMalloc((void**) &states, N * sizeof(curandState_t));

  /* invoke the GPU to initialize all of the random states */
  init<<<N, 1>>>(time(0), states);

  /* allocate an array of unsigned ints on the CPU and GPU */
  int cpu_nums[N];
  int* gpu_nums;
  cudaMalloc((void**) &gpu_nums, N * sizeof(int));

  /* invoke the kernel to get some random numbers */
  randoms<<<N, 1>>>(states, gpu_nums);

  /* copy the random numbers back */
  cudaMemcpy(cpu_nums, gpu_nums, N * sizeof( int), cudaMemcpyDeviceToHost);

  /* print them out */
  for (int i = 0; i < N; i++) {
    printf("%u\n", cpu_nums[i]);
  }

  streamOut(&cpu_nums[0]);

  /* free the memory we allocated for the states and numbers */
  cudaFree(states);
  cudaFree(gpu_nums);

  return 0;
}

void streamOut(int *cpu_nums)
{
    std::ofstream resultFile;
    resultFile.open("randomNum.txt");
    if (resultFile.is_open())
    {
        for (int i = 0; i <N ; i++)
        {
            resultFile << cpu_nums[i] << endl;
        }
        resultFile.close();
    }
    else
    {
        std::cout << "Unable to open file";
    }
}