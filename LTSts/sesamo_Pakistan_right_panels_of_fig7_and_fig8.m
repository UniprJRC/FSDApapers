%% data load
data = load('/Users/tortifr/articles_and_conferences/2023_JRSS_C/data_plot_articolo_serie_storiche2022/PK1207409000');
y=table2array(data.PK1207409000(:,2));
T = data.PK1207409000(:,1);
n=length(y);

%% detection of multiple LS 
%% Right panel of figure 7  of the paper
out = LTStsLSmult(y,...
    'maxLS',4,'alphaLTS',0.01,...%'bdpLTS',bdpLTS,...
    'alphaLS',0.01,'thresLS',0.01,'plots',1,'msg',1);
%click on the top panel of last Figure  and run the following
%lines
%plot LS
LSpos = out.LSpos;
outX = out.outX;
gc=gca;
xlim([-1 length(y)+1]);
ylimits = gc.YLim;
xlimits = gc.XLim;
hold on
for i=1:length(LSpos)
line([LSpos(i) LSpos(i)],[ylimits(1) ylimits(2)],'color','k','linewidth',1,'linestyle','--')
end
%plot outliers
hold on
for i=1:length(out.outliers)
    plot(out.outliers(i),y(out.outliers(i)),'rx')
end
xlabel('');
ylabel('Pakistan')
xticks([1 5 10 15 20 25 length(y)])
xticklabels({char(T.WEEK(1)),char(T.WEEK(5)),char(T.WEEK(10)),char(T.WEEK(15)),char(T.WEEK(20)),char(T.WEEK(25)),char(T.WEEK(end))})

%% variable selection, given the multiple LS 
%% Right panel of Figure 8 of the paper 
model.lshift = 0;
model.X = outX(:,3:end);
model.trend = 2;
model.seasonal=303;

for i=1:5
[out_model_1, out_reduced_1] = LTStsVarSel(y,'model',model,'plots',1,'nsamp',10000,'msg',1);
end
%plot outliers
%click on the top panel of Figure 'Residual plot' and run the following
%lines
hold on
for i=1:length(out.outliers)
    plot(out.outliers(i),y(out.outliers(i)),'rx')
end
xlim([-1 length(y)+1])          
%xlabel('month');
ylabel('Pakistan')
title('')
xticks([1 5 10 15 20 25 length(y)])
xticklabels({char(T.WEEK(1)),char(T.WEEK(5)),char(T.WEEK(10)),char(T.WEEK(15)),char(T.WEEK(20)),char(T.WEEK(25)),char(T.WEEK(end))})
