#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=8

#SBATCH --job-name="1nodes_8cores"
#SBATCH --mail-user=natakornk@student.unimelb.edu.au
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

#SBATCH --time=0-0:10:00

module load foss/2019b
module load mpi4py/3.0.2-timed-pingpong
module load numpy/1.17.3-python-3.7.4
source ~/virtualenv/python3.7.4/bin/activate

srun python3 all_question.py

##DO NOT ADD/EDIT BEYOND THIS LINE##
##Job monitor command to list the resource usage
my-job-stats -a -n -s
