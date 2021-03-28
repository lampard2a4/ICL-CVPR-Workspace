%%
% Edited with MATLAB R2019b on Win10.

%Load PVT.mat.
clear;clc;
load F0_PVT;

%Reshape into 60*3 array. Correspondences are embedded within indices.
p_raw = data_matrix(:,:,1);v_raw = data_matrix(:,:,2);t_raw = data_matrix(:,:,3);

p_all = [];v_all = [];t_all = [];
for i = [1:size(p_raw,1)]
    p_all = [p_all,p_raw(i,:)];v_all = [v_all,v_raw(i,:)];t_all = [t_all,t_raw(i,:)];
end

pvt_raw = [p_all;v_all;t_all]';

%Normalize the data.
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

%Standardize the PVT data with PCs.
pvt3D = pvt*eve;

%Plot the result.
figure;
grid on;
%X = Pressure, Y = Vibrations, Z = Temperature.
scatter3(pvt3D(1:10,1),pvt3D(1:10,2),pvt3D(1:10,3),'r','filled');hold on;
scatter3(pvt3D(11:20,1),pvt3D(11:20,2),pvt3D(11:20,3),'g','filled');hold on;
scatter3(pvt3D(21:30,1),pvt3D(21:30,2),pvt3D(21:30,3),'b','filled');hold on;
scatter3(pvt3D(31:40,1),pvt3D(31:40,2),pvt3D(31:40,3),'k','filled');hold on;
scatter3(pvt3D(41:50,1),pvt3D(41:50,2),pvt3D(41:50,3),'m','filled');hold on;
scatter3(pvt3D(51:60,1),pvt3D(51:60,2),pvt3D(51:60,3),'y','filled','MarkerEdgeColor','k');hold on;
axis equal;
xlabel({'PC1'});ylabel({'PC2'});zlabel({'PC3'});hold on;
pc1 = plot3([0,1],[0,0],[0,0],'Color','#00FFFF');hold on;
pc1.LineWidth = 3;
pc2 = plot3([0,0],[0,1],[0,0],'Color','#7E2F8E');hold on;
pc2.LineWidth = 3;
pc3 = plot3([0,0],[0,0],[0,1],'Color','#EDB120');hold on;
pc3.LineWidth = 3;
legend('Acrylic','Black Foam','Car Sponge','Flour Sack','Kitchen Sponge','Steel Vase','PC1','PC2','PC3');
hold off;
%%
%B.1.c.
%Project data to 2D PC space.
dim_down2D = pvt*eve(:,1:2);

%Plot the 2D result.
%X = PC1, Y = PC2.
figure;
scatter(dim_down2D(1:10,1),dim_down2D(1:10,2),'r','filled');hold on;
scatter(dim_down2D(11:20,1),dim_down2D(11:20,2),'g','filled');hold on;
scatter(dim_down2D(21:30,1),dim_down2D(21:30,2),'b','filled');hold on;
scatter(dim_down2D(31:40,1),dim_down2D(31:40,2),'k','filled');hold on;
scatter(dim_down2D(41:50,1),dim_down2D(41:50,2),'m','filled');hold on;
scatter(dim_down2D(51:60,1),dim_down2D(51:60,2),'y','filled','MarkerEdgeColor','k');hold on;
axis equal;grid on;
xlabel({'PC1'});ylabel({'PC2'});hold on;
PC1_2D = plot([0,1],[0,0],'Color','#00FFFF');hold on;
PC1_2D.LineWidth = 3;
PC2_2D = plot([0,0],[0,1],'Color','#7E2F8E');hold on;
PC2_2D.LineWidth = 3;
legend('Acrylic','Black Foam','Car Sponge','Flour Sack','Kitchen Sponge','Steel Vase','PC1','PC2');
hold off;
%%
%B.1.d.
%Project the PVT data to the spaces of each PC.
dim_down1D1 = pvt*eve(:,1:1);
dim_down1D2 = pvt*eve(:,2:2);
dim_down1D3 = pvt*eve(:,3:3);

%Plot the result.
figure;
subplot(3,1,1);
scatter(dim_down1D1(1:10,1), zeros(10,1),'r','filled');hold on;
scatter(dim_down1D1(11:20,1), zeros(10,1),'g','filled');hold on;
scatter(dim_down1D1(21:30,1), zeros(10,1),'b','filled');hold on;
scatter(dim_down1D1(31:40,1), zeros(10,1),'k','filled');hold on;
scatter(dim_down1D1(41:50,1), zeros(10,1),'m','filled');hold on;
scatter(dim_down1D1(51:60,1), zeros(10,1),'y','filled','MarkerEdgeColor','k');hold on;
grid on;xlim([-3 3]);
legend('Acrylic','Black Foam','Car Sponge','Flour Sack','Kitchen Sponge','Steel Vase');
title('Data distribution on PC1');
hold on;
subplot(3,1,2);
scatter(dim_down1D2(1:10,1), zeros(10,1),'r','filled');hold on;
scatter(dim_down1D2(11:20,1), zeros(10,1),'g','filled');hold on;
scatter(dim_down1D2(21:30,1), zeros(10,1),'b','filled');hold on;
scatter(dim_down1D2(31:40,1), zeros(10,1),'k','filled');hold on;
scatter(dim_down1D2(41:50,1), zeros(10,1),'m','filled');hold on;
scatter(dim_down1D2(51:60,1), zeros(10,1),'y','filled','MarkerEdgeColor','k');hold on;
grid on;xlim([-3 3]);
title('Data distribution on PC2');
hold on;
subplot(3,1,3);
scatter(dim_down1D3(1:10,1), zeros(10,1),'r','filled');hold on;
scatter(dim_down1D3(11:20,1), zeros(10,1),'g','filled');hold on;
scatter(dim_down1D3(21:30,1), zeros(10,1),'b','filled');hold on;
scatter(dim_down1D3(31:40,1), zeros(10,1),'k','filled');hold on;
scatter(dim_down1D3(41:50,1), zeros(10,1),'m','filled');hold on;
scatter(dim_down1D3(51:60,1), zeros(10,1),'y','filled','MarkerEdgeColor','k');hold on;
grid on;xlim([-3 3]);
title('Data distribution on PC3');
hold off;
%%
%For E.c: Finding sensors to keep.
var =[];

%Transform into absolute values.
abs_eve = abs(eve);

%Find indices with the largest coefficients.
for i = [1:2]
    [M I] = maxk(abs_eve(:,i), 2, 1);
    var = [var,I];
end

%Look for 2 most significant variables. First by the place of principal
%components(column), second by the frequency.
disp(var);