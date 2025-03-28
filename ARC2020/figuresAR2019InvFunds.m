close all
%% Figure 1: investment funds data
load fondi_large.mat
y=fondi_large{:,2};
X=fondi_large{:,[1 3]};

% Fit in the original scale
outla11=fitlm(X,y);
ANO=anova(outla11,'summary');
RF11=[ANO{'Model','F'} outla11.Rsquared.Adjusted ];


%% Create Figure 1

booneg=y<0;
seq=1:length(y);
group=ones(length(y),1);
group(seq(booneg))=2;

yXplot(y,X,'group',group)
legend({'Positive performance' 'Negative performance'})

sgtitle('Figure 1')
disp('fit on the original scale')
outfillm=fitlm(X,y,'exclude','');


%% Create Figure 4 (top panel)
ylimy=20;
nini=100;
la=[0.5 0.6 0.7 0.8 0.9 1];
out=FSRfan(y,X,'la',la,'family','YJ','plots',1,'init',round(nini/2),'ylimy',[-ylimy ylimy]); %#ok<NASGU>
title('Figure 4 top panel')
%% Create Figure 4 (bottom panel)
% pos and neg for 0.7
lasel=0.7;
ylimy1=5;
outpn=FSRfan(y,X,'la',lasel,'family','YJpn','plots',1,'init',round(nini/2),'ylimy',[-ylimy1 ylimy1]); %#ok<NASGU>

%% Create figure 5 
booneg=y<0;
laneg=0.5;
yneg=normYJ(y(booneg),[],laneg,'inverse',false,'Jacobian',false);

lapos=1;
ypos=normYJ(y(~booneg),[],lapos,'inverse',false,'Jacobian',false);

ymod=y;
ymod(booneg)=yneg;
ymod(~booneg)=ypos;

% yXplot with colors
seq=1:length(ymod);
group=ones(length(ymod),1);
group(seq(booneg))=2;

yXplot(ymod,X,'group',group)
legend({'Positive performance' 'Negative performance'})
sgtitle('Figure 5')


outla105=fitlm(X,ymod);
ANO=anova(outla105,'summary');
RF105=[ANO{'Model','F'} outla105.Rsquared.Adjusted ];


%% Create figure 6 top panel

outpn=FSRfan(ymod,X,'la',1,'family','YJpn','plots',1,'init',round(nini/2),'ylimy',[-ylimy ylimy]); %#ok<NASGU>

% Extract values of F test and R2 for 

%% Create figure 6 central panel
booneg=y<0;
la=0.25;
yneg=normYJ(y(booneg),[],la,'inverse',false,'Jacobian',false);

la=1;
ypos=normYJ(y(~booneg),[],la,'inverse',false,'Jacobian',false);

ymod=y;
ymod(booneg)=yneg;
ymod(~booneg)=ypos;
outpn=FSRfan(ymod,X,'la',1,'family','YJpn','plots',1,'init',round(nini/2),'ylimy',[-ylimy ylimy]); %#ok<NASGU>

outla1025=fitlm(X,ymod);
ANO=anova(outla1025,'summary');
RF1025=[ANO{'Model','F'} outla105.Rsquared.Adjusted ];

%% Create figure 6 bottom panel
booneg=y<0;
la=0;
yneg=normYJ(y(booneg),[],la,'inverse',false,'Jacobian',false);

la=1;
ypos=normYJ(y(~booneg),[],la,'inverse',false,'Jacobian',false);

ymod=y;
ymod(booneg)=yneg;
ymod(~booneg)=ypos;
outpn=FSRfan(ymod,X,'la',1,'family','YJpn','plots',1,'init',round(nini/2),'ylimy',[-ylimy ylimy]); %#ok<NASGU>

outla10=fitlm(X,ymod);
ANO=anova(outla10,'summary');
RF10=[ANO{'Model','F'} outla10.Rsquared.Adjusted ];

%% Create Table 1
nam=["laP" "laN" "F_{2,306}" "R2"];
tab2=[ones(4,1) [1; 0.5; 0.25; 0] [RF11; RF105; RF1025; RF10]];
disp(array2table(tab2,"VariableNames",nam));

%%  Figure 7
seq=1:length(ymod);
group=ones(length(ymod),1);
group(seq(booneg))=2;

yXplot(ymod,X,'group',group)
sgtitle('Figure 7')

%%  Figure 8 left panel
close all
outLMori=fitlm(X,y);
R2eyjORI=outLMori.Rsquared.Adjusted;

res=outLMori.Residuals{:,3};
qqplotFS(res,'X',X,'plots',1);

%% Figure 8 right panel
outLMtra=fitlm(X,ymod);
R2eyjTRA=outLMtra.Rsquared.Adjusted;
restra=outLMtra.Residuals{:,3};
qqplotFS(restra,'X',X,'plots',1);

%% Figure 8 two panels 
FontSizeqq=10;
nr=2;
nc=2;
cl=3.5;
h1=subplot(nr,nc,1);
qqplotFS(res,'X',X,'plots',1,'h',h1);
ylim([-cl cl])
xlim([-cl cl])
xlabel('Standard Normal Quantiles','FontSize',FontSizeqq)
ylabel('Quantiles of Input Sample','FontSize',FontSizeqq)
box('on')

h2=subplot(nr,nc,2);
qqplotFS(restra,'X',X,'plots',1,'h',h2);
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


%% plot of transformed y vs y for our transformation (Figure 9)
close all
FontSizeylabel=12;
plot(y,zscore(ymod),'x','MarkerSize',12,'Color','b')
ylabel('EYJ transformed values','FontSize',FontSizeylabel)
xlabel('y','FontSize',FontSizeylabel)
ylim([-2.5, 3.2])
title('Figure 9')
if prin==1
    % print to postscript
    print -depsc figsFondi\NP1.eps;
end


%% ace (transforming just y)
close all
p=size(X,2);
l=[4*ones(p,1); 1];
outACEori= ace(y,X,'l',l);
% aceplot(outACE) % ,'ylimy',ylimy)
outACElm=fitlm(X,outACEori.ty);
R2aceORI=outACElm.Rsquared.Ordinary;

outACEtra= ace(ymod,X,'l',l);
% aceplot(outACE) % ,'ylimy',ylimy)
out=fitlm(X,outACEtra.ty);
R2aceTRA=outLMace.Rsquared.Ordinary;

%% Create table 2

R2all=[[R2eyjORI; R2eyjTRA] [R2aceORI; R2aceTRA] [R2avasORI; R2avasTRA]];
R2allt=array2table(R2all,"VariableNames",["EYJ" "ACE" "AVAS"]);

laP=ones(2,1);
laN=[1; 0];
Tab2=[table(laP,laN) R2allt];
disp(Tab2)

%% Plot of transformed vs original (comparison with ace)
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
outAVAS=fitlm(X,outAVAS.ty);

R2avasORI=outAVAS.Rsquared.Ordinary;

outAVAS= avas(ymod,X,'l',l);
outLMavas=fitlm(X,outAVAS.ty);
R2avasTRA=outLMavas.Rsquared.Ordinary;

% Plot of transformed vs original (comparison with AVAS)
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
sgtitle('Figure 10')
if prin==1
    % print to postscript
    print -depsc figsFondi\NP2.eps;
end

