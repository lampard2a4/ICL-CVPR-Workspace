%Read the two images.
I1 = rgb2gray(imread('fd_1_8.jpg'));
I2 = rgb2gray(imread('fd_1_3.jpg'));

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

%Display the matching points. The data still includes several outliers, 
%but you can see the effects of rotation and scaling on the display of matched features.
figure; ax = axes;
showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2,'montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points 1','Matched points 2');

%Find the fundamental matrix and inliers
[fLMedS,inliers] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,'NumTrials',4000);
disp('The Fundamental Matrix is:');
disp(fLMedS);

%Show the inliers in the first image.
figure; 
subplot(121);
imshow(I1); 
title('Inliers and Epipolar Lines in First Image'); hold on;
plot(matchedPoints1.Location(inliers,1),matchedPoints1.Location(inliers,2),'go')
%Compute the epipolar lines in the first image.
epiLines = epipolarLine(fLMedS',matchedPoints2.Location(inliers,:));
%Compute the intersection pointsfdsafdas of the lines and the image border.
points = lineToBorderPoints(epiLines,size(I1));
%Show the epipolar lines in the first image
line(points(:,[1,3])',points(:,[2,4])');

subplot(122); 
imshow(I2);
title('Inliers and Epipolar Lines in Second Image'); hold on;
plot(matchedPoints2.Location(inliers,1),matchedPoints2.Location(inliers,2),'go')
epiLines = epipolarLine(fLMedS,matchedPoints1.Location(inliers,:));
points = lineToBorderPoints(epiLines,size(I2));
line(points(:,[1,3])',points(:,[2,4])');
truesize;

[isIn1,epipole1] = isEpipoleInImage(fLMedS,size(I1));
[isIn2,epipole2] = isEpipoleInImage(fLMedS',size(I2));