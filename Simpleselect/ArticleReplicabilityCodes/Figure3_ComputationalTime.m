function [] = Figure3_ComputationalTime(nSet,Repetition,pdfName,kSet)

%%  Parameters:
% nSet          is the set of n-values to be considered. For example,
%               nSet = nMin:step:nMax
%               where
%               nMin  is the minimun value of n considered;
%               step  the "step" considered to go from 1 to nMax;
%               nMax  is the maximun value of n considered.
% Repetitions   the number of algorithm runs for a fixed n.
%
% pdfName       the distribution from which numbers are generated. It can
%               be set in general form using the standard syntax of MATLAB, 
%               for example:
%                   pdfName = 'random(''unif'',0,100,[1 100])'
%               Distributions with specific parameter settings can be set
%               by simply indicating their names:
%                   pdfName = 'unif' for Uniformly distributed random numbers (continuos).
%                   pdfName = 'unid' for Uniformly distributed random numbers (discrete).
%                   pdfName = 'norm' for Normally  distributed random numbers.
%                   pdfName = 'exp'  for Exponential random numbers.
%                   pdfName = 'chi2' for Chi-square random numbers.
%                   pdfName = 'tweedie' for Tweedie generated random numbers.
%                   pdfName = 'birnbaumsaunders' for Birnbaum-Saunders random numbers.
%                   pdfName = 'wbl' for Weibull Distribution random numbers.
%                   pdfName = 'nakagami' for Nakagami Distribution random numbers.
%
% kSet          the order statistic(s) to be considered. Options:
%               kSet  = 'maximum';
%               kSet  = 'minumum';
%               kSet  = 'random';
%               kSet  = 'median';
%               Default (parameter missing) is the median.

% Example:
%{
    nMin = 10; step = 10; nMax = 200;
    nSet = nMin:step:nMax
    Repetition = 10000;
    pdfName    = 'unif';
    Figure3_ComputationalTime(nSet,Repetition,pdfName);

    thefilename = ['etime_' num2str(nMin) '_' num2str(nMax) '_' pdfName];
    saveas(gcf,thefilename);
    print(gcf,[thefilename '.eps'],'-depsc2');
    print(gcf,[thefilename '.png'],'-dpng');
%}

%{
    nMin = 200; step = 10; nMax = 1000;
    nSet = nMin:step:nMax
    Repetition = 10000;
    pdfName    = 'unif';
    Figure3_ComputationalTime(nSet,Repetition,pdfName);

    thefilename = ['etime_' num2str(nMin) '_' num2str(nMax) '_' pdfName];
    saveas(gcf,thefilename);
    print(gcf,[thefilename '.eps'],'-depsc2');
    print(gcf,[thefilename '.png'],'-dpng');
%}

%{
    nMin = 10; step = 50; nMax = 1010;
    nSet = nMin:step:nMax
    Repetition = 10000;
    pdfName    = 'birnbaumsaunders';
    Figure3_ComputationalTime(nSet,Repetition,pdfName);
    xlim([0,1000]);
    figure
    pdfName    = 'unif';
    Figure3_ComputationalTime(nSet,Repetition,pdfName);
    xlim([0,1000]);

    thefilename = ['etime_' num2str(nMin) '_' num2str(nMax) '_' 'distrib_effect'];
    saveas(gcf,thefilename);
    print(gcf,[thefilename '.eps'],'-depsc2');
    print(gcf,[thefilename '.png'],'-dpng');
%}



%{
    % this is to plot a distribution
    pd = makedist('Weibull','a',1,'b',1);
    x = 0:0.1:5;
    y = pdf(pd,x);
    plot(x,y,'LineWidth',2);

    % this is to plot a distribution
    pd = makedist('BirnbaumSaunders','beta',1,'gamma',2)    
    x = 0:0.1:5;
    y = pdf(pd,x);
    plot(x,y,'LineWidth',2);
    legend('Birnbaum-Saunders(1,2)','Location','northwest','fontsize',20,'interpreter','latex');

    saveas(gcf,'BirnbaumSaunders');
    print(gcf,['BirnbaumSaunders' '.eps'],'-depsc2');
    print(gcf,['BirnbaumSaunders' '.png'],'-dpng');


%}

%% This code is to test the computational time of quickselectFS vs MATLAB's,
% equivalently functions and many others.

% close all;
clc;

if nargin < 4 || isempty(kSet)
    kSet = 'median';
end

% The n values (n set) considered for this run.
%nSet  = nMin:step:nMax;
nMin = nSet(1); 
nMax = nSet(end);
step = nSet(2)-nSet(1);
nnSet = numel(nSet);

% To store final results.
TimeQuickselectFS = zeros(nnSet,1);
TimeQuickselectFSmex  = zeros(nnSet,1);
TimeMATLAB        = zeros(nnSet,1);
TimeNthELEMENT    = zeros(nnSet,1);
TimeNUREselect    = zeros(nnSet,1);


% Display some information.
disp(' ');
disp('Starting ...');
disp(' ');

disp(['nSet is ' num2str(nSet)]);
disp(' ');

disp(['Ripetition is ' num2str(Repetition)]);
disp(' ');

% The main loop ...
rI=1;
for n = nSet
    
    disp(' ');
    disp(['n is ' num2str(n)]);
    disp(' ');
    
    % To store partial computational time.
    TimeQuickselectFStemp     = zeros(Repetition,1);
    TimeQuickselectFSmextemp  = zeros(Repetition,1);
    TimeMATLABtemp        = zeros(Repetition,1);
    TimeNthELEMENTtemp    = zeros(Repetition,1);
    TimeNUREselectemp     = zeros(Repetition,1);
    
    
    for i=1:Repetition
        
        % Distributions for generating the array A
        switch pdfName
            case 'unif'
                % Uniformly distributed random numbers (continuos).
                A = random('unif',0,n,[1 n]);
                
            case'unid'
                % Discrete
                A = random('unid',n*10000,[1 n]);
                while numel(unique(A)) < n
                    A = random('unid',n*10000,[1 n]);
                end
                
            case 'norm'
                % Normally distributed random numbers.
                A = random('norm',0,1,[1 n]);
                
            case 'exp'
                % Exponential random numbers.
                A = random('exp',1,[1 n]);
                
            case 'chi2'
                % Chi-square random numbers.
                A = random('chi2',10,[1 n]);
                
            case 'tweedie'
                % Tweedie generated random numbers
                al=-0.2697 ; th=0.2911*10^(-6); de=0.0282;
                A = twdrnd(al,th,de,n);
                
            case 'birnbaumsaunders'
                % Birnbaum-Saunders random numbers.
                A = random('birnbaumsaunders',1,2,[1 n]);
                
            case 'wbl'
                % Weibull Distribution random numbers.
                %A = random('wbl',2,5,[1 n]);
                A = random('wbl',1,1,[1 n]);
                
            case 'nakagami'
                % Nakagami Distribution random numbers.
                A = random('nakagami',1,1,[1 n]);
                
            otherwise
                eval(['A = ' pdfName ';']);
        end
        
        A = A(:);
        
        % the selected order statistic
        
        if ischar(kSet)
            switch kSet
                case 'minumum'
                    k = 1;
                case 'maximum'
                    k = n;
                case 'random'
                    k = randi(n,1);
                case 'median'
                    k = floor((n+1)/2); % it is the lower median
                    % Median computation with Simpleselect.
                    % For simplicity, Simpleselect computes the 'lower
                    % median'. The advantage of this choice is that the
                    % result is independent from odd or even sequences. The
                    % exact computation is at the end of this code.
                    % Extensive testing with the exact median shows that
                    % performance are equivalent modulo a constant factor.
            end
        elseif isvector(kSet)
            k = round(kSet);
        else
            error('kSet is a vector of possible k-statistics');
        end
        
        % MATLAB sort
        tic;
        Asorted     = sort(A);
        MATLABStat  = Asorted(k);
        TimeMATLABtemp(i) = toc;
        
        % NthELEMENT
        tic;
        NthELEMENTout  = nth_element(A,k);
        NthELEMENTStat = NthELEMENTout(k);
        TimeNthELEMENTtemp(i) = toc;
        
        % quickselectFS
        tic;
        quickselectFSout = quickselectFS(A,k);
        TimeQuickselectFStemp(i)=toc;
        
        Acopy=A;
        % This is to break the link between A and Acopy!
        Acopy(end+1)= -1; %#ok<AGROW>
        Acopy(end)  = [];
        
        % Quickselect NURE.
        tic;
        NUREselect(A,n,k-1);
        NNUREselectOut= A(k);
        TimeNUREselectemp(i)=toc;
        % ATTENTION... now A is modified!
        
        % quickselectFS mex ... Optimezed
        tic;
        %SIMPLEselect(Acopy,n,k-1);
        %quickselectFSmexOut = Acopy(k);
        quickselectFSmexOut = quickselectFSmex(Acopy,n,k-1);
        TimeQuickselectFSmextemp(i)=toc;
        % ATTENTION... now also Acopy is modified!
        
        % Error check.
        if (MATLABStat ~= quickselectFSmexOut) || (MATLABStat ~= quickselectFSout) || (MATLABStat ~= quickselectFSmexOut) || (MATLABStat ~= NthELEMENTStat) || (MATLABStat ~= NNUREselectOut)
            disp('p - Mismatch !!! ');
            keyboard
        end
        
    end
    
    % Median Time
    TimeMATLAB(rI)            = median(TimeMATLABtemp);
    TimeNthELEMENT(rI)        = median(TimeNthELEMENTtemp);
    TimeQuickselectFS(rI)     = median(TimeQuickselectFStemp);
    TimeQuickselectFSmex(rI)  = median(TimeQuickselectFSmextemp);
    TimeNUREselect(rI)        = median(TimeNUREselectemp);
    
    rI=rI+1;
    
end

% Display results.
plot(nSet,TimeMATLAB,'-.k','LineWidth',2.5);
hold on;
plot(nSet,TimeNthELEMENT,'--','Color',[0.6 0.6 0.6],'LineWidth',2.5);
plot(nSet,TimeNUREselect,'--','Color',[0.4 0.4 0.4],'LineWidth',2.5);
plot(nSet,TimeQuickselectFSmex,'-m','LineWidth',2);
plot(nSet,TimeQuickselectFS,'-r','LineWidth',2);
legend('$SORT_{int}$','$NthEL_{mex}$','$NURE_{mex}$', '$SS_{mex}$','$SS_{jit}$','Location','northwest','fontsize',15,'interpreter','latex');
% C++ NthELEMENT_{mex} (Introselect)
xlabel(['n from ', num2str(nMin), ' to ', num2str(nMax), ', step=' num2str(step), ', and r=', num2str(Repetition),'.'],'fontsize',15,'interpreter','latex');
ylabel('Elapsed time','fontsize',15,'interpreter','latex');
set(gca,'FontSize',14);

% keyboard




