%% The code below assumes that MATLAB and FSDA toolbox has been installed.
% In order to get FSDA toolbox from MATLAB
% Home|Add-Ons|Get Add-Ons and in the
% Add-On Explorer Window, in the Search for add-ons textbox type FSDA

%% Check that FSDA is installed
if ~exist('FSDA','dir') && isempty(which('FSDA'))
    error('FSDA:notinstalled','FSDA not found on the MATLAB path. Please install FSDA and add it to the path.');
end

try
    load('citiesItaly2024.mat');
catch     % Check for an FSDA installation (folder named 'FSDA' on the MATLAB path)
    error('FSDA:FileNotFound','FSDA appears to be present but dataset citiesItaly2024 is not found')
end

%% Figure 1
typespm = struct;
typespm.upper = 'circle';
spmplot(citiesItaly2024,'order','AOE','typespm',typespm,'colorBackground',true);

%% Figures 2-8
out = pcaFS(citiesItaly2024,'smartEVchart',true);

%% Figures 9-15
Xsel=citiesItaly2024(:,{'Employm' 'Protest' 'UrbanFra'});

ShapeFile=citiesItaly2024.Properties.UserData{1};
out=pcaFS(Xsel,'ShapeFile',ShapeFile);


%% Figure 16
LatLong=citiesItaly2024.Properties.UserData{2};
Latitude=LatLong(:,1);
Longitude=LatLong(:,2);
out=pcaFS(citiesItaly2024,'Latitude',Latitude,'Longitude',Longitude);


%% Figure 17
figure
pcaProjection(Xsel)

%% Figure A1
load citiesItaly2024.mat
spmplot(citiesItaly2024);

%% Figure A2-A3
% pcaFS(citiesItaly2024)