#!/bin/sh

# Derictives

#PBS -N scr_descriptors_path

#PBS -W group_list=yetibrain

#PBS -l nodes=1:ppn=8,walltime=10:00:00,mem=8gb

#PBS -M sh3276@columbia.edu

#PBS -m ae

#PBS -V

#PBS -o localhost:/u/10/s/sh3276/eo/

#PBS -e localhost:/u/10/s/sh3276/eo/

#PBS -t 1

echo "starting job"

date

# copy input data to $TMPDIR
cp -r /vega/brain/users/sh3276/data/20150218_light_1_5hz_resized.tif $TMPDIR/20150218_light_1_5hz_resized.tif
cd $TMPDIR

# execute matlab script
module load matlab/2014a
matlab -nosplash -nodisplay -nodesktop <<EOF
parpool;
addpath(genpath('/u/10/s/sh3276/code/'));
job=batch(@scr_descriptors_pathyeti,2,{$PBS_ARRAYID,'$TMPDIR'});
wait(job);
getReport(job.Tasks(1).Error);
exit
EOF

# remove input data from $TMPDIR
rm $TMPDIR/20150218_light_1_5hz_resized.tif

echo "done with job"

date

# End of script
