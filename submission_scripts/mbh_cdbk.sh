#!/bin/sh

# Derictives

#PBS -N mbh_cdbk

#PBS -W group_list=yetibrain

#PBS -l nodes=1:ppn=1,walltime=12:00:00,mem=40000mb

#PBS -M sh3276@columbia.edu

#PBS -m a

#PBS -V

#PBS -o localhost:/u/10/s/sh3276/eo/

#PBS -e localhost:/u/10/s/sh3276/eo/

echo "starting job"

date

matlab -nosplash -nodisplay -nodesktop -r "scr_mbh_cdbk_yeti;exit"

echo "done with job"

date

# End of script
