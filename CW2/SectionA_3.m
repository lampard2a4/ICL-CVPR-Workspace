


scatter3(data_matrix(1,:,1),data_matrix(1,:,2),data_matrix(1,:,3), 'red', 'filled')
hold on

title("PVT plot for all objects");
xlabel('Pressure');
ylabel('Vibration');
zlabel('Temperature')
scatter3(data_matrix(2,:,1),data_matrix(2,:,2),data_matrix(2,:,3), 'green', 'filled')
scatter3(data_matrix(3,:,1),data_matrix(3,:,2),data_matrix(3,:,3), 'blue', 'filled')
scatter3(data_matrix(4,:,1),data_matrix(4,:,2),data_matrix(4,:,3), 'black', 'filled')
scatter3(data_matrix(5,:,1),data_matrix(5,:,2),data_matrix(5,:,3), 'magenta', 'filled')
scatter3(data_matrix(6,:,1),data_matrix(6,:,2),data_matrix(6,:,3), 'yellow', 'filled')
legend([{'Acrylic'},{'Black Foam'},{'Car Sponge'},{'Flour Sack'},{'Kitchen Sponge'},{'Steel Vase'}])

hold off