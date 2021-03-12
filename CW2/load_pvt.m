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

pvt = [p_all;v_all;t_all]';