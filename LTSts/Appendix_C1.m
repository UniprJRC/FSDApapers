%%%% Simulation study of Appendix C.1.

n = 100; % sample size
rep = 100; % number of repetitions


%% Simulation of time series with linear trend and a seasonal component with one harmonic

model=struct;
model.s=24;
model.trend=1;
model.trendb=[1,0.1];
model.seasonal=1;
model.seasonalb=[5 0];
model.signal2noiseratio=5;
model.nsim=rep;

rng(123)
out_sim=simulateTS(n,'model',model,'plots',0);

fitmodel=struct;
fitmodel.s=24;
fitmodel.trend=1;
fitmodel.seasonal=1;
fitmodel.lshift=-1;

%% plot of the data (Figure C.12)

ind=2;

figure;
y=out_sim.y(:,ind);
plot(y);

%% single spikes contamination

vec_AO = [0 1 5 10 20];
l_AO = length(vec_AO);
a=10; b=15;   % range size AO

pval_levelshift=zeros(rep,l_AO);
number_outliers=zeros(rep,l_AO);
number_AO=zeros(rep,l_AO);
percentage_AO=zeros(rep,l_AO);

% Figure C.14
figure;
t=get(gcf,'position');
set(gcf,'position',t.*[0,0,2,2])
for n_AO = 2:l_AO
    
    rng(100+n_AO)
    
    t_AO = randperm(n,vec_AO(n_AO));            % position of AO
    m_AO = (b-a).*rand(vec_AO(n_AO),1) + a;     % size of AO
    ud_AO = (rand(vec_AO(n_AO),1) > 0.5)*2 - 1; % sign of AO

    y=out_sim.y(:,ind);
    y(t_AO)=y(t_AO) + ud_AO.*m_AO;
    
    subplot(2,2,n_AO-1)
    plot(y);
    ylim([-20 30])
    if vec_AO(n_AO)>0
        hold on;plot(t_AO,y(t_AO),'*r')
    end
    title(['number of outliers = ' num2str(vec_AO(n_AO),'%i')]);
    set(gca,'FontSize',14);

end 

parfor ind = 1:rep

    for n_AO = 1:l_AO
    
        rng(100*ind+n_AO)
    
        t_AO = randperm(n,vec_AO(n_AO));            % position of AO
        m_AO = (b-a).*rand(vec_AO(n_AO),1) + a;     % size of AO
        ud_AO = (rand(vec_AO(n_AO),1) > 0.5)*2 - 1; % sign of AO
        
        y=out_sim.y(:,ind);
        
        y(t_AO)=y(t_AO) + ud_AO.*m_AO;
        
        out_fit=LTSts(y,'model',fitmodel,'plots',0,'msg',false);
        
        pval_levelshift(ind,n_AO)=out_fit.LevelShiftPval;
        number_outliers(ind,n_AO)=size(out_fit.outliers,1);
        number_AO(ind,n_AO)=size(intersect(out_fit.outliers,t_AO),1);
        percentage_AO(ind,n_AO)=size(intersect(out_fit.outliers,t_AO),1)/length(t_AO);
    
    end

end

% Table C.3 (left)
disp(vec_AO(2:l_AO))
disp(mean(percentage_AO(:,2:l_AO)))

% Table C.4 (left)
disp(vec_AO)
disp(mean(pval_levelshift<0.01,1))

% Figure C.13
figure;
t=get(gcf,'position');
set(gcf,'position',t.*[0,0,2,1])

subplot(1,2,1)
boxplot(number_outliers(:,1))
yline(2.5)
xticklabels([]);
ylabel('number of outliers found')
set(gca,'FontSize',14);

y=out_sim.y(:,2);
out_fit=LTSts(y,'model',fitmodel,'plots',0,'msg',false);
subplot(1,2,2)
plot(y,'b');
hold('on')
plot(out_fit.yhat,'k--','Linewidth',1.5)
plot(out_fit.outliers,y(out_fit.outliers),'*r')
legend({'Simulated data','Fitted values'},'Location','Northwest','FontSize',14)
set(gca,'FontSize',14);

% Figure C.16 (left panel)
figure;
boxplot(percentage_AO(:,2:end))
yline(0.975)
xticklabels(vec_AO(2:end)); xlabel('number of contaminating outliers'); ylabel('percentage outliers found')
title('Single contamination')
set(gca,'FontSize',14);


%% group of outliers contamination

vec_AO = [2 4 6 8];
l_AO = length(vec_AO);
a=10; b=15;   % range size AO

pval_levelshift=zeros(rep,l_AO);
number_outliers=zeros(rep,l_AO);
number_AO=zeros(rep,l_AO);
percentage_AO=zeros(rep,l_AO);

% Figure C.15
figure;
t=get(gcf,'position');
set(gcf,'position',t.*[0,0,2,2])
for n_AO = 1:l_AO
    
    rng(100+n_AO)
    
    tmp = randi([1 n-vec_AO(n_AO)],1,1);
    t_AO = tmp:(tmp+vec_AO(n_AO)-1);   % position of AO
    m_AO = (b-a)*rand(1,1) + a;      % size of AO
    ud_AO = (rand(1,1) > 0.5)*2 - 1; % sign of AO
         
    y=out_sim.y(:,2);
    y(t_AO)=y(t_AO) + ud_AO*m_AO;
        
    subplot(2,2,n_AO);
    plot(y);
    hold on;plot(t_AO,y(t_AO),'*r')
    ylim([-20 20])
    title(['number of outliers = ' num2str(vec_AO(n_AO),'%i')]);
    set(gca,'FontSize',14);
    
end

parfor ind = 1:rep
    
    for n_AO = 1:l_AO
    
        rng(100*ind+n_AO)

        tmp = randi([1 n-vec_AO(n_AO)],1,1);
        t_AO = tmp:(tmp+vec_AO(n_AO));   % position of AO
        m_AO = (b-a)*rand(1,1) + a;      % size of AO
        ud_AO = (rand(1,1) > 0.5)*2 - 1; % sign of AO
                
        y=out_sim.y(:,ind);
    
        y(t_AO)=y(t_AO) + ud_AO*m_AO;
        
        out_fit=LTSts(y,'model',fitmodel,'plots',0,'msg',false);
        
        pval_levelshift(ind,n_AO)=out_fit.LevelShiftPval;
        number_outliers(ind,n_AO)=size(out_fit.outliers,1);
        number_AO(ind,n_AO)=size(intersect(out_fit.outliers,t_AO),1);
        percentage_AO(ind,n_AO)=size(intersect(out_fit.outliers,t_AO),1)/length(t_AO);
    
    end
    
end

% Table C.3 (right)
disp(vec_AO)
disp(mean(percentage_AO))

% Table C.4 (right)
disp(vec_AO)
disp(mean(pval_levelshift<0.01,1))

% Figure C.16 (right panel)
figure; 
boxplot(percentage_AO)
yline(0.975)
xticklabels(vec_AO); xlabel('number of contaminating outliers'); ylabel('percentage of outliers found')
title("Group contamination")
set(gca,'FontSize',14);
