"""
Script - Post-processing fMRI images with Nilearn to obtain connectivity matrices
Author: Frédéric St-Onge

Date created: June 3rd 2020
Date modified: June 3rd 2020

Purpose:
    This script aims to import pre-processed images and confounds list from fMRIPrep and generate connectivity
    matrices based on the Schaefer Atlas parcellation. The script uses lists to iterate over nested loops to
    generate outputs for different subjects/sessions/confounds/kind of connectivity matrices.

Version: 0.1

Future updates:
- Integrate argument parsers for the subjects/sessions/confounds/kind of connectivity matrices
- Modify the pipeline to further scrub the frame-wise displacement? (look at fmripop: https://github.com/brain-modelling-group/fmripop)
"""
##############################################################################################################


#First step: Import necessary packages for the full script
from nilearn import datasets #For atlases
from nilearn import plotting #To plot brain images
from nilearn.input_data import NiftiLabelsMasker #To mask the data
from nilearn.connectome import ConnectivityMeasure #To compute the connectivity matrices
import pandas as pd #For dataframe manipulation (e.g. confound file)
from matplotlib import pyplot as plt #Used to bypass a bug where the figures wouldn't close in Nilearn
import numpy as np #To convert our confounds to numpy array
import os #To create directories in the loop

###
#Import the necessary atlases for the current processing. Chose the atlases you need
## An overview of available atlases is available here: https://nilearn.github.io/modules/reference.html#module-nilearn.datasets

## For the purpose of the present analyses, we chose the Schaefer Atlas with 200 brain regions.

#This downloads the atlas
#From the download, we first extract the 'maps' (i.e. the .nii image representing the atlas regions) and the we extract the labels (i.e. what each region is)
atlas_schaefer = datasets.fetch_atlas_schaefer_2018(n_rois=200)
atlas_filename_schaefer = atlas_schaefer.maps 
labels_schaefer = atlas_schaefer.labels 
print(f'The atlas is located at {atlas_filename_schaefer}') 
#print(labels_schaefer) #Prints the array of the labels
#print(len(labels_schaefer)) #Prints the length of the labels

#Should you need, you can plot the atlas representation here:
#plotting.plot_roi(atlas_filename_schaefer) #Plotting the regions included in the atlas


###
# Prepare to extract the subjects. To facilitate loops, we first:
# 1) Set subjects location
# 2) Set root location for derivatives (or creates it if the script is run for the first time)
# 3) Set the variables for the iterations and confounds
# 4) Start the loop

# 1)
subjects_location = '/Users/stong3/Desktop/test_fmriprep_PAD/derivatives/fmriprep/fmriprep'

# 2)
connectivity_matrices_dir = '/Users/stong3/Desktop/test_fmriprep_PAD/derivatives/connectivity_matrices/'

#This part creates the root directory inside of the derivatives folder, specified by the BIDS convention. The path above should reflect where you want the directory to go.
#Even if the intermediate path (derivatives) is not created yet, the function 'makedirs' creates it for you.
if not os.path.exists(connectivity_matrices_dir):
    os.makedirs(connectivity_matrices_dir)
    print(f'Created directory:{connectivity_matrices_dir}')
else:
    print(f'Directory {connectivity_matrices_dir} already exists. No directory is created.')


# 3) 
subject_list = ['00001']
session_list = ['BL00A', 'FU12A']
list_confounds = ['csf', 'white_matter', 'global_signal', 'trans_x', 'trans_y', 'trans_z', 'rot_x', 'rot_y', 'rot_z', 'cosine00', 'cosine01', 'cosine02']
kind_connectivity = ['correlation', 'partial correlation']
atlas = 'schaefer'
##The next steps... Create empty lists and append the list based on a .txt file? Or simply arguments?

print('------------------------------------')
print('Description of the post-processing: ')
print(f'    Subjects to process are with the following IDs : {subject_list}')
print(f'    Sessiong to process are the following : {session_list}')
print(f'    The confounds included to generate the matrices are : {list_confounds}')
print(f'    The kind of correlation matrices to be generated are: {kind_connectivity}')
print(f'    All procedures will be done with the {atlas} atlas/map.')
print('------------------------------------')

# 4)
for subject in subject_list:
    for session in session_list:
        print(f'Starting connectivity matrices extraction for subject {subject} for session {session}')
        print('------------------------------------')
        print(' ')
        
        #First, we need to import the paths where the fMRI pre-processed and confounds files are stored. They follow BIDS convention and depend on the path provided
        #for the subject location. After fetching the paths, we print them.
        print('Fetching the paths for the fMRI files and the confond files...')
        pre_processed_fmri_file = f'{subjects_location}sub-{subject}/ses-{session}/func/sub-{subject}_ses-{session}_task-rest_run-1_space-T1w_desc-preproc_bold.nii.gz'
        full_confound_file_fmriprep = f'{subjects_location}sub-{subject}/ses-{session}/func/sub-{subject}_ses-{session}_task-rest_run-1_desc-confounds_regressors.tsv'

        print(f'The path for the fmri file is: {pre_processed_fmri_file}')
        print(f'The path for the full confound file is: {full_confound_file_fmriprep}')
        print('------------------------------------')
        print(' ')

        #The confound file from fMRIPrep is huge and needs to be cleaned. We import it with Pandas to keep column names and select them more easily.
        print('We now import the confound file using Pandas:')
        confounds = pd.read_csv(full_confound_file_fmriprep, delimiter = '\t')
        print(f'Confounds selected for this extractions were: {list_confounds}')
        #print(confounds.head())
        final_confounds = confounds[list_confounds]
        #print(final_confounds.head())

        #We need to convert the dataframe type of Pandas to a Numpy array so it is readable by Nilearn.
        print('Conversion to Numpy array:')
        confounds_np = final_confounds.to_numpy()
        print('Done!')
        print('------------------------------------')
        

        #We are now ready to extract the time series using our atlas mask
        #from nilearn.input_data import NiftiLabelsMasker #Already imported in the top of the script
        print('Creating masker using ', atlas_filename_schaefer)

        masker = NiftiLabelsMasker(labels_img=atlas_filename_schaefer, standardize=True, verbose=5)
        time_series = masker.fit_transform(pre_processed_fmri_file, confounds=confounds_np)
        print('The shape of our time series is: ', np.shape(time_series))

        #We are now ready to extract the connectivity matrix using Nilearn functions.
        #This part of the script will:
        ## 1) Create a loop to extract matrices according to the kind of matrix wanted (e.g. correlation, partial correlation, etc.)
        ## 2) Check that the matrix shape matches the length of the atlas labels
        ## 3) Create a Pandas dataframe with the labels as columns and indices
        ## 4) Create a directory where we can save the matrix ('bids-like')
        ## 5) Export the dataframe to a .csv file 
        ## 6) Use Nilearn functions to plot the matrix with labels
        ## 7) Save the image in the same directory as the .csv file.

        ### 1)
        print('Extracting connectivity matrices for the following kinds: ', kind_connectivity)
        for kind in kind_connectivity:
            correlation_measure = ConnectivityMeasure(kind = kind)
            correlation_matrix = correlation_measure.fit_transform([time_series])[0]
            print('The shape of the correlation matrix is: ', np.shape(correlation_matrix))
        ### 2)
            print('Testing if the shape of the matrix and the lenght of the labels are matching:')
            try:
                len(labels_schaefer) in np.shape(correlation_matrix)
                if False:
                    raise ValueError('The length of the labels do not match the shape of the correlation_matrix')
            except ValueError:
                exit('The shape of the matrix and labels are not matching')
            print('The shape of the matrix and labels are matching.')
        ### 3)
            print('Creating a Pandas dataframe with labels as index')
            subject_connectivity_matrix = pd.DataFrame(data=correlation_matrix, index=labels_schaefer, columns=labels_schaefer)
            #print(subject_connectivity_matrix.head())
        ### 4)
            print('Creating a directory to save the computed correlation matrices')
            dir_matrices_derivatives = f'{connectivity_matrices_dir}sub-{subject}/ses-{session}/kind-{kind}/'
            if not os.path.exists(dir_matrices_derivatives):
                os.makedirs(dir_matrices_derivatives)
                print(f'Created directory:{dir_matrices_derivatives}')
            else:
                print(f'Directory {dir_matrices_derivatives} already exists. None is created.')

        ### 5)
            #Using an f string, we give the new directory
            print(f'Saving dataframe to a .csv file in : {dir_matrices_derivatives}')
            subject_connectivity_matrix.to_csv(f'{dir_matrices_derivatives}sub-{subject}_ses-{session}_atlas-{atlas}_kind-{kind}_connectivity_matrix.csv')

        ### 6)
            #from nilearn import plotting
            ## This one plots the matrix without reordering the clusters of fMRI activation and fitting labels
            display = plotting.plot_matrix(correlation_matrix)
            display.figure.savefig(f'{dir_matrices_derivatives}sub-{subject}_ses-{session}_atlas-{atlas}_kind-{kind}_connectivity_matrix_no_labels_not_ordered.png')  
            plt.close()

            ## This one plots the matrix, reorders the clusters and places the labels on the figure
            display1 = plotting.plot_matrix(correlation_matrix, figure=(30, 30), labels=labels_schaefer, vmax=0.8, vmin=-0.8, reorder=True)
            display1.figure.savefig(f'{dir_matrices_derivatives}sub-{subject}_ses-{session}_atlas-{atlas}_kind-{kind}_connectivity_matrix_labels_ordered.png')  
            plt.close()



