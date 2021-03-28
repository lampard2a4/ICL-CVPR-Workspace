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
%D.2.a
%Automatic tuning hyperparameters: finding the optimal MinLeafSize and NumLearningCycles(number of trees).
t = templateTree('Reproducible',true); % For reproducibiliy of random predictor selections
Mdl = fitcensemble(X_train,Y_train,'Method','Bag','Learners',t,'OptimizeHyperparameters',{'MinLeafSize','NumLearningCycles'});
%%
%D.2.b
r = randi([1 10],1,2);
%View two trees.
view(Mdl.Trained{r(1,1)},'Mode','graph');
view(Mdl.Trained{r(1,2)},'Mode','graph');
%%
%D.2.c
%Make predictions with trees generated.
ypred = predict(Mdl, X_test);
Y_test = categorical(Y_test);

%Convert the prediction to categorical.
Y_pred = categorical(ypred);

%Plot the confusion matrix.
figure;
plotconfusion(Y_test,Y_pred);