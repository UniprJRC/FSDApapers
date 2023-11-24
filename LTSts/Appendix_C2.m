%%%% Simulation study of Appendix C.2.

n = 100; % sample size
rep = 100; % number of repetitions


%% Simulation of time series with linear trend and a seasonal component with one harmonic + level shift

model=struct;
model.s=24;
model.trend=1;
model.trendb=[1,0.1];
model.seasonal=1;
model.seasonalb=[5 0];
model.lshift=40;
model.lshiftb=10;
model.signal2noiseratio=5;
model.nsim=rep;

rng(123)
out_sim=simulateTS(n,'model',model,'plots',0);

fitmodel=struct;
fitmodel.s=24;
fitmodel.trend=1;
fitmodel.seasonal=1;
fitmodel.lshift=-1;

%% plot of the data (Figure C.17)

ind=2;
a=10; b=15;

figure;
t=get(gcf,'position');
set(gcf,'position',t.*[0,0,2,1])

rng(100+3)
t_AO = randperm(n,5);            % position of AO
m_AO = (b-a).*rand(5,1) + a;     % size of AO
ud_AO = (rand(5,1) > 0.5)*2 - 1; % sign of AO

y=out_sim.y(:,ind);
y(t_AO)=y(t_AO) + ud_AO.*m_AO;

subplot(1,2,1)
plot(y);
xline(40)
ylim([-10 40])
hold on;plot(t_AO,y(t_AO),'*r')
title('Single contamination');
set(gca,'FontSize',14);


rng(100+2)
    
tmp = randi([1 n-4],1,1);
t_AO = tmp:(tmp+4-1);            % position of AO
m_AO = (b-a)*rand(1,1) + a;      % size of AO
ud_AO = (rand(1,1) > 0.5)*2 - 1; % sign of AO
     
y=out_sim.y(:,2);
y(t_AO)=y(t_AO) + ud_AO*m_AO;
    
subplot(1,2,2)
plot(y);
xline(40)
ylim([-10 40])
hold on;plot(t_AO,y(t_AO),'*r')
title('Group contamination');
set(gca,'FontSize',14);


%% single spikes contamination

vec_AO = [0 1 5 10 20];
l_AO = length(vec_AO);
a=10; b=15;   % range size AO

pval_levelshift=zeros(rep,l_AO);
pos_levelshift=zeros(rep,l_AO);
number_outliers=zeros(rep,l_AO);
number_AO=zeros(rep,l_AO);
percentage_AO=zeros(rep,l_AO);

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
        pos_levelshift(ind,n_AO)=out_fit.posLS;
        number_outliers(ind,n_AO)=size(out_fit.outliers,1);
        number_AO(ind,n_AO)=size(intersect(out_fit.outliers,t_AO),1);
        percentage_AO(ind,n_AO)=size(intersect(out_fit.outliers,t_AO),1)/length(t_AO);
    
    end

end

% Table C.5 (left)
disp(vec_AO)
disp(mean(pval_levelshift<0.01,1))

% Figure C.18 (left panel)
figure;
x_bp=[]; y_bp=[];
for i=1:l_AO
    tmp = pos_levelshift(pval_levelshift(:,i)<0.01,i);
    x_bp = [x_bp ; i*ones(length(tmp),1)];
    y_bp = [y_bp ; tmp];
end
boxplot(y_bp,x_bp);
yline(40)
xticklabels(vec_AO(1:5)); xlabel('number of contaminating outliers'); ylabel('location of LS found')
title("Single contamination")
set(gca,'FontSize',14);


%% group of outliers contamination

vec_AO = [2 4 6 8];
l_AO = length(vec_AO);
a=10; b=15;   % range size AO

pval_levelshift=zeros(rep,l_AO);
pos_levelshift=zeros(rep,l_AO);
number_outliers=zeros(rep,l_AO);
number_AO=zeros(rep,l_AO);
percentage_AO=zeros(rep,l_AO);

for ind = 1:rep
    
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
        pos_levelshift(ind,n_AO)=out_fit.posLS;
        number_outliers(ind,n_AO)=size(out_fit.outliers,1);
        number_AO(ind,n_AO)=size(intersect(out_fit.outliers,t_AO),1);
        percentage_AO(ind,n_AO)=size(intersect(out_fit.outliers,t_AO),1)/length(t_AO);
    
    end
    
end

% Table C.5 (right)
disp(vec_AO)
disp(mean(pval_levelshift<0.01,1))

% Figure C.18 (left panel)
figure;
x_bp=[]; y_bp=[];
for i=1:l_AO
    tmp = pos_levelshift(pval_levelshift(:,i)<0.01,i);
    x_bp = [x_bp ; i*ones(length(tmp),1)];
    y_bp = [y_bp ; tmp];
end
boxplot(y_bp,x_bp);
yline(40)
xticklabels(vec_AO(1:4)); xlabel('number of contaminating outliers'); ylabel('location of LS found')
title("Group contamination")
set(gca,'FontSize',14);

