
# Tk-Merge: Computationally Efficient Robust Clustering Under General Assumptions.

Insolia, L., Perrotta, D. (2023). Tk-Merge: Computationally Efficient Robust Clustering Under General Assumptions.

# Abstract

In real-world applications, the group of provenance of data can be inherently uncertain,  the data values can be imprecise and some of them can be  wrong.  We handle uncertain, imprecise and noisy data in clustering problems with general-shaped structures. We do it under very weak parametric assumptions with a two-step hybrid robust clustering algorithm based on trimmed k-means and hierarchical agglomeration. 
The algorithm has low computational complexity and effectively identifies the clusters also in presence of data contamination.
We also present natural generalizations of the approach as well as an adaptive procedure to estimate the amount of contamination in a data-driven fashion. 
Our proposal outperforms state-of-the-art robust, model-based methods in our numerical simulations and  real-world applications related to color quantization for image analysis, human mobility patterns based on GPS data, biomedical images of diabetic retinopathy, and functional data across weather stations.

# MATLAB Code

This repository contains the source code to replicate the simulation and application studies in the paper.
The proposed algorithm (see txmerge.m) performs robust clustering of general-shaped components.
Our implementation builds upon the FSDA MATLAB Toolbox, which is freely available at https://github.com/UniprJRC/FSDA. To replicate our analyses, the user is required to clone the FSDA repository.
Each .m file can be run as is to replicate the results in our manuscript or supplemental material. Data for our application studies can be downloaded from the links provided in the main manuscript (aside from Example 3). The functional data application to weather data requires the user to load the original data within R (see applications/TKMfda.R).
If you need help using the code, experience any bugs or have any suggestions, please contact Luca Insolia (Luca.insolia at unige.ch).

The code which generates all the figures can be found under the folders simulations and applications. 
