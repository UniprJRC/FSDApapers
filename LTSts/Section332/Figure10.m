%%%% Simulation study of Section 3.3.2.

% Import data 
data = readtable("P87_KZ.csv");
Y = data.Y;
clear data;

n = 121; % number of data to use as training set
nfore = size(Y,1)-n;

reps = 10; % number of repetitions

model=struct;
model.s=54;
model.trend=1;
model.seasonal=101;
model.lshift=-1;

%% Without contamination

train = Y(1:n);

% Estimate
outEST=LTSts(train,'model',model,'plots',0);

% Forecast
outFORE = forecastTS(outEST,'model',model,'plots',1);
hold on;
plot(Y);
plot(outEST.outliers,train(outEST.outliers),'rx','LineWidth',1)    % outliers 
hold off;

%% With contamination

% Generation of random locations and signs of the contamination
rng(2023)
locations_noise = randi(n,reps,1);
sign_noise=randi(2,reps,1)-1;
sign_noise(~sign_noise)=-1;

for i=1:reps
    rng(1)

    train = Y(1:n);
    train(locations_noise(i)) = max( 0 , train(locations_noise(i)) + 20000*sign_noise(i) );
    
    % Estimate
    outEST=LTSts(train,'model',model,'plots',0);
    
    % Forecast
    outFORE = forecastTS(outEST,'model',model,'plots',1);
    hold on;
    plot(Y);
    plot(outEST.outliers,train(outEST.outliers),'rx','LineWidth',1)    % outliers 
    hold off;

end

