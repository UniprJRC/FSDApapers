function [numOp] = Figure2_NumberOfElemtaryOperation(nSet,Repetitions,pdfName,kSet,CountWhat,SaveWhat)

%% This script is used to check the distributional properties of the operations in simpleselect
%  The main distribution checked is the DIckman
%
%%  Parameters:
% nSet          is the set of n-values to be considered. For example,
%               nSet = nMin:step:nMax
%               where
%               nMin  is the minimun value of n considered;
%               step  the "step" considered to go from 1 to nMax;
%               nMax  is the maximun value of n considered.
%
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
%               kSet  = vector of possible k-values, es: kSet=[1 5 10];
%
% CountWhat     operation type to count; an integer indicating:
%                   1. Assignments,
%                   2. Comparisons,
%                   3. Array Accesses,
%                   4. Mathematical Operations:
%                       4.1 Additions/Subtractions,
%                       4.4 Divisions.
%                   5. Swaps
%                   6. All: #1+#2+#3+#4.
%
% SaveWhat      which count statistics to save; a string for:
%                   'worst'    worst case, the max of the counts
%                   'average'  average case, the mean of the counts
%                   'best'     best case, the min of the counts
%                   'all'      all counts
%
%%   Output:
%
%  numOp: count of operations

%% This is to replicate Figure 1, panel left.
%{
     CountWhat = 2; 
     SaveWhat  = 'worst';
     nSet    = 1:1:30; 
     kSet    = 'median'; 
     pdfName = 'unif';
      
     Repetitions = 1000; 
     numOp1000worst   =   Figure2_NumberOfElemtaryOperation(nSet,Repetitions,pdfName,kSet,CountWhat,SaveWhat);
     Repetitions = 10000; 
     numOp100000worst =   Figure2_NumberOfElemtaryOperation(nSet,Repetitions,pdfName,kSet,CountWhat,SaveWhat);

     SaveWhat    = 'average';
     Repetitions = 1000; 
     numOp1000average =   Figure2_NumberOfElemtaryOperation(nSet,Repetitions,pdfName,kSet,CountWhat,SaveWhat);

     figure;

     plot(nSet,numOp1000worst,'-b','LineWidth',1);
     hold on; 
     plot(nSet,numOp100000worst,'-k','LineWidth',1);
     ss = 3;
     plot(nSet,numOp1000average,':b','LineWidth',2);
     pause(1);
     h=clickableMultiLegend('r=1000 max','r=100000 max','r=1000 mean','Fontsize',16,'Location','northwest','Interpreter','latex');

     % worst case quadratic
     text(nSet(1:20), (nSet(1:20).^2 + nSet(1:20).*5)/2 , '*' ,'Fontsize',18, 'VerticalAlignment', 'middle', 'HorizontalAlignment' , 'center');

     xlabel('n','Fontsize',14);
     ylabel('Number of comparisons','Fontsize',14);

     ylim([0 250]);
     set(gca ,'Fontsize',14);

     text(nSet(1,1), 175 , '$Theoretical \; \mathcal O(n^2) \; curve$' ,'Fontsize',18, 'VerticalAlignment', 'middle', 'HorizontalAlignment' , 'left','Interpreter','latex');

%}

%{
     % This is to save the figure
      mydir = '/Users/perrodo/Desktop/fixedpivotSelect/BozzaLaTex/figs';
      myfile = 'comparisons_worst_n-r';

      saveas(gcf,[mydir filesep myfile],'epsc');
      saveas(gcf,[mydir filesep myfile],'fig');
      saveas(gcf,[mydir filesep myfile],'png');
%}

%% Replicate results in the paper: Dickman for the max or the min

%{
    % Distribution of comparisons for the maximum: it is a Dickman

    nSet = 1000;
    kSet = 'maximum';

    Repetitions = 100000;
    pdfName    = 'unif';

    CountWhat = 2;      % Comparisons only
    SaveWhat  = 'all';  % Save all counts in numOp

    numOp   = Figure2_NumberOfElemtaryOperation(nSet,Repetitions,pdfName,kSet,CountWhat,SaveWhat);
    numOp50 = Figure2_NumberOfElemtaryOperation(50,Repetitions,pdfName,kSet,CountWhat,SaveWhat);

    figure;
    h1 = histogram(numOp/nSet, 100, 'Normalization', 'pdf');
    hold on
    h2 = histogram(numOp50/50, 100, 'Normalization', 'pdf','DisplayStyle','stairs','EdgeColor','k','LineWidth' ,2);
    evaluation_points = 1000;
    [f01 ,F01 ,x01] = vervaatxdf(1,evaluation_points);
    plot(x01+1,f01,'.b','LineWidth',10); ylim([0,1]);
    %line below is to plot the CDF, if needed
    %plot(x01+1,F01,'.r','LineWidth',10); ylim([0,1]);
    %legend('Normalised histogram n=1000' , 'Normalised histogram n=50' , 'PDF Dickman','CDF Dickman','interpreter','latex','fontsize',15);
    legend('Normalised histogram n=1000' , 'Normalised histogram n=50' ,'PDF Dickman','interpreter','latex','fontsize',15);
    xlim([1,6]);
    xlabel('c(n)/n','Interpreter','latex','FontSize',16);
    % Note that in the histogram c(n)/n starts from 1 while the pdf/cdf of
    % the Dickman starts from 0. Therefore the x axis should be x01+1)
%}

%{
     % This is to save the figure
      mydir = '/Users/perrodo/Desktop/fixedpivotSelect/BozzaLaTex/figs';
      myfile = 'comparisons_distribution';

      saveas(gcf,[mydir filesep myfile],'epsc');
      saveas(gcf,[mydir filesep myfile],'fig');
      saveas(gcf,[mydir filesep myfile],'png');
%}

%{
   % Distribution of swaps for the maximum (same setting as above)

    CountWhat = 5;      % Swaps only

    numOp = Figure2_NumberOfElemtaryOperation(nSet,Repetitions,pdfName,kSet,CountWhat,SaveWhat);
    figure;
    h1 = histogram(numOp/nSet, 'Normalization', 'pdf','DisplayStyle','stairs');
%}

%{
   % Distribution of swaps for the minimum

    nMin = 15; step = 5; nMax = 50;
    nSet = [];

    Repetitions = 10000;

    pdfName    = 'unif';

    kSet = 'minumum';

    CountWhat = 5;      % Swaps only
    SaveWhat  = 'all';  % Save all counts in numOp

    numOp = Figure2_NumberOfElemtaryOperation(nMax,Repetitions,pdfName,kSet,CountWhat,SaveWhat);
    figure;
    h2 = histogram(numOp/nMax, 100, 'Normalization', 'pdf','DisplayStyle','stairs');

    figure;
    for n=nMin:step:nMax
        numOp = Figure2_NumberOfElemtaryOperation(n,Repetitions,pdfName,kSet,CountWhat,SaveWhat);
        [hist_values,hist_edges] = histcounts(numOp/n, 'Normalization', 'probability');
        hist_centers = (hist_edges(1:end-1)+hist_edges(2:end))/2;
        positives = hist_values > 0;
        plot(hist_centers(positives)/n,hist_values(positives)*n,'-');
        hold on;
        %pause
    end
%}

% Note on the normalised histogram.
%   The area of each bar is the relative number of observations. The sum of
%   the bar areas is less than or equal to 1. The bin values are computed as:
%   $v_i = \frac{c_i}{N \cdot w_i}$
%   where:
%   $v_i$ is the bin value.
%   $c_i$ is the number of elements in the bin.
%   $w_i$ is the width of the bin.
%   $N$ is the number of elements in the input data.

%{
    % this is to fit a kernel on the histogram
    figure;
    h1=histfit(numOp,100,'kernel');
%}


%% start of code

clc;

% analyse the internal for cycle
internalfor = false;

lnSet = length(nSet);

% Structures to store results
cellFor     = cell(lnSet,1);
cellForTemp = cell(Repetitions,1);
numberOfFor = zeros(lnSet,1);


if strcmp(SaveWhat,'all')
    numOp    = zeros(Repetitions,length(nSet));
else
    numOp    = zeros(1,length(nSet));
end
nuOPTemp = [];
rI       = 1;

disp(' ');
disp('Starting ...');
disp(' ');

disp(['nSet is ' num2str(nSet)]);
disp(' ');

disp(['The repetitions are ' num2str(Repetitions)]);
disp(' ');

% The main loop ... on nSet

for n = nSet
    
    disp(' ');
    disp(['n is ' num2str(n)]);
    disp(' ');
    
    for i=1:Repetitions
        
        %% Distributions for generating the array A
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
                A = random('wbl',2,5,[1 n]);
                
            case 'nakagami'
                % Nakagami Distribution random numbers.
                A = random('nakagami',1,1,[1 n]);
                
            otherwise
                eval(['A = ' pdfName ';']);
        end
        
        
        %% the selected order statistic
        
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
        
        %% our algorithm, modified to count the operations
        
        [kE1 , nuOP, nuFor] = quickselectDIVAnalysis(A,n,k); %#ok<ASGLU>
        
        % Just to verify the correctness of computation
        SA  = sort(A);
        kE2 = SA(k);
        if (kE1 ~= kE2)
            disp('Mismatch !!!');
        end
        
        %% Operation(s) to count
        
        % CountWhat = 2 --> comparison
        % CountWhat = 3 --> array
        % CountWhat = 4 --> mathematical
        % CountWhat = 5 --> swap
        % CountWhat = 6 --> all
        nuOPTemp(i) = nuOP(CountWhat); %#ok<*AGROW>
        
        if internalfor
            % To analyse the "internal" 'for' cycle.
            cellForTemp{i} = nuFor; %#ok<UNRCH>
        end
    end
    
    %% Save count statistics
    
    switch SaveWhat
        
        case 'worst'
            % Worst Case
            [Maximum , Position] = max(nuOPTemp);
            numOp(rI)     = Maximum;
            
        case 'average'
            % Mean Case
            numOp(rI) = mean(nuOPTemp);
            
        case 'best'
            % Best Case
            [Minimum , Position] = min(nuOPTemp);
            numOp(rI)     = Minimum;
            
        case 'all'
            % All
            numOp(:,rI) = nuOPTemp;
            
    end
    
    if internalfor && (isequal(SaveWhat,'worst') || isequal(SaveWhat,'best'))
        % To analyse the "internal" 'for' cycle.
        cellFor(rI) = cellForTemp(Position);
    end
    
    rI          = rI+1;
    nuOPTemp    = [];
    cellForTemp = {};
    
end

if internalfor && (isequal(SaveWhat,'worst') || isequal(SaveWhat,'best'))
    % To analyse the "internal" 'for' cycle.
    for i=1:length(nSet)
        [~ , lF] = size(cellFor{i});
        numberOfFor(i) = lF;
    end
end

%% Exact median calculation
%{
 % Median from our function:
         if mod(n,2) ~= 0
            % n is an odd number:
            % k=(n/2)+1
              k=ceil(n/2);
              [kE1 nuOP nuFor]=quickselectDIVAnalysis(A,n,k);
         else
             %  n is an even number:
             %  k=((n/2)+((n/2)+1))/2;
                k=n/2;
                [kE1D nuOP1 nuFor AFinal]=quickselectDIVAnalysis(A,n,k);
                [kE1S nuOP2 nuFor AFinal]=quickselectDIVAnalysis(AFinal,n,k+1);
                nuOP=nuOP1+nuOP2;
                kE1=(kE1D+kE1S)/2;
         end
    % The median from Matlab.
      kE2 = median(A);
%}
