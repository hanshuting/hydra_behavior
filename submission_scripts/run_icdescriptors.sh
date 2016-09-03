#!/bin/sh

# Derictives

#PBS -N run_icdescriptors

#PBS -W group_list=yetibrain

#PBS -l nodes=1:ppn=4,walltime=24:00:00,mem=20gb

#PBS -M sh3276@columbia.edu

#PBS -m ae

#PBS -V

#PBS -o localhost:/u/10/s/sh3276/eo/

#PBS -e localhost:/u/10/s/sh3276/eo/

#PBS -t 1-13

echo "starting job"

date

# execute matlab script
module load matlab/2014a
matlab -nosplash -nodisplay -nodesktop << EOF
addpath(genpath('/u/10/s/sh3276/code/'));
scr_icdescriptors_yeti($PBS_ARRAYID);
exit
EOF

echo "done with job"

date

# End of script
