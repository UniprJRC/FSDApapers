
%% Figure 1 (top panel)
load clothes
Ntab=clothes;
N=table2array(Ntab);
[I,J]=size(N);
n=sum(sum(N));
r=sum(N,2)/n;
cprime=sum(N,1)/n;

ProfileRows=(N./sum(N,2));
d2=mahalCorAna(ProfileRows,cprime);

[RAW]=mcdCorAna(Ntab,'plots',1,'findEmpiricalEnvelope',true,...
    'conflev',1-0.01/size(N,1),'bdp',n);
plBIC=findobj('type','figure','Name','Residual plot');
figure(plBIC)
title('')
prin=0;
if prin==1
    % print to postscript
    print -depsc figs\MHD1.eps;
end



%% Figure1 (bottom panel) 
labelsr=Ntab.Properties.RowNames;

malindexplot(RAW.md.*r,RAW.EmpEnv.*r,'label',labelsr,'numlab',{12})
% findobj(gca,'line',{'Displayname'})
hh= findobj('Color','r');
legend(hh(1),'99.9643%')
title('')
if prin==1
    % print to postscript
    print -depsc figs\MHD1right.eps;
end

%% Figure 2:  CAtrad
out=CorAna(Ntab,'plots',0);

confellipse=struct;
confellipse.conflev=0.999;
confellipse.selCols=1:5;
confellipse.selRows='';
confellipse.method={'multinomial'}; %'bootRows' 'bootCols'};
CorAnaplot(out,'changedimsign',[false false],'confellipse',confellipse)
legend('off')
box('on')
title('')
if prin==1
    % print to postscript
    print -depsc figs\CAtrad.eps;
end

%% Raw and reweighted MCD
[RAW, REW]=mcdCorAna(Ntab,'plots',1,'findEmpiricalEnvelope',true,...
    'conflev',1-0.01/size(N,1));
title('')
%% Figure 3 top
rawmd=RAW.md.*r;
malindexplot(rawmd,RAW.EmpEnv.*r,'label',labelsr,'numlab',{8})

% findobj(gca,'line',{'Displayname'})
hh= findobj('Color','r');
legend(hh(1),'99.9643%')
title('')
if prin==1
    % print to postscript
    print -depsc figs\MHDR.eps;
end
%% Figure 3 bottom
rewmd=REW.md.*r;

malindexplot(rewmd,REW.EmpEnv.*r,'label',labelsr,'numlab',{7})
hh= findobj('Color','r');
legend(hh(1),'99.9643%')
title('')
if prin==1
    % print to postscript
    print -depsc figs\MHDRW.eps;
end


%% Figure 4 top: robust correspondence analysis (without ellipses)
selsup={'GB', 'SK' 'MT' 'GR' 'RO', 'LV', 'BG'};
selactive=setdiff(Ntab.Properties.RowNames,selsup);
Nsupr=Ntab(selsup,:);
Nactive=Ntab(selactive,:);
% Nsupc=tableN(1:14,6:8);
Sup=struct;
Sup.r=Nsupr;
% Sup.c=Nsupc;
out=CorAna(Nactive,'Sup',Sup);
CorAnaplot(out,'changedimsign',[true false])
box('on')
title('')
prin=0;
if prin==1
    print -depsc figs\robustCA.eps;
end
%% Figure 4 (bottom): robust correspondence analysis (without ellipses)
[~,indexesI]=intersect(Ntab.Properties.RowNames,selsup);
confellipse=struct;
confellipse.conflev=0.999;
confellipse.selCols=1:5;
confellipse.selRows='';

confellipse.method={'multinomial'}; %'bootRows' 'bootCols'};
plots=struct;
plots.FontSize=0.01;
CorAnaplot(out,'changedimsign',[true false],'confellipse',confellipse,...
    'plots',plots)
box('on')
title('')
prin=0;
if prin==1
    print -depsc figs\robustCA1.eps;
end

%% Figure 5: Scatter plot matrix of row profiles with outliers
selsup={'GB', 'SK' 'MT' 'GR' 'RO', 'LV', 'BG'};
group=ones(I,1);
label=Ntab.Properties.RowNames;
[~,indeOut]=intersect(label,selsup);
group(indeOut)=2;
ProfileRowsTable=array2table(ProfileRows,'RowNames',label,'VariableNames',Ntab.Properties.VariableNames);
[H,AX,BigAx]=spmplot(ProfileRowsTable,'group',group,'dispopt','box');
aa={'Normal units' 'Outliers'};
% findobj('legend','off')
add2spm(H,AX,BigAx,'userleg',aa)
if prin==1
    % print to postscript
    print -depsc figs\spmplot.eps;
end

%% Contribution of row points to inertia 1sr and 2nd dimension 
selsup={'GB', 'SK' 'MT' 'GR' 'RO', 'LV', 'BG'};

TB1=sortrows(out.OverviewRows,'CntrbPnt2In_1','descend');
x = categorical(TB1.Properties.RowNames,TB1.Properties.RowNames);
subplot(2,1,1)
bar(x,TB1{:,'CntrbPnt2In_1'},'b')
hold('on')
[~,indexes1]=intersect(TB1.Properties.RowNames,selsup);
bar(x(indexes1),TB1{indexes1,'CntrbPnt2In_1'},'r')
title('Contribution of rows to Dim-1')

subplot(2,1,2)
TB1=sortrows(out.OverviewRows,'CntrbPnt2In_2','descend');
x = categorical(TB1.Properties.RowNames,TB1.Properties.RowNames);
bar(x,TB1{:,'CntrbPnt2In_2'},'b')
title('Contribution of rows to Dim-2')
hold('on')
[~,indexes1]=intersect(TB1.Properties.RowNames,selsup);
bar(x(indexes1),TB1{indexes1,'CntrbPnt2In_2'},'r')


%% Contribution of column points to inertia 1st and 2nd dimensione 
% This figure is not given in the paper
TB1=sortrows(out.OverviewCols,'CntrbPnt2In_1','descend');
x = categorical(TB1.Properties.RowNames,TB1.Properties.RowNames);
subplot(2,1,1)
bar(x,TB1{:,'CntrbPnt2In_1'},'b')
title('Contribution of columns to Dim-1')

subplot(2,1,2)
TB1=sortrows(out.OverviewCols,'CntrbPnt2In_2','descend');
x = categorical(TB1.Properties.RowNames,TB1.Properties.RowNames);
bar(x,TB1{:,'CntrbPnt2In_2'},'b')
title('Contribution of columns to Dim-2')



%%

%%  With Rurithania (prepare input for Figure 1 supplementary material)

N1=[300 0 0 0 300];
% N1=array2table(N1,'VariableNames',Ntab.Properties.VariableNames);
    N1=array2table(N1,'VariableNames',Ntab.Properties.VariableNames,'RowNames',{'RR'});

Ntab1=[Ntab;N1];
out=CorAna(Ntab1);
%% ruri with confidence ellipses
confellipse=struct;
confellipse.conflev=0.999;
confellipse.selCols=1:5;
confellipse.selRows='';
confellipse.method={'multinomial'}; %  'bootRows' 'bootCols'};
CorAnaplot(out,'changedimsign',[false false],'confellipse',confellipse)
legend('off')
title('')
box('on')
title('')

prin=0;
if prin==1
    print -depsc figs\ruri.eps;
end


%% Car data robust analysis
% [RAW, REW]=mcdCorAna(Ntab,'plots',1,'findEmpiricalEnvelope',true,...
%     'conflev',1-0.01/size(N,1));
% title('')

%% Car data: Figure 6 (no confidence ellipses)
load car
out=CorAna(car);

CorAnaplot(out,'changedimsign',[false true])
title('')
box('on')

prin=0;
if prin==1
    print -depsc figs\cars1.eps;
end

%% Example cars (with confidence ellipses)
load car
out=CorAna(car);
Ntab=car;

confellipse=struct;
confellipse.conflev=0.999;
confellipse.selCols=1:7;
confellipse.selRows='';
confellipse.method={'multinomial'}; %  'bootRows' 'bootCols'};

CorAnaplot(out,'changedimsign',[false true],'confellipse',confellipse)
title('')
box('on')
legend('off')

prin=0;
if prin==1
    print -depsc figs\cars1WithCE.eps;
end



%% Robust  selsup without land rover (no confidence ellipses)
selsup={'Volvo' 'Toyota' 'Honda' 'Hyundai' 'Kia' 'Volkswagen' 'Smart'};
Nsupr=Ntab(selsup,:);
selactive=setdiff(Ntab.Properties.RowNames,selsup);
Nactive=Ntab(selactive,:);
Sup=struct;
Sup.r=Nsupr;
out=CorAna(Nactive,'Sup',Sup);
CorAnaplot(out,'changedimsign',[true true])
box('on')
title('')
box('on')

prin=0;
if prin==1
    print -depsc figs\cars2.eps;
end

%% Robust   selsup without land rover (with confidence ellipses)
selsup={'Volvo' 'Toyota' 'Honda' 'Hyundai' 'Kia' 'Volkswagen' 'Smart'};
Nsupr=car(selsup,:);
selactive=setdiff(car.Properties.RowNames,selsup);
Nactive=car(selactive,:);
Sup=struct;
Sup.r=Nsupr;
out=CorAna(Nactive,'Sup',Sup);
confellipse=struct;
confellipse.conflev=0.999;
confellipse.selCols=1:7;
confellipse.selRows='';
confellipse.method={'multinomial'}; %  'bootRows' 'bootCols'};

CorAnaplot(out,'changedimsign',[true true],'confellipse',confellipse)


box('on')
title('')
box('on')
legend('off')

prin=0;
if prin==1
    print -depsc figs\cars2WithCE.eps;
end


%% Robust selsup with land rover (no confidence ellipses)
selsup={'Volvo' 'Toyota' 'Honda' 'Hyundai' 'Kia' 'Volkswagen' 'Smart' 'Land Rover'};
Nsupr=car(selsup,:);
selactive=setdiff(car.Properties.RowNames,selsup);
Nactive=car(selactive,:);
% Nsupc=tableN(1:14,6:8);
Sup=struct;
Sup.r=Nsupr;
% Sup.c=Nsupc;
out=CorAna(Nactive,'Sup',Sup);
CorAnaplot(out,'changedimsign',[true false])
box('on')
title('')

prin=0;
if prin==1
    print -depsc figs\cars3.eps;
end


%% Robust selsup with land rover (with confidence ellipses)
selsup={'Volvo' 'Toyota' 'Honda' 'Hyundai' 'Kia' 'Volkswagen' 'Smart' 'Land Rover'};
Nsupr=car(selsup,:);
selactive=setdiff(car.Properties.RowNames,selsup);
Nactive=car(selactive,:);
% Nsupc=tableN(1:14,6:8);
Sup=struct;
Sup.r=Nsupr;
% Sup.c=Nsupc;
out=CorAna(Nactive,'Sup',Sup);
confellipse=struct;
confellipse.conflev=0.999;
confellipse.selCols=1:7;
confellipse.selRows='';
confellipse.method={'multinomial'}; %  'bootRows' 'bootCols'};

CorAnaplot(out,'changedimsign',[true false],'confellipse',confellipse)
box('on')
title('')
legend('off')

prin=0;
if prin==1
    print -depsc figs\cars3WithCE.eps;
end