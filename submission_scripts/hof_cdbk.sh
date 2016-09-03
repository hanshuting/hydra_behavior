#!/bin/sh

# Derictives

#PBS -N hof_cdbk

#PBS -W group_list=yetibrain

#PBS -l nodes=1:ppn=1,walltime=12:00:00,mem=8gb

#PBS -M sh3276@columbia.edu

#PBS -m ae

#PBS -V

#PBS -o localhost:/u/10/s/sh3276/eo/

#PBS -e localhost:/u/10/s/sh3276/eo/

echo "starting job"

date

matlab -nosplash -nodisplay -nodesktop -r "hof_cdbk_yeti($m,$n);exit"

echo "done with job"

date

# End of script
