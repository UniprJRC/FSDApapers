clc, clear, clf, close all
rng(2021, 'twister');

% load each image separately
% I = double(imread('00153.jpg'));
I = double(imread('00144.jpg'));

% all values are in the range 0 - 1
I = I / 255; 
imshow(I)
title('Original Image')

% size of the image
img_size = size(I);

% reshape to an nx3 matrix where n = number of pixels
% each row contains the Red, Green and Blue pixel values
X = reshape(I, img_size(1) * img_size(2), 3);
n = size(X, 1);


%% parameters

% true number of clusters
g = 2;
% trimming proportion
alpha = 0.025;

%% kmeans

[ksol, mu] = kmeans(X, g);

% assign centroids
IresKM = X .* 0;
for i = 1:g
    IresKM(ksol == i, :) = IresKM(ksol == i, :) + mu(i,:);
end
IresKM = reshape(IresKM, size(I));

%% TCLUST

out=tclust(X, g, alpha, 1000, 'plots', 1, 'msg',0, 'nocheck',1);
out.mergID = out.idx;

% get centroids
Ires = X .* 0;
muTC = zeros(g, size(X, 2));
for i = 1:g
    muTC(i, :) = mean(X(out.mergID == i,: ));
end

% assign centroids
IresTC = X .* 0;
for i = 1:g
    IresTC(out.mergID == i, :) = Ires(out.mergID == i, :) + muTC(i,:);
end
IresTC(out.mergID == 0, :) = X(out.mergID == 0, :);

% white cells for outliers
a = [1, 1, 1];
IresTC(out.mergID == 0, :) = repmat(a, sum(out.mergID == 0), 1);
IresTCLUST = reshape(IresTC, size(I));


%% tk-merge

k = floor(log(n))*2;
txOpt.nocheck = 1;
txOpt.msg = 0;
txOpt.nomes = 1;
txOpt.plots = 1;
out = txmerge(X, k, g, 'alpha', alpha, 'plots', 1, 'txOpt', txOpt, 'dist', 0);

% compute centroids
Ires = X .* 0;
muTKM = zeros(g, size(X, 2));
for i = 1:g
    muTKM(i, :) = mean(X(out.mergID == i,: ));
end

% assign centroids
IresTKM = X .* 0;
for i = 1:g
    IresTKM(out.mergID == i, :) = Ires(out.mergID == i, :) + muTKM(i,:); % .* 255;
end
IresTKM(out.mergID == 0, :) = X(out.mergID == 0, :);

% white cells for outliers
a = [1, 1, 1];
IresTKM(out.mergID == 0, :) = repmat(a, sum(out.mergID == 0), 1);
IresTKM = reshape(IresTKM, size(I));


%% plot solution

a=2; 
b=2; 

figure
subplot(a, b, 1)
% subplot(1, 2, 1)
image(I)
title('Original')
subplot(a, b, 2)
% subplot(1, 2, 2)
image(IresKM)
title('k-means')
subplot(a, b, 3)
image(IresTCLUST)
title('TCLUST')
subplot(a, b, 4)
image(IresTKM)
title('tk-merge')


