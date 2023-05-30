clc, clear, clf, close all
rng(2021, 'twister');

titsize = 19;
fsize = 11;

dat = readtable('taxigps.csv');
dat.Properties.VariableNames = {'ID', 'Time', 'Latitude', 'Longitude', 'Occupancy', 'Speed'};


%% data

length(unique(dat.ID));
id = 1:length(dat.Latitude);
lat = dat.Latitude(id);
lon = dat.Longitude(id);

figure
plot(lat,lon, 'b.')

X = [lat(1:end-1), lon(1:end-1)];
n = size(X, 1);

%% tk-merge

k = round(log(n)*2);
g = 1;
alpha = 0.3;
txOpt.nocheck = 1;
txOpt.msg = 0;
txOpt.nomes = 1;
txOpt.plots = 1;

% semi-automated procedure
% out1_tkm = txmerge(X, k, g, 'alpha', alpha, 'plots', 1, 'txOpt', txOpt, 'dist', 0, 'auto', 1);
out2_tkm = txmerge(X, k, 8, 'alpha', alpha, 'plots', 1, 'txOpt', txOpt, 'dist', 0, 'auto', 0);
xlabel("Latitude",'FontSize',fsize)
ylabel("Longitude",'FontSize',fsize)
set(findall(gcf,'-property','FontSize'),'FontSize',fsize)
title(sprintf('tk-merge for k=%d, K=%d, %s=%.2f', k, g, '$\alpha$', alpha), 'Interpreter', 'Latex','fontsize',titsize)

% title('tk-merge, structural contamination','fontsize',titsize);

tt = findall(gca,'-property','MarkerFaceColor');
cli = [1, 2];
clrdef=[0 0.4470 0.7410;
        1 0 0];
for i = 1:2
    set(tt(cli(i)),'Color', clrdef(i,:))
end
% for i = 1:6
%     set(tt(i),'Color', [0 0 0])
% end

titim = sprintf('fig8_1_tkmerge_gps');
saveas(gcf, titim,'epsc')


%% TC-merge

% txOpt = [];
% txOpt.nocheck = 1;
% txOpt.msg = 0;
% txOpt.plots = 1;
% out1_tkm = dempk(X, k, g, 'alpha', alpha, 'plots', 1, 'txOpt', txOpt, 'dist', 0, 'tkm', 0);

%% tk-means

outtk = tkmeans(X, g, alpha, 'plots', 'ellipse', 'msg',0);
xlabel("Latitude",'FontSize',fsize)
ylabel("Longitude",'FontSize',fsize)
set(findall(gcf,'-property','FontSize'),'FontSize',fsize)
title(sprintf('tk-means for K=%d, %s=%.2f', g, '$\alpha$', alpha), 'Interpreter', 'Latex','fontsize',titsize)

tt = findall(gca,'-property','MarkerFaceColor');
tt2 = findall(gca,'-property','Marker');
cli = [4, 5];
clrdef=[0 0.4470 0.7410;
        1 0 0];
mrk = '.+';
for i = 1:2
    set(tt(cli(i)),'Color', clrdef(i,:))
    set(tt2(cli(i)),'Marker', mrk(i))
    if i==2
        set(tt2(cli(i)),'MarkerSize', 3)
    end
end

for i = 1:3
    set(tt(i),'Color', [0 0 0])
end

titim = sprintf('fig8_1_tkmeans_gps');
saveas(gcf, titim,'epsc')

%% TCLUST

r = 1000;
outTC = tclust(X, g, alpha, r,'plots', 'ellipse', 'msg',0, 'nocheck',1);
xlabel("Latitude",'FontSize',fsize)
ylabel("Longitude",'FontSize',fsize)
set(findall(gcf,'-property','FontSize'),'FontSize',fsize)
title(sprintf('TCLUST for K=%d, r=%d, %s=%.2f', g, r, '$\alpha$', alpha), 'Interpreter', 'Latex','fontsize',titsize)

tt = findall(gca,'-property','MarkerFaceColor');
tt2 = findall(gca,'-property','Marker');
cli = [4, 5];
clrdef=[0 0.4470 0.7410;
        1 0 0];
mrk = '.+';
for i = 1:2
    set(tt(cli(i)),'Color', clrdef(i,:))
    set(tt2(cli(i)),'Marker', mrk(i))
    if i==2
        set(tt2(cli(i)),'MarkerSize', 3)
    end
end

for i = 1:3
    set(tt(i),'Color', [0 0 0])
end

titim = sprintf('fig8_1_tclust_gps');
saveas(gcf, titim,'epsc')
