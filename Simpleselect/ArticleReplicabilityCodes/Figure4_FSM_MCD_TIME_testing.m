function ATG = Figure4_FSM_MCD_TIME_testing(contperc , settings)

% ---------------------------------------------------------------
% Time monitoring on SIMPLEselect/quickselectFS inside FS and MCD
% ---------------------------------------------------------------
%
%%  Parameters:
%
% settings.algorithm         
%          = choose what to monitor: fs_easy fs_fast mcd;
%            algorithm = 'fs_easy' -> FS implementation type: classic
%            algorithm = 'fs_fast' -> FS implementation type: fast but
%                                     hardly readable
%            algorithm = 'mcd'     -> MCD
%
% settings.plot_eachcontperc 
%           = true or false; it is used to plot or not the results for each 
%             contamination percentage.
%
% settings.internal          
%           = true or false to choose the monitoring type.
%             "internal=true" monitors only the time consumed by the
%             computation of order statistics, using SIMPLEselect,
%             quickselect or sort;
%             "internal=false" monitors the elapsed time to run of the
%             entire FS algoritm under the various options.
%
% settings.initialsubset  
%           = The basic subset used to start the FS, used here to force the
%             interchange and study its effect on the computing time.
%             initialsubset = (1:2)' force to start from units 1 and 2.
%             initialsubset = 0 means random start.
%
% settings.V                 
%           = [2] means 2 variables, [2,4,6] indicates three runs 
%             respectively with 2,4,and 6 variables.
%
% settings.N                 
%           = [50:50:1000] is to monitor n = 50, 100, 150, ... , 1000.
%
% settings.dorank            
%           = true or false; if true, the results and the plots are ranked 
%             from the most to the least performant method.
%
% contperc                   
%           = contperc*100 is the contamination percentage: it is used in 
%             association to initialsubset to force the interchange.
%             contperc = 0 means no data contamination; otherwise indicate
%             which rates you want, e.g. 0:0.010:0.5.
%
   
%% Figure 4 - MCD

%{
    settings.algorithm         = 'mcd'; 
    settings.plot_eachcontperc = true;
    settings.internal          = true;
    settings.initialsubset     = 0;
    settings.V                 = [2];
    settings.N                 = [50:50:1000];
    settings.dorank            = false;

    contperc      = 0;

    ATG_all=NaN(4,length(contperc));
    for i=1:length(contperc)
        ATG = Figure4_FSM_MCD_TIME_testing(contperc(i),settings);
        ATG_all(:,i) = ATG;
    end
%}

%% Figure 4 - fs_easy

%{
    settings.algorithm         = 'fs_easy'; 
    settings.plot_eachcontperc = true;
    settings.internal          = true;
    settings.initialsubset     = 0;
    settings.V                 = [2];
    settings.N                 = [50:50:1000];
    settings.dorank            = false;

    contperc      = 0;

    ATG_all=NaN(4,length(contperc));
    for i=1:length(contperc)
        ATG = Figure4_FSM_MCD_TIME_testing(contperc(i),settings);
        ATG_all(:,i) = ATG;
    end
%}

%% Figure 4 - fs_fast

%{
    settings.algorithm         = 'fs_fast'; 
    settings.plot_eachcontperc = true;
    settings.internal          = true;
    settings.initialsubset     = 0;
    settings.V                 = [2];
    settings.N                 = [50:50:1000];
    settings.dorank            = false;

    contperc      = 0;

    ATG_all=NaN(4,length(contperc));
    for i=1:length(contperc)
        ATG = Figure4_FSM_MCD_TIME_testing(contperc(i),settings);
        ATG_all(:,i) = ATG;
    end
%}

%% Figure 4 - mcd, fs_easy, fs_fast, n=1000, varying contamination

%{
    settings.plot_eachcontperc = false;
    settings.internal          = true;
    settings.initialsubset     = (1:2)';
    settings.V                 = [2];
    settings.N                 = [1000];
    settings.dorank            = false;

    contperc      = 0:0.010:0.5;

    settings.algorithm         = 'fs_fast'; 
    ATG_fs_fast_all=NaN(4,length(contperc));
    for i=1:length(contperc)
        ATG = Figure4_FSM_MCD_TIME_testing(contperc(i),settings);
        ATG_fs_fast_all(:,i) = ATG;
    end

    settings.algorithm         = 'fs_easy'; 
    ATG_fs_easy_all=NaN(4,length(contperc));
    for i=1:length(contperc)
        ATG = Figure4_FSM_MCD_TIME_testing(contperc(i),settings);
        ATG_fs_easy_all(:,i) = ATG;
    end

    settings.algorithm         = 'mcd'; 
    ATG_mcd_all=NaN(4,length(contperc));
    for i=1:length(contperc)
        ATG = Figure4_FSM_MCD_TIME_testing(contperc(i),settings);
        ATG_mcd_all(:,i) = ATG;
    end

    % plot effect of contamination on the ATG
    figure; 
    plot(contperc*100, ATG_mcd_all(3,:)*100, '+b','LineWidth',2,'LineStyle','none');
    hold on;
    plot(contperc*100, ATG_fs_easy_all(3,:)*100, 'or','MarkerFaceColor','red','LineWidth',2,'LineStyle','none');
    plot(contperc*100, ATG_fs_fast_all(3,:)*100, 'ok','LineWidth',2,'LineStyle','none');

    set(gca,'fontsize',16);
    xlabel('Contamination percentage','fontsize',15,'interpreter','latex');
    ylabel('$(SSO_{jit} - SORT_{mex})/SORT_{mex}\cdot100$','fontsize',15,'interpreter','latex');
    title(['$n=' num2str(settings.N) '$'],'FontSize',20,'interpreter','latex');
    legend('mcd','fs easy','fs fast','FontSize',18,'interpreter','latex');
    ylim([-80 -40]);

    %{
        title('Percentage gain monitoring','FontSize',18,'interpreter','latex');
        saveas(gcf,'FSM_contam_data');
        print(gcf,'FSM_contam_data.eps','-depsc2');
    %}
%}


close all; rng('default'); warning('off'); 

plot_eachcontperc   = settings.plot_eachcontperc;
algorithm           = settings.algorithm;
internal            = settings.internal;
initialsubset       = settings.initialsubset;
V                   = settings.V;
N                   = settings.N;
dorank              = settings.dorank;

%% Time settings (not parametrised)

ttrep = 11;              % tic-toc replicates
useTimeit = 0;           % useTimeit = 1 uses timeit and ttrep is set to 1

%% Plot parameters: they can be modified to beautify plots

titleFontSize = 20;
gcaFontSize   = 16;
xylabFontSize = 15;

% used in the time percentage difference plot
clr_tpd = {'k','r','r'};
lst_tpd = {'-','-',':'};

% used in other plots
clr = {'k','r','r','m'};
lst = {'-','-',':','-'};

thickLineWidth= 2;
thinLineWidth = 0.5;

% legend used for the plots
legRun  = {'NURE_{mex}','SS_{jit}','SSO_{jit}','SORT_{int}'};

% flag to plot the MAD time values
plotmad = true;

%% Simulation

% internal variable used to monitor the run time
if internal==true
    TrunVar    = {'Tnrx_internal','Tjit_internal','Tjio_internal','Tfsm_internal'};
else
    TrunVar    = {'Tnrx_overall','Tjit_overall','Tjio_overall','Tfsm_overall'};
end

nrun    = numel(TrunVar);  % counter/flag for the type of runs monitored

if useTimeit == 1, ttrep=1; end  % if you prefer timeit, one replicate is sufficient

resultstruct = zeros(numel(N),numel(V));

Tfsm_overall = resultstruct;
Tjit_overall = resultstruct;
Tjio_overall = resultstruct;
Tmex_overall = resultstruct;
Tnrx_overall = resultstruct;

Tfsm_internal = resultstruct;
Tjit_internal = resultstruct;
Tjio_internal = resultstruct;
Tmex_internal = resultstruct;
Tnrx_internal = resultstruct;

Tfsm_internal_mad = resultstruct;
Tjit_internal_mad = resultstruct;
Tjio_internal_mad = resultstruct;
Tmex_internal_mad = resultstruct;
Tnrx_internal_mad = resultstruct;

Tncalls = zeros(numel(N),numel(V));

countn = 0;
for n=N
    contamination = floor(n*contperc);
    countn = countn+1;
    countv = 0;
    for v=V
        countv = countv+1;
        
        % Contaminated data
        rng(123456);
        Y=randn(n,v);
        %Y = lognrnd(10,1,n,v);
        Ycont=Y;
        if contamination ~= 0
            Ycont(1:contamination,:)=Ycont(1:contamination,:)+10;
        end
        
        % MONITOR USE OF SORT
        tend_overall = zeros(ttrep,1);
        tend_internal = zeros(ttrep,1);
        tend_internal_mad = zeros(ttrep,1);
        ncalls = zeros(ttrep,1);
        for i=1:ttrep
            rng(123456);
            if useTimeit
                switch algorithm
                    case 'fs_easy'
                        f = @() FSMeasy_qs(Ycont,'ostype','sort','msg',0,'plots',0,'m0',initialsubset);
                    case 'fs_fast'
                        f = @() FSM_qs(Ycont,'ostype','sort','msg',0,'plots',0,'m0',initialsubset);
                    case 'mcd'
                        f = @() mcd_qs(Ycont,'ostype','sort','msg',0);
                end
                tend_overall(i)=timeit(f);
            else
                tstart=tic;
                switch algorithm
                    case 'fs_easy'
                        [RAW , tend_internal_srt]=FSMeasy_qs(Ycont,'ostype','sort','msg',0,'plots',0,'m0',initialsubset);
                    case 'fs_fast'
                        [RAW , tend_internal_srt]=FSM_qs(Ycont,'ostype','sort','msg',0,'plots',0,'m0',initialsubset);
                    case 'mcd'
                        [RAW , ~ , ~ , tend_internal_srt]=mcd_qs(Ycont,'ostype','sort','msg',0);
                end
                tend_overall(i)      = toc(tstart);
                tend_internal(i)     = tend_internal_srt(1);
                tend_internal_mad(i) = tend_internal_srt(2);
                ncalls(i)            = tend_internal_srt(3);
            end
        end
        Tfsm_overall(countn,countv)     = median(tend_overall);
        Tfsm_internal(countn,countv)    = median(tend_internal);
        Tfsm_internal_mad(countn,countv)= median(tend_internal_mad);
        Tncalls(countn,countv)          = median(ncalls);
        
        % MONITOR USE OF SIMPLESELECT
        tend_overall = zeros(ttrep,1);
        tend_internal = zeros(ttrep,1);
        tend_internal_mad = zeros(ttrep,1);
        for i=1:ttrep
            rng(123456);
            if useTimeit
                switch algorithm
                    case 'fs_easy'
                        f = @() FSMeasy_qs(Ycont,'ostype','qs__','msg',0,'plots',0,'m0',initialsubset);
                    case 'fs_fast'
                        f = @() FSM_qs(Ycont,'ostype','qs__','msg',0,'plots',0,'m0',initialsubset);
                    case 'mcd'
                        f = @() mcd_qs(Ycont,'ostype','qs__','msg',0);
                end
                tend_overall(i)=timeit(f);
            else
                tstart=tic;
                switch algorithm
                    case 'fs_easy'
                        [RAW_qs , tend_internal_qs] = FSMeasy_qs(Ycont,'ostype','qs__','msg',0,'plots',0,'m0',initialsubset);
                    case 'fs_fast'
                        [RAW_qs , tend_internal_qs] = FSM_qs(Ycont,'ostype','qs__','msg',0,'plots',0,'m0',initialsubset);
                    case 'mcd'
                        [RAW_qs  , ~ , ~ , tend_internal_qs] = mcd_qs(Ycont,'ostype','qs__','msg',0);
                end
                tend_overall(i)      = toc(tstart);
                tend_internal(i)     = tend_internal_qs(1);
                tend_internal_mad(i) = tend_internal_qs(2);
            end
        end
        Tjit_overall(countn,countv)     = median(tend_overall);
        Tjit_internal(countn,countv)    = median(tend_internal);
        Tjit_internal_mad(countn,countv)= median(tend_internal_mad);
        
        % MONITOR USE OF SIMPLESELECT WITH ORACLE
        tend_overall = zeros(ttrep,1);
        tend_internal = zeros(ttrep,1);
        tend_internal_mad = zeros(ttrep,1);
        for i=1:ttrep
            rng(123456);
            if useTimeit
                switch algorithm
                    case 'fs_easy'
                        f = @() FSMeasy_qs(Ycont,'ostype','qso_','msg',0,'plots',0,'m0',initialsubset);
                    case 'fs_fast'
                        f = @() FSM_qs(Ycont,'ostype','qso_','msg',0,'plots',0,'m0',initialsubset);
                    case 'mcd'
                        f = @() mcd_qs(Ycont,'ostype','qso_','msg',0);
                end
                tend_overall(i)=timeit(f);
            else
                tstart=tic;
                switch algorithm
                    case 'fs_easy'
                        [RAW_qso , tend_internal_qso] = FSMeasy_qs(Ycont,'ostype','qso_','msg',0,'plots',0,'m0',initialsubset);
                    case 'fs_fast'
                        [RAW_qso , tend_internal_qso] = FSM_qs(Ycont,'ostype','qso_','msg',0,'plots',0,'m0',initialsubset);
                    case 'mcd'
                        [RAW_qso  , ~ , ~ ,  tend_internal_qso] = mcd_qs(Ycont,'ostype','qso_','msg',0);
                end
                tend_overall(i)      = toc(tstart);
                tend_internal(i)     = tend_internal_qso(1);
                tend_internal_mad(i) = tend_internal_qso(2);
            end
        end
        Tjio_overall(countn,countv)     = median(tend_overall);
        Tjio_internal(countn,countv)    = median(tend_internal);
        Tjio_internal_mad(countn,countv)= median(tend_internal_mad);
        
        % MONITOR USE OF SIMPLESELECT COMPILED
        tend_overall = zeros(ttrep,1);
        tend_internal = zeros(ttrep,1);
        tend_internal_mad = zeros(ttrep,1);
        for i=1:ttrep
            rng(123456);
            if useTimeit
                switch algorithm
                    case 'fs_easy'
                        f = @() FSMeasy_qs(Ycont,'ostype','qsc_','msg',0,'plots',0,'m0',initialsubset);
                    case 'fs_fast'
                        f = @() FSM_qs(Ycont,'ostype','qsc_','msg',0,'plots',0,'m0',initialsubset);
                    case 'mcd'
                        f = @() mcd_qs(Ycont,'ostype','qsc_','msg',0);
                end
                tend_overall(i)=timeit(f);
            else
                tstart=tic;
                switch algorithm
                    case 'fs_easy'
                        [RAW_qsc , tend_internal_qsc] = FSMeasy_qs(Ycont,'ostype','qsc_','msg',0,'plots',0,'m0',initialsubset);
                    case 'fs_fast'
                        [RAW_qsc , tend_internal_qsc] = FSM_qs(Ycont,'ostype','qsc_','msg',0,'plots',0,'m0',initialsubset);
                    case 'mcd'
                        [RAW_qsc  , ~ , ~ , tend_internal_qsc] = mcd_qs(Ycont,'ostype','qsc_','msg',0);
                end
                tend_overall(i)      = toc(tstart);
                tend_internal(i)     = tend_internal_qsc(1);
                tend_internal_mad(i) = tend_internal_qsc(2);
            end
        end
        Tmex_overall(countn,countv)     = median(tend_overall);
        Tmex_internal(countn,countv)    = median(tend_internal);
        Tmex_internal_mad(countn,countv)= median(tend_internal_mad);
        
        % MONITOR USE OF QUICKSELECT COMPILED FROM NUMERICAL RECIPES IN C
        tend_overall = zeros(ttrep,1);
        tend_internal = zeros(ttrep,1);
        tend_internal_mad = zeros(ttrep,1);
        for i=1:ttrep
            rng(123456);
            if useTimeit
                switch algorithm
                    case 'fs_easy'
                        f = @() FSMeasy_qs(Ycont,'ostype','nrc_','msg',0,'plots',0,'m0',initialsubset);
                    case 'fs_fast'
                        f = @() FSM_qs(Ycont,'ostype','nrc_','msg',0,'plots',0,'m0',initialsubset);
                    case 'mcd'
                        f = @() mcd_qs(Ycont,'ostype','nrc_','msg',0);
                end
                tend_overall(i)=timeit(f);
            else
                tstart=tic;
                switch algorithm
                    case 'fs_easy'
                        [RAW_nrc , tend_internal_nrc] = FSMeasy_qs(Ycont,'ostype','nrc_','msg',0,'plots',0,'m0',initialsubset);
                    case 'fs_fast'
                        [RAW_nrc , tend_internal_nrc] = FSM_qs(Ycont,'ostype','nrc_','msg',0,'plots',0,'m0',initialsubset);
                    case 'mcd'
                        [RAW_nrc  , ~ , ~ , tend_internal_nrc] = mcd_qs(Ycont,'ostype','nrc_','msg',0);
                end
                tend_overall(i)       = toc(tstart);
                tend_internal(i)      = tend_internal_nrc(1);
                tend_internal_mad(i)  = tend_internal_nrc(2);
            end
        end
        Tnrx_overall(countn,countv)      = median(tend_overall);
        Tnrx_internal(countn,countv)     = median(tend_internal);
        Tnrx_internal_mad(countn,countv) = median(tend_internal_mad);
        
        %% Display progress results
        
        disp(['n=' num2str(n) ' , ' 'v=' num2str(v)  ' , ' 'ncalls=' , num2str(median(ncalls))]);
        disp(['OVERALL:  ' 'Tfsm=' num2str(Tfsm_overall(countn,countv)) ' - ' 'Tjit=' num2str(Tjit_overall(countn,countv)) ' - ' 'Tjio=' num2str(Tjio_overall(countn,countv)) ' - ' 'Tmex=' num2str(Tmex_overall(countn,countv)) ' - ' 'Tnrx=' num2str(Tnrx_overall(countn,countv))]);
        disp(['INTERNAL: ' 'Tfsm=' num2str(Tfsm_internal(countn,countv)) ' - ' 'Tjit=' num2str(Tjit_internal(countn,countv)) ' - ' 'Tjio=' num2str(Tjio_internal(countn,countv)) ' - ' 'Tmex=' num2str(Tmex_internal(countn,countv)) ' - ' 'Tnrx=' num2str(Tnrx_internal(countn,countv))]);
        
        if ~useTimeit
            if sum(RAW.md-RAW_qs.md)>10^(-10) || sum(RAW.md-RAW_qsc.md)>10^(-10) || sum(RAW.md-RAW_qso.md)>10^(-10) || sum(RAW.md-RAW_nrc.md)>10^(-10)
                disp(['n=' num2str(n) ' , ' 'v=' num2str(v) ' -- ' 'err = ' num2str(sum(RAW.md-RAW_qs.md)) ' - ' num2str(sum(RAW.md-RAW_qsc.md)) ' - ' num2str(sum(RAW.md-RAW_qso.md)) ' - ' num2str(sum(RAW.md-RAW_nrc.md))]);
            else
                disp(' ');
            end
        end
    end
end

%% Average Time Percentage Gain (ATG) over all sample sizes, and ranking

T_overall     = [Tnrx_overall'      ; Tjit_overall'  ; Tjio_overall'  ; Tfsm_overall'];
T_internal    = [Tnrx_internal'     ; Tjit_internal' ; Tjio_internal' ; Tfsm_internal'];
Tmad_internal = [Tnrx_internal_mad' ; Tjit_internal_mad' ; Tjio_internal_mad' ; Tfsm_internal_mad'];

% scores and speed normalised by the sum of meanValues
if internal
    tit0 = ' (I)'; % title id
    refValues = T_internal(4,:);
    ATG = nanmean(bsxfun(@rdivide, T_internal-refValues, refValues), 2);
else
    tit0 = ' (O)'; % title id
    refValues = T_overall(4,:);
    ATG = nanmean(bsxfun(@rdivide, T_overall-refValues, refValues), 2);
end
speed = (100/sum(refValues))./(ATG);

if dorank
    % performance ranking index (i_ms)
    [~,i_ms] = sort(ATG,'descend');
else
    i_ms = 1:4;  % this will bypass performance ranking  
end

% rank time values and associated dispersion
if internal
    T_sorted    = T_internal(i_ms,:);
    Tmad_sorted = Tmad_internal(i_ms,:);
else
    T_sorted = T_overall(i_ms,:);
    Tmad_sorted = [];
end

if plot_eachcontperc
    %% PLOT: ATG over all sample sizes
    
    fig1 = figure;
    hax2 = axes('parent',fig1);
    barh(hax2,ATG(i_ms),'LineWidth',1.5,'EdgeColor','k','FaceColor',[0.8889,0.8889,0.8889]);
    %set(hax2,'xlim',[0 max(speeds)+.1],'xtick',0:10:max(speeds))
    set(hax2,'FontSize',gcaFontSize);
    set(hax2,'ytick',1:nrun)
    set(hax2,'yticklabel',legRun(i_ms),'fontsize',xylabFontSize)
    set(hax2,'OuterPosition',[0 0 1 1]);
    title(hax2,['Average Time Percentage Gain' tit0],'interpreter','latex','FontSize',titleFontSize);
    
    
    %% Absolute Time Performance: median time
    
    figure;
    if ~isempty(Tmad_sorted) && plotmad
        heb=errorbar(T_sorted',Tmad_sorted','-o','MarkerSize',5,'LineWidth',thinLineWidth);
        hold on;
    else
        heb = [];
    end
    hpl = plot(T_sorted', 'LineWidth', thickLineWidth);
    for i=1:nrun
        set(hpl(i),'Color',clr{i});
        set(hpl(i),'LineStyle',lst{i});
        if ~isempty(heb), set(heb(i),'Color',clr{i}); end
    end
    set(gca,'TickLabelInterpreter','none');
    xticks(1:length(N));
    xticklabels(cellstr(num2str(N(:)))); %xtickangle(gca,45);
    xtl = get(gca,'XtickLabel'); xtl(2:2:end)={' '}; set(gca,'XtickLabel',xtl);
    yticklabels(cellstr(num2str(1000*yticks')));
    set(gca,'fontsize',gcaFontSize);
    xlabel('Sample size','fontsize',xylabFontSize);
    ylabel('Time in milli-seconds','fontsize',xylabFontSize);
    title(['Median Elapsed Time'  tit0],'interpreter','latex','FontSize',titleFontSize);
    hl=legend(hpl,legRun(i_ms));
    set(hl,'Location','northwest');
    
    
    %% Relative Time Performance: time percentage differences
    
    localLegRun = legRun(i_ms);
    localTrun   = TrunVar(i_ms);
    
    kk = numel(localLegRun);
    therefval = localTrun{kk};
    therunval = localTrun; therunval(kk)=[];
    r         = localLegRun{kk};
    vv        = localLegRun; vv(kk)=[];
    
    countv = 0;
    for v=V
        countv = countv+1;
        refval = eval([therefval '(:,countv)']);
        leg    = cell(kk-1,1);
        ii=0;
        figure;
        for theval = therunval
            ii=ii+1;
            val = eval([theval{:} '(:,countv)']);
            leg{ii,:} = ['$((' vv{ii} ' - ' r ') / ' r ') \cdot 100$']; %tit = '((v - r) / r) * 100';
            
            perc_difference     = ((val - refval)./refval) * 100;
            perc_difference_abs = 100 * abs(val - refval) ./ ((val + refval) / 2);
            
            hhh=plot(N, perc_difference , 'LineWidth',2 , 'Marker' , '.' , 'MarkerFaceColor',clr_tpd{ii} ,'MarkerSize',8) ;
            set(hhh,'Color',clr_tpd{ii});
            set(hhh,'LineStyle',lst_tpd{ii});
            hold on;
        end
        line(N,zeros(1,numel(N)),'Color','k','LineStyle','--','LineWidth',0.5);
        hold off;
        set(gca,'fontsize',gcaFontSize);
        legend(leg,'interpreter','latex');
        set(gca,'FontSize',gcaFontSize);
        xlabel('Sample size','fontsize',xylabFontSize);
        ylabel('Time percentage difference','fontsize',xylabFontSize);
        title(['Relative Time Performance'  tit0 ' - ' settings.algorithm],'FontSize',titleFontSize);
    end
    
    %{
    % time percentage difference between the three compiled versions
    countv = 0;
    for v=V
        countv = countv+1;
        figure;
        plot(N, [(Tjit_internal(:,countv) - Tfsm_internal(:,countv))./Tfsm_internal(:,countv) , (Tnrx_internal(:,countv) - Tfsm_internal(:,countv))./Tfsm_internal(:,countv) , (Tmex_internal(:,countv)-Tfsm_internal(:,countv))./Tfsm_internal(:,countv)],'LineWidth',2);
        hold on;line(N,zeros(1,numel(N)),'Color','k','LineStyle','--'); hold off;
        legend({'$(Tjit_{internal}-Tfsm_{internal})/Tfsm_{internal}$' , '$(Tnrx_{internal}-Tfsm_{internal})/Tfsm_{internal}$' , '$(Tmex_{internal}-Tfsm_{internal})/Tfsm_{internal}$'},'FontSize',16,'interpreter','latex');
        title(['mex comparisons' num2str(v)],'interpreter','latex','FontSize',titleFontSize);
    end
    %}
end

end

% %% Absolute Time Performance: original code
%{
    localLegRun = legRun(i_ms);
    localTrun   = TrunVar(i_ms);
    countv = 0;
    for v=V
        countv = countv+1;
        figure;
        i=0;
        for theval = localTrun
            i=i+1;
            val = eval([theval{:} '(:,countv)']);
            plot(N, val , 'LineWidth',2,'Color',clr{i},'LineStyle',lst{i}) ;
            hold on;
        end

        hold off;

        set(gca,'fontsize',gcaFontSize);
        hl=legend(localLegRun); set(hl,'Location','northwest');
        xlabel('sample size','fontsize',xylabFontSize);
        ylabel('Median time in milli-seconds','fontsize',xylabFontSize);
        yticklabels(cellstr(num2str(1000*yticks')));
        set(gca,'FontSize',gcaFontSize);
        title(['Elapsed Time'  tit0],'interpreter','latex','FontSize',titleFontSize);

    end
%}


% personalized time percentage difference
%{
    countv = 0;
    for v=V
        countv = countv+1;
        figure;
        plot(N, [(Tjit_internal(:,countv) - Tfsm_internal(:,countv))./Tfsm_internal(:,countv) , (Tjio_internal(:,countv) - Tfsm_internal(:,countv))./Tfsm_internal(:,countv) , (Tmex_internal(:,countv)-Tfsm_internal(:,countv))./Tfsm_internal(:,countv)],'LineWidth',2);
        hold on;line(N,zeros(1,numel(N)),'Color','k','LineStyle','--'); hold off;
        legend({'(Tjit_internal-Tfsm_internal)/Tfsm_internal' , '(Tjio_internal-Tfsm_internal)/Tfsm_internal' , '(Tmex_internal-Tfsm_internal)/Tfsm_internal'},'FontSize',16);
        title(['v=' num2str(v)],'FontSize',18);
    end
%}

