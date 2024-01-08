#!/bin/bash

SUB=$1
FMRIPREP=/tmp/fmriprep-1.5.0.simg
SURF_LICENSE=/usr/local/freesurfer/freesurfer_6.0.0_centos6/license.txt

export NTHREADS=3
export MEMMB=24576

export BIDS_DIR=/tmp/SZG2_BIDS/test
export OUTPUT_DIR=/tmp/SZG2_BIDS/derivatives
export WORK_DIR=/tmp/SZG2_BIDS/work


mkdir /tmp/workflow_${SUB}
cd /tmp/workflow_${SUB}
echo "Working from $PWD"
cp -r /net/data4/SchizGaze2_16/Subjects/SZG2_BIDS/sub-${SUB}/

# /home and /tmp are automatically available in the container
# -B host_dir:container_dir
# For example, -B /nfs/tarazlee/james:/data
# would make the data in /nfs/tarazlee/james visible at /data
# Do not mount over any standard directories within the container,
# e.g., never -B /usr/local:/usr/local

singularity run --cleanenv $FMRIPREP                        \
    $BIDS_DIR $OUTPUT_DIR participant                       \
    --nthreads ${NTHREADS}                                  \
    --mem-mb ${MEMMB}                                       \
    --fs-license-file=$SURF_LICENSE                         \
    --participant-label=sub-2026                          \
    -w $WORK_DIR                                            \
    --ignore slicetiming                                    \
    --use-aroma                                             \
    --aroma-melodic-dimensionality -100                     \
    --output-spaces T1w
    --output-spaces MNI152NLin6Asym:res-2 fsaverage:den-10k \
