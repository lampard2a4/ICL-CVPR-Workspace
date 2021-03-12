%%
% Edited with MATLAB R2019b on Win10.

%Load 3D electrode data.
clear;clc;
load electrodes3D;
%Standardize the data.
elec3D = zscore(dim_down3D);
%%
%Select number of clusters
k = input('Please input the number of clusters(>=2): ');

%and distance metric.
disp("Please select the distance metric inputting corresponding number.");
disp("1 for euclidean.");
disp("2 for manhattan.");
disp("3 for cosine.");
disp("4 for correlation.");
dm = input("Please select: ");
switch dm
    case 1
        dm = 'euclidean';
    case 2
        dm = 'cityblock';
    case 3
        dm = 'cosine';
    case 4
        dm = 'correlation';
    otherwise
        dm = 'euclidean';
end

%Commence hierarchy clustering.
Y = pdist(elec3D,dm);
Z = linkage(Y,'average');
c = cophenet(Z,Y);
disp("Cophenetic correlation coefficient of the chosen distance metric: ");
disp(c);
%Display the dendrogram.
figure;
dendrogram(Z);
T = cluster(Z,'MaxClust',k);
disp("Elbow plot can be obtained with Microsoft Excel.");
%%
%Plot the result of clustering.
figure;
lgds=[];
for i = 1:k
    plot3(elec3D(T==i,1),elec3D(T==i,2),elec3D(T==i,3),'.','MarkerSize',12);
    hold on;
    cur_lgd = ['Cluster',' ',int2str(i)];
    cur_lgd = join(cur_lgd);
    lgds = [lgds,{cur_lgd}];
end
lgds = lgds';
legend(lgds,'Location','NW');
hold on;
title 'Cluster Assignments and Centroids'
hold off
%%
