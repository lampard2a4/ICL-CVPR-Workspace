%%
% Edited with MATLAB R2019b on Win10.

%Load PVT.mat.
clear;clc;
load electrode_matrix;
em = electrode_matrix;
clear electrode_matrix;
clear data_matrix;

%Reshape into a 60*19 array and keep the correspondences within indices.
e_reshape = [];
for e = [1:19]
    tmp = [];
    for t = [1:10]
        tmp = [tmp, em(:,e,t)]; 
    end
    flat = [];
    for i = [1:6]
        flat = [flat, tmp(i,:)];
    end
    e_reshape = [e_reshape, flat'];
end

clear e;clear flat;clear i;clear t;clear tmp;

%Normalize the data.
elec = zscore(e_reshape);
%%
%B.2.a.
cm = cov(elec);
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
%Project the electrode data into 3D PC space.
dim_down3D = elec*eve(:,1:3);

%Plot the result.
%X = PC1, Y = PC2, Z = PC3.
figure;
scatter3(dim_down3D(1:10,1),dim_down3D(1:10,2),dim_down3D(1:10,3),'r','filled');hold on;
scatter3(dim_down3D(11:20,1),dim_down3D(11:20,2),dim_down3D(11:20,3),'g','filled');hold on;
scatter3(dim_down3D(21:30,1),dim_down3D(21:30,2),dim_down3D(21:30,3),'b','filled');hold on;
scatter3(dim_down3D(31:40,1),dim_down3D(31:40,2),dim_down3D(31:40,3),'k','filled');hold on;
scatter3(dim_down3D(41:50,1),dim_down3D(41:50,2),dim_down3D(41:50,3),'m','filled');hold on;
scatter3(dim_down3D(51:60,1),dim_down3D(51:60,2),dim_down3D(51:60,3),'y','filled','MarkerEdgeColor','k');hold on;
grid on;axis equal;
xlabel({'PC1'});ylabel({'PC2'});zlabel({'PC3'});
hold on;
PC1_3D = plot3([0,1],[0,0],[0,0],'Color','#00FFFF');
PC1_3D.LineWidth = 3;
hold on;
PC2_3D = plot3([0,0],[0,1],[0,0],'Color','#7E2F8E');
PC2_3D.LineWidth = 3;
hold on;
PC3_3D = plot3([0,0],[0,0],[0,1],'Color','#EDB120');
PC3_3D.LineWidth = 3;
legend('Acrylic','Black Foam','Car Sponge','Flour Sack','Kitchen Sponge','Steel Vase','PC1','PC2','PC3');
hold off;
%%
%For E.c: Finding the electrodes to keep.
var =[];

%Transform into absolute values.
abs_eve = abs(eve);

%Find indices with the largest coefficients, which are contributions to
%PCs.
for i = [1:4]
    [M I] = maxk(abs_eve(:,i), 4, 1);
    var = [var,I];
end

%Look for 4 most significant variables. First by the place of principal
%components(column), second by the frequency.
disp(var);
%%
%Save the transformed electrode data.
save ('electrodes3D','dim_down3D');
save ('electrodesOri','e_reshape');