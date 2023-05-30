This repository contains the source code to replicate the simulation and application studies in:

Insolia, L., Perrotta, D. (2023). Tk-Merge: Computationally Efficient 
Robust Clustering Under General Assumptions.

The proposed algorithm (see txmerge.m) performs robust clustering of general-shaped components.

Our implementation builds upon the FSDA MATLAB Toolbox, which is freely available at https://github.com/UniprJRC/FSDA. To replicate our analyses, the user is required to clone the FSDA repository.

Each .m file can be run as is to replicate the results in our manuscript or supplemental material. Data for our application studies can be downloaded from the links provided in the main manuscript (aside from Example 3). The functional data application to weather data requires the user to load the original data within R (see applications/TKMfda.R).

If you need help using the code, experience any bugs or have any suggestions, please contact Luca Insolia (Luca.insolia at unige.ch).