%% user setting
imfile = 'boletus1280.jpg'; % 'boletus1280.jpg' ; 'girl1280.jpg'
bw     = true; % true to convert to black and white
pnoise = 0.2;
filter = 4; % 1 = Non-adaptive WM; 2 = Adaptive WM; 3 = Structural WM; 4 = Wiener

%% read image
I    = imread(imfile);
if bw == 1, I = rgb2gray(I); end
Zori = double(I);      % keep original image
Z    = Zori;           % image to be manipulated
[row , col , rgb] = size(Z); % there is a third unused dimension for color images

%% add noise to the image
x    = rand(size(Z));
d    = x < pnoise/2;
Z(d) = 0;    % Set to minimum value
d    = find(x >= pnoise/2 & x < pnoise);
Z(d) = 255;  % Set to saturated value

%% Weighted mask for the Wiener filter
W = [10,12,9; 12,19,12; 9,12,10];
W = W ./ sum(sum(W)); W = W(:);

%% denoise with weighted median
tocwm = zeros((col-3)*(row-3),1); tocqs = tocwm;
Zclean_wm = Z(:);     % Filtered
Zclean_qs = Z(:);     % images
for qsw=0:1
    ii = 0;
    for y = 2:1:(col-1)*rgb
        for x = 2:1:row-1
            ind1 = x-1 + (y-1 - 1).*row; % = sub2ind([row,col],x-1,y-1);
            ind2 = x-1 + (y   - 1).*row; % = sub2ind([row,col],x-1,y);
            ind3 = x-1 + (y+1 - 1).*row; % = sub2ind([row,col],x-1,y+1);
            ind5 = x   + (y   - 1).*row; % = sub2ind([row,col],x,y);
            imask = [ind1; ind1+1; ind1+2; ind2; ind2+1; ind2+2; ind3; ind3+1; ind3+2];
            A = Z(imask);
            ii = ii+1;
            if qsw
                t0=tic;
                Zclean_qs(ind5) = quickselectFSw(A,W,0.5);
                tocqs(ii) = toc(t0);
            else
                t0=tic;
                [~ , Zclean_wm(ind5) , ~] = weightedMedian(A,W);
                tocwm(ii) = toc(t0);
            end
        end
    end
end
Zclean_wm = reshape(Zclean_wm,size(Z));
Zclean_qs = reshape(Zclean_qs,size(Z));
[~,mk] = maxk(tocwm,10); tocwm(mk)=median(tocwm);
[~,mk] = maxk(tocqs,10); tocqs(mk)=median(tocqs);
sumtocwm = sum(tocwm);
sumtocqs = sum(tocqs);

figure('Name','Original     '); imshow(uint8(Z));
figure('Name','Denoised qs  '); imshow(uint8(Zclean_qs))
figure('Name','Denoised wm  '); imshow(uint8(Zclean_wm))

disp(['etime - sort-based weighted median:    ',num2str(sumtocwm)]);
disp(['etime - quickselectFSw:                ',num2str(sumtocqs)]);

sumtocwm/sumtocqs

