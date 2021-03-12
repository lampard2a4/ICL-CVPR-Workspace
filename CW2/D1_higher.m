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
Y = pdist(pvt,dm);
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
    plot3(pvt(T==i,1),pvt(T==i,2),pvt(T==i,3),'.','MarkerSize',12);
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

