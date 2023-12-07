%%%% Simulation study of Appendix B.4.

n = 100; % sample size
rep = 100; % number of repetitions

snr_vec = [10 20 30]; % signal to noise ratio
n_snr = length(snr_vec);

n_AO = 5; % number of spikes in contamination


%% plot of the data (Figure B.11)

% first model: seasonal component with one harmonic and a level shift + single spikes contamination

model=struct;
model.trend=0;                  % trend
model.trendb=0;                 % parameters of the trend
model.s=24;                     % monthly time series
model.seasonal=1;               % harmonic and harmonic trend
model.seasonalb=80*[1 1];       % parameters for the harmonics
model.lshiftb=300;              % level shift amplitude
model.lshift=30;                % level shift position
model.nsim = rep;
   
a_vec = [300 300 250];
b_vec = [600 600 500];

i = 1;

figure;
t=get(gcf,'position');
set(gcf,'position',t.*[0,0,3,2])

indplot=1;

for isnr = 1:n_snr

    model.signal2noiseratio = snr_vec(isnr);   % signal to noise ratio
    
    % generate data
    rng(102+isnr)
    out_sim=simulateTS(n,'plots',0,'model',model);
    
    % add single AO
    y = out_sim.y;
    
    a = a_vec(isnr); b = b_vec(isnr);
    
    rng(100+i+100*isnr)
    t_AO = randperm(n,n_AO);            % position of AO
    m_AO = (b-a).*rand(n_AO,1) + a;     % size of AO
    ud_AO = (rand(n_AO,1) > 0.5)*2 - 1; % sign of AO
    y(t_AO,i)=y(t_AO,i) + ud_AO.*m_AO;
    
    subplot(3,3,indplot); indplot=indplot+1;
    plot(y(:,i))
    hold on;plot(t_AO,y(t_AO,i),'*r')
    h2 = text(40, 1500,['snr = ' num2str(snr_vec(isnr),'%i')],'FontSize',18,'FontWeight', 'Bold');
    if isnr == 1
        h1 = text(-30, -300,'First model','FontSize',18,'FontWeight', 'Bold');
        set(h1, 'rotation', 90)
    end
    ylim([-530 1200])
    set(gca,'FontSize',14);
    
end

% second model: linear trend, an external covariate and a level shift + single spikes contamination

rng(27288)
tmp = randn(n,1);

model=struct;
model.trend=1;                  % linear trend
model.trendb=[0.5 1];           % parameters of the linear trend
model.s=12;                     % monthly time series
model.seasonal=0;               % no harmonic
model.seasonalb=[];             % parameter for harmonic
model.X=tmp;                    % explanatory variable
model.Xb=10;                    % parameter for explanatory variable
model.lshiftb=70;               % level shift amplitude
model.lshift=30;                % level shift position
model.nsim = rep;

a_vec = [100 100 50];
b_vec = [200 200 150];

for isnr = 1:n_snr

    model.signal2noiseratio = snr_vec(isnr);   % signal to noise ratio
    
    % generate data
    rng(3+isnr)
    out_sim=simulateTS(n,'plots',0,'model',model);
    
    % add single AO
    y = out_sim.y;
    
    a = a_vec(isnr); b = b_vec(isnr);
    
    rng(556+i+100*isnr)
    t_AO = randperm(n,n_AO);            % position of AO
    m_AO = (b-a).*rand(n_AO,1) + a;     % size of AO
    ud_AO = (rand(n_AO,1) > 0.5)*2 - 1; % sign of AO
    y(t_AO,i)=y(t_AO,i) + ud_AO.*m_AO;
        
    subplot(3,3,indplot); indplot=indplot+1;
    plot(y(:,i))
    hold on;plot(t_AO,y(t_AO,i),'*r')
    if isnr == 1
        h1 = text(-30, -150,'Second model','FontSize',18,'FontWeight', 'Bold');
        set(h1, 'rotation', 90)
    end
    ylim([-210 400])
    set(gca,'FontSize',14);
              
end

% third model: linear trend, an AR component of order 1 and a level shift

model=struct;
model.trend=0;                  % trend
model.trendb=0;             % parameters of the trend
model.s=12;                     % monthly time series
model.seasonal=0;               % no harmonic
model.seasonalb=[];             % parameter for harmonic
model.lshiftb=70;               % level shift amplitude
model.lshift=30;                % level shift position
model.ARp=1;
model.ARb=0.6;
model.nsim = rep;

a=50; b=100;

for isnr = 1:n_snr

    model.signal2noiseratio = snr_vec(isnr);   % signal to noise ratio
    
    % generate data
    rng(3+isnr)
    out_sim=simulateTS(n,'plots',0,'model',model);
    
    % add single AO
    y = out_sim.y;
    
    rng(898+i+100*isnr)
    t_AO = randperm(n,n_AO);            % position of AO
    m_AO = (b-a).*rand(n_AO,1) + a;     % size of AO
    ud_AO = (rand(n_AO,1) > 0.5)*2 - 1; % sign of AO
    y(t_AO,i)=y(t_AO,i) + ud_AO.*m_AO;
       
    subplot(3,3,indplot); indplot=indplot+1;
    plot(y(:,i))
    hold on;plot(t_AO,y(t_AO,i),'*r')
    if isnr == 1
        h1 = text(-30, -50,'Third model','FontSize',18,'FontWeight', 'Bold');
        set(h1, 'rotation', 90)
    end
    ylim([-100 250])
    set(gca,'FontSize',14);

end
   

%% First model: seasonal component with one harmonic and a level shift + single spikes contamination

% model used to simulate the data
model=struct;
model.trend=0;                  % trend
model.trendb=0;                 % parameters of the trend
model.s=24;                     % monthly time series
model.seasonal=1;               % harmonic and harmonic trend
model.seasonalb=80*[1 1];       % parameters for the harmonics
model.lshiftb=300;              % level shift amplitude
model.lshift=30;                % level shift position
model.nsim = rep;

% complete model to initialise the variable selection process
rng(1)
overmodel=struct;
overmodel.trend=3;          % cubic trend
overmodel.s=24;             % monthly time series
overmodel.seasonal=303;     % number of harmonics: three harmonics growing cubically (B=3, G=3)
overmodel.lshift=-1;        % search for level shift
overmodel.X=randn(n,2);     % two extra explanatory variable
overmodel.ARp=1:3;          % no autoregressive component

n_correct = zeros(n_snr,1);
n_correct_included = zeros(n_snr,1);

dim_red = zeros(n_snr,rep);
    
a_vec = [300 300 250];
b_vec = [600 600 500];

for isnr = 1:n_snr

    model.signal2noiseratio = snr_vec(isnr);   % signal to noise ratio
    
    % generate data
    rng(102+isnr)
    out_sim=simulateTS(n,'plots',0,'model',model);
    
    % add single AO
    y = out_sim.y;
    
    a = a_vec(isnr); b = b_vec(isnr);
    for i = 1:rep
        rng(100+i+100*isnr)
        t_AO = randperm(n,n_AO);            % position of AO
        m_AO = (b-a).*rand(n_AO,1) + a;     % size of AO
        ud_AO = (rand(n_AO,1) > 0.5)*2 - 1; % sign of AO
        y(t_AO,i)=y(t_AO,i) + ud_AO.*m_AO;
        
    end
    
    correct_i = zeros(rep,1);
    correct_included_i = zeros(rep,1);
    
    parfor i = 1:rep
    
        rng(123+i)
        [out_model,out_reduced] = LTStsVarSel(y(:,i),'model',overmodel,'plots',0,'msg',0,'dispresults',false,'thPval',0.001,'firstTestLS',true);
    
        dim_red(isnr,i)=size(out_reduced.B,1);
   
        if (out_model.trend == model.trend && out_model.seasonal == model.seasonal && out_model.lshift ~= 0 && isempty(out_model.X) && out_model.ARp(end) == 0)
            correct_i(i) = 1;
        end

        if (out_model.seasonal >= model.seasonal && out_model.lshift ~= 0)
            correct_included_i(i) = 1;
        end
    
    end
    
    n_correct(isnr) = sum(correct_i);
    n_correct_included(isnr) = sum(correct_included_i);

end

disp(snr_vec)
disp(n_correct)
disp(n_correct_included)


%% Second model: linear trend, an external covariate and a level shift + single spikes contamination

% model used to simulate the data
rng(27288)
tmp = randn(n,1);
model=struct;
model.trend=1;                  % linear trend
model.trendb=[0.5 1];           % parameters of the linear trend
model.s=12;                     % monthly time series
model.seasonal=0;               % no harmonic
model.seasonalb=[];             % parameter for harmonic
model.X=tmp;                    % explanatory variable
model.Xb=10;                    % parameter for explanatory variable
model.lshiftb=70;               % level shift amplitude
model.lshift=30;                % level shift position
model.nsim = rep;

% complete model to initialise the variable selection process
rng(2)
overmodel=struct;
overmodel.trend=3;            % cubic trend
overmodel.s=12;               % monthly time series
overmodel.seasonal=303;       % number of harmonics: three harmonics growing cubically (B=3, G=3)
overmodel.lshift=-1;          % search for level shift
overmodel.X=[tmp randn(n,2)]; % two extra explanatory variable
overmodel.ARp=1:3;            % autoregressive component

n_correct = zeros(n_snr,1);
n_correct_included = zeros(n_snr,1);

dim_red = zeros(n_snr,rep);
    
a_vec = [100 100 50];
b_vec = [200 200 150];

for isnr = 1:n_snr

    model.signal2noiseratio = snr_vec(isnr);   % signal to noise ratio
    
    % generate data
    rng(3+isnr)
    out_sim=simulateTS(n,'plots',0,'model',model);
    
    % add single AO
    y = out_sim.y;
    
    a = a_vec(isnr); b = b_vec(isnr);
    for i = 1:rep
        rng(556+i+100*isnr)
        t_AO = randperm(n,n_AO);            % position of AO
        m_AO = (b-a).*rand(n_AO,1) + a;     % size of AO
        ud_AO = (rand(n_AO,1) > 0.5)*2 - 1; % sign of AO
        y(t_AO,i)=y(t_AO,i) + ud_AO.*m_AO;
        
    end
    
    correct_i = zeros(rep,1);
    correct_included_i = zeros(rep,1);

    parfor i = 1:rep
    
        rng(123+i)
        [out_model,out_reduced] = LTStsVarSel(y(:,i),'model',overmodel,'plots',0,'msg',0,'dispresults',false,'thPval',0.001,'firstTestLS',true);
    
        dim_red(isnr,i)=size(out_reduced.B,1);

        if(all(size(out_model.X)==size(model.X)))
            if (out_model.trend == model.trend && out_model.seasonal == model.seasonal && out_model.lshift ~= 0 && all(out_model.X == model.X) && out_model.ARp(end) == 0)
                correct_i(i) = 1;
            end
        end

        if (out_model.trend >= model.trend && out_model.lshift ~= 0 && any(sum(out_model.X == model.X,1)==100))
            correct_included_i(i) = 1;
        end
    
    end

    n_correct(isnr) = sum(correct_i);
    n_correct_included(isnr) = sum(correct_included_i);
    
end

disp(snr_vec)
disp(n_correct)
disp(n_correct_included)


%% Third model: linear trend, an AR component of order 1 and a level shift + single spikes contamination

model=struct;
model.trend=0;                  % trend
model.trendb=0;             % parameters of the trend
model.s=12;                     % monthly time series
model.seasonal=0;               % no harmonic
model.seasonalb=[];             % parameter for harmonic
model.lshiftb=70;               % level shift amplitude
model.lshift=30;                % level shift position
model.ARp=1;
model.ARb=0.6;
model.nsim = rep;

% complete model to initialise the variable selection process
rng(1)
overmodel=struct;
overmodel.trend=3;          % cubic trend
overmodel.s=12;             % monthly time series
overmodel.seasonal=303;     % number of harmonics: three harmonics growing cubically (B=3, G=3)
overmodel.lshift=-1;        % search for level shift
overmodel.X=randn(n,2);     % two extra explanatory variable
overmodel.ARp=1:3;          % autoregressive component

n_correct = zeros(n_snr,1);
n_correct_included = zeros(n_snr,1);

dim_red = zeros(n_snr,rep);
    
a=50; b=100;

for isnr = 1:n_snr

    model.signal2noiseratio = snr_vec(isnr);   % signal to noise ratio
    
    % generate data
    rng(3+isnr)
    out_sim=simulateTS(n,'plots',0,'model',model);
    
    % add single AO
    y = out_sim.y;
    
    for i = 1:rep
        rng(898+i+100*isnr)
        t_AO = randperm(n,n_AO);            % position of AO
        m_AO = (b-a).*rand(n_AO,1) + a;     % size of AO
        ud_AO = (rand(n_AO,1) > 0.5)*2 - 1; % sign of AO
        y(t_AO,i)=y(t_AO,i) + ud_AO.*m_AO;
        
    end
    
    correct_i = zeros(rep,1);
    correct_included_i = zeros(rep,1);
    
    parfor i = 1:rep
    
        rng(123+i)
        [out_model,out_reduced] = LTStsVarSel(y(:,i),'model',overmodel,'plots',0,'msg',0,'dispresults',false,'thPval',0.001,'firstTestLS',true);
    
        dim_red(isnr,i)=size(out_reduced.B,1);

        if (out_model.trend == model.trend && out_model.seasonal == model.seasonal && out_model.lshift ~= 0 && isempty(out_model.X) && out_model.ARp(end) == model.ARp)
            correct_i(i) = 1;
        end

        if (out_model.trend >= model.trend && out_model.lshift ~= 0 && out_model.ARp(end) >= model.ARp)
            correct_included_i(i) = 1;
        end
    
    end
    
    n_correct(isnr) = sum(correct_i);
    n_correct_included(isnr) = sum(correct_included_i);
    
end

disp(snr_vec)
disp(n_correct)
disp(n_correct_included)

