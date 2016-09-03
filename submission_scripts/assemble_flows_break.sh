#!/bin/sh

# Derictives

#PBS -N assemble_flows

#PBS -W group_list=yetibrain

#PBS -l nodes=1:ppn=1,walltime=2:00:00,mem=80000mb

#PBS -M sh3276@columbia.edu

#PBS -m a

#PBS -V

#PBS -o localhost:/u/10/s/sh3276/eo/

#PBS -e localhost:/u/10/s/sh3276/eo/

#PBS -t 11-20


echo "starting job"

date

matlab -nosplash -nodisplay -nodesktop -r "assemble_flows_break_yeti($PBS_ARRAYID);exit"

echo "done with job"

date

# End of script
