%%
% Edited with MATLAB R2019b on Win10.

%Load PVT.mat.
clear;clc;
load F0_PVT;

%Reshape the PVT data into a 60*3 array.
p_raw = data_matrix(:,:,1);v_raw = data_matrix(:,:,2);t_raw = data_matrix(:,:,3);

p_all = [];v_all = [];t_all = [];
for i = [1:size(p_raw,1)]
    p_all = [p_all,p_raw(i,:)];v_all = [v_all,v_raw(i,:)];t_all = [t_all,t_raw(i,:)];
end

pvt_raw = [p_all;v_all;t_all]';

%Normalize the data.
pvt = zscore(pvt_raw);
%%
%Compute the actual center(mean) for each obj.
avgs = [];
for i = [1:10:60]
    p_avg = mean(pvt(i:i+9,1));v_avg = mean(pvt(i:i+9,2));t_avg = mean(pvt(i:i+9,3));
    avg = [p_avg,v_avg,t_avg];
    avgs = [avgs;avg];
end
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
[idx,C,sumd,D] = kmeans(pvt,k,'Display','final','Distance',dm,'Start','sample');
disp("Elbow plot can be obtained with Microsoft Excel.");
%%
%Plot the result of clustering.
figure;
%plot the standardized pvt data.
scatter3(pvt(1:10,1),pvt(1:10,2),pvt(1:10,3),'r','filled');hold on;
scatter3(pvt(11:20,1),pvt(11:20,2),pvt(11:20,3),'g','filled');hold on;
scatter3(pvt(21:30,1),pvt(21:30,2),pvt(21:30,3),'b','filled');hold on;
scatter3(pvt(31:40,1),pvt(31:40,2),pvt(31:40,3),'k','filled');hold on;
scatter3(pvt(41:50,1),pvt(41:50,2),pvt(41:50,3),'m','filled');hold on;
scatter3(pvt(51:60,1),pvt(51:60,2),pvt(51:60,3),'y','filled','MarkerEdgeColor','k');hold on;
%plot the centriods
plot3(C(:,1),C(:,2),C(:,3),'x','Color','#808080','MarkerSize',15,'LineWidth',3),grid on;
%plot real centers
plot3(avgs(1,1),avgs(1,2),avgs(1,3),'x','Color','r','MarkerSize',15,'LineWidth',3);
plot3(avgs(2,1),avgs(2,2),avgs(2,3),'x','Color','g','MarkerSize',15,'LineWidth',3);
plot3(avgs(3,1),avgs(3,2),avgs(3,3),'x','Color','b','MarkerSize',15,'LineWidth',3);
plot3(avgs(4,1),avgs(4,2),avgs(4,3),'x','Color','k','MarkerSize',15,'LineWidth',3);
plot3(avgs(5,1),avgs(5,2),avgs(5,3),'x','Color','m','MarkerSize',15,'LineWidth',3);
plot3(avgs(6,1),avgs(6,2),avgs(6,3),'x','Color','y','MarkerSize',15,'LineWidth',3);
axis equal;
hold on;
legend('Acrylic','Black Foam','Car Sponge','Flour Sack','Kitchen Sponge','Steel Vase','Centriods');
hold on;
title 'Cluster Assignments and Centroids'
hold off
%%
%Evaluation against the ground truth.
%Generate labels.
Y = [];
for i = [1:6]
    Y = [Y,i*ones(1,10)];
end
Y = Y';

%Compute the purity.
Pur = Purity(Y,idx);
%Compute the Normalized Mutual Info.
NMI = nmi(Y, idx);

disp("Purity is");disp(Pur);
disp("NMI is");disp(NMI);
%%
function score = Purity(labels, clusters)
%PURITY - calculates purity to evaluate clustering
% score=Purity(labels, clusters)  where labels assigns the
% ground truth and clusters is the clustering assignment.
assert(length(labels) == length(clusters));
overlap = 0;
u_clusters = unique(clusters);
for i = 1:length(u_clusters)
    k = u_clusters(i);
    % Find best cluster for this label
    assignments = labels(clusters == k);
    overlap = overlap + sum(assignments == mode(assignments));
end

score = overlap / length(labels);
end

function z = nmi(x, y)
% Compute normalized mutual information I(x,y)/sqrt(H(x)*H(y)) of two discrete variables x and y.
% Input:
%   x, y: two integer vector of the same length 
% Ouput:
%   z: normalized mutual information z=I(x,y)/sqrt(H(x)*H(y))
% Written by Mo Chen (sth4nth@gmail.com).
assert(numel(x) == numel(y));
n = numel(x);
x = reshape(x,1,n);
y = reshape(y,1,n);

l = min(min(x),min(y));
x = x-l+1;
y = y-l+1;
k = max(max(x),max(y));

idx = 1:n;
Mx = sparse(idx,x,1,n,k,n);
My = sparse(idx,y,1,n,k,n);
Pxy = nonzeros(Mx'*My/n); %joint distribution of x and y
Hxy = -dot(Pxy,log2(Pxy));


% hacking, to elimative the 0log0 issue
Px = nonzeros(mean(Mx,1));
Py = nonzeros(mean(My,1));

% entropy of Py and Px
Hx = -dot(Px,log2(Px));
Hy = -dot(Py,log2(Py));

% mutual information
MI = Hx + Hy - Hxy;

% normalized mutual information
z = sqrt((MI/Hx)*(MI/Hy));
z = max(0,z);
end

