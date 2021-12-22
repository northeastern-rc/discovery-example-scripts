#!/bin/bash
#SBATCH -N 1			#use one compute node
#SBATCH --ntasks=1		#use 1 task
#SBATCH -p gpu			#use the 'gpu' partition
#SBATCH --gres=gpu:1		#request a GPU inside the node
#SBATCH --output=testGPU.out	#standard output file name
#SBATCH --error=testGPU.err	#standard error file name
#SBATCH --job-name=testGPU	#name for the job allocation

#To gain access to Matlab, a Matlab module must be loaded:
module load matlab/R2021a

#To submit Matlab jobs to the SLURM scheduler, the Matlab commands to be executed must be containined in a single .m script:
matlab -nodisplay < my_gpu_program.m 

