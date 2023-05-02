
%% Decide to save or not filgures to postscipt files
prin=0;

%% HOSPITAL fig 1 fanplot

load('hospitalFS.txt');
y=exp(hospitalFS(:,5));
X=hospitalFS(:,1:4);
n=length(y);
[outFSRfan]=FSRfan(y,X,'plots',1,'init',round(n*0.2),'nsamp',100000,'msg',0,'family','YJ');

fanplot(outFSRfan,'conflev',[0.99 0.9999])
title('')
xcoo=round(n*0.6);
rangeaxis=axis;
line(repmat(xcoo,2,1), rangeaxis(3:4)','LineWidth',1,'color','k');

if prin==1
    % print to postscript
    print -depsc figs\H1.eps
end

%% H2 BIC and AGI
close all
[out]=fanBIC(outFSRfan);
if prin==1
    % print to postscript
    print -depsc figs\H2.eps
end



%% LD (Loyalty cards data) BIC and AGI
close all
load('loyalty.txt');
y=loyalty(:,4); %#ok<SUSENS>
X=loyalty(:,1:3);
n=length(y);
[outFSRfan]=FSRfan(y,X,'plots',1,'init',round(n*0.3),'nsamp',10000,'la',[-1:0.1:1],'msg',0);
[out]=fanBIC(outFSRfan);
if prin==1
    % print to postscript
    print -depsc figs\L1.eps
end



%%  Investment funds data fanplot for trasformed data
YY=load('fondi_large.txt');
y=YY(:,2);
X=YY(:,[1 3]);
n=length(y);
y1=normYJ(y,[],0.75);
[outFSRfan]=FSRfan(y1,X,'plots',1,'init',round(n*0.2),'nsamp',10000,...
    'la',1,'msg',0,'family','YJpn','conflev',[0.99 0.9999]);
title('')

xcoo=round(n*0.6);
rangeaxis=axis;
line(repmat(xcoo,2,1), rangeaxis(3:4)','LineWidth',1,'color','k');

xlim([50 n+5])
if prin==1
    % print to postscript
    print -depsc figs\IF1.eps
end

%%  Investment funds data IF2 fanplot using transformed data using laP=1 and laN=0
y2=normYJpn(y,[],[1 0]);
[outFSRfan2]=FSRfan(y2,X,'plots',1,'init',round(n*0.2),'nsamp',10000,'la',1,'msg',0,'family','YJpn');
title('')
ylim([-5 5])
xlim([60 length(y)+2])
if prin==1
    % print to postscript
    print -depsc figs\IF2.eps
end

%% Investment funds data BIC and AGI
close all
n=length(y);
[outFSRfan]=FSRfan(y,X,'plots',0,'init',round(n*0.3),'family','YJ','nsamp',10000,'la',[-1:0.1:1],'msg',0);
[out]=fanBIC(outFSRfan);
if prin==1
    % print to postscript
    print -depsc figs\IF3.eps
end

%% Investment funds data heatmaps
labest=0.75;
[outFSRfanpn]=FSRfan(y,X,'msg',0,'family','YJpn','la',labest);
out1=fanBICpn(outFSRfanpn,'laRangeAndStep',[1.5 0.25 0.5]);

if prin==1
    % print to postscript
    print -depsc figs\IF4l.eps
    print -depsc figs\IF4r.eps
end

if prin==1
    % print to postscript
    print -depsc figs\IF5l.eps
    print -depsc figs\IF5r.eps
end


%% Balance sheets data  BIC and AGI
XX=load('BalanceSheets.txt');
% Define X and y
y=XX(:,6);
X=XX(:,1:5);

[outFSRfan]=FSRfan(y,X,'msg',0,'family','YJ','la',-1:0.25:1.5);
out1=fanBIC(outFSRfan);
if prin==1
    % print to postscript
    print -depsc figs\BS1.eps
end



%% BS2 and BS3
% Balance sheets data.
XX=load('BalanceSheets.txt');
% Define X and y
y=XX(:,6);
X=XX(:,1:5);
n=length(y);
la=[0 0.25 0.5 0.75 1 1.25];
[outFSRfan]=FSRfan(y,X,'plots',1,'init',round(n*0.3),'nsamp',5000,'la',la,'msg',0,'family','YJ');
[outini]=fanBIC(outFSRfan,'plots',0);
% labest is the best value imposing the constraint that positive and
% negative observations must have the same tramsformation parameter.
labest=outini.labest;
% Compute test for positive and test for negative using labest
indexlabest=find(labest==la);
% Find initial subset to initialize the search.
lms=outFSRfan.bs(:,indexlabest);
[outFSRfanpn]=FSRfan(y,X,'msg',0,'family','YJpn','la',labest,'plots',0,'lms',lms);
% Check if two different transformations are needed for positive and negative values
% Start monitoring the exceedances in the subset in agreement with a
% transformation from 90 per cent.
fraciniFSR=0.90;
% option plots (just show the BIC and the smoothness index plot).
nsamp=2000;
out=fanBICpn(outFSRfanpn,'fraciniFSR',fraciniFSR,'nsamp',nsamp);

if prin==1
    % print to postscript
    print -depsc figs\BS2l.eps
    print -depsc figs\BS2r.eps
    print -depsc figs\BS3l.eps
    print -depsc figs\BS3r.eps
end


