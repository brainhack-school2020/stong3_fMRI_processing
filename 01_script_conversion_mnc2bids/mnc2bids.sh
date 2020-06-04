#!/bin/bash

#First, inside the container, we need to move to the directory where the files to convert are stored. We can force this with a cd command.

cd /files_to_convert

#The loop starts below
for folders in */; do #This starts the loop. For each folder in the files_to_convert directory, do the following:
    subj="${folders%/}" #Take the name of the folder, strip the "/" and assign this value to a variable "subj" (subject)
    echo "--------------------------"
    echo "--------------------------"
    echo "Processing subject ${subj}" #This is for us: it simply echoes which subject we are currently processing in ther terminal.
    echo "--------------------------"
    #We need to prepare new directories for the new BIDS formatted files. 
    #The format according to BIDS specification is: rawdata/<subject>/<session>/<modality>
        #The loop will take care of the "subject" part using the $subj variable
        #We create 2 sub-directories for each subject (session 1 - baseline, and session 2 - 12 months)
        #In each sub-directory, for each session, we create an anat and a func folder
    echo "--------------------------"
    echo "Creating..."
    mkdir -p /converted_files/sub-${subj}/ses-BL00/anat
    echo "...Directory for ${subj} converted anat BL created (session 1)"
    mkdir -p /converted_files/sub-${subj}/ses-FU12/anat
    echo "...Directory for ${subj} converted anat FU12 created (session 2)"
    mkdir -p /converted_files/sub-${subj}/ses-BL00/func #The p create intermediate directories too.
    echo "...Directory for ${subj} converted func BL created (session 1)"
    mkdir -p /converted_files/sub-${subj}/ses-FU12/func
    echo "...Directory for ${subj} converted func FU12 created (session 2)"

    echo " "
    echo "Starting conversion..."
    echo " "
    #We have a little problem with the visit labels. The dataset includes visit from 2 different visit labels, either PRE or NAP. We can use a bash operator "||" to lauch
    ## the same task with NAP instead of PRE if the mnc2nii cannot find a PRE visit.
    echo "--------------------------------"
    echo "Conversion - Baseline Structural"
    echo "--------------------------------"

    echo "Testing if the subject has a PRE visit"
        #If the line below fails, the || operator executes the next line. Since we use line break operators, the echo and next mnc2nii commands count as a single command.
    mnc2nii -nii ${subj}/PREBL00/images/preventad_${subj}_PREBL00_t1w_001_t1w-defaced_001.mnc /converted_files/sub-${subj}/ses-BL00/anat/sub-${subj}_ses-BL00_T1w.nii || \
    ( echo "There is no PRE visit. Checking for a NAP visit..." && \
    mnc2nii -nii ${subj}/NAPBL00/images/preventad_${subj}_NAPBL00_t1w_001_t1w-defaced_001.mnc /converted_files/sub-${subj}/ses-BL00/anat/sub-${subj}_ses-BL00_T1w.nii )

    echo "--------------------------------"
    echo "Conversion - 12 months Structural"
    echo "--------------------------------"

    echo "Testing if the subject has a PRE visit"
    mnc2nii -nii ${subj}/PREFU12/images/preventad_${subj}_PREFU12_t1w_001_t1w-defaced_001.mnc /converted_files/sub-${subj}/ses-FU12/anat/sub-${subj}_ses-FU12_T1w.nii || \
    ( echo "There is no PRE visit. Checking for a NAP visit..." && \
    mnc2nii -nii ${subj}/NAPFU12/images/preventad_${subj}_NAPFU12_t1w_001_t1w-defaced_001.mnc /converted_files/sub-${subj}/ses-FU12/anat/sub-${subj}_ses-FU12_T1w.nii )

    echo "--------------------------------"
    echo "Conversion - Baseline Functional"
    echo "--------------------------------"

    echo "Testing if the subject has a PRE visit"
    mnc2nii -nii ${subj}/PREBL00/images/preventad_${subj}_PREBL00_bold_001.mnc /converted_files/sub-${subj}/ses-BL00/func/sub-${subj}_ses-BL00_task-rest_bold.nii || \
    ( echo "There is no PRE visit. Checking for a NAP visit..." ; \
    mnc2nii -nii ${subj}/NAPBL00/images/preventad_${subj}_NAPBL00_bold_001.mnc /converted_files/sub-${subj}/ses-BL00/func/sub-${subj}_ses-BL00_task-rest_bold.nii )

    echo "--------------------------------"
    echo "Conversion - 12 months Functional"
    echo "--------------------------------"

    echo "Testing if the subject has a PRE visit"
    mnc2nii -nii ${subj}/PREFU12/images/preventad_${subj}_PREFU12_bold_001.mnc /converted_files/sub-${subj}/ses-FU12/func/sub-${subj}_ses-FU12_task-rest_bold.nii || \
    ( echo "There is no PRE visit. Checking for a NAP visit..." ; \
    mnc2nii -nii ${subj}/NAPFU12/images/preventad_${subj}_NAPFU12_bold_001.mnc /converted_files/sub-${subj}/ses-FU12/func/sub-${subj}_ses-FU12_task-rest_bold.nii )
    
    echo "Conversion done for subject ${subj}! "
    echo " "
done #Don't forget to tell the loop to close!
