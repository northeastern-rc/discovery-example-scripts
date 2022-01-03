# MATLAB sample GPU scripts

## MATLAB GPU supported jobs

You can run many built-in MATLAB functions using GPU arrays. Note that it is required to run the job on the gpu or multiple partitions with a GPU allocated to the job.
The script **submit_gpu.bash** inside directory **matlab_gpu** is an example Slurm script to be used for GPU-supported MATLAB scripts such as the example **my_gpu_program.m**:

```bash
#!/bin/bash
#SBATCH -N 1			#use one compute node
#SBATCH --ntask=1		#use 1 task
#SBATCH -p gpu			#use the 'gpu' partition
#SBATCH --gres=gpu:1		#request a GPU inside the node
#SBATCH --output=testGPU.out	#standard output file name
#SBATCH --error=testGPU.err	#standard error file name
#SBATCH --job-name=testGPU	#name for the job allocation

#To gain access to Matlab, a Matlab module must be loaded:
module load matlab/R2021a

#To submit Matlab jobs to the SLURM scheduler, the Matlab commands to be executed must be containined in a single .m script:
matlab -nodisplay < my_gpu_program.m
```

Note that the matlab script **my_gpu_program.m** contains GPU array data structures and GPU-enabled MATLAB functions. Example taken from: https://www.mathworks.com/help/parallel-computing/gpuarray.html.

```
X = [1,2,3];
% Transfer X to the GPU:
G = gpuArray(X);
% Check that the data is on the GPU:
isgpuarray(G)
% Calculate the element-wise square of the array G:
GSq = G.^2;
% Transfer the result GSq back to the CPU:
XSq = gather(GSq)
%% You can create data directly on the GPU directly by using some MATLAB functions and specifying the option "gpuArray":
G = rand(1,3,"gpuArray")

%% Use MATLAB Functions with the GPU:
% use gpuArray-enabled MATLAB functions to operate with gpuArray objects:
% check the properties of your GPU using the gpuDevice function:
gpuDevice

% Create a row vector that repeats values from -15 to 15. To transfer it to the GPU and create a gpuArray object, use the gpuArray function:
X = [-15:15 0 -15:15 0 -15:15];
gpuX = gpuArray(X);
whos gpuX

% Operate using GPU-enabled functions:
gpuE = expm(diag(gpuX,-1)) * expm(diag(gpuX,1));
gpuM = mod(round(abs(gpuE)),2);
gpuF = gpuM + fliplr(gpuM);
% Plot the results:
imagesc(gpuF);
colormap(flip(gray));

% If you need to transfer the data back from the GPU, use gather. NOTE - Transferring data back to the CPU can be costly, and is generally not necessary unless you need to use your result with functions that do not support gpuArray.

result = gather(gpuF);
whos result
```
