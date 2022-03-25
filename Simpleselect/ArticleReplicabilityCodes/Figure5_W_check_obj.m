function [] = Figure5_W_check_obj(nSet,qVal,Repetitions)

% TEST Weighted Median and weighted percentiles - CHECK OBJECTIVE FUNCTION

%%  Parameters:

% nSet          is the set of n-values to be considered. For example,
%               nSet = nMin:step:nMax
%               where
%               nMin  is the minimun value of n considered;
%               step  the "step" considered to go from 1 to nMax;
%               nMax  is the maximun value of n considered.
%
% qVal          is the percentile value to be considered. For example,
%               qVal = 0.5
%
% N             the sample size to be considered. 
%
% Repetitions   the number of runs.
%
%% Example: Figure 5 - Objective function values 
% Objective here is to compoare the obj values obtained with simpleselect
% and the classic weighted median.

%{
    qVal        = 0.5;
    nMin = 100; step = 10; nMax = 1000;
    nSet        = nMin:step:nMax;
    Repetitions = 101;
    Figure5_W_check_obj(nSet,qVal,Repetitions);
%}

rng(123);

nMin  = nSet(1);
nMax  = nSet(end);
step  = nSet(2)-nSet(1);
nnSet = numel(nSet); %#ok<NASGU>

steps = max(1,ceil((nMax-nMin)/step));

% Store computational time.
T1=zeros(Repetitions,steps);
T2=zeros(Repetitions,steps);

miglioranze = 0;
uguaglianze = 0;
peggioranze = 0;
entro_tolleranza = 0;
differenze_p = 0;

Distance  = zeros(Repetitions*steps,1);
Distance0 = zeros(Repetitions*steps,1);

Positions  = zeros(Repetitions*steps,1);
Positions0 = zeros(Repetitions*steps,1);

Obj   = zeros(Repetitions*steps,1);
Obj0  = zeros(Repetitions*steps,1);


cDist=0; cTime=0;

for nn=nMin:step:nMax
    
    cTime=cTime+1;
    
    n=nn;
    disp(n);
    
    for i=1:Repetitions
        
        cDist = cDist+1;
        
        %% Data and weights
        
        D = random('unif',0,1,[1 n]);
        
        W=random('unif',0,1,[1 n]);        
        W=W/sum(W);
        
        %% Compute weighted percentiles
        
        t1=tic;
        [kE , wE , p, A]  = quickselectFSw(D,W,qVal); %#ok<ASGLU>
        T1(i,cTime)=toc(t1);

        Positions(cDist) = p;
        A = A';
        
        t2=tic;
        [A0 , kE0 , p0]=weightedMedian(D,W); %#ok<ASGLU>
        T2(i,cTime)=toc(t2);
        
        W0 = A0(2,:);
        D0 = A0(1,:); %#ok<NASGU>
        
        Positions0(cDist) = p0; %wE1 ~= kE || We0 ~= kE

        
        %% check consistency        
        
        % diff between positions
        if (p-p0)~=0
            differenze_p = differenze_p + 1;
        end
        
        % balance of weights
        Distance(cDist)  = sum(A(2,1:p-1)) - sum(A(2,p+1:n)) ;
        Distance0(cDist) = sum(W0(1:p0-1)) - sum(W0(p0+1:n)) ;

        if abs(Distance(cDist)-Distance0(cDist)) < 10^(-6)
            uguaglianze = uguaglianze + 1;
        elseif abs(Distance(cDist)) < abs(Distance0(cDist))
            miglioranze = miglioranze +1;
        elseif abs(Distance(cDist)) > abs(Distance0(cDist))
            peggioranze = peggioranze+1;
        else
            entro_tolleranza = entro_tolleranza + 1;
        end
        
        % obj functions
        Obj(cDist)  = sum(  A(2,1:n)  .* abs(  A(1,1:n)  - A(1,p) ) );
        Obj0(cDist) = sum(  A0(2,1:n) .* abs(  A0(1,1:n) - A0(1,p0) ) );
        %Obj0(cDist) = sum(  W0(1:n)   .* abs(  D0(1:n)   - D0(p0) ) );
       
    end
    
end

%% Disp stats

disp(['diff_p           = ' num2str(differenze_p)]);
disp(['equalities       = ' num2str(uguaglianze)]);
disp(['improvements     = ' num2str(miglioranze)]);
disp(['worsenings       = ' num2str(peggioranze)]);
disp(['within tolerance = ' num2str(entro_tolleranza)]);


%% Plot Objective function values

figure;
boxplot([Obj,Obj0],'labels',{'SSw', 'WMsort'});
set(gca,'FontSize',16);
objeq = '$ \displaystyle \tilde{A}_{w} = \mbox{argmin}_{a} \sum_{i=1}^{n}  w_{i}|a_i - a| $';
title({'Minimization problem:' ,objeq},'FontSize',20,'Interpreter','latex');
ylabel('Objective function values','FontSize',20,'Interpreter','latex');
axis manual;


figure;
%nbin = ceil(sqrt(length(Obj))); 
%nbin0 = ceil(sqrt(length(Obj0)));
hhobj  = histogram(Obj,'EdgeColor','r','DisplayStyle','stairs','LineWidth',3);
hold on
hhobj0 = histogram(Obj0,'EdgeColor',FSColors.darkgrey.RGB,'FaceColor',FSColors.greysh.RGB,'LineWidth',1);%lightblue
set(gca,'FontSize',16);
legend([hhobj,hhobj0] , '$SSw$', '$WM_{sort}$','FontSize',20,'Interpreter','latex');
pause(2)
%clickableMultiLegend([hhobj,hhobj0] , 'SSw', 'WMsort','FontSize',16);
labd = '$ \displaystyle \sum_{i=1}^{n}  w_{i}|a_i - a| $';
labe = 'Objective function values';
xlabel(labd,'FontSize',20,'Interpreter','latex');
title(labe,'FontSize',20,'Interpreter','latex');
axis manual;

