% This folder relates to the paper:
% "A practically efficient and extensible fixed-pivot selection algorithm".
% It contains the new functions discussed in the paper and the code to
% reproduce the results reported in the figures and the tables.
% 
% The new functions are:
% - quickselectFS.m     (root folder)
% - quickselectFSw.m    (root folder)
% - quickselectFSmex.c  (dep_mex folder)
% - quickselectFSwmex.c (dep_mex folder)
% - vervaatrnd.m        (dep_fsda folder)
% - vervaatsim.m        (dep_fsda folder)
% - vervaatxdf.m        (dep_fsda folder) 
% 
% To replicate the results in the paper you can run the examples in the 
% following functions, located in the root folder:
% - Figure1_NumberOfElemtaryOperation.m
% - Figure3_ComputationalTime.m
% - Figure4_FSM_MCD_TIME_testing.m
% - Figure5_W_check_obj.m
% - Figure5_W_check_position.m
% - Figure5_W_check_time.m
% - Table1_medc_test.m
% 
% Please run addDEP2path to add to the MATLAB path all dependencies, which
% are in the folders:
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
                

