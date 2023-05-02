%% Generate the data
rng(10)
n=1000;
p=3;
kk=200;
X=randn(n,p);
beta=[ 1; 1; 1]*0.3;
sig=0.5; % value of sigma
eta=X*beta;

la=1;
init=6;
mdr=(init:n)';
lapos=1.5;
laneg=0;
% lamid=1;

y=eta+sig*randn(n,1);
y(1:kk)=y(1:kk)-1.9;
ypos=y>0;
ytra=y;
ytra(ypos)=normYJ(y(ypos),[],lapos,'inverse',true,'Jacobian',false);
ytra(~ypos)=normYJ(y(~ypos),[],laneg,'inverse',true,'Jacobian',false);

if any(isnan(ytra))
    disp('response with missing values')
end
r2=regstats(ytra,X,'linear',{'rsquare'});

%% Supplementary material
yXplot(ytra,X)
prin=0;
if prin==1
    % print to postscript
    print -depsc figsJD\SM1suppl.eps;
end
%% Create data for Figure SM1 (fanplot)
out=FSRfan(ytra,X,'la',[0.5 0.75 1 1.25 1.5],'family','YJ','plots',1,'init',init,'msg',0);

%% Create Figure SM1 (fanplot)
fanplot(out,'xlimx',[100 1000])
text(880, 19,'0.5','FontSize',12)
title('')

if prin==1
    % print to postscript
    print -depsc figsJD\SM1.eps;
end
%% Prepare data for Figure SM2
out=FSRfan(ytra,X,'la',1,'family','YJpn','plots',1,'init',init,'msg',0);
h1a=gca;
out125=FSRfan(ytra,X,'la',1.25,'family','YJpn','plots',1,'init',init,'msg',0,'tag','new');
h2a=gca;

%% Create Figure SM2
% move the figure above into a single one with two panels
xlim1=100;
xlim2=1030;

figure; %create new figure
fig1 = get(h1a,'children'); %get handle to all the children in the figure
s1 = subplot(2,1,1); %create and get handle to the subplot axes
copyobj(fig1,s1);
xlim([xlim1 xlim2])
box('on')

fig2 = get(h2a,'children'); %get handle to all the children in the figure
s2 = subplot(2,1,2); %create and get handle to the subplot axes
copyobj(fig2,s2);
xlim([xlim1 xlim2])
xlabel('Subset size m')
box('on')

if prin==1
    % print to postscript
    print -depsc figsJD\SM2.eps;
end

%% Prepare data for  Figure SM3
lapos=1.5;
laneg=0.25;
ytraP=ytra;
ypos=ytra>0;
ytraP(ypos)=normYJ(ytra(ypos),[],lapos,'inverse',false,'Jacobian',false);
ytraP(~ypos)=normYJ(ytra(~ypos),[],laneg,'inverse',false,'Jacobian',false);
out=FSRfan(ytraP,X,'la',1,'family','YJpn','plots',1,'init',init,'msg',0);
title(['lapos=' num2str(lapos) '    laneg='   num2str(laneg)])
h1a=gca;
fig1 = get(h1a,'children'); %get handle to all the children in the figure

lapos=1.5;
laneg=0;
ytraP=ytra;
ypos=ytra>0;
ytraP(ypos)=normYJ(ytra(ypos),[],lapos,'inverse',false,'Jacobian',false);
ytraP(~ypos)=normYJ(ytra(~ypos),[],laneg,'inverse',false,'Jacobian',false);
out=FSRfan(ytraP,X,'la',1,'family','YJpn','plots',1,'init',init,'msg',0,'tag','new');
title(['lapos=' num2str(lapos) '    laneg='   num2str(laneg)])
h2a=gca;
fig2 = get(h2a,'children'); %get handle to all the children in the figure

%% Create Figure SM3
% move the figure above into a single one with two panels
xlim1=100;
xlim2=1030;
ylim1=-4;
ylim2=16;
hall = figure; %create new figure
s1 = subplot(2,1,1); %create and get handle to the subplot axes
copyobj(fig1,s1);
xlim([xlim1 xlim2])
ylim([ylim1 ylim2])

ylim1=-4;
ylim2=21;

box('on')
title('$\lambda_P=1.5 \qquad \lambda_N=0.25$','Interpreter','Latex','FontSize',14) 
s2 = subplot(2,1,2); %create and get handle to the subplot axes
copyobj(fig2,s2);
xlim([xlim1 xlim2])
ylim([ylim1 ylim2])
xlabel('Subset size m')
box('on')
title('$\lambda_P=1.5 \qquad \lambda_N=0$','Interpreter','Latex','FontSize',14) 

if prin==1
    % print to postscript
    print -depsc figsJD\SM3.eps;
end

%% Prepare data for  Figure SM4
lapos=1.5;
laneg=0.25;
ytraP=ytra;
ypos=ytra>0;
ytraP(ypos)=normYJ(ytra(ypos),[],lapos,'inverse',false,'Jacobian',false);
ytraP(~ypos)=normYJ(ytra(~ypos),[],laneg,'inverse',false,'Jacobian',false);

outFSR=FSR(ytraP,X);

outLM=fitlm(X,ytraP,'Exclude',outFSR.ListOut);
%% Comparison with avas
y=ytra;
p=size(X,2);
% l=4 implies do not transform the X variables
l=4*ones(p,1);
out=avas(y,X,'l',l);
aceplot(out)
outLMavas=fitlm(X,out.ty);
if prin==1
    % print to postscript
    print -depsc figsJD\SM5.eps;
end


%% Comparison with ace
y=ytra;
p=size(X,2);
% l=4 implies do not transform the X variables
l=[4*ones(p,1);1];
out=ace(y,X,'l',l);
aceplot(out)
outLMace=fitlm(X,out.ty);

if prin==1
    % print to postscript
    print -depsc figsJD\SM6.eps;
end


