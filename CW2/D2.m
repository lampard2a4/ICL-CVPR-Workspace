%%
% Edited with MATLAB R2019b on Win10.

%Load electrode data.
clear;clc;
load acrylic_211_01_HOLD;
%Change the table here.
elec_raw = F0Electrodes';
%Standardize the data.
elec = zscore(elec_raw);
%%
%B.2.a.
%eve = eigenvectors, eva = var = variances = eigenvalues.
[eve,score,var,tsquared,explained,mu] = pca(elec);

disp("Eigenvectors are:");
disp(eve);

disp("Respective variances are:");
disp(var);

x = [1:19]';

figure;
plot(x,var,'-r*'),grid on;
axis equal;
xlabel({'Place of the principal component'});ylabel({'Respective variance'});
%%
%B.2.b.
dim_down3D = elec*eve(:,1:3);

%X = PC1, Y = PC2, Z = PC3.
figure;
scatter3(dim_down3D(:,1),dim_down3D(:,2),dim_down3D(:,3),128,[0.9290 0.6940 0.1250],'.'),grid on;
xlabel({'PC1'});ylabel({'PC2'});zlabel({'PC3'});
hold on;
PC1_3D = plot3([0,1],[0,0],[0,0],'r');
PC1_3D.LineWidth = 3;
hold on;
PC2_3D = plot3([0,0],[0,1],[0,0],'g');
PC2_3D.LineWidth = 3;
hold on;
PC3_3D = plot3([0,0],[0,0],[0,1],'b');
PC3_3D.LineWidth = 3;
legend('3D Data','PC1','PC2','PC3');
axis equal;
%%
%Save the transformed electrode data.
save ('electrodes3D','dim_down3D');