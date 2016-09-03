#!/bin/sh

# Derictives

#PBS -N scr_cluster

#PBS -W group_list=yetibrain

#PBS -l nodes=1:ppn=2,walltime=48:00:00,mem=40000mb

#PBS -M sh3276@columbia.edu

#PBS -m a

#PBS -V

#PBS -o localhost:/u/10/s/sh3276/eo/

#PBS -e localhost:/u/10/s/sh3276/eo/

echo "starting job"

date

matlab -nosplash -nodisplay -nodesktop -r "scr_cluster_yeti_break;exit"

echo "done with job"

date

# End of script
