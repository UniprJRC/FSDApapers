%%%% Figure 2 of Section 3.1

load TTsalmon.mat

foreMonths = 12;
numObs = length(salmon.yP)-foreMonths;
y=salmon.yP(1:numObs);

overmodel=struct;
overmodel.trend=3;              % cubic trend
overmodel.s=12;                 % monthly time series
overmodel.seasonal=303;         % number of harmonics
overmodel.lshift=-1;            % positions of level shift which have to be considered
overmodel.ARp= 1:3;

[reduceout,outFITchk]=LTStsVarSel(y,'model',overmodel,'firstTestLS', 1,'plots',0,'nsamp',1000,'thPval',0.05);

startdate=[2010 1];
outFORE=forecastTS(outFITchk,'model',reduceout,'nfore',foreMonths, 'StartDate', startdate,'plots',1);
hold on
plot(outFORE.datesnumeric(numObs+1:end), salmon.yP(numObs+1:end))
ylim([16 32])

% Contamination
y(end)=23;

[reduceout,outFITchk]=LTStsVarSel(y,'model',overmodel,'firstTestLS', 1,'plots',0,'nsamp',1000,'thPval',0.05);

startdate=[2010 1];
outFORE=forecastTS(outFITchk,'model',reduceout,'nfore',foreMonths, 'StartDate', startdate,'plots',1);
hold on
plot(outFORE.datesnumeric(numObs+1:end), salmon.yP(numObs+1:end))
ylim([16 32])
