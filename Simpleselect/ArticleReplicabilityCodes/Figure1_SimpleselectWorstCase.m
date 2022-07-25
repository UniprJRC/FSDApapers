% Figure1_SimpleselectWorstCase reproduces Figure 1, which illustrates the
% dynamic of quickselectFS in the worst case, that is, when  ﻿when we look
% for the maximum ($k=n$) among elements in increasing order except the
% last containing the minimum. The script just calls quickselectFSw_demo.m.
% To reproduce the figure 1 and understand the dynamic, we suggest adding a
% brakpoint at line 84 of quickselectFSw_demo, which is just at the
% beginning of the while loop.
A = [2 3 4 5 6 7 8 9 1];
k=9;
quickselectFS_demo(A,k);
