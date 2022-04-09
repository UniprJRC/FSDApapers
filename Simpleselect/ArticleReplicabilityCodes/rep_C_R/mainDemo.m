function [D,W,out_qsw,out_qs] = mainDemo(n,k,p,comparewith)
%% Demo function associated to quickselectFS and quickselectFSw
%
% This is to test in C and R the use of quickselectFS and quickselectFSw,
% using functions ported to the respective programming environments.
%
% The C-functions, quickselectFS.c and quickselectFSw.c, can be tested in
% any platform after compiling main.c in an executable. 
%
% The R-functions, quickselectFS.R and quickselectFSw.R, can be tested in R
% by running mainDemo.R
%
% The three demo functions (main.c, mainDemo.R and mainDemo.m) generate
% random numbers using the Mersenne-Twister framework. This should
% facilitate the extension of the demo examples to more complex simulation
% settings.
%
% Note that the implementations in MATLAB and C of the Mersenne-Twister are
% fully equivalent, while unfortunately this is not the case in R. For this
% reason, we use a specific framework that allows replicating in MATLAB the
% same numbers generated in R. This is function mtR.m, which is part of the
% FSDA toolbox.
%
%{
    n=10; k=5; p=0.5;
    comparewith = 'C';
    [D,W,out_qsw,out_qs] = mainDemo(n,k,p,comparewith);
%}

%{
    n=10; k=5; p=0.5;
    comparewith = 'R';
    [D,W,out_qsw,out_qs] = mainDemo(n,k,p,comparewith);
%}

%{
    % data generated above
    % D 
    % 0.8293406 0.7133021 0.7141369 0.1802098 0.7933905 
    % 0.8626241 0.7293147 0.8257157 0.4182991 0.1609702
    
    % W
    % 0.45924481 0.55344167 0.57121980 0.06907991 0.30869239 
    % 0.67710048 0.20190217 0.77120541 0.57069109 0.50561533
%}

%% generate data 
%  we use the same distribution for both data and weights, but it is easy
%  to extend it if necessary

myseed = 896; 

if strcmp(comparewith,'C')
    % C and MATLAB implement the Mersenne-Twister in the same way.
    rng(myseed , 'twister');
    MTn = rand(2*n,1);
    
elseif strcmp(comparewith,'R')
    % R implements the Mersenne-Twister differently. We use mtR for this.    
    MTn = mtR(2*n,0,myseed);
    
else
    disp('comparewith option: please choose R or C');
end

D = MTn(1:n);
W = MTn(n+1:end);

%% run quickselectFS and quickselectFSw

[kD , kW , kstar] = quickselectFSw(D,W/sum(W),p);
out_qsw = [kD , kW , kstar];

out_qs = quickselectFS(D,k);


%% now some output display 
disp(' ');
disp(' ');

disp(['CHECK CONSISTENCY WITH ' comparewith]);

disp(' ');
disp(['RUNNING quickselectFSw on A with weights W' ' for p=' num2str(p)]);
disp(['weighted percentile is          '  num2str(kD)]);
disp(['the associated weight is        '  num2str(kW)]);
disp(['the position of the data/weight '  num2str(kstar)]);
disp(' ');

disp(['RUNNING quickselectFS on A' ' for k=' num2str(k)]);
disp(['the order statistic is          '  num2str(out_qs)]);

