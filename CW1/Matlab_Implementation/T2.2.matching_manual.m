%Read the two images.
I1 = rgb2gray(imread('hg_2_2.jpg'));
I2 = rgb2gray(imread('hg_2_8.jpg'));

%I1 = imrotate(I1,-90);
%I2 = imrotate(I2,-90);


figure;
imshow(I1);
[x1,y1] = getpts();
matchedPoints1=[x1,y1];

figure;
imshow(I2);
[x2,y2] = getpts();
matchedPoints2=[x2,y2];


figure; ax = axes;
showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2,'montage','Parent',ax);
title(ax, 'Correspondences found manually');
legend(ax, 'Matched points 1','Matched points 2');