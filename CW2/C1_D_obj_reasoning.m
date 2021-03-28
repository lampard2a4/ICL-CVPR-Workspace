%1D Temperature plot for acrylic and kitchen sponge normalised


acrylic_kitchen_matrix = normalize(two_dim_matrix([1:10,41:50],:));


scatter(acrylic_kitchen_matrix(1:10,3),zeros(1,10), 'red', 'filled')
hold on

title("Temperature plot for Acrylic and Kitchen Sponge");
xlabel('Temperature');
scatter(acrylic_kitchen_matrix(11:20,3), zeros(1,10), 'magenta', 'filled')
legend([{'Acrylic'},{'Kitchen Sponge'}])

hold off