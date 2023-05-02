
%% Figure 1: investment funds data
FondiInv = xlsread('fondiInv.xlsx', 'Foglio1','A2:C310');
yori=FondiInv(:,3);
Xall=FondiInv(:,1:2);

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


%% Figure 8 right panel
outLMtra=fitlm(Xall,ymod);
res=outLMtra.Residuals{:,3};
qqplotFS(res,'X',Xall,'plots',1);


