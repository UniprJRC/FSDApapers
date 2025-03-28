
clc, clear, clf, close all
USER_PATH = 'YOUR_PATH';


titsize = 19;
fsize = 11;

% trimming level
alpha = 0.05;

% to run each ex separately
% exi = 1;
% exi = 2;
% exi = 3;

for exi=1:3
    if exi == 1
        
        rng(2021, 'twister');
        
        % ex 1: 2 half moons

        nPoints = 1000;
        g = 2;

        C1 = [0 0];   % center of the circle
        C2 = [-5 7.5];
        R1 = [8 10];  % range of radii
        R2 = [8 10];
        A1 = [1 3]*pi/2; % [rad] range of allowed angles
        A2 = [-1 1]*pi/2;

        urand = @(nPoints,limits)(limits(1) + rand(nPoints,1)*diff(limits));
        randomCircle = @(n,r,a)(pol2cart(urand(n,a),urand(n,r)));

        [P1x,P1y] = randomCircle(nPoints,R1,A1);
        P1x = P1x + C1(1);
        P1y = P1y + C1(2);

        [P2x,P2y] = randomCircle(nPoints,R2,A2);
        P2x = P2x + C2(1);
        P2y = P2y + C2(2);

        figure
        plot(P1x,P1y,'or'); hold on;
        plot(P2x,P2y,'sb'); hold on;
        axis square

        X = [P1x, P1y; P2x, P2y];
        n = length(X);
        m = round(n * alpha);
        XX = rand(m, 2) .* (max(X)- min(X)) + min(X);
        X = [X; XX];
        figure
        plot(X(:,1), X(:,2), 'b.')

    elseif exi == 2
        % ex2: sinusoidal 3 clusters

        nPoints = 3000;
        g = 3;

        nclu0 = nPoints; 
        nclu1 = nPoints; 
        nclu2 = nPoints; 

        % sinusoidal noise (amplitude*sin(frequency*time+phase)+bias)
        l = -2 * pi;
        v = -l + (2*l)*rand(nclu0,1);
        noise1 = [80 + 0.5*randn(nclu0,1) + 10*sin(2*v) , (80 + 5*v)];
        noise2 = noise1;
        noise2(:,1) = noise2(:,1) +randn(length(noise1), 1)  .* 3;

        % clusters 
        mu1 = [10 100]; mu2 = [30 80];
        Sigma1 = [1 1.5; 1.5 3];  
        Sigma2 = [10 -3; -3 8]; 

        clu1 = mvnrnd(mu1,3*Sigma1,nclu1);
        clu2 = mvnrnd(mu2,4*Sigma2,nclu2);

        % final contaminated datasets 
        X1 = [clu1 ; clu2 ; noise2];

        figure
        gscatter(X1(:,1), X1(:,2));
        title('dataset','fontsize',20);
        axis equal

        X = X1;
        n = length(X);
        m = round(n * alpha);
        XX = rand(m, 2) .* (max(X)- min(X)) + min(X);
        X = [X; XX];
        figure
        plot(X(:,1), X(:,2), 'b.')

    elseif exi == 3    
        % ex 3: 2 sinusoids

        nPoints = 5000;
        g = 4;

        x1 = linspace(1, 10, nPoints)';
        y1 = sin(x1).^4 + randn(length(x1), 1).*0.15;

        y2 = cos(x1).^4 + randn(length(x1), 1).*0.15 - 2;

        y3 = y1 - 4;
        y4 = y2 -  4;
        X = [x1, y1; x1, y2; x1, y3; x1, y4];

        figure 
        plot(X(:,1), X(:,2), 'b.');

        n = length(X);
        m = round(n * alpha);
        XX = rand(m, 2) .* (max(X)- min(X)) + min(X);
        X = [X; XX];
        figure
        plot(X(:,1), X(:,2), 'b.')

    end

    % to reduce a bit trimming due to overlap of noise and true clusters
    alpmin = alpha/10;
    alpha = alpha - alpmin;

    %% tk-merge

    n = length(X);
    k = floor(log(n)*2*g);

    txOpt.plots = 0;
    out1_tkm = txmerge(X, k, g, 'alpha', alpha, 'plots', 1, 'txOpt', txOpt, 'dist', 0);
    xlabel('X1')
    ylabel('X2')
    set(findall (gcf,'-property','FontSize'),'FontSize',fsize)
    title('')
    xlim([min(X(:,1)), max(X(:,1))])
    ylim([min(X(:,2)), max(X(:,2))])
    legend('Location', 'best');

    tt = findall(gca,'-property','MarkerFaceColor');
    if exi==1
        cli = [1, 2, 3];
        clrdef=[0.4660 0.6740 0.1880;
            0 0.4470 0.7410;
            1 0 0];
        legpos = 'northwest';
    elseif exi==2 
        cli = [1, 2, 3, 4];
        clrdef=[0.4660 0.6740 0.1880;
            0 0.4470 0.7410;
            0.4940 0.1840 0.5560;
            1 0 0];
        legpos = 'southwest';
    elseif exi==3
        cli = [1, 2, 3, 4, 5];
        clrdef=[0.4660 0.6740 0.1880;
            0 0.4470 0.7410;
            0.4940 0.1840 0.5560;
            0.8500 0.3250 0.0980;
            1 0 0];
        legpos = 'northeast';
    end
    
%     set(findall(gcf,'-property','location'),'location',legpos);
    legend('Location', legpos);
    
    for i = 1:length(cli)
        set(tt(cli(i)),'Color', clrdef(i,:))
    end

    titim = sprintf('%s/sim3_%d_tkm', USER_PATH, exi);
    saveas(gcf, titim,'epsc')

    %% TCLUST

    out1_tclust = tclust(X, g, alpha, 1000,'plots', 'ellipse');
    set(findall(gcf,'-property','FontSize'),'FontSize',fsize)
    xlabel('X1')
    ylabel('X2')
    set(findall (gcf,'-property','FontSize'),'FontSize',fsize)
    title('')
    xlim([min(X(:,1)), max(X(:,1))])
    ylim([min(X(:,2)), max(X(:,2))])

    %%
    
    tt = findall(gca,'-property','MarkerFaceColor');
    if exi==1
        cli = [7, 8, 9];
        clrdef=[0.4660 0.6740 0.1880;
            0 0.4470 0.7410;
            1 0 0];
        ntt=6;
        legpos = 'northwest';
    elseif exi==2 
        cli = [10, 11, 12, 13];
        clrdef=[
            0.4660 0.6740 0.1880;
            0.4940 0.1840 0.5560;
            0 0.4470 0.7410;
            1 0 0];
        ntt=9;
        legpos = 'southwest';
    elseif exi==3
        cli = [13, 14, 15, 16, 17];
        clrdef=[0.8500 0.3250 0.0980;
            0.4660 0.6740 0.1880;
            0 0.4470 0.7410;
            0.4940 0.1840 0.5560;
            1 0 0];
        ntt=12;
        legpos = 'northeast';
    end

    set(findall(gcf,'-property','location'),'location',legpos);    
    % legend('Location', legpos);
    
    for i = 1:length(cli)
        set(tt(cli(i)),'Color', clrdef(i,:))
    end
    for i = 1:ntt
        set(tt(i),'Color', [0 0 0])
    end

    titim = sprintf('%s/sim3_%d_TC', USER_PATH, exi);
    saveas(gcf, titim,'epsc')
end