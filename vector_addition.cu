#include <iostream>
using namespace std;

__global__ void vector_addition(float* A, float* B, float* C, int N) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < N) {
        C[i] = A[i] + B[i]; 
    }
}

int main() {
    // Host arrays
    float A[5] = {1, 2, 3, 4, 5};
    float B[5] = {1, 2, 3, 4, 5};
    float C[5]; // Result array
    int N = 5;

    // Device arrays
    float *d_a, *d_b, *d_c;

    // Allocate memory on the device
    cudaMalloc(&d_a, N * sizeof(float));
    cudaMalloc(&d_b, N * sizeof(float));
    cudaMalloc(&d_c, N * sizeof(float));

    // Copy data from host to device
    cudaMemcpy(d_a, A, N * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, B, N * sizeof(float), cudaMemcpyHostToDevice);

    // Launch kernel with 1 block and N threads
    vector_addition<<<1, N>>>(d_a, d_b, d_c, N);

    // Copy result back from device to host
    cudaMemcpy(C, d_c, N * sizeof(float), cudaMemcpyDeviceToHost);

    // Print the result
    for (int i = 0; i < N; i++) {
        cout << "C[" << i << "] = " << C[i] << endl;
    }

    // Free device memory
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    return 0;
}
