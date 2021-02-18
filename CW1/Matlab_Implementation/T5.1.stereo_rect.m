%%
%Read the two images.
I1 = rgb2gray(imread('fd_1_8_und.jpg'));
I2 = rgb2gray(imread('fd_1_3_und.jpg'));

%I1 = imrotate(I1,-90);
%I2 = imrotate(I2,-90);

%Find the SURF features.
points1 = detectSURFFeatures(I1);
points2 = detectSURFFeatures(I2);

%Extract the features.
[f1,vpts1] = extractFeatures(I1,points1);
[f2,vpts2] = extractFeatures(I2,points2);

%Retrieve the locations of matched points.
indexPairs = matchFeatures(f1,f2) ;
matchedPoints1 = vpts1(indexPairs(:,1));
matchedPoints2 = vpts2(indexPairs(:,2));

%Find the fundamental matrix and inliers
[fLMedS,inliers] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,'NumTrials',4000);
disp('The Fundamental Matrix is:');
disp(fLMedS);
%%
%Show the inliers in the first image.
fig1=figure; 
imshow(I1); 
hold on;
plot(matchedPoints1.Location(inliers,1),matchedPoints1.Location(inliers,2),'go')
%Compute the epipolar lines in the first image.
epiLines = epipolarLine(fLMedS',matchedPoints2.Location(inliers,:));
%Compute the intersection pointsfdsafdas of the lines and the image border.
points = lineToBorderPoints(epiLines,size(I1));
%Show the epipolar lines in the first image
line(points(:,[1,3])',points(:,[2,4])');
truesize;
%%
fig2=figure; 
imshow(I2);
hold on;
plot(matchedPoints2.Location(inliers,1),matchedPoints2.Location(inliers,2),'go')
epiLines = epipolarLine(fLMedS,matchedPoints1.Location(inliers,:));
points = lineToBorderPoints(epiLines,size(I2));
line(points(:,[1,3])',points(:,[2,4])');
truesize;
%%
[isIn1,epipole1] = isEpipoleInImage(fLMedS,size(I1));
[isIn2,epipole2] = isEpipoleInImage(fLMedS',size(I2));
%%
[t1, t2] = estimateUncalibratedRectification(fLMedS,matchedPoints1,matchedPoints2,size(I2));
[I1Rect,I2Rect] = rectifyStereoImages(I1,I2,t1,t2);
%%
figure;
subplot(121);
imshow(I1Rect); 
subplot(122); 
imshow(I2Rect);
%%
I3 = imread('l.jpg');
I4 = imread('r.jpg');
[I3Rect,I4Rect] = rectifyStereoImages(I3,I4,t1,t2);
%%
figure;
subplot(121);
imshow(I3Rect); 
subplot(122); 
imshow(I4Rect);