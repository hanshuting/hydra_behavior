#!/bin/sh

# Derictives

#PBS -N assign_mbh

#PBS -W group_list=yetibrain

#PBS -l nodes=1:ppn=1,walltime=12:00:00,mem=16000mb

#PBS -M sh3276@columbia.edu

#PBS -m a

#PBS -V

#PBS -o localhost:/u/10/s/sh3276/eo/

#PBS -e localhost:/u/10/s/sh3276/eo/

#PBS -t 1-10

echo "starting job"

date

matlab -nosplash -nodisplay -nodesktop -r "assign_mbh_yeti_break($PBS_ARRAYID);exit"

echo "done with job"

date

# End of script
