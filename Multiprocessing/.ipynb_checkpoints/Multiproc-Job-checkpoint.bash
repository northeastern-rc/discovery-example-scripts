#!/bin/bash

#SBATCH --partition=short
#SBATCH -J Multiprocessing
#SBATCH --time=00:05:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=5
#SBATCH --output=%j.output
#SBATCH --error=%j.error

#Load the conda environment:
module load anaconda3/2021.05

# run the python code
python Multiprocessing.py