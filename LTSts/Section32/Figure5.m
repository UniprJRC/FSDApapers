%% data generation
A = [ones(1,50) 25*ones(1,50) 50*ones(1,50) 75*ones(1,50)] + rand(1,200);

figure;
plot(A,'-')

%% detection of multiple LS 
%% Figure 5 all panels
out = LTStsLSmult(A',...
    'maxLS',5,'alphaLTS',0.01,...%'bdpLTS',bdpLTS,...
    'alphaLS',0.01,'thresLS',0.01,'plots',1,'msg',1);
