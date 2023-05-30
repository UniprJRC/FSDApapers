clc, clear, clf, close all
USER_PATH = 'YOUR_PATH';
rng(2021, 'twister');

titsize = 19;
fsize = 11;

% cluster_shape = 1 -->  'circular';
% cluster_shape = 2 -->  'elliptical';
cluster_shape = 2;

% number of clusters
g= 2;

ncont = 100; 
nclu1 = 800; 
nclu2 = 800; 

n = (ncont+nclu1+nclu2);
alpha = ncont/n+0.005;

% sinusoidal noise (amplitude*sin(frequency*time+phase)+bias)
l = -2 * pi;
v = -l + (2*l)*rand(ncont,1);
noise1 = [80 + 0.5*randn(ncont,1) + 10*sin(2*v) , (80 + 5*v)];

% pointmass contamination
noise2 = [80 90]+0.1*randn(ncont,2);

% clusters 
mu1 = [10 100]; mu2 = [30 80];
if cluster_shape == 1
    %spherical
    Sigma1 = [1 0 ; 0 1];     
    Sigma2 = [1 0; 0 1]; 
else
    %with covariance structure
    Sigma1 = [1 1.5; 1.5 3];  
    Sigma2 = [10 -3; -3 8]; 
end
clu1 = mvnrnd(mu1,3*Sigma1,nclu1);
clu2 = mvnrnd(mu2,4*Sigma2,nclu2);

% final contaminated datasets 
X1 = [clu1 ; clu2 ; noise1];
X2 = [clu1 ; clu2 ; noise2];

gscatter(X1(:,1), X1(:,2));
title('dataset','fontsize',20);
axis equal

%%

out1_kmeans  = tkmeans(X1,g,0,'plots','ellipse');
xlabel('X1')
ylabel('X2')
set(findall(gcf,'-property','FontSize'),'FontSize',fsize)
title('k-means, structural contamination','fontsize',titsize);
set(findall(gcf,'-property','location'),'location','southwest');
tt = findall(gca,'-property','MarkerFaceColor');
cli = [7, 8];
clrdef=[0.4660 0.6740 0.1880;
    0 0.4470 0.7410;
    0.9290 0.6940 0.1250];
for i = 1:2
    set(tt(cli(i)),'Color', clrdef(i,:))
end
for i = 1:6
    set(tt(i),'Color', [0 0 0])
end

titim = sprintf('%s/fig1_s1', USER_PATH);
saveas(gcf, titim,'epsc')


%%
out2_kmeans  = tkmeans(X2,g,0,'plots','ellipse');
xlabel('X1')
ylabel('X2')
set(findall(gcf,'-property','FontSize'),'FontSize',fsize)
title('k-means, pointmass contamination','fontsize',titsize);
tt = findall(gca,'-property','MarkerFaceColor');
cli = [7, 8];
clrdef=[0.4660 0.6740 0.1880;
    0 0.4470 0.7410;
    0.9290 0.6940 0.1250];
for i = 1:2
    set(tt(cli(i)),'Color', clrdef(i,:))
end
for i = 1:6
    set(tt(i),'Color', [0 0 0])
end

titim = sprintf('%s/fig1_p1', USER_PATH);
saveas(gcf, titim,'epsc')

%%

out1_tkmeans = tkmeans(X1,g,alpha,'plots','ellipse');
xlabel('X1')
ylabel('X2')
set(findall(gcf,'-property','FontSize'),'FontSize',fsize)
title('tk-means, structural contamination','fontsize',titsize);
set(findall(gcf,'-property','location'),'location','southwest');
tt = findall(gca,'-property','MarkerFaceColor');
cli = [7, 8, 9];
clrdef=[0.4660 0.6740 0.1880;
    0 0.4470 0.7410;
    1 0 0];
for i = 1:length(cli)
    set(tt(cli(i)),'Color', clrdef(i,:))
end
for i = 1:6
    set(tt(i),'Color', [0 0 0])
end

titim = sprintf('%s/fig1_s2', USER_PATH);
saveas(gcf, titim,'epsc')


%%

out2_tkmeans = tkmeans(X2,g,alpha,'plots','ellipse');
xlabel('X1')
ylabel('X2')
set(findall(gcf,'-property','FontSize'),'FontSize',fsize)
title('tk-means, pointmass contamination','fontsize',titsize);
tt = findall(gca,'-property','MarkerFaceColor');
cli = [7, 8, 9];
clrdef=[0.4660 0.6740 0.1880;
    0 0.4470 0.7410;
    1 0 0];
for i = 1:length(cli)
    set(tt(cli(i)),'Color', clrdef(i,:))
end
for i = 1:6
    set(tt(i),'Color', [0 0 0])
end

titim = sprintf('%s/fig1_p2', USER_PATH);
saveas(gcf, titim,'epsc')


%%

out1_tclust = tclust(X1,g,alpha,20,'plots','ellipse');
xlabel('X1')
ylabel('X2')
set(findall(gcf,'-property','FontSize'),'FontSize',fsize)
title('TCLUST, structural contamination','fontsize',titsize);
set(findall(gcf,'-property','location'),'location','southwest');
tt = findall(gca,'-property','MarkerFaceColor');
cli = [7, 8, 9];
clrdef=[0 0.4470 0.7410;
    0.4660 0.6740 0.1880;
    1 0 0];
for i = 1:length(cli)
    set(tt(cli(i)),'Color', clrdef(i,:))
end
for i = 1:6
    set(tt(i),'Color', [0 0 0])
end

titim = sprintf('%s/fig1_s3', USER_PATH);
saveas(gcf, titim,'epsc')

%%

out2_tclust = tclust(X2,g,alpha,20,'plots','ellipse');
xlabel('X1')
ylabel('X2')
set(findall(gcf,'-property','FontSize'),'FontSize',fsize)
title('TCLUST, pointmass contamination','fontsize',titsize);
tt = findall(gca,'-property','MarkerFaceColor');
cli = [7, 8, 9];
clrdef=[0 0.4470 0.7410;
    0.4660 0.6740 0.1880;
    1 0 0];
for i = 1:length(cli)
    set(tt(cli(i)),'Color', clrdef(i,:))
end
for i = 1:6
    set(tt(i),'Color', [0 0 0])
end

titim = sprintf('%s/fig1_p3', USER_PATH);
saveas(gcf, titim,'epsc')

%%

k = ceil(log(n));
txOpt.plots = 1;
out1_tkm = txmerge(X1, k, g, 'alpha', alpha, 'plots', 'ellipse', 'txOpt', txOpt, 'dist', 0);
xlabel('X1')
ylabel('X2')
set(findall(gcf,'-property','FontSize'),'FontSize',fsize)
title('tk-merge, structural contamination','fontsize',titsize);
set(findall(gcf,'-property','location'),'location','southwest');
tt = findall(gca,'-property','MarkerFaceColor');
cli = [7, 8, 9];
clrdef=[0.4660 0.6740 0.1880;
    0 0.4470 0.7410;
    1 0 0];
for i = 1:length(cli)
    set(tt(cli(i)),'Color', clrdef(i,:))
end
for i = 1:6
    set(tt(i),'Color', [0 0 0])
end

titim = sprintf('%s/fig1_s4', USER_PATH);
saveas(gcf, titim,'epsc')

%%

k = floor(log(n)/2);
out2_tkm = txmerge(X2, k, g, 'alpha', alpha, 'plots', 'ellipse', 'txOpt', txOpt, 'dist', 0);
xlabel('X1')
ylabel('X2')
set(findall(gcf,'-property','FontSize'),'FontSize',fsize)
title('tk-merge, pointmass contamination','fontsize',titsize);
tt = findall(gca,'-property','MarkerFaceColor');
cli = [7, 8, 9];
clrdef=[0.4660 0.6740 0.1880;
    0 0.4470 0.7410;
    1 0 0];
for i = 1:length(cli)
    set(tt(cli(i)),'Color', clrdef(i,:))
end
for i = 1:6
    set(tt(i),'Color', [0 0 0])
end

titim = sprintf('%s/fig1_p4', USER_PATH);
saveas(gcf, titim,'epsc')

%%
cascade