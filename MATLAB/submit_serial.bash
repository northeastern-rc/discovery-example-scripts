#!/bin/bash
#SBATCH -N 1			#use one compute node
#SBATCH --ntasks=1		#use 1 task
#SBATCH --cpus-per-task=1	#use 1 cpu per task (would be the default)
#SBATCH -p express		#use the 'express' partition
#SBATCH --output=test.out	#standard output file name
#SBATCH --error=test.err	#standard error file name
#SBATCH --job-name=test		#name for the job allocation

#To gain access to Matlab, a Matlab module must be loaded:
module load matlab/R2020a

#To submit Matlab jobs to the SLURM scheduler, the Matlab commands to be executed must be containined in a single .m script:

matlab -nodisplay < magic_square.m  
