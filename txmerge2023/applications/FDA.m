clc, clear, clf, close all
USER_PATH = 'YOUR_PATH';
rng(2021, 'twister');
titsize = 19;
fsize = 11;

X = csvread('FDAtemp.csv', 1);

%%

[n,p] = size(X);
figure
plot(X(:,1), X(:,2), '.b')

%%

k = round(log(n)*4);
g = 1;
alpha = 0.1;
txOpt.nocheck = 1;
txOpt.msg = 0;
txOpt.nomes = 1;
txOpt.plots = 1;

out1_tkm = txmerge(X, k, g, 'alpha', alpha, 'plots', 1, 'txOpt', txOpt, 'dist', 0, 'auto', 0);
xlabel("day",'FontSize',fsize)
ylabel("°C",'FontSize',fsize)
set(findall(gcf,'-property','FontSize'),'FontSize',fsize)
title(sprintf('tk-merge for k=%d, K=%d, %s=%.2f', k, g, '$\alpha$', alpha), 'Interpreter', 'Latex','fontsize',titsize)

tt = findall(gca,'-property','MarkerFaceColor');
cli = [1, 2];
clrdef=[0 0.4470 0.7410;
        1 0 0];
for i = 1:2
    set(tt(cli(i)),'Color', clrdef(i,:))
end

xlim([0 364])
ylim([-5 30])

titim = sprintf('%s/FDAtkmSol', USER_PATH);
saveas(gcf, titim,'epsc')


%%

X = [X, out1_tkm.mergID];
csvwrite('FDAtempTKM.csv', X);

%%
% raw station data (see tmFDA.R script)
XX = csvread('FDAtemp_raw.csv', 1);

id =  logical(XX(:,end));
XX = XX(:,1:end-1);

figure
hold on
iter1=0;
iter2=0;
msiz=2;
for i = linspace(73, 1, 73)
    
    if id(i)==1
        if iter1==0
            p1= plot(XX(i, :)', '-+r', 'DisplayName', 'Outlying curves', 'MarkerSize', msiz);
            iter1=1;
        else
            plot(XX(i, :)', '-+r', 'MarkerSize', msiz)
        end
    else
        if iter2==0
            p2=plot(XX(i, :)', 'LineStyle', '-', 'Color', [0 0.4470 0.7410], 'DisplayName', 'Clean curves');
            iter2=1;
        else
            plot(XX(i, :)', 'LineStyle', '-', 'Color', [0 0.4470 0.7410]);
        end
        
    end
end

plot(XX(~id, :)', 'Color', [0 0.4470 0.7410]);
plot(XX(id, :)', '-+r', 'MarkerSize', msiz);

box on

xlabel("day",'FontSize',fsize)
ylabel("°C",'FontSize',fsize)
set(findall(gcf,'-property','FontSize'),'FontSize',fsize)
title(sprintf('Average temperature from 1980 to 2009'), 'Interpreter', 'Latex','fontsize',titsize)

xlim([0 364])
ylim([-5 30])

legend([p1, p2], 'Location', 'southeast')

titim = sprintf('%s/FDAtkm', USER_PATH);
saveas(gcf, titim,'epsc')


