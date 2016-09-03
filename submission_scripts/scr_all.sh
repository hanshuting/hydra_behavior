#!/bin/sh

# Derictives

#PBS -N scr_all

#PBS -W group_list=yetibrain

#PBS -l nodes=1:ppn=4,walltime=24:00:00,mem=40000mb

#PBS -M sh3276@columbia.edu

#PBS -m abe

#PBS -V

#PBS -o localhost:/u/10/s/sh3276/eo/

#PBS -e localhost:/u/10/s/sh3276/eo/

echo "starting job"

date

matlab -nosplash -nodisplay -nodesktop -r "script_all_yeti;exit"

echo "done with job"

date

# End of script
