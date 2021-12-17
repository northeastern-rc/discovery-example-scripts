#!/bin/bash
#SBATCH -N 1			#use one compute node
#SBATCH --ntasks=16		#use 16 tasks
#SBATCH --cpus-per-task=1	#use 1 cpu per task (would be the default)
#SBATCH -p short		#use the 'express' partition
#SBATCH --output=testSNP.out	#standard output file name
#SBATCH --error=testSNP.err	#standard error file name
#SBATCH --job-name=testSNP	#name for the job allocation
#SBATCH --array=1-10%1          #create 10 jobs, run 1 at a time
#SBATCH --time=24:00:00

#To gain access to Matlab, a Matlab module must be loaded:
module load matlab/R2020a

#The Matlab Parallel Computing Toolbox (PCT) creates the matlab pool environment
#in a default temporary directory under /home/<yourusername>/.matlab
#NOTE: when submitting multiple PCT jobs, it is best practice to create a different
#temporary directory for each job:

# Create a temporary directory on scratch:
mkdir -p /scratch/$USER/$SLURM_JOB_ID

#To submit Matlab jobs to the SLURM scheduler, the Matlab commands to be executed must be containined in a single .m script:

matlab -nodisplay < parforExample.m 

# Cleanup local work directory
rm -rf /scratch/$USER/$SLURM_JOB_ID
