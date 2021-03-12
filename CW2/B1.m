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
%cm = Corvariance Matrix, eve = eigenvectors, eva = eigenvalues.
cm = cov(pvt);
[eve,score,eva,tsquared,explained,mu] = pca(pvt);

%B.1.a.
disp("Corvariance Matrix is :");
disp(cm);

disp("Eigenvalues are :");
disp(eva);

disp("Eigenvectors are :");
disp(eve);
%%
%B.1.b.
figure;
%X = Pressure, Y = Vibrations, Z = Temperature.
scatter3(pvt(:,1),pvt(:,2),pvt(:,3),128,[0.9290 0.6940 0.1250],'.'),grid on;
axis equal;
xlabel({'Pressure'});ylabel({'Vibration'});zlabel({'Temperature'});
hold on;
pc1 = plot3([0,eve(1,1)],[0,eve(2,1)],[0,eve(3,1)],'r');
pc1.LineWidth = 3;
hold on;
pc2 = plot3([0,eve(1,2)],[0,eve(2,2)],[0,eve(3,2)],'g');
pc2.LineWidth = 3;
hold on;
pc3 = plot3([0,eve(1,3)],[0,eve(2,3)],[0,eve(3,3)],'b');
pc3.LineWidth = 3;
legend('Standardized Data','PC1','PC2','PC3');
%%
%B.1.c.
dim_down2D = pvt*eve(:,1:2);
%X = PC1, Y = PC2.
figure;
scatter(dim_down2D(:,1),dim_down2D(:,2),128,[0.9290 0.6940 0.1250],'.'),grid on;
axis equal;
xlabel({'PC1'});ylabel({'PC2'});
hold on;
PC1_2D = plot([0,1],[0,0],'r');
PC1_2D.LineWidth = 3;
hold on;
PC2_2D = plot([0,0],[0,1],'g');
PC2_2D.LineWidth = 3;
legend('2D Data','PC1','PC2');
%%
%B.1.d.
dim_down1D1 = pvt*eve(:,1:1);
dim_down1D2 = pvt*eve(:,2:2);
dim_down1D3 = pvt*eve(:,3:3);

figure;
subplot(3,1,1),grid on;
scatter(dim_down1D1(:,1), zeros(size(pvt,1),1),128,'r','.');
title('Data distribution on PC1');
hold on;
subplot(3,1,2);
scatter(dim_down1D2(:,1), zeros(size(pvt,1),1),128,'g','.');
title('Data distribution on PC2');
hold on;
subplot(3,1,3);
scatter(dim_down1D3(:,1), zeros(size(pvt,1),1),128,'b','.');
title('Data distribution on PC3');