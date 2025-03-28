%% Data reading
XX=load('BalanceSheets.txt');
% Define X and y
y=XX(:,6);
X=XX(:,1:5);

%% Produce original yXplot (Figure 11)
yXplot(y,X)
legend('off')
sgtitle('Figure 11')
prin=0;
if prin==1
    % print to postscript
    print -depsc figsBS\yXoriBS.eps;
end


%% Create upper panel of  Figure 12 (fan plot)
ylimy=20;
nini=1000;
la=[0.5 0.75 1 1.25];
out=FSRfan(y,X,'la',la,'family','YJ','plots',0,'init',round(nini/2),'ylimy',[-ylimy ylimy]);
fanplotFS(out)

%% Create lower panel for Figure 12 (pos and neg for 1)
lasel=1;
ylimy1=5;
outpn=FSRfan(y,X,'la',lasel,'family','YJpn','plots',1,'init',round(nini/2),'ylimy',[-ylimy1 ylimy1]);


%% Create figure 13
booneg=y<=0;
la=1.5;
yneg=normYJ(y(booneg),[],la,'inverse',false,'Jacobian',false);
la=0.5;
ypos=normYJ(y(~booneg),[],la,'inverse',false,'Jacobian',false);
ytra=y;
ytra(booneg)=yneg;
ytra(~booneg)=ypos;
outpn=FSRfan(ytra,X,'intercept',1,'plots',1,'family','YJpn','la',1);

if prin==1
    % print to postscript
    print -depsc figsBS\fanplottraBS.eps;
end



%% yXplot in the transformed space (Figure 14)

out=FSR(ytra,X);

if prin==1
    % print to postscript
    print -depsc figsBS\yXtraBS.eps;
end


%% Comparison of the two fits: create Table 3
mdl=fitlm(X,y);
StoreFandR2=[mdl.ModelFitVsNullModel.Fstat;  mdl.Rsquared.Ordinary];

outtra=FSR(ytra,X,'plots',0);
mdltra=fitlm(X,ytra,'Exclude',outtra.outliers);
StoreFandR2tra=[mdltra.ModelFitVsNullModel.Fstat;  mdltra.Rsquared.Ordinary];

laP=[1 0.5];
laN=[1 1.5];
nobs=[n n-length(outtra.outliers)];
mis=NaN(1,2);
tsta=[mdl.Coefficients{:,"tStat"} mdltra.Coefficients{:,"tStat"}];
FandR2=[StoreFandR2 StoreFandR2tra];
df=nobs-p;

namrow=["laP"; "laN"; "Number of observations"; "Error d.f. nu";
    "t_nu values"; "Intercept"; "x"+(1:5)'; "F5,nu for regression"; "R2adj"];
namcol=["All" "42 deleted"];

data=[laP; laN; nobs;df;mis; tsta; FandR2 ];
dataT=array2table(data,"RowNames",namrow,"VariableNames",namcol);
disp('Table 3')
disp(dataT)

%% Brushing  (FIGURE 14)
disp('THIS SECTION REQUIRES USER INTERACTION')
n=length(y);
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



%% Prepare input for Table 4
outFSR=FSR(ytra,X,'plots',0,'msg',0);
good=setdiff(1:length(y),outFSR.outliers);
ytragood=ytra(good);
Xgood=X(good,:);
ygood=y(good);

%% Original scale with and without outliers
outORI=fitlm(X,y);
R2ori=outORI.Rsquared.Ordinary;

outlm=fitlm(Xgood,ygood);
R2noout=outlm.Rsquared.Ordinary;

%% Transformed EYJ scale with and without outliers
outEYJ=fitlm(X,ytra);
R2eyj=outEYJ.Rsquared.Ordinary;

outEYJgood=fitlm(Xgood,ytragood);
R2eyjnoout=outEYJgood.Rsquared.Ordinary;

%% Comparison with ACE with and without outliers
l=[4*ones(p,1); 1];
outAC= ace(y,X,'l',l);
R2ACE=outAC.rsq;
outACnoout=ace(ygood,Xgood,'l',l);
R2ACnoout=outACnoout.rsq;


%%  Comparison with avas:  with and without outliers
p=size(X,2);
% l=4 implies do not transform the X variables
l=4*ones(p,1);
outAV=avas(y,X,'l',l);
R2AVAS=outAV.rsq;
outAVnoout=avas(ygood,Xgood,'l',l);
R2AVASnoout=outAVnoout.rsq;

%% Create Table 4
rownam=["Untransformed" "EYJ" "ACE" "AVAS"];

R2all=[R2ori R2noout;
    R2eyj R2eyjnoout;
    R2ACE R2ACnoout;
    R2AVAS R2AVASnoout];

R2t=array2table(R2all,"VariableNames",["Complete" "Outliers deleted"],"RowNames",rownam);
disp("Table 4")
disp(R2t)


