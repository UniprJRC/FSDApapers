%% Analyze poison data
% Read original matrix
clearvars;close all;
load('poison.txt');
y=poison(:,end);
X=poison(:,2:6);
p=size(X,2);
prin=0;

%% Fan plot (original data)
[out]=FSRfan(y,X,'plots',0,'la',[-2 -1.5 -1 -0.5 0 0.5],'ylimy',[-10 10],'nsamp',3000,'init',10);
fanplot(out,'ylimy',[-10 9])
title('')

if prin==1
    % print to postscript
    print -depsc figsJD\P1.eps;
end

%% Data contamination
ycont=y;
ycont(6)=0.14;
ycont(9)=0.08;
ycont(10)=0.07;
ycont(11)=0.06;


%% AVAS  original data (P2)
l=5*ones(p,1);
outAV= avas(y,X,'l',l);
aceplot(outAV)
if prin==1
    % print to postscript
    print -depsc figsJD\P2.eps;
end

%% ACE original data (P3)
l=[5*ones(p,1); 1];
outAV= ace(y,X,'l',l);
aceplot(outAV)
if prin==1
    % print to postscript
    print -depsc figsJD\P3.eps;
end


%% Fan plot
[out]=FSRfan(ycont,X,'plots',0,'la',[-1 -0.5 0 0.5 1],'ylimy',[-10 10],'nsamp',3000,'init',10);
fanplot(out,'ylimy',[-10 10])
text(43.4,9,'-1','FontSize',12)
title('')
if prin==1
    % print to postscript
    print -depsc figsJD\P4.eps;
end


%% AVAS contaminated data (P5)
l=5*ones(p,1);
outAVcont= avas(ycont,X,'l',l);
aceplot(outAVcont)
if prin==1
    % print to postscript
    print -depsc figsJD\P5.eps;
end

%% ACE contaminated data (P6)
l=[5*ones(p,1); 1];
outAC= ace(y,X,'l',l);

outACcont= ace(ycont,X,'l',l);
aceplot(outACcont)
if prin==1
    % print to postscript
    print -depsc figsJD\P6.eps;
end

%% Figure 5 3 panels 
% LP (our transformation correct and wrong)
% Comparison correct and wrong transformation
close all
subplot(2,3,1)
hold('on')
ytra=normBoxCox(ycont,1,-1,'Jacobian',false);
plot(ycont,ytra,'bx')
ytra025=normBoxCox(ycont,1,0.25,'Jacobian',false);
plot(ycont,ytra025,'o','MarkerEdgeColor','r')
outl=[6 9 10 11];
plot(ycont(outl),ytra025(outl),'o','Marker','o','MarkerFaceColor','r')
ylabel('Transformed y')
legend({'la=-1', 'la=0.25' 'Outliers'},'Location','best')
xlabel('y')

% AVAS (central panel)
subplot(2,3,2)
hold('on')
plot(y,outAV.ty,'bx')
plot(ycont,outAVcont.ty,'o','Marker','o','MarkerEdgeColor','r')
xlabel('y')

ytra033=normBoxCox(ycont,1,0.33,'Jacobian',false);
[ycontsor,ycontsorind]=sort(ycont);
ysor=zscore(ytra033(ycontsorind),1);
plot(ycontsor,ysor,'-','Color','k','LineWidth',2)
plot(ycont(outl),outAVcont.ty(outl),'o','Marker','o','MarkerFaceColor','r')
legend({'Orig. data' 'Cont. data'  '\lambda=1/3' 'Outliers'},'Location','best')

% ACE (right panel)
subplot(2,3,3)
hold('on')
plot(y,outAC.ty,'bx')
plot(ycont,outACcont.ty,'o','Marker','o','MarkerEdgeColor','r')
plot(ycont(outl),outACcont.ty(outl),'o','Marker','o','MarkerFaceColor','r')
legend({'Orig. data' 'Cont. data' 'Outliers'},'Location','best')
xlabel('y')
if prin==1
    % print to postscript
    print -depsc figsJD\P6.eps;
end


% %% ACE
% l=[5*ones(p,1); 1];
% outAV= ace(y,X,'l',l);
% 
% l=[5*ones(p,1); 1];
% outAVcont= ace(ycont,X,'l',l);
% hold('on')
% plot(y,outAV.ty,'o')
% plot(ycont,outAVcont.ty,'x')
% legend({'Original data' 'Contaminated data'})
% 
% %% AVAS
% l=[5*ones(p,1); 1];
% outAV= avas(y,X,'l',l);
% 
% l=[5*ones(p,1); 1];
% outAVcont= avas(ycont,X,'l',l);
% hold('on')
% plot(y,outAV.ty,'o')
% plot(ycont,outAVcont.ty,'x')
% legend({'Original data' 'Contaminated data'})
% 
% 
% 
% %% ace
% p=size(X,2);
% 
% l=[5*ones(p,1); 1];
% outAV= avas(y,X,'l',l);
% % out= ace(y,X,'l',l);
% aceplot(outAVcont)
% 
% ytra=normBoxCox(ycont,1,-1,'Jacobian',false);
% plot(y,ytra,'o');
% xlabel('y')
% ylabel('y transformed with la=-1')
% 
% 
% 
% 
% %% Data analysis
% la=[ 0 0.5 1 1.5];
% ylimy=8;
% out=FSRfan(outAVcont.ty,X,'la',la,'family','YJ','plots',1,'init',round(n/2),'ylimy',[-ylimy ylimy]);
% ylimy=10;
% la=[ 1 1.5];
% % la=0.75;
% % la=0.8;
% %
% la=1;
% la=1.25;
% out=FSRfan(y,X,'la',la,'family','YJpn','plots',1,'init',round(n/2));
% outlier=[57 36 38 18 60 17];
% bsb=setdiff(1:length(y),outlier);
% y=y(bsb);
% X=X(bsb,:);
% 
% databrush=struct;
% databrush.selectionmode='Brush'; % Lasso selection
% databrush.persist='on'; % Enable repeated mouse selections
% 
% fanplot(out,'databrush',{'selectionmode' 'Brush' 'persist' 'on'});



