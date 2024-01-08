# sz_social_cognition

## Analysis code for: *Social Cognition and Functional Connectivity in Early Psychosis and Schizophrenia.* Rutherford et al. (2024).

**Pre-registration [link](https://osf.io/jh5fc).**

This repository is organized as follows:

 - `connectivity/` --> scripts for creating subject-level seed connectivity maps
 - `fmriprep/` --> scripts for running fMRI preprocessing using fMRIPrep
 - `group_level/` --> scripts for running group difference tests on subject-level connectivity maps (HC vs. SZ and HC vs. EP)
 - `prediction/` --> scripts for prediction of social cognition and visualization of predictive model evaluation metrics and statistical significance
 - `rois/` --> IPS-IFG peak coordinate NIFTI mask
 - `stat_maps/` --> Group difference statistical maps (Z_stat) for IPS seed
