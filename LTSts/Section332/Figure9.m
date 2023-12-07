%%%% Figure 9 of Section 3.3.2

model=struct;
model.trend=1;
model.s=54;
model.seasonal=101;

lshiftloc = struct;
lshiftloc.wlength = 5;

% Belarus 
BY = readtable("data_sanctions_BY.csv");

pos_TLS = find(ischange(BY.Y,'mean','MaxNumChanges',1));
model.lshift = max((pos_TLS-5),10):min((pos_TLS+5),size(BY,1)-10);

rng(1)
outBY=LTSts(BY.Y,'model',model,'conflev',1-0.01/size(BY,1),'plots',0,'lshiftlocref',lshiftloc,'SmallSampleCor',1,'msg',0,'h',round(size(BY,1)*0.8),'nsamp',1000);

figure
plot(BY.WEEK,BY.Y,'b','LineWidth',1)
hold on
plot(BY.WEEK,outBY.yhat,'k','LineWidth',1)
xline(BY.WEEK(outBY.posLS),'--k','LineWidth',1)
plot(BY.WEEK(outBY.outliers),BY.Y(outBY.outliers),'rx','LineWidth',1)
ylabel('Belarus', 'FontSize', 15)
xtickangle(30)

% Kazakhstan 
KZ = readtable("data_sanctions_KZ.csv");

pos_TLS = find(ischange(KZ.Y,'mean','MaxNumChanges',1));
model.lshift = max((pos_TLS-5),10):min((pos_TLS+5),size(KZ,1)-10);

rng(1)
outKZ=LTSts(KZ.Y,'model',model,'conflev',1-0.01/size(KZ,1),'plots',0,'lshiftlocref',lshiftloc,'SmallSampleCor',1,'msg',0,'h',round(size(KZ,1)*0.8),'nsamp',1000);

figure
plot(KZ.WEEK,KZ.Y,'b','LineWidth',1)
hold on
plot(KZ.WEEK,outKZ.yhat,'k','LineWidth',1)
xline(KZ.WEEK(outKZ.posLS),'--k','LineWidth',1)
plot(KZ.WEEK(outKZ.outliers),KZ.Y(outKZ.outliers),'rx','LineWidth',1)
ylabel('Kazakhstan', 'FontSize', 15)
xtickangle(30)

% cross-correlation between the estimated fitted values
dd = xcorr(zscore(outBY.yhat),zscore(outKZ.yhat),10,'normalized');
max(abs(dd))

