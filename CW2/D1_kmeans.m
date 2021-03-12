%%
% Edited with MATLAB R2019b on Win10.

%Load PVT.mat.
clear;clc;
load F0_PVT-1;
p_raw = data_matrix(:,:,1);v_raw = data_matrix(:,:,2);t_raw = data_matrix(:,:,3);

p_all = [];v_all = [];t_all = [];
for i = [1:size(p_raw,1)]
    p_all = [p_all,p_raw(i,:)];v_all = [v_all,v_raw(i,:)];t_all = [t_all,t_raw(i,:)];
end

pvt_raw = [p_all;v_all;t_all]';
%Standardize the data.
pvt = zscore(pvt_raw);
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
[idx,C,sumd,D] = kmeans(pvt,k,'Display','final','Distance',dm);
disp("Elbow plot can be obtained with Microsoft Excel.");
%%
%Plot the result of clustering.
figure;
lgds=[];
for i = 1:k
    plot3(pvt(idx==i,1),pvt(idx==i,2),pvt(idx==i,3),'.','MarkerSize',12);
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
title 'Cluster Assignments and Centroids'
hold off

