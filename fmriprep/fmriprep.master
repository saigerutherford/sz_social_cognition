#!/bin/bash -l
####  Begin Slurm preamble

#SBATCH --job-name=fmriprep_test1
#SBATCH --mail-type=FAIL
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=3
#SBATCH --cpus-per-task=1
#SBATCH --mem=24576m
#SBATCH --time=32:00:00
#SBATCH --account=sripada
#SBATCH -p standard

####  End Slurm preamble
echo
echo "STEP 1: SETUP ENVIRONMENT"
echo
module load fsl/6.0.1

# Reset NTHREADS to be the number of processors available for this job
export NTHREADS=3
export MEMMB=24576

#defined by submit script, no sub- or ses- prefixes
#SUB
#SESSION
umask 0002 

export SCRIPTDIR=/scratch/sripada_root/sripada/shared_data/workflow
export ENV=~/environments/aws3/
export DCM2BIDS_CFG=${SCRIPTDIR}/data/abcd_dcm2bids.conf
export FSL_DIR=/sw/arcts/centos7/fsl/6.0.1/
export PATH=${PATH}:${SCRIPTDIR}/bin
export OUTPUTDIR=/scratch/sripada_root/sripada/shared_data/workflow/
export LOG_DIR=${OUTPUTDIR}/logs

#set up a /tmp folder
#mkdir -p ${LOG_DIR}/${SUB}
echo "SCRIPTDIR: ${SCRIPTDIR}" > ${LOG_DIR}/${SUB}/${SESSION}/01setup.log 2>&1
echo "ENV: ${ENV}" >> ${LOG_DIR}/${SUB}/${SESSION}/01setup.log 2>&1
echo "DCM2BIDS_CFG: ${DCM2BIDS_CFG}" >> ${LOG_DIR}/${SUB}/${SESSION}/01setup.log 2>&1
echo "FSL_DIR: ${FSL_DIR}" >> ${LOG_DIR}/${SUB}/${SESSION}/01setup.log 2>&1
echo "LOG_DIR: ${LOG_DIR}" >> ${LOG_DIR}/${SUB}/${SESSION}/01setup.log 2>&1
echo "PATH: ${PATH}" >> ${LOG_DIR}/${SUB}/${SESSION}/01setup.log 2>&1
echo "OUTPUTDIR: ${OUTPUTDIR}" >> ${LOG_DIR}/${SUB}/${SESSION}/01setup.log 2>&1
echo "NTHREADS: $NTHREADS" >> ${LOG_DIR}/${SUB}/${SESSION}/01setup.log 2>&1
echo "MEMMB: ${MEMMB}" >> ${LOG_DIR}/${SUB}/${SESSION}/01setup.log 2>&1
module list >> ${LOG_DIR}/${SUB}/${SESSION}/01setup.log 2>&1

if [[ -d /tmp/workflow_${SUB} ]]; then
    rm -rf /tmp/workflow_${SUB}
fi

mkdir /tmp/workflow_${SUB}
cd /tmp/workflow_${SUB}
echo "Working from $PWD"

source ${ENV}/bin/activate

echo
echo "STEP 2: DOWNLOADING"
echo
#download subject
#think we're going to need some logic in this script to deal with different output folders of different scanners
${SCRIPTDIR}/code/cp_bash.sh > ${LOG_DIR}/${SUB}/${SESSION}/02download.log 2>&1
if [ ! $? -eq 0 ]; then
    echo "STEP 2: FAILED"
    exit 0
fi

echo
echo "STEP 3: DCM2BIDS"
echo
#dcm2bids
${SCRIPTDIR}/code/dcm2bids.sh > ${LOG_DIR}/${SUB}/${SESSION}/03dcm2bids.log 2>&1
if [ ! $? -eq 0 ]; then
    echo "STEP 3: FAILED"
    exit 0
fi

echo
echo "STEP 4: FIELDMAP"
echo
#fieldmaps
${SCRIPTDIR}/src/unpack_and_setup.sh sub-${SUB} ses-${SESSION} > ${LOG_DIR}/${SUB}/${SESSION}/04unpack.log 2>&1
if [ ! $? -eq 0 ]; then 
    echo "STEP 4: FAILED"
    exit 0
fi

echo
echo "STEP 5: JSON CORRECTIONS"
echo
#final json corrections
${SCRIPTDIR}/src/correct_jsons.py /tmp/workflow_${SUB}/BIDS > ${LOG_DIR}/${SUB}/${SESSION}/05correct.log 2>&1
if [ ! $? -eq 0 ]; then 
    echo "STEP 5: FAILED"
    exit 0
fi

${SCRIPTDIR}/code/check_errors.sh 
if [ ! $? -eq 0 ]; then
    echo "ERRORS PRIOR TO FMRIPREP"
    exit 0
fi


echo
echo "STEP 6: FMRIPREP"
echo
#fmriprep
${SCRIPTDIR}/code/run_fmriprep.sh > ${LOG_DIR}/${SUB}/${SESSION}/06fmriprep.log 2>&1

echo
echo "STEP 7: CLEANUP"
echo
#cleanup
${SCRIPTDIR}/code/cleanup.sh > ${LOG_DIR}/${SUB}/${SESSION}/07cleanup.log 2>&1
if [ ! $? -eq 0 ]; then
    echo "STEP 7: FAILED"
    exit 0
fi


