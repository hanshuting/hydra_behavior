#!/bin/sh

# Derictives

#PBS -N run_flows2

#PBS -W group_list=yetibrain

#PBS -l nodes=1:ppn=1,walltime=48:00:00,mem=4000mb

#PBS -M sh3276@columbia.edu



#PBS -V

#PBS -o localhost:/u/10/s/sh3276/eo/

#PBS -e localhost:/u/10/s/sh3276/eo/

#PBS -t 1-4,10-15,20-25,26-81

echo "starting job"

date

matlab -nosplash -nodisplay -nodesktop -r "estimate_all_flows_yeti_batch2($PBS_ARRAYID);exit"

echo "done with job"

date

# End of script
