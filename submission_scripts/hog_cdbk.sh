#!/bin/sh

# Derictives

#PBS -N hog_cdbk

#PBS -W group_list=yetibrain

#PBS -l nodes=1:ppn=4,walltime=48:00:00,mem=16gb

#PBS -M sh3276@columbia.edu

#PBS -m ae

#PBS -V

#PBS -o localhost:/u/10/s/sh3276/eo/

#PBS -e localhost:/u/10/s/sh3276/eo/

echo "starting job"

date

matlab -nosplash -nodisplay -nodesktop -r "hog_cdbk_yeti($m,$n);exit"

echo "done with job"

date

# End of script
