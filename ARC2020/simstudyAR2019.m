%% Create Figures 2 and 3
% Create figures which compare empirical and theoretical forward envelopes
% for score test, positive score and negative score test.
%

%% Simulate under the null
close all
ylimy=20;
lapos=1;
laneg=1;
lamid=1;

rng(10)
n=200;
p=3;
X=randn(n,p);
beta=[ 1; 1; 1];
sig=0.5; % simstudyR2big
% sig=5;  % simstudyR2small
eta=X*beta;

nsimul=1000; % In the paper nsimul =10000
init=6;

ScorepALL=zeros(n-init+1,nsimul);
ScorenALL=ScorepALL;
ScoreALL=ScorepALL;
R2all=zeros(nsimul,1);
mdr=(init:n)';
for j=1:nsimul
    y=eta+sig*randn(n,1);
    ypos=y>0;
    ytra=y;
    ytra(ypos)=normYJ(y(ypos),[],lapos,'inverse',true);
    ytra(~ypos)=normYJ(y(~ypos),[],laneg,'inverse',true);

    if any(isnan(ytra))
        disp('response with missing values')
    end
    r2=regstats(ytra,X,'linear',{'rsquare'});
    R2all(j)=r2.rsquare;

    out=FSRfan(ytra,X,'la',lamid,'family','YJpn','plots',0,'init',init,'msg',0);
    ScorepALL(:,j)=out.Scorep(:,end);
    ScorenALL(:,j)=out.Scoren(:,end);
    ScoreALL(:,j)=out.Score(:,end);

    if j==nsimul/2 || j==nsimul/4  || j==nsimul*0.75 || j==nsimul*0.9
        disp(['Simul nr. ' num2str(j) ' n=' num2str(n)]);
    end

end

% Sort rows of matrix mdrStore
mdrStore=sort(ScoreALL,2);
mdrStorep=sort(ScorepALL,2);
mdrStoren=sort(ScorenALL,2);


figure;
lwd=1.5;
hold('on');
quant=[0.005 0.25 0.5 0.75 0.995];

sel=round(nsimul*quant);
% Plot lines of empirical quantiles
line(mdr(:,1),mdrStore(:,sel),'LineStyle','--','Color','b','LineWidth',lwd,'DisplayName','Score');
line(mdr(:,1),mdrStorep(:,sel),'LineStyle','-','Color','g','LineWidth',lwd,'DisplayName','Scorep');
line(mdr(:,1),mdrStoren(:,sel),'LineStyle',':','Color','k','LineWidth',lwd);
xlabel('Subset size m');
ylabel('Theoretical and empirical envelopes of Student''s t')
lwdenv=0.1;

theo=tinv(repmat(quant,n-init+1,1),repmat(mdr(:,1)-p-2,1,length(quant)));
line(mdr(:,1),theo,'color','r','LineWidth',lwdenv)
ylim([-6 6])
% legend({'Score' 'Scorep' 'Scoren'})

if prin==1
    % print to postscript
    print -depsc figs\simunderH0.eps;
end

%% Simulate under H1
close all

lapos=1.5;
laneg=0;
lamid=1;

nsimul=1000; % In the paper nsimul =10000
init=6;

ScorepALL=zeros(n-init+1,nsimul);
ScorenALL=ScorepALL;
ScoreALL=ScorepALL;
R2all=zeros(nsimul,1);
mdr=(init:n)';

for j=1:nsimul
    y=eta+sig*randn(n,1);
    ypos=y>0;
    ytra=y;
    ytra(ypos)=normYJ(y(ypos),[],lapos,'inverse',true);
    ytra(~ypos)=normYJ(y(~ypos),[],laneg,'inverse',true);

    if any(isnan(ytra))
        disp('response with missing values')
    end
    r2=regstats(ytra,X,'linear',{'rsquare'});
    R2all(j)=r2.rsquare;

    out=FSRfan(ytra,X,'la',lamid,'family','YJpn','plots',0,'init',init,'msg',0);
    ScorepALL(:,j)=out.Scorep(:,end);
    ScorenALL(:,j)=out.Scoren(:,end);
    ScoreALL(:,j)=out.Score(:,end);

    if j==nsimul/2 || j==nsimul/4  || j==nsimul*0.75 || j==nsimul*0.9
        disp(['Simul nr. ' num2str(j) ' n=' num2str(n)]);
    end

end

mdrStore=sort(ScoreALL,2);
mdrStorep=sort(ScorepALL,2);
mdrStoren=sort(ScorenALL,2);

figure;
lwd=1.5;
hold('on');
quant=[0.25 0.5 0.75];
sel=round(nsimul*quant);
% Plot lines of empirical quantiles
line(mdr(:,1),mdrStore(:,sel),'LineStyle','--','Color','b','LineWidth',lwd,'DisplayName','Score');
line(mdr(:,1),mdrStorep(:,sel),'LineStyle','-','Color','g','LineWidth',lwd,'DisplayName','Scorep');
line(mdr(:,1),mdrStoren(:,sel),'LineStyle',':','Color','k','LineWidth',lwd);
xlabel('Subset size m');
ylabel('Theoretical and empirical envelopes of Student''s t')

lwdenv=0.1;

theo=tinv(repmat(quant,n-init+1,1),repmat(mdr(:,1)-p-2,1,length(quant)));
line(mdr(:,1),theo,'color','r','LineWidth',lwdenv)
ylim([-8.5 1.2])
% legend({'Score' 'Scorep' 'Scoren'})

if prin==1
    % print to postscript
    print -depsc figs\simunderH1.eps;
end

