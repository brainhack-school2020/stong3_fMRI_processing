#!/bin/bash

set -e #Setting the environment
toplvl=/Users/stong3/Desktop/bhs_project #The top level of our folder
mncdir=/Users/stong3/Desktop/bhs_project/sourcedata #Where our mnc data is stored
#The mncdir, after sourcedata, has the structure: /subject/visit/images
mnc2niidir=/Users/stong3/Desktop/bhs_project/rawdata


#First pass - Baseline anatomical image
for subj in mncdir; do
    echo "Processing subject $subj"

    mkdir -p ${mnc2niidir}/sub-${subj}/ses-1/anat
    echo "...Directory for converted anat created"
    mkdir -p ${mnc2niidir}/sub-${subj}/ses-1/func
    echo "...Directory for converted func created"

    docker run -it -d --rm \
    -v {mncdir}/${subj}/*BL00/images:/files_to_convert:ro \
    -v {mnc2niidir}/sub-${subj}/ses-1/anat:/converted_files_anat \
    -v {mnc2niidir}/sub-${subj}/ses-1/func:/converted_files_func \
    -e ${subj} \
    nistmni/minc-toolkit \
    mnc2nii -nii /files_to_convert/preventad_${subj}_*BL00_t1w*.mnc /converted_files_anat/sub-${subj}_ses-1_T1w.nii \
    mnc2nii -nii /files_to_convert/preventad_${subj}_*BL00_bold_001.mnc /converted_files_func/sub-${subj}_ses-1_task-rest_acq_bold.nii

    ls {mnc2niidir}/{$subj}

