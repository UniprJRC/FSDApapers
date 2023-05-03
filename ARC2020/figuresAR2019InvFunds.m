close all
%% Figure 1: investment funds data
load fondi_large.mat
yori=fondi_large{:,2};
Xall=fondi_large{:,[1 3]};

%% Create Figure 1

booneg=yori<0;
seq=1:length(yori);
group=ones(length(yori),1);
group(seq(booneg))=2;

yXplot(yori,Xall,'group',group)
legend({'Positive performance' 'Negative performance'})

disp('fit on the original scale')
outfillm=fitlm(Xall,yori,'exclude','');

%% Create Figure 4 (top panel)
ylimy=20;
nini=100;
la=[0.5 0.6 0.7 0.8 0.9 1];
out=FSRfan(yori,Xall,'la',la,'family','YJ','plots',1,'init',round(nini/2),'ylimy',[-ylimy ylimy]); %#ok<NASGU>

%% Create Figure 4 (bottom panel)
% pos and neg for 0.7
lasel=0.7;
ylimy1=5;
outpn=FSRfan(yori,Xall,'la',lasel,'family','YJpn','plots',1,'init',round(nini/2),'ylimy',[-ylimy1 ylimy1]); %#ok<NASGU>

%% Create figure 5
booneg=yori<0;
la=0.5;
yneg=normYJ(yori(booneg),[],la,'inverse',false,'Jacobian',false);

la=1;
ypos=normYJ(yori(~booneg),[],la,'inverse',false,'Jacobian',false);

ymod=yori;
ymod(booneg)=yneg;
ymod(~booneg)=ypos;

% yXplot with colors
seq=1:length(ymod);
group=ones(length(ymod),1);
group(seq(booneg))=2;

yXplot(ymod,Xall,'group',group)
legend({'Positive performance' 'Negative performance'})

%% Create figure 6 top panel
booneg=yori<0;
la=0.5;
yneg=normYJ(yori(booneg),[],la,'inverse',false,'Jacobian',false);

la=1;
ypos=normYJ(yori(~booneg),[],la,'inverse',false,'Jacobian',false);

ymod=yori;
ymod(booneg)=yneg;
ymod(~booneg)=ypos;
outpn=FSRfan(ymod,Xall,'la',1,'family','YJpn','plots',1,'init',round(nini/2),'ylimy',[-ylimy ylimy]); %#ok<NASGU>

%% Create figure 6 central panel
booneg=yori<0;
la=0.25;
yneg=normYJ(yori(booneg),[],la,'inverse',false,'Jacobian',false);

la=1;
ypos=normYJ(yori(~booneg),[],la,'inverse',false,'Jacobian',false);

ymod=yori;
ymod(booneg)=yneg;
ymod(~booneg)=ypos;
outpn=FSRfan(ymod,Xall,'la',1,'family','YJpn','plots',1,'init',round(nini/2),'ylimy',[-ylimy ylimy]); %#ok<NASGU>


%% Create figure 6 bottom panel
booneg=yori<0;
la=0;
yneg=normYJ(yori(booneg),[],la,'inverse',false,'Jacobian',false);

la=1;
ypos=normYJ(yori(~booneg),[],la,'inverse',false,'Jacobian',false);

ymod=yori;
ymod(booneg)=yneg;
ymod(~booneg)=ypos;
outpn=FSRfan(ymod,Xall,'la',1,'family','YJpn','plots',1,'init',round(nini/2),'ylimy',[-ylimy ylimy]); %#ok<NASGU>

%%  Figure 7
seq=1:length(ymod);
group=ones(length(ymod),1);
group(seq(booneg))=2;

yXplot(ymod,Xall,'group',group)


%%  Figure 8 left panel
close all
outLMtra=fitlm(Xall,yori);
res=outLMtra.Residuals{:,3};
qqplotFS(res,'X',Xall,'plots',1);
h1=gcf;

%% Figure 8 right panel
outLMtra=fitlm(Xall,ymod);
restra=outLMtra.Residuals{:,3};
qqplotFS(restra,'X',Xall,'plots',1);
h2=gcf;

%% Figure 8 two panels 
FontSizeqq=10;
nr=2;
nc=2;
cl=3.5;
h1=subplot(nr,nc,1);
qqplotFS(res,'X',Xall,'plots',1,'h',h1);
ylim([-cl cl])
xlim([-cl cl])
xlabel('Standard Normal Quantiles','FontSize',FontSizeqq)
ylabel('Quantiles of Input Sample','FontSize',FontSizeqq)
box('on')

h2=subplot(nr,nc,2);
qqplotFS(restra,'X',Xall,'plots',1,'h',h2);
ylim([-cl cl])
xlim([-cl cl])

xlabel('Standard Normal Quantiles','FontSize',FontSizeqq)
ylabel('')
box('on')
prin=0;
if prin==1
    % print to postscript
    print -depsc figsFondi\qqplotwithenv.eps;
end


%% %%%%%%%%%%%%%%%% additional analysis for referees
X=Xall;
y=yori;

close all

%% plot of transformed y vs y for our transformation (Figure 9)

plot(yori,zscore(ymod),'x','MarkerSize',12,'Color','b')
ylabel('EYJ transformed values','FontSize',FontSizeylabel)
xlabel('y','FontSize',FontSizeylabel)
ylim([-2.5, 3.2])

if prin==1
    % print to postscript
    print -depsc figsFondi\NP1.eps;
end


%% ace (transforming just y)
close all
p=size(X,2);
l=[4*ones(p,1); 1];
outACE= ace(y,X,'l',l);
aceplot(outACE) % ,'ylimy',ylimy)
fitlm(X,outACE.ty)

%% Plot of transformed vs original (comparison with ace)
y=yori;

close all
hold('on')
ytrast=zscore(ymod);
plot(y,ytrast,'x')
plot(y,outACE.ty,'o')

legend({'EYJ' 'ACE'})


% avas (transforming just y)
close all
p=size(X,2);
l=[4*ones(p,1); 1];
outAVAS= avas(y,X,'l',l);
% aceplot(outAVAS) % ,'ylimy',ylimy)
fitlm(X,outAVAS.ty)


% Plot of transformed vs original (comparison with AVAS)
y=yori;

close all
hold('on')
ytrast=zscore(ymod);
plot(y,ytrast,'x')
plot(y,outAVAS.ty,'o')

legend({'EYJ' 'AVAS'})



%% Create Figure 10
close all
ms=7;
subplot(1,2,1)
sim='s';
FontSizeylabel=14;
kk=5;
hold('on')
plot(y,ytrast,'x','MarkerSize',ms,'Color','b')
plot(y,outACE.ty,sim,'MarkerSize',ms+kk,'Color','r') % 'MarkerFaceColor','r'
ylabel('ACE and EYJ','FontSize',FontSizeylabel)
xlabel('y','FontSize',FontSizeylabel)
legend({'EYJ' 'ACE' },'Location','southeast')
set(gca,'FontSize',18)
ylim([-2.5, 3.2])

subplot(1,2,2)
hold('on')
plot(y,ytrast,'x','MarkerSize',ms,'Color','b')
plot(y,outAVAS.ty,sim,'MarkerSize',ms+kk,'Color','r')

legend({'EYJ' 'AVAS'},'Location','southeast')
ylabel('AVAS and EYJ','FontSize',FontSizeylabel)
xlabel('y','FontSize',FontSizeylabel)
set(gca,'FontSize',18)
ylim([-2.5, 3.2])
if prin==1
    % print to postscript
    print -depsc figsFondi\NP2.eps;
end

