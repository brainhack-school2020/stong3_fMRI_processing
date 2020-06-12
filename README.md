# fMRI preprocessing using fMRIPrep and Atlas Extraction using Nilearn

## Summary of the Brain Hack School project - Initial plan at week 2

The goal of this project was to use a subset of an open fMRI dataset (Prevent-AD) to create a tutorial in the form of
a Jupiter notebook, to pre-process fMRI data using fMRIPrep. The project was also aiming to develop a basic Nilearn pipeline to extract functional connectivity atlases. All these operations were initially planned be done on an HPC server (i.e. Beluga) using Slurm Job submission.

## Project definition - Initial plan at week 2
### Background

Having little experience with neuroimaging and my PhD thesis using fMRI, I wanted to be able to start from raw data
(in BIDS format) and learn how to process the data until I obtain derivatives (i.e. connectivity matrices). Based
on the current PhD project that I am working on, using various atlases leads to varying results. As such, I wanted
to extract connectivity matrices from pre-processed time-series using Nilearn, which comes pre-loaded with several
atlases of interest. Finally, as most of my work will involve large cohorts (which might not be feasible to do 
on a personnal computer), I wanted to be able to realize these analyses on a HPC, where ressources can be used appropriatly.

### Data and tools

Data: A subset of 10 subjects, with 2 scans each, from the open data of the PREVENT-AD (part of the CONP initiative)

Preprocessing tool: fMRIPrep, an open fMRI processing software, available through a Singularity container

Matrice extraction: Nilearn, an open Python package, allowing for extraction of connectivity matrices based on specific atlases

HPC: Beluga 

### Deliverables

The deliverables will take the form of 1) Fingerprinting analyses using the 10 subjects and 2) A tutorial in the form of a notebook on how to pre-process fMRI data on an HPC server.

## Project definition - Final plan at week 4
### Background

The initial project aimed to create a full tutorial on how to process fMRI images, starting from raw, un-processed data, all the way to extracting derivatives from pre-processed images. The project however changed substantially as the weeks advanced. Below is a representation of the objectives before (in week 2) and objectives of the current week (week 4):

| Week 2 - Objectives                                                                                                        | Week 4 - Objectives                                                                                                    |
|----------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------|
| - [DONE] Download Prevent-AD Date from the CONP using DataLad                                                              | - [DONE] Despair and lose hope a little bit because the whole week 3 is gone converting images for nothing             |
| - [DONE] Transform the .mnc format files in BIDS using a custom bash script and the minc-toolkit within a Docker container | - [DONE] Regain hope and change objectives                                                                             |
| - [PROBLEM] Perform BIDS validation using a Docker container of bids/validator                                             | - [DONE] Download two BIDSed visits of a single subject of the Prevent-AD directly from the lab's HPC using ```scp```  |
| - BIDS correction, if needed (e.g. including a dataset_description.json)                                                   | - [DONE] Run BIDS validator on the data to ensure it is 'BIDS-valid' and do appropriate corrections if needed.         |
| - Running fMRIPrep using a Docker container                                                                                | - [DONE] Launch fMRIPrep a couple of time to better understand the options available and correct errors                |
| - Use the fMRIPrep output to build a basic Nilearn pipeline to extract functional connectivity                             | - [DONE] Wait 14h per subject as the subject was processed locally                                                     |
| - Run fingerprinting analyses between the 2 visits of each of the 10 subjects                                              | - [DONE] Develop the Nilearn pipeline to extract the functional connectivity from the data                             |
|                                                                                                                            | - [In progress] Create deliverables (Two notebooks: One with the failed steps and the second with the steps of week 4) |
|                                                                                                                            | - [In progress] Create presentation for BHS                                                                            |
|                                                                                                                            | - [In progress] Clean up the repository                                                                                |
|                                                                                                                            | - Create nice brain image                                                                                              |

To explain more clearly what happened, at the end of week 3, after I was able to convert the ```.mnc``` images in ```.nii``` format and 'BIDS-like' format, the bids-validator would not work due to the fact that there is usually a ```.json``` file that accompagnies the images and provide information that is necessary for pre-processing. After asking around, unless I would know enough about ```.mnc``` format to extract the necessary information in the headers to create the ```.json``` files myself, there was nothing I could do to transform in bids. As such, I had to change the project to use data that was already in bids.

### Objective
Use 2 visits of a single subject in the Prevent-AD cohort (anonymized) in bids format to illustrate pre-processing using fMRIPrep and to extract connectivity matrices using Nilearn.

### Tools
Docker containers were used to pull the bids-validator and fMRIPrep. Nilearn was used on the pre-processed data to generate connectivity matrices

### Deliverables
Create 2 Jupyter notebooks: 1) A tutorial on using mnc2bids (first project, not currently working) and 2) A tutorial on using fMRIPrep and Nilearn. 
