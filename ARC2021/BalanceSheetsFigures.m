%% Data reading
XX=load('BalanceSheets.txt');
% Define X and y
yori=XX(:,6);
X=XX(:,1:5);

%% Create transformed data
booneg=yori<=0;
la=1.5;
yneg=normYJ(yori(booneg),[],la,'inverse',false,'Jacobian',false);
la=0.5;
ypos=normYJ(yori(~booneg),[],la,'inverse',false,'Jacobian',false);
ytra=yori;
ytra(booneg)=yneg;
ytra(~booneg)=ypos;
outpn=FSRfan(ytra,X,'intercept',1,'plots',0,'family','YJpn','la',1);

%% Brushing linked plots

n=length(yori);
[out]=LXS(ytra,X);
[out]=FSReda(ytra,X,out.bs);
% Plot minimum deletion residual
mdrplot(out,'xlimx',[1000 n+1],'ylimy',[1.7 5]);
% Now, some interactive brushing starting from the monitoring residuals
% plot. Once a set of trajectories is highlighted in the monitoring residual plot, 
% the corresponding units are highlighted in the other plots
databrush=struct;
databrush.bivarfit='i1'; 
databrush.selectionmode='Rect'; % Rectangular selection
% databrush.persist='off'; % Enable repeated mouse selections
databrush.Label='on'; % Write labels of trajectories while selecting
databrush.RemoveLabels='on'; % Do not remove labels after selection
databrush.RemoveTool='off'; %remove yellow

cascade;
fground=struct;
fground.fthresh=100;
standard=struct;
standard.xlim=[800 n+1];
resfwdplot(out,'databrush',databrush,'fground',fground,'standard',standard,'datatooltip','');


%% Figure BS1 comparison with avas 
prin=0;
y=yori;
p=size(X,2);
% l=4 implies do not transform the X variables
l=4*ones(p,1);
out=avas(y,X,'l',l);
aceplot(out)

if prin==1
    % print to postscript
    print -depsc figsJD\BS1.eps;
end

%% Figure BS2 comparison with ACE
 l=[4*ones(p,1); 1];
outAC= ace(y,X,'l',l);
aceplot(outAC)
if prin==1
    % print to postscript
    print -depsc figsJD\BS2.eps;
end

%% Figure BS3 residuals vs fitted (cleaned data)
booneg=yori<=0;
la=1.5;
yneg=normYJ(yori(booneg),[],la,'inverse',false,'Jacobian',false);
la=0.5;
ypos=normYJ(yori(~booneg),[],la,'inverse',false,'Jacobian',false);
ytra=yori;
ytra(booneg)=yneg;
ytra(~booneg)=ypos;

outFSR=FSR(ytra,X,'plots',0);
 good=setdiff(1:length(yori),outFSR.outliers);
 ytragood=ytra(good);
 Xgood=X(good,:);

outlm=fitlm(Xgood,ytragood);

plot(outlm.Fitted,outlm.Residuals{:,1})

b=outlm.Coefficients{:,1};
fitted=[ones(length(yori),1) X]*b;
resall=(ytra-fitted)/outlm.RMSE;
close all
hold('on')
plot(fitted,resall,'o')
plot(fitted(outFSR.outliers),resall(outFSR.outliers),'o','Marker','o','MarkerFaceColor','k')
ylabel('Residuals')
xlabel('Fitted values')
title('')
if prin==1
    % print to postscript
    print -depsc figsJD\BS3.eps;
end
%% Plot (comparison with avas left panel)
y=yori;
p=size(X,2);
 l=[4*ones(p,1); 1];
outAV= avas(y,X,'l',l);

close all
subplot(2,2,1)
hold('on')
ytrast=zscore(ytra,1);
plot(y,ytrast,'x')
plot(y,outAV.ty,'o')


plot(y(outFSR.outliers),outAV.ty(outFSR.outliers),'o','Marker','o','MarkerFaceColor','k')
legend({'ExtendedYJ' 'AVAS'},'Location','Best')
xlabel('y')
ylabel('Transformed y')


% Plot (comparison with ACE right panel)
y=yori;
p=size(X,2);
 l=[4*ones(p,1); 1];
outAC= ace(y,X,'l',l);

subplot(2,2,2)
hold('on')
ytrast=zscore(ytra,1);
plot(y,ytrast,'x')
plot(y,outAC.ty,'o')


plot(y(outFSR.outliers),outAC.ty(outFSR.outliers),'o','Marker','o','MarkerFaceColor','k')
legend({'ExtendedYJ' 'ACE'},'Location','Best')
xlabel('y')
ylabel('Transformed y')

if prin==1
    % print to postscript
    print -depsc figsJD\BS4.eps;
end
