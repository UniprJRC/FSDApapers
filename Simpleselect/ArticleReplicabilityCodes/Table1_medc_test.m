%% script to assess the perfomance of the various medcouple solutions

% The versions monitored store results in these variables:
% tc  = c-compiled;  
% tma = matlab-fast-quickselectFSw jit version
% tmb = matlab-fast-quickselectFSw mex version
% tw  = matlab-fast-whimed
% ts  = matlab-simplified; 
% to  = matlab-octile; 
% tq  = matlab-quantiles;

N      = 10000;   % sample size
R      = 100;     % number of repetitions

tol_naive = 10^(-3);
tol_other = 10^(-3);

tc = zeros(R,1); tma=tc; tmb=tc; tw=tc; ts=tc; to = tc; tq=tc; 

for c = 1:R
    
    if R == 0
        % fixed array of values
        datain = [20, 7, 4, 5, 12, 13, 21, 14, 16, 14, 16, 21, 1, 3, 7, 14, 18, 19, 21, 16, 14];
        % medcouple should be equal to 0.119163278182991
        
    elseif R == 1
        % This is for generating an arbitrary long sequence.
        % For assessment with the equivalent code in C, use a fixed seed:
        myseed = 896;
        % To generate always different sequences, use random seeds:
        %myseed = randi(1000,1,1);
        % then set the randpn number generator
        rng(myseed , 'twister');
        % and finally generate the data (for example normal data)
        datain = rand(N,1);
        % REMARK: the line below is equivalent to randi(1000,1,5)
        %datain = ceil(datain*1000);
        
    else
        if mod(c,floor(R/10))==0, disp(['repetition n. ' num2str(c)]); end
        % Generate different random sequences (seed 896 is a good one to
        % compare consistency with the original C code on a difficult sequence)
        
        myseed = randi(1000,1,1);
        rng(myseed , 'twister');
        %datain = rand(N,1);
        % REMARK: to generate N random integers (for example between 1 and
        % 1000) using the Mersenne Twister in both C and MATLAB, note that
        % the line below is equivalent to randi(1000,N,1):
        %datain = ceil(datain*1000);
               
        % Line below is to test with skewed data from the lognormal
        datain = lognrnd(0,1,N,1);
    end
    
    % just to ensure that data are stored in a column vector
    datain = datain(:);
    
    % COMPILED from code in LIBRA/Robustbase: this is the baseline
    tc0 = tic();
    MCc = medc_call(datain);
    tc(c)  = toc(tc0);
    
    % $n\log n$, using whimed (which is based on MATLAB sortrows)
    tw0 = tic();
    [MCw , t_whimed] = medcouple(datain, 0, 1);
    tw(c)  = toc(tw0);
    
    %f_whimed = @() medcouple(datain, 0, 1);
    %tw2(c) = timeit(f_whimed);
    
    % $n\log n$, using quickselectFSw
    tm0a = tic();
    [MCma , ta_diva] = medcouple(datain, 0, 0); % jit
    tma(c)  = toc(tm0a);
    
    % $n\log n$, using quickselectFSw
    tm0b = tic();
    [MCmb , tb_diva] = medcouple(datain, 0, 2); % mex
    tmb(c)  = toc(tm0b);

    
    %f_qsel = @() medcouple(datain, 0, 1);
    %tm2(c) = timeit(f_qsel);
    
    % $n^2$ "naive" algorithm, simplified
    ts0 = tic();
    MCs = medcouple(datain,1);
    ts(c)  = toc(ts0);
    
    % Quantiles-based approximation
    to0 = tic();
    MCo = medcouple(datain,2);
    to(c)  = toc(to0);
    
    % Octiles-based approximation
    tq0 = tic();
    MCq = medcouple(datain,3);
    tq(c)  = toc(tq0);
    
    if abs(MCc - MCw)>tol_other
        disp('WHIMED:  mismach !!');
    end
    
    if abs(MCc - MCma)>tol_other
        disp('DIVA:  mismach !!');
    end
    
    if abs(MCc - MCs)>tol_naive
        disp('NAIVE:  mismach !!');
    end
    
 end

disp(' ');
disp('OVERALL TIME EXECUTION (sum -- median in seconds)')
disp(['time using c-compiled mex     = ' num2str(sum(tc)) ' -- ' num2str(median(tc))]);
disp(['time using wmHaase            = ' num2str(sum(tw)) ' -- ' num2str(median(tw))]);
disp(['time using quickselectFSw mex = ' num2str(sum(tmb)) ' -- ' num2str(median(tmb))]);
disp(['time using quickselectFSw     = ' num2str(sum(tma)) ' -- ' num2str(median(tma))]);
disp(['time using naive method       = ' num2str(sum(ts)) ' -- ' num2str(median(ts))]);
disp(['time using quantiles          = ' num2str(sum(tq)) ' -- ' num2str(median(tq))]);
disp(['time using octiles            = ' num2str(sum(to)) ' -- ' num2str(median(to))]);
disp(' ');
disp('TOTAL TIME SPENT IN COMPUTING WEIGHTED MEDIANS')
disp(['wmHaase        = ' num2str(t_whimed)]);
disp(['quickselectFSw = ' num2str(ta_diva) ]);

