objects = ["acrylic_211", "black_foam_110", "car_sponge_101", "flour_sack_410", "kitchen_sponge_114", "steel_vase_702"];

%Creating the empty matrices to store data in. The data matrix is a 3x3
%matrix, with the third dimension constituting of the P,V,T values.

%The two_dim_matrix is a 2D flattened structure. Each column in this matrix
%represents the P,V,T values.


data_matrix = zeros(6,10,3);
electrode_matrix = zeros(6,19,10);
two_dim_matrix = zeros(60,3);


%This is where the index/timestep is chosen. If the timestep is desired to
%be modified, this value is to be changed.
index_val = 31;



for i = 1:6
    for j = 1:9
        load(strcat(objects(i),"_","0",num2str(j),"_HOLD.mat"))
        data_matrix(i,j,1) = F0pdc(index_val);
        %as the PAC is a 22x1000 matrix have to pick the 2nd row
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


%saves the output

save('F0_PVT.mat',"data_matrix","two_dim_matrix")
%save("electrode_matrix.mat", "electrode_matrix")
