#!/bin/bash

cd /files_to_convert

for folders in */; do
    subj="${folders%/}" #This line takes the directory and strips it of it's "/" so it we get a subject number (subj)
    echo "Processing subject ${subj}"

    #We need to prepare new directories for the new BIDS formatted files. 
    #The format is: rawdata/<subject>/<session>/<modality>
    mkdir -p /converted_files/sub-${subj}/ses-1/anat #We prepare the new directories according to bids specification.
    echo "...Directory for ${subj} converted anat BL created (session 1)"
    mkdir -p /converted_files/sub-${subj}/ses-2/anat
    echo "...Directory for ${subj} converted anat FU12 created (session 2)"
    mkdir -p /converted_files/sub-${subj}/ses-1/func
    echo "...Directory for ${subj} converted func BL created (session 1)"
    mkdir -p /converted_files/sub-${subj}/ses-2/func
    echo "...Directory for ${subj} converted func FU12 created (session 2)"

    echo "Conversion - Baseline Structural"
    # The dataset includes visit from 2 different visit labels, either PRE or NAP. Since the code still converts the data even if an error is thrown, I run the unelegant script below where every subject is tried with all labels.
    # Since the mnc2nii function doesn't output anything if an error occurs and that the name of the file would be the same with either labels, it seems sufficient at this time.
    mnc2nii -nii ${subj}/PREBL00/images/preventad_${subj}_PREBL00_t1w_001_t1w-defaced_001.mnc /converted_files/sub-${subj}/ses-1/anat/sub-${subj}_ses-1_T1w.nii
    mnc2nii -nii ${subj}/NAPBL00/images/preventad_${subj}_NAPBL00_t1w_001_t1w-defaced_001.mnc /converted_files/sub-${subj}/ses-1/anat/sub-${subj}_ses-1_T1w.nii

    echo "Conversion - 12 months Structural"
    mnc2nii -nii ${subj}/PREFU12/images/preventad_${subj}_PREFU12_t1w_001_t1w-defaced_001.mnc /converted_files/sub-${subj}/ses-2/anat/sub-${subj}_ses-2_T1w.nii
    mnc2nii -nii ${subj}/NAPFU12/images/preventad_${subj}_NAPFU12_t1w_001_t1w-defaced_001.mnc /converted_files/sub-${subj}/ses-2/anat/sub-${subj}_ses-2_T1w.nii

    echo "Conversion - Baseline Functional"
    mnc2nii -nii ${subj}/PREBL00/images/preventad_${subj}_PREBL00_bold_001.mnc /converted_files/sub-${subj}/ses-1/func/sub-${subj}_ses-1_task-rest_acq_bold.nii
    mnc2nii -nii ${subj}/NAPBL00/images/preventad_${subj}_NAPBL00_bold_001.mnc /converted_files/sub-${subj}/ses-1/func/sub-${subj}_ses-1_task-rest_acq_bold.nii

    echo "Conversion - 12 months Functional"
    mnc2nii -nii ${subj}/PREFU12/images/preventad_${subj}_PREFU12_bold_001.mnc /converted_files/sub-${subj}/ses-2/func/sub-${subj}_ses-2_task-rest_acq_bold.nii
    mnc2nii -nii ${subj}/NAPFU12/images/preventad_${subj}_NAPFU12_bold_001.mnc /converted_files/sub-${subj}/ses-2/func/sub-${subj}_ses-2_task-rest_acq_bold.nii
    
    echo "Conversion done"

done
