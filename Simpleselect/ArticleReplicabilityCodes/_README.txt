% This folder relates to the paper:
% "A practically efficient fixed-pivot selection algorithm and its 
% extensible MATLAB suite". It contains the novel functions and the code 
% to reproduce the results in the figures and the table of the paper.
%
% The novel functions linked to the selection algorithm, inclusive of
% as extensive header with detailed documentation and practical examples 
% of function usage, are:
%
% - quickselectFS.m     (root folder)
% - quickselectFSw.m    (root folder)
% - quickselectFSmex.c  (dep_mex folder)
% - quickselectFSwmex.c (dep_mex folder)
% - vervaatrnd.m        (dep_fsda folder)
% - vervaatsim.m        (dep_fsda folder)
% - vervaatxdf.m        (dep_fsda folder) 
% 
% The functions and script used to replicate the results in the paper are:
%
% - Figure1_NumberOfElemtaryOperation.m
% - Figure3_ComputationalTime.m
% - Figure4_FSM_MCD_TIME_testing.m
% - Figure5_W_check_obj.m
% - Figure5_W_check_position.m
% - Figure5_W_check_time.m
% - Figure6_weighted_median_filter.m
% - Table1_medc_test.m
%
% They contain few introductory lines and the examples that reproduce the 
% figures and the table in the paper and some complementary output. 
% To run the examples, it is necessary to execute the function addDEP2path, 
% which adds to the MATLAB path all dependencies in the folders:
%
% - dep_mex:     contains the C-functions and mex-files compiled for macos,  
%                linux and windows.
% - dep_robstat: contains functions to compute the Minimum Covariant Determinant 
%                (MCD) and Forward Search (FS) estimators, slightly modified
%                to monitor the time taken by sorting and order statistics.
% - dep_mc:      contains functions to compute the medcouple taken from 
%                the LIBRA toolbox, which is distributed by KU Leuven at:
%                https://github.com/mwgeurts/libra or
%                https://wis.kuleuven.be/statdatascience/robust/LIBRA/
% - dep_fsda:    contains standalone FSDA functions not relevant to the  
%                paper but required to run the MCD, FS and some examples;  
%                they are taken from:
%                https://github.com/UniprJRC
%                https://it.mathworks.com/matlabcentral/fileexchange/72999-fsda
%
% Folder dep_C_R is not necessary to reproduce the results in the paper, 
% but contains functions to test in C and R quickselectFS and quickselectFSw. 
% - The C-functions, quickselectFS.c and quickselectFSw.c, can be tested in  
%   any platform after compiling main.c in an executable. 
% - The R-functions, quickselectFS.R and quickselectFSw.R, can be tested 
%   in R by running mainDemo.R. 
% - The MATLAB-equivalent is mainDemo.m. 
%
% Finally, we provide two demo functions that display the execution of 
% the algorithms in a didactical form.
% 
% - quickselectFS_demo.m
% - quickselectFSw_demo.m
% 
% The folder doc_html contains html documentation generated from the 
% functions header automatically. It is included for illustration only: 
% it can be visualised correctly only within MATLAB with additional 
% installation steps that are not relevant in this context. 
