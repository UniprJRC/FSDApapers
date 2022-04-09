% This folder relates to the paper:
% "﻿A practically efficient fixed-pivot selection algorithm and its extensible MATLAB suite".
% It contains the new functions discussed in the paper and the code to
% reproduce the results reported in the figures and the table.
%
% The novel functions are:
% - quickselectFS.m     (root folder)
% - quickselectFSw.m    (root folder)
% - quickselectFSmex.c  (dep_mex folder)
% - quickselectFSwmex.c (dep_mex folder)
% - vervaatrnd.m        (dep_fsda folder)
% - vervaatsim.m        (dep_fsda folder)
% - vervaatxdf.m        (dep_fsda folder) 
% 
% To replicate the results you can run the examples that are at the head
% of the following functions, located in the root folder:
%
% - Figure1_NumberOfElemtaryOperation.m
% - Figure3_ComputationalTime.m
% - Figure4_FSM_MCD_TIME_testing.m
% - Figure5_W_check_obj.m
% - Figure5_W_check_position.m
% - Figure5_W_check_time.m
% - Table1_medc_test.m
%
% To run the examples, it is necessary to execute first the function  
% addDEP2path, which adds to the MATLAB path all dependencies, which
% are in the folders:
%
% - dep_mex:     includes the C-functions and the mex-files compiled for
%                macos and windows.
% - dep_robstat: includes the MCD and FS functions, modified to monitor the
%                time taken by the computation of order statistics.
% - dep_mc:      includes functions for the medcouple, taken from the LIBRA
%                toolbox, which can be downloaded from:
%                https://github.com/mwgeurts/libra or
%                https://wis.kuleuven.be/statdatascience/robust/LIBRA/
% - dep_fsda:    includes functions required to tun the MCD and FS, taken 
%                from the FSDA toolbox, which can be downloaded from:
%                https://github.com/UniprJRC
%                https://it.mathworks.com/matlabcentral/fileexchange/72999-fsda
%
% The documentation in html files is under folder doc_html.
%
% There are also two demo functions, which disply the execution of the algorithms.
% 
% - quickselectFS_demo.m
% - quickselectFSw_demo.m
%
% Finally, folder rep_C_R contains functions to test in C and R the use of
% quickselectFS and quickselectFSw. The C-functions, quickselectFS.c and
% quickselectFSw.c, can be tested in any platform after compiling main.c in
% an executable. The R-functions, quickselectFS.R and quickselectFSw.R, can
% be tested in R by running mainDemo.R. The MATLAB-equivalent is mainDemo.m. 
