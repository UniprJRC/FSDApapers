clear 
close all
%% Figures for John and Draper data
% Read original matrix
XX= load('JohnDraper.txt');
% Set X matrix
Location=dummyvar(XX(:,2));
Inspector=dummyvar(XX(:,3));
Replicate=dummyvar(XX(:,4));
X=[Location(:,1:end-1) Inspector(:,1:end-1)  Replicate(:,1:end-1)];
y=XX(:,1);

%% Create data for figure JD1
n=length(y);
la=[0.5 0.75 1 1.25 1.5 2];
ylimy=40;
out=FSRfan(y,X,'la',la,'family','YJ','plots',0,'init',round(n/2),'ylimy',[-ylimy ylimy]);
%% Create JD1
fanplot(out)
fs=12;
text(57,-15,'2','FontSize',fs)
text(54,16,'0.75','FontSize',fs)
text(48,16,'0.5','FontSize',fs)
title('')
prin=0;
if prin==1
    % print to postscript
    print -depsc figsJD\JD1.eps;
end

%%  Remove the outliers
outlier=[57 36 38 18 60 17];
bsb=setdiff(1:length(y),outlier);
y=y(bsb);
X=X(bsb,:);

%% Create JD2 (left panel)
 la=0.75;
out=FSRfan(y,X,'la',la,'family','YJpn','plots',1,'init',round(n/2),'nsamp',10000);
ylim([-5 5])
title('')
if prin==1
    % print to postscript
    print -depsc figsJD\JD2l.eps;
end

%% Create JD2 (right panel)
yori=y;
booneg=yori<0;
la=1.5;
yneg=normYJ(yori(booneg),[],la,'inverse',false,'Jacobian',false);

la=0;
ypos=normYJ(yori(~booneg),[],la,'inverse',false,'Jacobian',false);

ymod=yori;
ymod(booneg)=yneg;
ymod(~booneg)=ypos;
ylimy=5;
outpn=FSRfan(ymod,X,'la',1,'family','YJpn','plots',1,'init',round(length(y)/2),'ylimy',[-ylimy ylimy]); %#ok<NASGU>
title('')
if prin==1
    % print to postscript
    print -depsc figsJD\JD2r.eps;
end

%% Create JD3 (avas)
p=size(X,2);
l=5*ones(p,1);
out= avas(y,X,'l',l);
ylimy=[-4 5;-4 4; -4 5];
aceplot(out,'ylimy',ylimy)
if prin==1
    % print to postscript
    print -depsc figsJD\JD3.eps;
end


fitlm(X,out.ty)
%% Create JD4 (aceplot)
p=size(X,2);
l=[5*ones(p,1); 1];
out= ace(y,X,'l',l);
aceplot(out,'ylimy',ylimy)
if prin==1
    % print to postscript
    print -depsc figsJD\JD4.eps;
end
fitlm(X,out.ty)

%% Create JD5
ty=zscore(ymod,1);
figure
subplot(2,2,1)
plot(y,ty,'o')
ylabel('Transformed y')
xlabel('y')
title('Plot of ty vs. y')

outLM=fitlm(X,ty);
yhat=outLM.Fitted;
res=outLM.Residuals{:,1};
ylim(ylimy(1,:))

subplot(2,2,2)
plot(yhat,res,'o')
refline(0,0)
title('Plot of residuals vs. fit')
ylabel('Residuals')
xlabel('Fitted values')
ylim(ylimy(2,:))


subplot(2,2,3)
plot(yhat,ty,'o')
title('Plot of ty vs. fit')
ylabel('Transformed y')
xlabel('Fitted values')
ylim(ylimy(3,:))

if prin==1
    % print to postscript
    print -depsc figsJD\JD5.eps;
end

%% Extra fig (JD6)
p=size(X,2);
l=[5*ones(p,1); 1];
out= ace(y,X,'l',l);
aceplot(out) % ,'ylimy',ylimy)

fitlm(X,out.ty)
FSRfan(out.ty,X,'la',1,'family','YJpn','plots',1,'init',round(length(y)/2),'nsamp',5000)
title('')
if prin==1
    % print to postscript
    print -depsc figsJD\JD6.eps;
end