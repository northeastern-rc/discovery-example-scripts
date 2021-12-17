# Importing required Libraries
from multiprocessing import Pool
import os
import time

if __name__ == "__main__":
    # Function to square the numbers
    def square(i):
        res=0
        for i in range(1000):
            res += i*i
        return res
            
    t1=time.time()
    print("No. Of CPU's requested: {}".format(os.environ['SLURM_CPUS_PER_TASK']))
    
    
    # Multiprocessing Code
    with Pool(int(os.environ['SLURM_CPUS_PER_TASK'])) as p:
        p.map(square,range(100000))
    p.close()
    p.join()
    
    print("Time taken by Multiprocessing moudle to execute the program: {}".format(time.time()-t1))
    
    # Serial Code
    t2=time.time()
    result = []
    for i in range(100000):
        result.append(square(i))
    
    print("Time taken by Serial Code to execute the program: {}".format(time.time()-t2))