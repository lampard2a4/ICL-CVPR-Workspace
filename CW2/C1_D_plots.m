%acrylic and kitchen_sponge

new_objects_normalized = normalize(two_dim_matrix([1:10,41:50],:));


% from the 2D matrix, we are interested in acrylic and kitchen sponge
% these are indices 1 to 10 for black foam and 41 to 50 for kitchen sponge

% The data is normalised after selecting values from these two objects, as
% this ensures a better spread due to the non-linearity of the
% normalization transformation


acrylic = new_objects_normalized(1:10,:);

kitchen_sponge = new_objects_normalized(11:20,:);

pvt_eig_matrix = lda_function(acrylic,kitchen_sponge,3);


figure(1)
graph_plotter_3D(acrylic, kitchen_sponge, pvt_eig_matrix, "Pressure", "Vibration", "Temperature", "PVT LDA Graph")
figure(2)
lda_plotter_2D(pvt_eig_matrix,acrylic,kitchen_sponge,"2D LDA Projected PVT Plot" )
figure(3)
lda_plotter(pvt_eig_matrix,acrylic,kitchen_sponge,"1D LDA Projected PVT Plot" )




acrylic_pv = acrylic(:,1:2);
kitchen_sponge_pv = kitchen_sponge(:,1:2);


pv_eig_matrix = lda_function(acrylic_pv,kitchen_sponge_pv,2);

figure(4)
lda_plotter(pv_eig_matrix,acrylic_pv,kitchen_sponge_pv, "LDA Projected PV plot")
figure(5)
graph_plotter_2D(acrylic_pv, kitchen_sponge_pv, pv_eig_matrix, "Pressure" , "Vibration" , "Pressure vs. Vibration LDA graph")



acrylic_vt = acrylic(:,2:3);
kitchen_sponge_vt = kitchen_sponge(:,2:3);

vt_eig_matrix = lda_function(acrylic_vt,kitchen_sponge_vt,2);

figure(6)
lda_plotter(vt_eig_matrix,acrylic_vt,kitchen_sponge_vt, "LDA Projected VT plot")
figure(7)
graph_plotter_2D(acrylic_vt, kitchen_sponge_vt, vt_eig_matrix, "Vibration" , "Temperature" , "Vibration vs. Temperature LDA graph")


acrylic_pt = acrylic(:,[1,3]);
kitchen_sponge_pt = kitchen_sponge(:,[1,3]);

pt_eig_matrix = lda_function(acrylic_pt,kitchen_sponge_pt,2);

figure(8)
lda_plotter(pt_eig_matrix,acrylic_pt,kitchen_sponge_pt, "LDA Projected PT plot")
figure(9)
graph_plotter_2D(acrylic_pt, kitchen_sponge_pt, pt_eig_matrix, "Pressure" , "Temperature" , "Pressure vs. Temperature LDA graph")



function lda_plotter_2D(eig_matrix,class1,class2,title_var)
    
    %3D to 2D transformation is done by multiplying the eigenvalues by the
    %respective coordinates to get new (x,y) key value pair. 1x3 x 3x10
    %gives us a 1x10 output for x and y respectively.
    
    class1_projected_x = eig_matrix(:,1).' * class1.';
    class2_projected_x = eig_matrix(:,1).' * class2.';
    
    class1_projected_y = eig_matrix(:,2).' * class1.';
    class2_projected_y = eig_matrix(:,2).' * class2.';
    
 
    
    scatter(class1_projected_x,class1_projected_y,'red', 'filled');
    hold on;
    title(title_var);
    grid on;
    scatter(class2_projected_x,class2_projected_y,'magenta', 'filled');
    xlim([-3 3])
    ylim([-3 3])
    xlabel("LDA1");
    ylabel("LDA2");
    
    legend([{'Acrylic'},{'Kitchen Sponge'}]);
    hold off;

    
end







function lda_plotter(eig_matrix,class1,class2,title_var)
    
    %2D to 1D transformation is done by multiplying the eigenvalues by the
    %respective coordinates to get new x value. 1xn x nx10
    %gives us a 1x10 output for the 1d axis
    
    class1_projected = eig_matrix(:,1).' * class1.';
    class2_projected = eig_matrix(:,1).' * class2.';
    
    boundary = eig_matrix(:,1).' * eig_matrix(:,2);
    
    scatter(class1_projected,zeros(1,10),'red', 'filled');
    hold on;
    title(title_var);
    grid on;
    scatter(class2_projected,zeros(1,10),'magenta', 'filled');
    xlim([-2,2])
    ylim([-2,2])
    xlabel("LDA 1");
    
    xline(boundary,'--','Color',[0.494,0.184,0.557], 'LineWidth', 3)
    
    legend([{'Acrylic'},{'Kitchen Sponge'},{'Decision Boundary'}]);
    hold off;

    
end



function eigen_matrix = lda_function(class1,class2,dimension)
    %class1 and class2 are a 10x2 or 10x3 matrices
    %dimension is an integer, either 2 or 3
    
    %calculate class mean
    class1_mean = mean(class1);
    class2_mean = mean(class2);
    
    
    %create empty vector for within class matrix
    class1_within_class = zeros(1,dimension);
    class2_within_class = zeros(1,dimension);
    
    for i = 1:10
        %this loop sums across all the trials for each object, and adds the
        %squared error calculating the within class scatter matrix.
        class1_within_class = class1_within_class + ((class1(i,:) - class1_mean).' * (class1(i,:) - class1_mean)); 
        class2_within_class = class2_within_class + ((class2(i,:) - class2_mean).' * (class2(i,:) - class2_mean)); 
    end
    
    
    Sw = class1_within_class + class2_within_class;
    
    Sb = (class1_mean - class2_mean).' * (class1_mean - class2_mean);
    %Sw and Sb are calculated as per formulas in the slides.
    
    
    %inv is used instead of Sw\Sb, as it was found to give better accuracy.
    %However, this depends on the dataset being used, as for different
    %index value it was found that Sw\Sb gave better results. For both
    %methods, the first/primary eigenvector doesn't change but the
    %other/other two (depending on dimension) did change. 
    combined_matrix = inv(Sw) * Sb;
   
   
    [eigen_matrix, eigen_val] = eig(combined_matrix);
    
    [diag_val,indices] = sort(diag(eigen_val),'descend');
    
    disp(eigen_matrix)
    
    eigen_matrix = eigen_matrix(:,indices);
    
    %display below for debugging purposes. The above code sorts the
    %eigenvectors in descending eigenvalue order.
    disp(eigen_matrix)
end


function graph_plotter_2D(class1, class2, eigen_matrix, axis1_label, axis2_label,title_label)
    %Simple function to plot a 2D graph, given two classes.
    
    scatter(class1(:,1),class1(:,2),'red', 'filled');
    hold on;
    title(title_label);
    xlabel(axis1_label);
    ylabel(axis2_label);
    scatter(class2(:,1),class2(:,2),'magenta', 'filled');
    
    x = (-10: 0.5: 10);
    
    %polyfit was used as this allows for a continually straight line. 
    polynomial_val_lda_1 = polyfit([0,eigen_matrix(1,1)], [0,eigen_matrix(2,1)], 1);
    y_val_lda_1 = polyval(polynomial_val_lda_1,x);

    polynomial_val_lda_2 = polyfit([0,eigen_matrix(1,2)], [0,eigen_matrix(2,2)], 1);
    y_val_lda_2 = polyval(polynomial_val_lda_2,x);
    
    plot(x,y_val_lda_1, 'Color', '#00FFFF')
    plot(x,y_val_lda_2, 'Color', '#7E2F8E')
    
    grid on
    
    
    xlim([-3 3])
    ylim([-3 3])

    legend([{'Acrylic'},{'Kitchen Sponge'},{'LDA 1'},{'LDA 2'}])
    
    hold off
    
end


function graph_plotter_3D(class1, class2, eigen_matrix, axis1_label, axis2_label,axis3_label, title_label)
    %simple 3d plotter
    
    scatter3(class1(:,1),class1(:,2),class1(:,3), 'red', 'filled');
    hold on;
    title(title_label);
    xlabel(axis1_label);
    ylabel(axis2_label);
    zlabel(axis3_label);
    scatter3(class2(:,1),class2(:,2),class2(:,3),'magenta', 'filled');
   
    
    %plot used instead of polyfit because polyfit doesn't work for 3D. 
    plot3([0 eigen_matrix(1,1)], [0 eigen_matrix(2,1)], [0 eigen_matrix(3,1)], 'Color', '#00FFFF');
    
    plot3([0 eigen_matrix(1,2)], [0 eigen_matrix(2,2)], [0 eigen_matrix(3,2)], 'Color', '#7E2F8E');
    
    plot3([0 eigen_matrix(1,3)], [0 eigen_matrix(2,3)], [0 eigen_matrix(3,3)], 'Color', '#EDB120');
    
    
    grid on
    
    
    xlim([-3 3])
    ylim([-3 3])
    zlim([-3 3])

    legend([{'Acrylic'},{'Kitchen Sponge'},{'LDA 1'},{'LDA 2'},{'LDA 3'}])
    
    hold off
    
end


