# MATLAB sample scripts
Example scripts to run MATLAB on Discovery. The examples include:

1. Serial (1 CPU) script
2. Parallel (multiple CPU) script
3. Parallel (multiple CPU) script with job array 
4. Parallel GPU script

## Serial example

The script **submit_serial.bash** shell script is a basic example of running a serial batch job using MATLAB. It runs the MATLAB function **magic_square.m** on a single CPU (`--ntasks=1`) on the express partition.

```bash
#!/bin/bash
#SBATCH -N 1			#use one compute node
#SBATCH --ntasks=1		#use 1 task
##SBATCH --cpus-per-task=1	#use 1 cpu per task (would be the default)
#SBATCH -p express		#use the 'express' partition
#SBATCH --output=test.out	#standard output file name
#SBATCH --error=test.err	#standard error file name
#SBATCH --job-name=test		#name for the job allocation

#To gain access to Matlab, a Matlab module must be loaded:
module load matlab/R2020a

#To submit Matlab jobs to the SLURM scheduler, the Matlab commands to be executed must be containined in a single .m script:

matlab -nodisplay < magic_square.m
```

To submit it run:
```bash
sbatch submit_serial.bash 
```

## Parallel examples

### Using MATLAB Parallel Server and Parallel pool options

The example script **submit_parallel_singleNode.bash** shows how to scale MATLAB programs to be used on multiple CPUs. The current example only uses a single node but can be extended to run on multiple nodes too.

```bash

#!/bin/bash
#SBATCH -N 1			#use one compute node
#SBATCH --ntasks=16		#use 16 tasks
#SBATCH --cpus-per-task=1	#use 1 cpu per task (would be the default)
#SBATCH -p express		#use the 'express' partition
#SBATCH --output=testSNP.out	#standard output file name
#SBATCH --error=testSNP.err	#standard error file name
#SBATCH --job-name=testSNP	#name for the job allocation

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

```

Note that the MATLAB script **parforExample.m** has to include MATLAB Parallel synthax to ensure parallelism is invoked:

```
% create a local cluster object:
pc = parcluster('local')

% explicitly set the JobStorageLocation to the temp directory that was created in your sbatch script
pc.JobStorageLocation = strcat('/scratch/',getenv('USER'),'/', getenv('SLURM_JOB_ID'))

% start the matlabpool with maximum available workers
% control how many workers by setting ntasks in your sbatch script
%parpool(pc, str2num(getenv('SLURM_CPUS_ON_NODE')))
parpool(pc, str2num(getenv('SLURM_NTASKS')))

% run a parfor loop, distributing the iterations to the SLURM_CPUS_ON_NODE workers

% 1. read the data and parameters (and iteration number N) from file: data

parfor i = N:1000
	%1. do a calculation with the data and paramters of i
end

%2. store the current data / current parameters into a file: data
```

To submit the parallel job:

```bash
sbatch submit_parallel_singleNode.bash
```

Additional Parallel example: **myParallelAlgorithmFcn.m** which shows how to run benchmarks on multiple pool numbers.

### Using Slurm job arrays

You may want to use job arrays to extend existing jobs conviniently, or to submit multiple jobs. The script **submit_parallel_singleNode_jobarray.bash** is an example shell script which is set up to run 10 batch jobs one after the other (`%1`), each with a 24 hour limit, 16 cores on one node. By passing the flag `--array=1-10%1` to Slurm, it creates 10 different copies of the script, each with its own identifier which is store in variable `SLURM_ARRAY_TASK_ID` that goes from 1 to 10. For more info: https://slurm.schedmd.com/job_array.html 

```bash
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
```

submit the job array once, and see the multiple jobs generated: 

```bash
sbatch submit_parallel_singleNode_jobarray.bash 
squeue -u $USER
```

## MATLAB GPU supported jobs

You can run many built-in MATLAB functions using GPU arrays. Note that it is required to run the job on the gpu or multiple partitions with a GPU allocated to the job.

