clear variables; close all; clc;
rng(2021, 'twister');

% verbosity
verb = 0;
% number of repetitions to perform
reptot = 100;

% setting 1,3: fix overlap value and vary n
% setting 2: fix n value and vary overlap value
% simsetting = 1;
% simsetting = 2;
simsetting = 3;

if simsetting == 1  
    n = round(linspace(1000,45000,10));
    overlvec = 0.005;
    
    % use this setting to reproduce the scatterplot in the main text
    % rng(100)
    % n = 6000;

elseif simsetting == 2
    overlvec = linspace(0.0005, 0.035, 10);
    n = 5000;
    
    % NOTE: use the very last run to reproduce the scatterplot in the main text
elseif simsetting == 3
%     n = round(linspace(50000,300000,11)); % we did split it in 2 runs
    n = round(linspace(325000,500000,8));
    overlvec = 0.005;
    simsetting = 1;
end

% number of variables
v = 2;
% true clusters
k = 3;
% contamination level
alpha = 0.2;
% methods in use
% estnam = {'tkm', 'tclust'};
estnam = {'tk-merge', 'tk-means', 'tclust'};
nest = length(estnam);

% initialize variables
ARI_DEMP    = zeros(reptot, length(n));
RI_DEMP     = ARI_DEMP;
ARI_MRG     = ARI_DEMP;
RI_MRG      = ARI_DEMP;
ARI_tclus   = ARI_DEMP;
RI_tclus    = ARI_DEMP;
tocDEMPK    = ARI_DEMP;
tocMRG      = ARI_DEMP;
tocTCLUST   = ARI_DEMP;

% clustering options
tkmeansOpt.nocheck = 1;
tkmeansOpt.msg = 0;
tkmeansOpt.nomes = 1;
tkmeansOpt.plots = verb;

%% 

for i = 1:length(n)
    
    n_i = n(i);
    noise = floor(alpha * n_i);

    for overli = 1:length(overlvec)
        
        if simsetting == 1
            ii = i;
        elseif simsetting == 2
            ii = overli;
        end
        overlap = overlvec(overli);
        
        % [numpool, ~, ~, ~, ~] = PoolPrepare(16, reptot, {});
        % parfor repi = 1:reptot
           
        for repi = 1:reptot

            % simulate data
            out = MixSim(k, v, 'sph', false, 'hom', false, 'int', [0 10], 'Display', 'off', ...
                'MaxOmega',  overlap, 'Display','off');
            [X, id] = simdataset(n_i, out.Pi, out.Mu, out.S, 'noiseunits', noise);
            if verb == 1
               % Plotting data
                figure
                gscatter(X(:,1), X(:,2), id, [], [], 15);
                xlabel('X1')
                ylabel('X2')
                set(findall (gcf,'-property','FontSize'),'FontSize',11)
                title('')
                xlim([min(X(:,1)), max(X(:,1))])
                ylim([min(X(:,2)), max(X(:,2))])
                % str = sprintf('Simulated data with %d groups in %d dimensions and %d units', k, v, n);
                % title(str,'Interpreter','Latex'); 
            end
            
            alphaemp = noise/(noise+n_i);
            kk = k*2;

            % tk-means
            ticDEMPK = tic;
            DEMP = tkmeans(X, k, alphaemp, 'plots', verb, 'msg',0);
            DEMP.mergID = DEMP.idx;
            tocDEMPK(repi, ii) = toc(ticDEMPK);  
            [ARI_DEMP(repi, ii), RI_DEMP(repi, ii)] = RandIndexFS(DEMP.mergID, id);

            % tk-merge
            ticMRG = tic;
            MRG = txmerge(X, kk, k, 'alpha', alphaemp , 'plots', verb, 'tkmeansOpt', tkmeansOpt, 'dist', 0, 'auto', 0);
            tocMRG(repi, ii) = toc(ticMRG);
            [ARI_MRG(repi, ii), RI_MRG(repi, ii)] = RandIndexFS(MRG.mergID, id);
            if verb == 1
                set(gca,'FontSize',25)
                legend1 = clickableMultiLegend(gca, num2str((0:5)'));
                set(legend1,'LineWidth',1,'Interpreter','latex','FontSize',26, 'Location', 'northwest')
                title('Simulated data')
                xlim([min(X(:,1)), max(X(:,1))]);
                ylim([min(X(:,2)), max(X(:,2))]);
            end

            % TCLUST
            ticTCLUST = tic;
            tclustout=tclust(X, k, alphaemp , 1000,'plots', verb, 'msg',0, 'nocheck',1);
            tocTCLUST(repi, ii) = toc(ticTCLUST);
            [ARI_tclus(repi, ii), RI_tclus(repi, ii)] = RandIndexFS(tclustout.idx, id);

            % cascade;
            close all

        end
    end
end

%% plot solutions

tratio = abs((tocMRG - tocTCLUST)./tocTCLUST)*100;
tratio2 = abs((tocDEMPK - tocTCLUST)./tocTCLUST)*100;
sol = {tocMRG, tocDEMPK, tocTCLUST; 
        ARI_MRG, ARI_DEMP, ARI_tclus; 
        tratio, tratio2, tratio};

%%
% close all 
ylab = {'Computing time in seconds', 'Adjusted Rand Index', 'Computational time gain in % ', };
col = 'brgmycrbkgmycbkgmyc';  
mkT = { '.', '-', '*', 'o', '+', '*', 'x', 'v', 'square', 'diamond'};

if simsetting == 1
    x = n;
elseif simsetting == 2
%     x = round(overlvec, 4, 'decimals');
    x = overlvec;
end

% to add dispersion: median \pm Sn
adddisp=1;


mrks = 4;
lnd = 2;
fnts = 15;
% close all
for i=1:size(sol, 1)
    figure
    for j = 1:nest
        s_n   = Sn(sol{i, j});
        madm = median(sol{i, j}) - s_n; 
        madp = median(sol{i, j}) + s_n; 
        if ~(i==3 && j==3)
            plot(x, median(sol{i, j}), 'Color', col(j), 'DisplayName', string(estnam(j)), ...
                'linestyle', '-', 'LineWidth', lnd, 'MarkerSize', mrks);
            hold on
            if adddisp==1
                hold on
                plot(x, madp, 'Color', col(j), ... %'DisplayName', string(estnam(j)), ...
                    'linestyle', '--', 'LineWidth', lnd, 'MarkerSize', mrks);
                hold on
                plot(x, madm, 'Color', col(j), ... %'DisplayName', string(estnam(j)), ...
                    'linestyle', '--', 'LineWidth', lnd, 'MarkerSize', mrks);
            end
        end
        if i == 2
            ylim([0.75,1])
        end
    end
    set(gca,'FontSize',fnts)
    if simsetting == 1
        xticks(n);
        xticklabels(round(n/1000,1));
        xtickangle(45); 
        xlabel('Number of observations (in thousands)','FontSize', fnts, 'FontWeight', 'Bold');
    elseif simsetting == 2
        xx = num2str(round(x, 4)');
        xx(4, :) = '0.0120';
        xx(end, :) = '0.0350';
        xticks(x);
        xticklabels(xx);
        xtickangle(45);
        xlabel('Overlap value','FontSize', fnts, 'FontWeight', 'Bold');
    end
    xlim([min(x), max(x)]);
    grid()
    ylabel(ylab{i},'FontSize',  fnts, 'FontWeight', 'Bold');
    
    if i==1 || i==2
        hold on
        h(1) = plot(nan, nan, '-b', 'LineWidth', lnd);
        hold on
        h(2) = plot(nan, nan, '-r', 'LineWidth', lnd);
        hold on
        h(3) = plot(nan, nan, '-g', 'LineWidth', lnd);
        legend(h, estnam, 'Location', 'best')
    else
        hold on
        h(1) = plot(nan, nan, '-b', 'LineWidth', lnd);
        hold on
        h(2) = plot(nan, nan, '-r', 'LineWidth', lnd);
        legend(h, estnam(1:2), 'Location', 'best')
    end

end

