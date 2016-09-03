#!/bin/sh

# Derictives

#PBS -N test

#PBS -W group_list=yetibrain

#PBS -l nodes=1:ppn=4,walltime=5:00:00,mem=64000mb

#PBS -M sh3276@columbia.edu

#PBS -m ae

#PBS -V

#PBS -o localhost:/u/10/s/sh3276/eo/

#PBS -e localhost:/u/10/s/sh3276/eo/

echo "starting job"

date

module load matlab/2014a
matlab -nosplash -nodisplay -nodesktop -r "addpath(genpath('/u/10/s/sh3276/code/'));test;exit"

echo "done with job"

date

# End of script
