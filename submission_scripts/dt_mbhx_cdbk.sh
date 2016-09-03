#!/bin/sh

# Derictives

#PBS -N dt_mbhx_cdbk

#PBS -W group_list=yetibrain

#PBS -l nodes=1:ppn=8,walltime=12:00:00,mem=8gb

#PBS -M sh3276@columbia.edu

#PBS -m a

#PBS -V

#PBS -o localhost:/u/10/s/sh3276/eo/

#PBS -e localhost:/u/10/s/sh3276/eo/

echo "starting job"

date

matlab -nosplash -nodisplay -nodesktop -r "dt_mbhx_cdbk_yeti($CHUNK_LEN,$TRACK_LEN,$TRACK_TH,$SAMPLE_STRIDE);exit"

echo "done with job"

date

# End of script
