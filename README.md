# Decomposing Neuroanatomical Heterogeneity in Depression: Preprocessing and Harmonization Pipeline

This repository contains the R code applied for the preprocessing and harmonization pipeline used in our study on neuroanatomical heterogeneity in Major Depressive Disorder (MDD). The harmonization analyses adjust for scanner protocol, site effects, and other batch-related influences in the multi-site neuroimaging data, using the neuroComBat package.

## Preprocessing and exclusion criteria for harmonization

The initial dataset, derived from 41 sites, included N=9,831 individuals (MDDs: 4,205; Controls: 5,626). Individual FreeSurfer features across cortical thickness (CT), cortical surface area (CSA), and subcortical volume (SV) domains were assessed, and samples with >5% missing data, indicating possible parcellation or reliability issues, were excluded. Following deduplication and removal of individuals with missing or ambiguous values for diagnosis, sex, and age, N=1,314 participants (MDD: 564; HC: 750) were excluded, yielding a final preprocessed dataset of N=8,517 individuals (MDD: 3,641; HC: 4,876).

## Harmonization

The preprocessed dataset (N=8,517) was harmonized seperately for each neuroanatomical domian (CT, CSA, SV) using the neuroComBat package (https://github.com/Jfortin1/neuroCombat_Rpackage; Fortin, J. P. et al. Harmonization of cortical thickness measurements across scanners and sites. Neuroimage 167, 104 (2017)), an enhanced version of ComBat (Johnson, W. E., Li, C. & Rabinovic, A. Adjusting batch effects in microarray expression data using empirical Bayes methods. Biostatistics 8, 118–127 (2007)), to adjust for site-specific effects (e.g., scanner type, protocol variations, FreeSurfer version) while preserving covariate effects (age, sex, diagnosis). 

