clear all
close all
%% data load
data = load('/Users/tortifr/articles_and_conferences/2023_JRSS_C/data_plot_articolo_serie_storiche2022/p_12119085_t_full_zero_added.txt');
y=data(:,2);
T = data(:,1);
n=length(y);
dstr = num2str(T);
dnum = datenum(T);
dtime = datetime(dstr,'InputFormat','yyyyMM');
% 
% figure;
% plot(dtime,y);
% datetick('x', 'yyyymm');

%% detection of multiple LS 
%%  all panels of Figure 6 of the paper
close all;
out = LTStsLSmult(y,...
    'maxLS',4,'alphaLTS',0.01,...%'bdpLTS',bdpLTS,...
    'alphaLS',0.01,'thresLS',0.01,'plots',1,'msg',1);
cascade
%% Left panel of figure 3  of the paper
% plot data
close all
figure;
plot(y,'-')
LSpos = out.LSpos;
outX = out.outX;
gc=gca;
ylimits = gc.YLim
xlimits = gc.XLim
%plot yhat
plot(out.yhat,'k-')
%plot LS
hold on
for i=1:length(LSpos)
line([LSpos(i) LSpos(i)],[ylimits(1) ylimits(2)],'color','k','linewidth',1,'linestyle','--')
end
%plot outliers
for i=1:length(out.outliers)
plot(out.outliers(i),y(out.outliers(i)),'rx')
end
xlabel('month');
ylabel('trade quantity tons')
xticklabels({'',char(dtime(20)),char(dtime(40)),char(dtime(60)),char(dtime(80)),char(dtime(100)),''})
xticklabels({'','12/2009','08/2011','04/2013','12/2014','08/2016',''})
%saveas(gcf,['D:\time_series\data_plot_articolo_serie_storiche2022\plot\plants_wedge3_v2.fig'],'fig');
%saveas(gcf,['D:\time_series\data_plot_articolo_serie_storiche2022\plot\plants_wedge3_v2.eps'],'epsc');

%% variable selection, given the multiple LS 
%% Right panel of Figure 3  of the paper
model.trend = 2;
model.lshift = 0;
model.seasonal=303;
model.X = outX(:,3:end);

[out_model_1, out_reduced_1] = LTStsVarSel(y,'model',model,'plots',1);%,'nsamp',10000);
trend_all(i)=out_model_1.trend;
seasonal_all(i)=out_model_1.seasonal;

