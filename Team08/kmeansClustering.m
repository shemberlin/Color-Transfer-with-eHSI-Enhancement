img = imread('source.png');
img = imresize(im2double(img), 0.2);
imgHSI = rgb2hsi(img);
[M, N] = size(imgHSI(:, :, 1));
H = imgHSI(:, :, 1);
S = imgHSI(:, :, 2);
I = imgHSI(:, :, 3);
Hv = H(:);
Sv = S(:);
Iv = I(:);
HSIv = [Hv/360, Sv, Iv];
C = kmeans(HSIv, 2);
C = reshape(C, [M, N]);
   for i = 1:max(C(:)) 
        figure();
        imshow(C==i);
    end