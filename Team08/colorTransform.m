function output = colorTransform(source, target)

%source = im2double(imread('test3_ehsi.jpg'));
%target = im2double(imread('scotland_plain.jpg'));

[x,y,z] = size(source);
img_s = reshape(im2double(source),[],3);
img_t = reshape(im2double(target),[],3);

a = [0.3811 0.5783 0.0402;0.1967 0.7244 0.0782;0.0241 0.1288 0.8444];
b = [1/sqrt(3) 0 0;0 1/sqrt(6) 0;0 0 1/sqrt(2)];
c = [1 1 1;1 1 -2;1 -1 0];
b2 = [sqrt(3)/3 0 0;0 sqrt(6)/6 0;0 0 sqrt(2)/2];
c2 = [1 1 1;1 1 -1;1 -2 0];

img_s = max(img_s,1/255);
img_t = max(img_t,1/255);

% RGB 轉換到 LMS
LMS_s = a*img_s';
LMS_t = a*img_t';

% 取對數後的 LMS 數
LMS_s = log10(LMS_s);
LMS_t = log10(LMS_t);

% 轉到 lab 空間
lab_s = b*c*LMS_s;
lab_t = b*c*LMS_t;

% 計算參考影像lab空間的 Lαβ平均值、標準差
mean_s = mean(lab_s,2);
std_s = std(lab_s,0,2);

% 計算待轉影像lab空間的 Lαβ平均值、標準差
mean_t = mean(lab_t,2);
std_t = std(lab_t,0,2);

res_lab = zeros(3,x*y);

sf = std_t./std_s;

for ch = 1:3 % for each channel, apply the statistical alignment
    res_lab(ch,:) = (lab_s(ch,:) - mean_s(ch))*sf(ch) + mean_t(ch);
end

% 轉換回 LMS 空間
LMS_res=c2*b2*res_lab;
for ch = 1:3
    LMS_res(ch,:) = 10.^LMS_res(ch,:);
end

%  LMS 轉回到 RGB 色彩空間
est_im = ([4.4679 -3.5873 0.1193;-1.2186 2.3809 -0.1624;0.0497 -0.2439 1.2045]*LMS_res)';
est_im = reshape(est_im,size(source)); 

%{
figure;
subplot(1,3,1); imshow(source); title('Original Image'); axis off
subplot(1,3,2); imshow(target); title('Target Palette'); axis off
subplot(1,3,3); imshow(est_im); title('Result After Colour Transfer'); axis off
%}
output = est_im;
end