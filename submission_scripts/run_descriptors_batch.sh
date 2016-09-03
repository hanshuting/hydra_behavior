#!/bin/sh

# Derictives

#PBS -N scr_descriptors

#PBS -W group_list=yetibrain

#PBS -l nodes=1:ppn=8,walltime=10:00:00,mem=40000mb

#PBS -M sh3276@columbia.edu

#PBS -m ae

#PBS -V

#PBS -o localhost:/u/10/s/sh3276/eo/

#PBS -e localhost:/u/10/s/sh3276/eo/

#PBS -t 13

echo "starting job"

date

# copy input data to $TMPDIR
#cp /vega/brain/users/sh3276/data/20150218_light_1_5hz_resized.tif
cd $TMPDIR

# execute matlab script
module load matlab/2014a
matlab -nosplash -nodisplay -nodesktop << EOF
c=parcluster('local');
addpath(genpath('/u/10/s/sh3276/code/'));
job=createJob(c);
createTask(job,@scr_descriptors_yeti,1,{$PBS_ARRAYID});
submit(job);
wait(job,'finished');
getReport(job.Tasks(1).Error);
exit
EOF

# remove input data from $TMPDIR
#cd /spare/yeti/tmp/
#rm $TMPDIR/20150218_light_1_5hz_resized.tif

echo "done with job"

date

# End of script
