# fMRI preprocessing using fMRIPrep and Atlas Extraction using Nilearn

## Summary of the Brain Hack School project

The goal of this project will be to use a subset of an open fMRI dataset (Prevent-AD) to create a tutorial in the form of
a Jupiter notebook, to pre-process fMRI data using fMRIPrep. The project will also use Nilearn to extract functional
connectivity atlases. All these operations will be done on an HPC server (i.e. Beluga) using Slurm Job submission.

## Project definition
### Background

Having little experience with neuroimaging and my PhD thesis using fMRI, I want to be able to start from raw data
(in BIDS format) and learn how to process the data until I obtain derivatives (i.e. connectivity matrices). Based
on the current PhD project that I am working on, using various atlases leads to varying results. As such, I want
to extract connectivity matrices from pre-processed time-series using Nilearn, which comes pre-loaded with several
atlases of interest. Finally, as most of my work will involve large cohorts (which might not be feasible to do 
on a personnal computer), I want to be able to realize these analyses on a HPC, where ressources can be used appropriatly.

### Data and tools

Data: A subset of 10 subjects, with 2 scans each, from the open data of the PREVENT-AD (part of the CONP initiative)

Preprocessing tool: fMRIPrep, an open fMRI processing software, available through a Singularity container

Matrice extraction: Nilearn, an open Python package, allowing for extraction of connectivity matrices based on specific atlases

HPC: Beluga 

### Deliverables

The deliverables will take the form of 1) Fingerprinting analyses using the 10 subjects and 2) A tutorial in the form of a notebook
on how to pre-process fMRI data on an HPC server. 
