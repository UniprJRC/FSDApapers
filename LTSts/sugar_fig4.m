%% data load
data = load('/Users/tortifr/articles_and_conferences/2023_JRSS_C/data_plot_articolo_serie_storiche2022/p17049075/P_17049075_TQV_full');
y=cell2mat(data.P_17049075_T_full(:,2));
T = (data.P_17049075_T_full(:,1));
n=length(y);
dstr = (T{:});
dtime = datetime(dstr,'InputFormat','yyyyMM');

%% detection of multiple LS 
%% Left panel of figure 4  of the paper
out = LTStsLSmult(y,...
    'maxLS',4,'alphaLTS',0.01,...%'bdpLTS',bdpLTS,...
    'alphaLS',0.01,'thresLS',0.01,'plots',1,'msg',1);

%plot LS
LSpos = out.LSpos;
outX = out.outX;
gc=gca;
xlim([-2 length(dtime)+2]);
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
xticks([1 20 40 60 80 100 length(dtime)])
xticklabels({'01/2008','08/2009','04/2011','12/2012','08/2014','04/2016','01/2018'})

model.trend = 2;
model.lshift = 0;
model.seasonal=303;
model.X = outX(:,3:end);



%% variable selection, given the multiple LS 
%% Right panel of Figure 4 of the paper
for i=1:5
    disp(['----------------' ,num2str(i)])
[out_model_1, out_reduced_1] = LTStsVarSel(y,'model',model,'nsamp',10000,'plots',1);
end

%after selecting the top panel of the last 'Residual plots' Figure, run the
%following comments:
xlim([-2 length(dtime)+2])   
title('')
ylabel('trade quantity tons')
xticks([1 20 40 60 80 100 length(dtime)])
xticklabels({'01/2008','08/2009','04/2011','12/2012','08/2014','04/2016','01/2018'})
