objects = ["acrylic_211", "black_foam_110", "car_sponge_101", "flour_sack_410", "kitchen_sponge_114", "steel_vase_702"];

data_matrix = zeros(6,10,3);
electrode_matrix = zeros(6,19,10);

index_val = 400;

two_dim_matrix = zeros(60,3);

for i = 1:6
    for j = 1:9
        load(strcat(objects(i),"_","0",num2str(j),"_HOLD.mat"))
        data_matrix(i,j,1) = F0pdc(index_val);
        data_matrix(i,j,2) = F0pac(2,index_val);
        data_matrix(i,j,3) = F0tdc(index_val);
        electrode_matrix(i,:,j) = F0Electrodes(:,index_val); 
        two_dim_matrix((i-1)*10+j,1) = F0pdc(index_val);
        two_dim_matrix((i-1)*10+j,2) = F0pac(2,index_val);
        two_dim_matrix((i-1)*10+j,3) = F0tdc(index_val);
        
        
    end
        load(strcat(objects(i),"_","10","_HOLD.mat"));
        data_matrix(i,10,1) = F0pdc(index_val);
        data_matrix(i,10,2) = F0pac(2,index_val);
        data_matrix(i,10,3) = F0tdc(index_val);
        electrode_matrix(i,:,10) = F0Electrodes(:,index_val); 
        two_dim_matrix((i-1)*10+10,1) = F0pdc(index_val);
        two_dim_matrix((i-1)*10+10,2) = F0pac(2,index_val);
        two_dim_matrix((i-1)*10+10,3) = F0tdc(index_val);
end

save('F0_PVT.mat',"data_matrix", "electrode_matrix","two_dim_matrix")
