clc, clear, clf, close all
USER_PATH = 'YOUR_PATH';
rng(2021, 'twister');

titsize = 19;
fsize = 11;

dat = readtable('datos_ojo.csv', 'Delimiter', ';');

%%

ids = dat.Var1;
dat = [dat.V1, dat.V2];
dat = strrep(dat, ',', '.');
dat = str2double(dat);
dat = [ids, dat];

V1 = dat(:, 2);
V2 = dat(:, 3);

figure
plot(V1, V2, 'b.')

%%

close all

n = length(V1);
X = [V1, V2];


%% tk-merge with DEMP

% close all
% rng(100)
% 
% k = ceil(log(n))*2;
% g = 1;
% alpha = 0.15;

% txOpt.nocheck = 1;
% txOpt.msg = 0;
% txOpt.nomes = 1;
% txOpt.plots = 1;
% 
% txmerge(X, k, g, 'alpha', alpha, 'plots', 1, 'txOpt', txOpt, 'dist', 1, 'auto', 1);
% title(sprintf('tkD-merge for k=%d, K=%d, %s=%.2f', k, g, '$\alpha$', alpha), 'Interpreter', 'Latex','fontsize',titsize)

%% semi-automated tk-merge

close all
rng(100)

k = ceil(log(n))*2;
g = 1;
alpha = 0.15;
txOpt.nocheck = 1;
txOpt.msg = 0;
txOpt.nomes = 1;
txOpt.plots = 1;

txmerge(X, k, g, 'alpha', alpha, 'plots', 1, 'txOpt', txOpt, 'dist', 0, 'auto', 1);
% title('Merged components using tk-merge')
% title('Components using tk-merge')
xlabel("X1",'FontSize',fsize)
ylabel("X2",'FontSize',fsize)
set(findall(gcf,'-property','FontSize'),'FontSize',fsize)
title(sprintf('tk-merge for k=%d, K=%d, %s=%.2f', k, g, '$\alpha$', alpha), 'Interpreter', 'Latex','fontsize',titsize)

tt = findall(gca,'-property','MarkerFaceColor');
cli = [1, 2];
clrdef=[0 0.4470 0.7410;
        1 0 0];
for i = 1:2
    set(tt(cli(i)),'Color', clrdef(i,:))
end

titim = sprintf('%s/fig9_1_tkm_ret', USER_PATH);
saveas(gcf, titim,'epsc')



%% semi-automated TC-merge

rng(100)
close all

alpha = 0.25;
txOpt = [];
txOpt.nocheck = 1;
txOpt.msg = 0;
txOpt.plots = 1;
k = round(log(n));
r = 64;
txmerge(X, k, g, 'alpha', alpha, 'plots', 1, 'txOpt', txOpt, 'dist', 0, 'auto', 1, 'tkm', 0);
% title('Components using TC-merge')
% title('Merged components using TC-merge')

xlabel("X1",'FontSize',fsize)
ylabel("X2",'FontSize',fsize)
set(findall(gcf,'-property','FontSize'),'FontSize',fsize)
title(sprintf('TC-merge for k=%d, K=%d, r=%d, %s=%.2f', k, g, r, '$\alpha$', alpha), 'Interpreter', 'Latex','fontsize',titsize)

tt = findall(gca,'-property','MarkerFaceColor');
cli = [1, 2];
clrdef=[0 0.4470 0.7410;
        1 0 0];
for i = 1:2
    set(tt(cli(i)),'Color', clrdef(i,:))
end

titim = sprintf('%s/fig9_1_TC_ret', USER_PATH);
saveas(gcf, titim,'epsc')



%% tk-means

tkmeans(X, g, alpha, 'plots', 1, 'msg',0);

%% TCLUST

tclust(X, g, alpha, 1000,'plots', 1, 'msg',0, 'nocheck',1);
