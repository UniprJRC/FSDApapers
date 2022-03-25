function [] = Figure5_W_check_position(qSet,N,Repetitions)

% TEST Weighted Median and weighted percentiles - POSITION FOUND IN ARRAY

%%  Parameters:

% qSet          is the set of percentile values to be considered. For example,
%               qSet = 0.1:0.1:0.9
%
% N             the sample size to be considered. 
%
% Repetitions   the number of runs.
%
%% Example: Figure 5

%{

    qSet        = 0.1:0.1:0.9;
    N           = 1000;
    Repetitions = 500;
    Figure5_W_check_position(qSet,N,Repetitions);

%}

rng(123);

nqSet = length(qSet);

Positions  = zeros(Repetitions,nqSet);

for iwk = 1:nqSet
    disp(['percentile: ' num2str(qSet(iwk))]);
    
    tws = tic;
    for r=1:Repetitions
        % Values can by anything
        D = randi(N*10,1,N).*randperm(N);
        % D = random('unif',0,n,[1 n]);
        
        % check if the position is correct for given p with uniform weights
        W=random('unif',0,1,[1 N]);
        % W=random('unif',0,n,[1 n]);
        
        W=W/sum(W);
        [kE , wE , p, A]  = quickselectFSw(D,W,qSet(iwk)); %#ok<ASGLU>
        
        Positions(r,iwk) = p;
    end
    disp(['N=' num2str(N)  ' - time WTD quickselect = ' num2str(toc(tws))]);
    
    tss = tic;
    for r=1:Repetitions
        D = randi(N*10,1,N).*randperm(N);
        kkk  = quickselectFS(D,round(qSet(iwk)*N)); %#ok<NASGU>
    end
    disp(['N=' num2str(N)  ' - time UNW quickselect = ' num2str(toc(tss))]);
    disp(' ');
end

%% plot

figure;
for iwk = 1:nqSet
    ll = Positions(:,iwk);
    llmed = median(ll); llmad = mad(ll);
    h1 = histogram(ll,'FaceColor','b','EdgeColor','b');
    set(gca,'FontSize',16);
    hold on;
end
set(gca,'FontSize',18);
xlabel({'$\mbox{Positions for percentiles in}$ ' , num2str(qSet)},'FontSize',20,'Interpreter','latex');
title(['$n=$ ' num2str(N) ', $R=$ ' num2str(Repetitions) ', uniform weights'] , 'FontSize',20,'Interpreter','latex');


figure;
h00 = boxplot(Positions,'labels',num2cell(qSet));
set(gca,'FontSize',18);
xlabel('$\mbox{Percentile}/100$','FontSize',20,'Interpreter','latex');
ylabel('$\mbox{Position}$','FontSize',20,'Interpreter','latex');
title(['$n=$ ' num2str(N) ', $R=$ ' num2str(Repetitions) ', uniform weights'] , 'FontSize',20,'Interpreter','latex');


