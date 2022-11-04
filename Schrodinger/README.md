# Schrodinger on Discovery

This example provides a use case on how to submit Schrodinger Desmond jobs on Discovery.

Here, we use Multisim of Desmond which runs in the umbrella mode on the input files:
3FU3.pdb,3FU3\_md\_job\_1.cfg, 3FU3\_md\_job\_1.cms and 3FU3\_md\_job\_1.msj 

**NOTE:** The submit shell script 3FU3\_md\_job\_1.sh does not directly use Slurm to submit a job. All Slurm parameters will be passed via the Schrodinger command directly, and a job will be submitted.

## Shell script 3FU3\_md\_job\_1.sh details

1. `${SCHRODINGER}/utilities/multisim` is the exectuable program you are running.
2. `-JOBNAME 3FU3_md_job_1` - defines the slurm job name 
3. `-HOST discovery-gpu` - determines the job partition allocation, such as running on a gpu, express, debug or the short partitions. The specific options and details can be found in the host files within the Schrodinger directories. For example, for schrodinger/2019-4 the file will be located at: `/shared/centos7/schrodinger/2019-4/schrodinger.hosts`
The current options for that version are: discovery-debug, discovery-express, discovery-general, discovery-gpu and discovery-fullnode (depricated, so this option is the same as general).
4. The `-maxjob` and `-cpu` parameters are used to calculate `%NPROC%` in the Schrodinger host file. The formula is a multiplication of the values of `-maxjob` and `-cpu` parameters. So kindly make sure that you are eligible to use (`-maxjob` * `-cpu`) cores in that partition or the job submission will fail at Slurm level. 
5. `-m 3FU3_md_job_1.msj` - specifies the .msj input file (defining the basic workflow).
6. `-c 3FU3_md_job_1.cfg` - specifies the .cfg input file (configuration parameters).
7. `-description "Molecular Dynamics" 3FU3_md_job_1.cms` - provides description.
8. `-mode umbrella` - run MD simulations using the umbrella mode.
9. `-set "stage[1].set_family.md.jlaunch_opt=[\"-gpu\"]"` - specify the utilization of a GPU in the calculation in this setup option.
10. The `-PROJ` parameter is not mentioned above but it Is the project file parameter (.prj file).
11. `-o 3FU3_md_job_1-out.cms` - provide the output file name.

### Additional usful flags 

You can find additional useful flags in the manual. To see the full list type:

```bash
module load schrodinger
$SCHRODINGER/utilities/multisim -h 
```

## Steps to run a job

### Step 0 - set up Passwordless SSH
It is recommended to setup passwordless ssh to ensure proper function of Maestro. Follow the instructions for [Mac](https://rc-docs.northeastern.edu/en/latest/first_steps/connect_mac.html#passwordless-ssh) or [Windows](https://rc-docs.northeastern.edu/en/latest/first_steps/connect_windows.html#passwordless-ssh).

### Next steps:

1. Clone the example scripts to your home, scratch or work directories. For example:
```bash
cd /scratch/$USER
git clone git@github.com:northeastern-rc/discovery-example-scripts.git
cd Schrodinger 
```
2. From the login node, load the Schrodinger module. For example:
```bash
module load schrodinger/2019-4
```
3. Execute the shell script, this will submit a job on Discovery:
```bash
./3FU3_md_job_1.sh &
```
You should be able to see the output on the screen of your job being submitted. Once submitted you can check your job status by:
```bash
squeue -u $USER
```

### Performance: 
To fully leverge the GPU and/or multi-CPU features on the localhost session, you will need to create your own modified "localhost" entry (that includes the "processors" and/or "gpgpu" entries) in the `~/.schrodinger/schrodinger.hosts` file.

### Recommended steps to include more CPUs in schrodinger.hosts:
1. Copy the default `schrodinger.hosts` file to your home directory. Type the following:
```bash
cp /shared/centos7/schrodinger/2021-1/schrodinger.hosts ~/.schrodinger/schrodinger.hosts
```
2. Open the file `~/.schrodinger/schrodinger.hosts` using a file editor. You can use the [Discovery OOD File Explorer](https://rc-docs.northeastern.edu/en/latest/using-ood/fileexplore.html).
3. Create a new host with your desired features. For example:
```bash
name:        discovery-myhost
host:        login-00.discovery.neu.edu
queue:       SLURM2.1
schrodinger: /shared/centos7/schrodinger/2021-1
qargs:       --partition=short --time=24:00:00 --nodes=2 --ntasks=%NPROC%
processors:  128
tmpdir:      /tmp

name:        myhost-gpu
host:        localhost
processors:  12
gpgpu:       0 , gpu1
tmpdir:      /tmp
``` 
Where in the added host `discovery-myhost` we've included the option to allocate 2 nodes and up to 128 CPUs, and in host `myhost-gpu` (mainly used for Maestro) we've modified up to 12 CPUs and a GPU to be allocated to the job.

Additional info on how to modify the hosts file:
* [Configure your personal schrodinger.hosts file](https://www.schrodinger.com/kb/1844)
* [Multi-Core configuration suggestions](https://www.schrodinger.com/kb/462)
* [List of applications that can run on GPUs](https://www.schrodinger.com/kb/278)


## Checkpointing:

Checkpoint files will be automatically created, so use `-RESTART` option to start from the recent checkpoint.

To continue an existing job you can create an additional host that has the Slurm flag `--array`. We have added an additional host to `schrodinger.hosts`, which can run multiple jobs on the gpu node. The hostname "discovery-gpu-array" is currently set up to run a job array of 10 jobs, 1 at a time on the gpu partition, for 8 hours. 
It is possible to set up a script similar to example 3FU3\_md\_job\_1.ARRAY.sh
where it the next job will continue based on the last created .cpt file. 

More info here on checkpointing can be found here: https://www.schrodinger.com/kb/1883 
