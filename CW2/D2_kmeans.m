%%
% Edited with MATLAB R2019b on Win10.

%Load 3D electrode data.
clear;clc;
load electrodes3D;
%Standardize the data.
elec3D = zscore(dim_down3D);
%%
%Select number of clusters
k = input('Please input the number of clusters: ');

%and distance metric.
disp("Please select the distance metric inputting corresponding number.");
disp("1 for euclidean.");
disp("2 for manhattan.");
disp("3 for cosine.");
disp("4 for correlation.");
dm = input("Please select: ");
switch dm
    case 1
        dm = 'sqeuclidean';
    case 2
        dm = 'cityblock';
    case 3
        dm = 'cosine';
    case 4
        dm = 'correlation';
    otherwise
        dm = 'sqeuclidean';
end

%Commence K Means clustering.
[idx,C,sumd,D] = kmeans(elec3D,k,'Display','final','Distance',dm);
disp("Elbow plot can be obtained with Microsoft Excel.");
%%
%Plot the result of clustering.
figure;
lgds=[];
for i = 1:k
    plot3(elec3D(idx==i,1),elec3D(idx==i,2),elec3D(idx==i,3),'.','MarkerSize',12);
    hold on;
    cur_lgd = ['Cluster',' ',int2str(i)];
    cur_lgd = join(cur_lgd);
    lgds = [lgds,{cur_lgd}];
end
plot3(C(:,1),C(:,2),C(:,3),'kx','MarkerSize',15,'LineWidth',3),grid on;
hold on;
lgds = [lgds,"Centroids"];
lgds = lgds';
legend(lgds,'Location','NW');
hold on;
title 'Cluster Assignments and Centroids of Electrode data'
hold off
%%


