%% This file contains the code to create all the figures shown in the paper
% "Robust Transformations for Multiple Regression via Additivity and
% Variance Stabilization" by
% Marco Riani, Anthony C. Atkinson and Aldo Corbellini (2022)
%
% The file is organized in Sections. Each Section produces the code to
% generate a particular figure.
%
% REMARK: This code assumes toolbox FSDA version >=8.5.23 has been
% installed and that MATLAB>=2021a is running

%% Ex1 (seven outliers).
rng('default')
rng(1000)
x = (0:0.1:15)';
y = sin(x) + 0.5*(rand(size(x))-0.5);
y([100,105:110]) = 1;
X=x;
y=exp(y);

% Standard non-robust analysis without options.
out=avas(y,x,'rob',false,'tyinitial',false,...
    'orderR2',false,'scail',false,'trapezoid',false);

%% Create Figure1 (non robust analysis)
tX=out.tX;
ty=out.ty;
% Top left-hand panel, transformed y against y; top right-hand panel, transformed
% y against fitted values; lower panel, transformed x
addout=false;
subplot(2,2,1)
plot(y,ty,'o')
ylabel('Transformed y')
xlabel('y')
if addout ==true
    hold('on')
    plot(y(highlight),ty(highlight),'ro','MarkerFaceColor','r')
end

yhat=sum(tX,2);

subplot(2,2,2)
plot(yhat,ty,'o')
ylabel('Transformed y')
xlabel('Fitted values')
if addout ==true
    hold('on')
    plot(yhat(highlight),ty(highlight),'ro','MarkerFaceColor','r')
end
subplot(2,2,3:4)
j=1;
plot(X(:,j),tX(:,j),'o')
R=rug(0.03);
try
    delete(R.yRug)
catch
end
ylabel('Transformed X')
xlabel('X')
if addout ==true
    hold('on')
    plot(X(highlight,j),tX(highlight,j),'ro','MarkerFaceColor','r')
end
set(gcf,'NumberTitle','off','Name',['Figure 1: Example 1 (seven outliers). ...' ...
    'Standard non robust analysis ...'])

%% Ex1: all options set to true
out=avas(y,x,'rob',true,'tyinitial',true,...
    'orderR2',true,'scail',true,'trapezoid',true);

%% Ex1: create Figure2 (all options set to true)
close all
tX=out.tX;
ty=out.ty;
p=size(tX,2);
addout=true;
highlight=out.outliers;
subplot(2,2,1)
plot(y,ty,'o')
ylabel('Transformed y')
xlabel('y')
if addout ==true
    hold('on')
    plot(y(highlight),ty(highlight),'ro','MarkerFaceColor','r')
end

yhat=sum(tX,2);

subplot(2,2,2)
plot(yhat,ty,'o')
ylabel('Transformed y')
xlabel('Fitted values')
if addout ==true
    hold('on')
    plot(yhat(highlight),ty(highlight),'ro','MarkerFaceColor','r')
end
subplot(2,2,3:4)
j=1;
plot(X(:,j),tX(:,j),'o')
R=rug(0.03);
try
    delete(R.yRug)
catch
end
ylabel('Transformed X')
xlabel('X')
if addout ==true
    hold('on')
    plot(X(highlight,j),tX(highlight,j),'ro','MarkerFaceColor','r')
end
set(gcf,'NumberTitle','off','Name',['Figure 2: Example 1. Robust analysis. Top left ' ...
    'panel, transformed y against y ...'])

%% Two variable model
rng(30)
x2 = (0:0.01:1.5)';
n=length(x2);
x1=randn(n,1);
X=[x1 x2];
y = 10*(1+sin(x1)+ exp(x2)) + 0.5*(randn(n,1)-0.5);
y=y.^3;

% All options initially set to false
out=avas(y,X,'rob',false,'tyinitial',false,...
    'scail',false,'orderR2',false,'trapezoid',false);

%% Two variable model: create Figure 3
close all
highlight=out.outliers;
tX=out.tX;
ty=out.ty;
addout=~isempty(highlight);
yhat=sum(tX,2);
res = ty - yhat;
subplot(2,2,1)
plot(yhat,res,'o')
refline(0,0)
title('Plot of residuals vs. fit')
ylabel('Residuals')
xlabel('Fitted values')
if addout ==true
    hold('on')
    plot(yhat(highlight),res(highlight),'ro','MarkerFaceColor','r')
end

subplot(2,2,2)
plot(yhat,ty,'o')
title('Plot of ty vs. fit')
ylabel('Transformed y')
xlabel('Fitted values')
if addout ==true
    hold('on')
    plot(yhat(highlight),ty(highlight),'ro','MarkerFaceColor','r')
end
set(gcf,'NumberTitle','off','Name',['Figure 3: Two variable model. Non robust ' ...
    'analysis without options...'])



%% Two variable model: scail set to true
out=avas(y,X,'rob',false,'tyinitial',false,...
    'scail',true,'orderR2',false,'trapezoid',false);
disp(out.pvaldw)
% aceplot(out)


%% Two variable model: create figure 4
close all
highlight=out.outliers;
tX=out.tX;
ty=out.ty;
addout=~isempty(highlight);
yhat=sum(tX,2);
res = ty - yhat;
subplot(2,2,1)
plot(yhat,res,'o')
refline(0,0)
title('Plot of residuals vs. fit')
ylabel('Residuals')
xlabel('Fitted values')
if addout ==true
    hold('on')
    plot(yhat(highlight),res(highlight),'ro','MarkerFaceColor','r')
end

subplot(2,2,2)
plot(yhat,ty,'o')
title('Plot of ty vs. fit')
ylabel('Transformed y')
xlabel('Fitted values')
if addout ==true
    hold('on')
    plot(yhat(highlight),ty(highlight),'ro','MarkerFaceColor','r')
end
set(gcf,'NumberTitle','off','Name',['Figure 4: Two variable model. Non robust ' ...
    'analysis with option scail...'])


%% Two variable model: tyinitial true and scail true
close all
tyinitial=struct;
tyinitial.la=[0 0.1 0.2 0.3 0.4 1/2];
out=avas(y,X,'rob',false,'tyinitial',tyinitial,...
    'scail',true,'orderR2',false,'trapezoid',false);
% aceplot(out)
disp(out)


%%  Two variable model: create figure 5
close all
highlight=out.outliers;
tX=out.tX;
ty=out.ty;
addout=~isempty(highlight);
yhat=sum(tX,2);
res = ty - yhat;
subplot(2,2,1)
plot(yhat,res,'o')
refline(0,0)
title('Plot of residuals vs. fit')
ylabel('Residuals')
xlabel('Fitted values')
if addout ==true
    hold('on')
    plot(yhat(highlight),res(highlight),'ro','MarkerFaceColor','r')
end

subplot(2,2,2)
plot(yhat,ty,'o')
title('Plot of ty vs. fit')
ylabel('Transformed y')
xlabel('Fitted values')
if addout ==true
    hold('on')
    plot(yhat(highlight),ty(highlight),'ro','MarkerFaceColor','r')
end
set(gcf,'NumberTitle','off','Name',['Figure 5: Two variable model. Non robust ' ...
    'analysis with option scail and tyinitial ...'])



%% Two variable model: all options set to true
close all
tyinitial=struct;
tyinitial.la=[0 0.1 0.2 0.3 0.4 1/2];
out=avas(y,X,'rob',true,'tyinitial',tyinitial,...
    'scail',true,'orderR2',true,'trapezoid',true);

%% Two variable model: create figure 6
aceplot(out,'oneplot',true)
disp(out)
set(gcf,'NumberTitle','off','Name',['Figure 6: Two variable model. Robust ' ...
    'with all options ...'])


%% Example 2: 4 explanatory variables
clear
rng(100)
x1 = (0:0.1:15)';
n=length(x1);
X24=randn(n,3);
y = sin(x1) + 0.5*(rand(size(x1))-0.5) + X24*(1:3)';
y([90,100,105:110]) = 1;
X=[x1 X24];
y=exp(y);


%% Example 2: automatic model selection create Figure 7
close all
[VALtfin,~]=avasms(y,X);
disp(VALtfin)
close(findobj('type','figure','Tag','pl_heatmap'));
set(gcf,'NumberTitle','off','Name','Figure 7: Example 2. Augmented start plot of options ...')



%% Example 2: all options set to false, create Figure 8
close all
out=avas(y,X,'rob',false,'tyinitial',false,...
    'scail',false,'orderR2',false,'trapezoid',false);
aceplot(out,'oneplot',true)
disp(out)
set(gcf,'NumberTitle','off','Name','Figure 8: Example 2. Non robust analysis. ...')


%% Example 2: all options set to true
out=avas(y,X,'rob',true,'tyinitial',true,...
    'scail',true,'orderR2',true,'trapezoid',true);


%% Example 2: create Figure 9
close all
aceplot(out)
close(findobj('type','figure','Tag','pl_tX'));

disp(out)
highlight=out.outliers;
tX=out.tX;
addout=~isempty(highlight);
% Add the fourth panel referred to X1 and tX1
subplot(2,2,4)
j=1;

plot(X(:,j),tX(:,j),'o')
a=gca;
a.XTickLabel='';
R=rug(0.03);
try
    delete(R.yRug)
catch
end
jstr=num2str(j);

ylabel(['Transformed X' jstr])
xlabel(['X' jstr])

if addout ==true
    hold('on')
    plot(X(highlight,j),tX(highlight,j),'ro','MarkerFaceColor','r')
end
set(gcf,'NumberTitle','off','Name','Figure 9: Robust analysis with all options. ...')


%% Example from Wang and Murphy: generate the data
close all
rng('default')
seed=100;
negstate=-30;
n=200;
X1 = mtR(n,0,seed)*2-1;
X2 = mtR(n,0,negstate)*2-1;
X3 = mtR(n,0,negstate)*2-1;
X4 = mtR(n,0,negstate)*2-1;
res=mtR(n,1,negstate);
% Generate y
y = log(4 + sin(3*X1) + abs(X2) + X3.^2 + X4 + .1*res );
X = [X1 X2 X3 X4];
y([121 80 34 188 137 110 79 86 1])=1.9+randn(9,1)*0.01;


%% Example from Wang and Murphy: create Figure 10 
% Automatic model selection
close all
[VALtfinchk,Resarraychk]=avasms(y,X);

close(findobj('type','figure','Tag','pl_heatmap'));
set(gcf,'NumberTitle','off','Name',['Figure 10: Example from Wang and Murphy. Augmented' ...
    ' star plot ...'])

%% Example from Wang and Murphy: extract best solution
close all
j=1;
outj=VALtfinchk{j,"Out"};
out=outj{:};


%% Example from Wang and Murphy: create Figure 11
% ty vs y and residuaal vs fit for best solution (2 panels plot)
highlight=out.outliers;
tX=out.tX;
ty=out.ty;
addout=~isempty(highlight);

figure
subplot(2,2,1)
plot(y,ty,'o')
ylabel('Transformed y')
xlabel('y')
title('Plot of ty vs. y')
if addout ==true
    hold('on')
    plot(y(highlight),ty(highlight),'ro','MarkerFaceColor','r')
end

yhat=sum(tX,2);
res = ty - yhat;
subplot(2,2,2)
plot(yhat,res,'o')
refline(0,0)
title('Plot of residuals vs. fit')
ylabel('Residuals')
xlabel('Fitted values')
if addout ==true
    hold('on')
    plot(yhat(highlight),res(highlight),'ro','MarkerFaceColor','r')
end
set(gcf,'NumberTitle','off','Name',['Figure 11: Example from Wang and Murphy. Left' ...
    ' hand panel, transformed y against y ...'])


%% Example from Wang and Murphy: create Figure 12
% tXj against Xj for j=1, 2, 3 and 4.
close all
aceplot(out)
close(findobj('type','figure','Tag','pl_ty'));

set(gcf,'NumberTitle','off','Name',['Figure 12: Example from Wang and Murphy. Transformation' ...
    ' of the four explanatory variables ...'])

%%  Marketing data
% https://www.kaggle.com/fayejavad/marketing-linear-multiple-regression
clear
close all
load('Marketing_Data')
y=Marketing_Data{:,4};
X=Marketing_Data{:,1:3};

% Fit regression model based on the original data
fitlm(X,y)
% F stat is 504

%%  Marketing data: all options set to false.
% Monotonicity of the expl. variables imposed.
out=avas(y,X,'rob',false,'tyinitial',false,'orderR2',false,...
    'scail',false,'trapezoid',false','l',3*ones(size(X,2),1));
aceplot(out,'oneplot',true)

set(gcf,'NumberTitle','off','Name',['Figure 13: Marketing data. Standard' ...
    ' non robust analysis without options ...'])

%% Marketing data: regression model based on transformed data using all options set to false
% find F-value
fitlm(out.tX,out.ty)
% F stat is 472 (even smaller than that for linear regression)

%% Marketing data: all options set to true. Create Figure 14.
close all
out=avas(y,X,'trapezoid',true,'rob',true,'tyinitial',true,'orderR2',true,'scail',true,'l',3*ones(size(X,2),1));
aceplot(out,'oneplot',true)

set(gcf,'NumberTitle','off','Name',['Figure 14: MArketing data. RAVAS analysis' ...
    ' with all options ...'])

%% Marketing data: regression model based on transformed data using all options set to true
% find F value
fitlm(out.tX,out.ty,'Exclude',out.outliers)
% F stat excluding the outliers is 936

%% Marketing data: model selection with quadratic model, create Figure 15
close all
Xq=[X(:,1:2) X(:,1).^2 X(:,2).^2 X(:,1).*X(:,2)];
[VALtfin,CorrMat]=avasms(y,Xq,'l',3*ones(size(Xq,2),1),...
    'critBestSol',0.01,'maxBestSol',2);
disp(VALtfin)

% heatmap figure is automatically produced so it is closed
close(findobj('type','figure','Tag','pl_heatmap'));

set(gcf,'NumberTitle','off','Name',['Figure 15: Marketing data' ...
    ' Augmented star plot...'])

%% Marketing data: show details of best solution, create Figure 16
close all
j=1;
outj=VALtfin{j,"Out"};
solj=outj{:};
aceplot(solj,'oneplot',true)

set(gcf,'NumberTitle','off','Name',['Figure 16: Marketing data' ...
    ' quadratic model...'])

% Regression model on the transformed scale
outjr=fitlm(solj.tX,solj.ty,'Exclude',solj.outliers);

disp(outjr)
%% Marketing data: quadratic model all options set to false
out=avas(y,Xq,'l',3*ones(size(Xq,2),1));
fitlm(out.tX,out.ty,'Exclude','')
% The F-stat now has a value of 556, hardly better than regression on the
% first-order model without transformation of the response or of the
% explanatory variables

%% Create Figure 17
close all
% In the paper just the two top panels have been shown
aceplot(out,'oneplot',true)

set(gcf,'NumberTitle','off','Name',['Figure 17: quadratic model' ...
    ' Standard non robust analysis without options...'])
