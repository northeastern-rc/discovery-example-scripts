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
