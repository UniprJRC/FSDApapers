function [] = Figure5_W_check_time(qVal,nSet,Repetitions,pdfNameData,pdfNameWeights)

% TEST Weighted Median and weighted percentiles - COMPUTATIONAL TIME

%%  Parameters:
%
% qVal          the quantile to be considered. Example:
%               qVal  = 0.5 is the median.
%
% nSet          is the set of n-values to be considered. For example,
%               nSet = nMin:step:nMax
%               where
%               nMin  is the minimun value of n considered;
%               step  the "step" considered to go from 1 to nMax;
%               nMax  is the maximun value of n considered.
% Repetitions   the number of algorithm runs for a fixed n.
%
% pdfNameData   the distribution from which data are generated. It can
%               be set in general form using the standard syntax of MATLAB,
%               for example:
%                   pdfNameData = 'random(''unif'',0,100,[1 100])'
%               Distributions with specific parameter settings can be set
%               by simply indicating their names:
%                    = 'unif' for Uniformly distributed random numbers (continuos).
%                    = 'unid' for Uniformly distributed random numbers (discrete).
%                    = 'norm' for Normally  distributed random numbers.
%                    = 'exp'  for Exponential random numbers.
%                    = 'chi2' for Chi-square random numbers.
%                    = 'tweedie' for Tweedie generated random numbers.
%                    = 'birnbaumsaunders' for Birnbaum-Saunders random numbers.
%                    = 'wbl' for Weibull Distribution random numbers.
%                    = 'nakagami' for Nakagami Distribution random numbers.
%
% pdfNameWeights   the distribution to generate weights. As for
%                  pdfNameData, with these distributions in addition:
%                    = 'equal' for equal weights (degenerate case).
%                    = 'lognormal' for log-normal weights.
%                    = 'lognormalrndp' for lognormal with random parameters.
%                    = if specified otherwise, it generates a random
%                      permutation of n elements.
%
%

%% Example: Figure 5

%{
    qVal        = 0.5;
    nMin = 100; step = 10; nMax = 1000;
    nSet        = nMin:step:nMax
    Repetitions = 101;
    pdfNameData = 'unif';
    pdfNameWeights = 'unif';
    Figure5_W_check_time(qVal,nSet,Repetitions,pdfNameData,pdfNameWeights);

%}

%%


%clc;
%clear all;
%close all;

rng(123);

nMin  = nSet(1);
nMax  = nSet(end);
step  = nSet(2)-nSet(1);
nnSet = numel(nSet); %#ok<NASGU>

steps = max(1,ceil((nMax-nMin)/step));

% Store computational time.
T1=zeros(Repetitions,steps);
T2=zeros(Repetitions,steps);

cDist=0; cTime=0;

for nn=nMin:step:nMax
    
    cTime=cTime+1;
    
    n=nn;
    disp(n);
    
    for i=1:Repetitions
        
        cDist = cDist+1;
        
        %% Data distribution
                
        switch pdfNameData
            case 'unif'
                % Uniformly distributed random numbers (continuos).
                D = random('unif',0,1,[1 n]);
            case'unid'
                % Discrete
                D = random('unid',n*10000,[1 n]);
                while numel(unique(D)) < n
                    D = random('unid',n*10000,[1 n]);
                end
            case 'norm'
                % Normally distributed random numbers.
                D = random('norm',0,1,[1 n]);
            case 'exp'
                % Exponential random numbers.
                D = random('exp',1,[1 n]);
            case 'chi2'
                % Chi-square random numbers.
                D = random('chi2',10,[1 n]);
            case 'tweedie'
                % Tweedie generated random numbers
                al=-0.2697 ; th=0.2911*10^(-6); de=0.0282;
                D = twdrnd(al,th,de,n);
            case 'birnbaumsaunders'
                % Birnbaum-Saunders random numbers.
                D = random('birnbaumsaunders',1,2,[1 n]);
            case 'wbl'
                % Weibull Distribution random numbers.
                %A = random('wbl',2,5,[1 n]);
                D = random('wbl',1,1,[1 n]);
            case 'nakagami'
                % Nakagami Distribution random numbers.
                D = random('nakagami',1,1,[1 n]);
            otherwise
                D = 1:n;
                D = shuffling(D);
        end
        D = D(:);
        
        % used to be:
        %D = random('unif',0,1,[1 n]);
        %D = randi(n*10,1,n).*randperm(n);
        %D = 1:n;
        %D = shuffling(D);

        
        %% Weights
                
        switch pdfNameWeights
            case 'equal'
                % Equal weights.
                W = ones(1,n)/n;
            case 'lognormal'
                % Log-normal distributed random numbers.
                W = random('lognormal',0,1,[1 n]);
            case 'lognormalrndp'
                % Log-normal distributed with random parameters.
                mu    = randn; sigma = abs(1+randn);
                W = random('lognormal',mu,sigma,[1 n]);
                % W = -W + max(W); % switch skweness to the right
            case 'unif'
                % Uniformly distributed random numbers (continuos).
                W = random('unif',0,1,[1 n]);
            case'unid'
                % Discrete
                W = random('unid',n*10000,[1 n]);
                while numel(unique(D)) < n
                    W = random('unid',n*10000,[1 n]);
                end
            case 'norm'
                % Normally distributed random numbers.
                W = random('norm',0,1,[1 n]);
            case 'exp'
                % Exponential random numbers.
                W = random('exp',1,[1 n]);
            case 'chi2'
                % Chi-square random numbers.
                W = random('chi2',10,[1 n]);
            case 'tweedie'
                % Tweedie generated random numbers
                al=-0.2697 ; th=0.2911*10^(-6); de=0.0282;
                W = twdrnd(al,th,de,n);
            case 'birnbaumsaunders'
                % Birnbaum-Saunders random numbers.
                W = random('birnbaumsaunders',1,2,[1 n]);
            case 'wbl'
                % Weibull Distribution random numbers.
                %A = random('wbl',2,5,[1 n]);
                W = random('wbl',1,1,[1 n]);
            case 'nakagami'
                % Nakagami Distribution random numbers.
                W = random('nakagami',1,1,[1 n]);
            otherwise
                W = randperm(n);
        end
        W = W(:);
        
        % used to be: 
        % W=rand(1,n);
        % W=random('unif',0,n,[1 n]);
        % W=random('unif',0,1,[1 n]);
        % W=random('beta',1,1,[1 n]);
        % W=lognrnd(0,1,n,1)';
        % W=ones(1,n)/n; % equal weights
        % W=randperm(n); % permuted integers
        % W = 10+mu+sigma*randn(n,1)';        
        %mu    = randn;
        %sigma = abs(1+randn);
        %W = lognrnd(mu,sigma,n,1)';
        % W = -W + max(W); % switch skweness to the right

        
        %% weights must sum to one in our algorithm
        W=W/sum(W);
        
        %% time estimate for computing the weighted quantile
        
        t1=tic;
        [kE , wE , p]  = quickselectFSw(D,W,qVal); %#ok<ASGLU>
        T1(i,cTime)=toc(t1);
        
        
        t2=tic;
        [~ , kE0 , p0]=weightedMedian(D,W); %#ok<ASGLU>
        T2(i,cTime)=toc(t2);
        
        % the output is unused, but it is necessary to be fair in
        % evaluating the time execution.
    end
    
end

%% plot

m1=1000*median(T1,1);
m2=1000*median(T2,1);
%s1=1000*Sn(T1,1);
%s2=1000*Sn(T2,1);

figure;
nticks = nMin:step:nMax;
hp1 = plot(nticks,m1, '-r' , nticks,m2,'-.k','LineWidth',2);
xlim([0 nMax]);
legend([hp1(1),hp1(2)] , '$SSw$', '$WM_{sort}$','FontSize',20,'Interpreter','latex');
%xtl  = xticklabels; nxtl = length(xtl);
%xtl2 = [0 , nS:floor(N/(nxtl-1)):N]';
%xticklabels(xtl2);
set(gca,'FontSize',16);
xlabel('$n$','FontSize',20,'Interpreter','latex');
ylabel('Time in milliseconds','FontSize',20,'Interpreter','latex');
%title('Time execution','FontSize',20,'Interpreter','latex');
axis manual;

