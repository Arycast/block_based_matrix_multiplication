import numpy as np
import time

# Row and Col size of matrix being bulitiplied
row_size = 512
col_size = 64

# Generate random input matrix
A = np.random.randint(low=-128,high=127, size=(row_size,col_size))
B = np.random.randint(low=-128,high=127, size=(col_size,row_size))

# Output matrix
conventional_out = np.zeros((row_size,row_size))
block_alg_out = np.zeros((row_size,row_size))

# Row and Col size of block matrix
block_row_size = 4
block_col_size = 4

mult_block_result = np.zeros((block_row_size,block_col_size))       # Store multiplication output per block
sum_block_result = np.zeros((block_row_size,block_col_size))        # Store accumulator output of every block per row of input A
curr1_block_result = np.zeros((block_row_size,block_col_size))      # Block matrix from input A
curr2_block_result = np.zeros((block_row_size,block_col_size))      # Block matrix from input B


start = time.time()
# Perform block based matrix multiplication
for row_out in range(0,row_size,block_row_size):            # Traverse input A row with step block_row_size
    for col_out in range(0,row_size,block_row_size):        # Traverse input A column with step block_col_size
        for block in range(0,col_size,block_col_size):      # Traverse input B column with step block_col_size
            
            for row_block in range(0,block_row_size):       # Traverse block input A row
                for col_block in range(0,block_col_size):   # Traverse block input B column
                    curr1_block_result[row_block,col_block] = A[row_block+row_out, col_block+block]
                    curr2_block_result[row_block,col_block] = B[row_block+block, col_block+col_out]
            
            # Multiply each block in input A column with input B row
            mult_block_result = np.matmul(curr1_block_result,curr2_block_result)
            sum_block_result = np.add(sum_block_result,mult_block_result)

        # Input accumulated block matrix into output matrix
        for i in range(block_row_size):
            for j in range(block_col_size):
                block_alg_out[i+row_out, j+col_out] = sum_block_result[i,j]

        # Rewrite temporary sum matrix as zero
        sum_block_result = np.zeros((block_row_size,block_col_size))

block_based_time = time.time() - start
start = time.time()

# Conventional matrix multiplication
conventional_out = np.matmul(A,B)
conventional_time = time.time() - start

# ============ Uncomment this line to see input and output ============
# print(f'Input Matrix A:\n{A}')
# print(f'Input Matrix B:\n{B}')

# print('======== Conventional Output ========')
# print(conventional_out)
# print('======== Block Based Output ========')
# print(block_alg_out)

if ((conventional_out == block_alg_out).all()): print('[INFO] Output Matrices of both algorithm MATCHED!!')
else: print('[ERROR] Output Matrices DIFFERS')

print(f'Calculation time of conventional multiplication: {conventional_time}')
print(f'Calculation time of block based multiplication: {block_based_time}')