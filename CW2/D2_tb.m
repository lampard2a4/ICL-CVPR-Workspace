%%
% Edited with MATLAB R2019b on Win10.

%Load 3D electrode data.
clear;clc;
load electrodes3D;

%Normalize the data.
X = zscore(dim_down3D);

%Generate labels.
Y = [];
for i = [1:6]
    Y = [Y,i*ones(1,10)];
end
Y = Y';
%%
%test_train_split of Matlab.

% For reproducibility.
rng('default');

%The ratio of the test set.
testRatio = 0.4;

%Generating the indices of the training set,
trainIndices = crossvalind('HoldOut', size(X, 1), testRatio);
%and the test set.
testIndices = ~trainIndices;

%The data and labels for the training set.
X_train = X(trainIndices, :);
Y_train = Y(trainIndices, :);

%The data and labels for the test set.
X_test = X(testIndices, :);
Y_test = Y(testIndices, :);
%%
%Visualization of training and test sets.

figure;
scatter3(X_train(Y_train == 1,1), X_train(Y_train == 1,2),X_train(Y_train == 1,3),'r','filled');hold on;
scatter3(X_train(Y_train == 2,1), X_train(Y_train == 2,2),X_train(Y_train == 2,3),'g','filled');hold on;
scatter3(X_train(Y_train == 3,1), X_train(Y_train == 3,2),X_train(Y_train == 3,3),'b','filled');hold on;
scatter3(X_train(Y_train == 4,1), X_train(Y_train == 4,2),X_train(Y_train == 4,3),'k','filled');hold on;
scatter3(X_train(Y_train == 5,1), X_train(Y_train == 5,2),X_train(Y_train == 5,3),'m','filled');hold on;
scatter3(X_train(Y_train == 6,1), X_train(Y_train == 6,2),X_train(Y_train == 6,3),'y','filled','MarkerEdgeColor','k');hold on;
grid on;axis equal;
legend('Acrylic','Black Foam','Car Sponge','Flour Sack','Kitchen Sponge','Steel Vase');
title('Training set');
hold off;

figure
scatter3(X_test(Y_test == 1,1), X_test(Y_test == 1,2),X_test(Y_test == 1,3),'r','filled');hold on;
scatter3(X_test(Y_test == 2,1), X_test(Y_test == 2,2),X_test(Y_test == 2,3),'g','filled');hold on;
scatter3(X_test(Y_test == 3,1), X_test(Y_test == 3,2),X_test(Y_test == 3,3),'b','filled');hold on;
scatter3(X_test(Y_test == 4,1), X_test(Y_test == 4,2),X_test(Y_test == 4,3),'k','filled');hold on;
scatter3(X_test(Y_test == 5,1), X_test(Y_test == 5,2),X_test(Y_test == 5,3),'m','filled');hold on;
scatter3(X_test(Y_test == 6,1), X_test(Y_test == 6,2),X_test(Y_test == 6,3),'y','filled','MarkerEdgeColor','k');hold on;
grid on;axis equal;
legend('Acrylic','Black Foam','Car Sponge','Flour Sack','Kitchen Sponge','Steel Vase');
title('Test set');
hold off;
%%
%Finding the Optimal Leaf Size.
%Manual optimazation is given below.
leaf = [1 2 4 8 16 32];
figure
for i=1:length(leaf)
    b = TreeBagger(100,X_train,Y_train,'Method','classification','OOBPrediction','On','MinLeafSize',leaf(i));grid on;
    pm = plot(oobError(b));
    pm.LineWidth = 2;
    hold on
end
xlabel('Number of Grown Trees');
ylabel('Mean Squared Error');
legend({'1' '2' '4' '8' '16' '32'},'Location','NorthEast');
title('Finding the optimal leaf size');
hold off
%%
%With the optimal leaf size, find the optimal number of trees.
optLeaf = 2;
b = TreeBagger(100,X_train,Y_train,'Method','classification','OOBPredictorImportance','On','MinLeafSize',optLeaf);
figure
pt = plot(oobError(b));pt.LineWidth = 2;grid on;hold on;
xlabel('Number of Grown Trees');
ylabel('Out-of-Bag Mean Squared Error');
title('Finding the number of trees');
hold off;
%%
%With the optimal leaf size and number of trees, reconstruct the
%final treebagger by changing the number of trees manually.
optTree = 22;
b = TreeBagger(optTree,X_train,Y_train,'Method','classification','OOBPredictorImportance','On','MinLeafSize',optLeaf);
figure
pf = plot(oobError(b));pf.LineWidth = 2;grid on;hold on;
xlabel('Number of Grown Trees');
ylabel('Out-of-Bag Mean Squared Error');
hold off;
%%
%D.2.b.
%Generate indices for trees to view.
r = randi([1 optTree],1,2);
%View two trees.
view(b.Trees{r(1,1)},'Mode','graph');
view(b.Trees{r(1,2)},'Mode','graph');
%%
%D.2.c
%Make predictions with trees generated.
ypred = predict(b, X_test);
Y_test = categorical(Y_test);

%Convert the prediction to categorical.
Y_pred = [];
for i = [1:24]
    tmp=str2num(cell2mat(ypred(i)));
    Y_pred = [Y_pred;tmp];
end
Y_pred = categorical(Y_pred);

%Plot the confusion matrix.
figure;
plotconfusion(Y_test,Y_pred);