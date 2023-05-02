%% Analyze ChenLockhartStephens data (gasoline data)
% Read original matrix
XX=load('gasoline.txt');
y=XX(:,1);
X=XX(:,2);
%% Figure G1
la=[-0.5 0 0.5 1 1.5];
n=length(y);
ylimy=8;
out=FSRfan(y,X,'la',la,'family','YJ','plots',0,'init',round(n/2),'ylimy',[-ylimy ylimy]);
prin=0;
fanplot(out,'ylimy',[-4 8])
title('')
if prin==1
    % print to postscript
    print -depsc figsJD\G1.eps;
end


%% Input data for figure G2

la=0.8:0.01:2.6;
Xwithint=[ones(length(y),1) X];
BB=[la' zeros(length(la),3)];
for i=1:length(la)
    ytranorm=normBoxCox(y,1,la(i),'Jacobian',true);
    ytra=normBoxCox(y,1,la(i),'Jacobian',false);
    btranorm=Xwithint\ytranorm;
    res=ytranorm-Xwithint*btranorm;
    RSS=res'*res;
    btra=Xwithint\ytra;
    BB(i,2:4)=[btranorm(end) btra(end) RSS];
end

%% Create Figure G2
ylimy=[0 12];
subplot(2,1,1)

plot(la,log(BB(:,3)))
title('Non normalized transformation')
ylim(ylimy)
subplot(2,1,2);
plot(la,log(BB(:,2)))
xlabel('\lambda','FontSize',14)
title('Normalized transformation')
ylim(ylimy)

if prin==1
    % print to postscript
    print -depsc figsJD\G2.eps;
end
