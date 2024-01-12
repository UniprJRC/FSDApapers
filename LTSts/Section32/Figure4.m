%% data load
load TTsugar

y=TTsugar.yQ;
T=TTsugar.Time;

n=length(y);

%% detection of multiple LS
%% Left panel of figure 4 of the paper
out = LTStsLSmult(y,...
    'maxLS',4,'alphaLTS',0.01,...%'bdpLTS',bdpLTS,...
    'alphaLS',0.01,'thresLS',0.01,'plots',1,'msg',1);

%after selecting the top panel of the last 'Residual plots' Figure, run the
%following comments:

%plot LS
LSpos = out.LSpos;
gc=gca;
xlim([-2 length(T)+2]);
ylimits = gc.YLim;
xlimits = gc.XLim;
hold on
for i=1:length(LSpos)
    line([LSpos(i) LSpos(i)],[ylimits(1) ylimits(2)],'color','k','linewidth',1,'linestyle','--')
end


%plot outliers
for i=1:length(out.outliers)
    plot(out.outliers(i),y(out.outliers(i)),'rx')
end
xlabel('');
ylabel('trade quantity tons')
xticks([1 20 40 60 80 100 length(T)])
xticklabels({'01/2008','08/2009','04/2011','12/2012','08/2014','04/2016','01/2018'})

%% variable selection, given the multiple LS
%% Right panel of Figure 4 of the paper

model.trend = 2;
model.lshift = 0;
model.seasonal=303;
model.X = out.outX(:,3:end);

for i=1:5
    disp(['----------------' ,num2str(i)])
    [out_model_1, out_reduced_1] = LTStsVarSel(y,'model',model,'nsamp',10000,'plots',1);
end

%after selecting the top panel of the last 'Residual plots' Figure, run the
%following comments:
xlim([-2 length(T)+2])
title('')
ylabel('trade quantity tons')
xticks([1 20 40 60 80 100 length(T)])
xticklabels({'01/2008','08/2009','04/2011','12/2012','08/2014','04/2016','01/2018'})
