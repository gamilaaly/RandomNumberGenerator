cmake_minimum_required(VERSION 3.10)

### c++11 standards
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

project (randomNum)

# CUDA PACKAGE
find_package( CUDA REQUIRED)
set(CUDA_SEPARABLE_COMPILATION ON)
set(CUDA_PROPAGATE_HOST_FLAGS OFF)
set(CUDA_HOST_COMPILER g++)

file(GLOB CUDA_FILES "Source/" *.cu)
CUDA_COMPILE(CU_O ${CUDA_FILES})
list(APPEND CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS}; -gencode arch=compute_30,code=sm_30; -std=c++11 )

cuda_add_executable( randomNum src/randomNumGenerator.cu)


