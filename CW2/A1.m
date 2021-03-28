black_foam = zeros(1,1000);
car_sponge = zeros(1,1000);

%black_foam_110 and car_sponge_101 for PAC (vibration)
%This loads up each file, adds it to the running total and finally plots
%the average.


load("black_foam_110_01_HOLD.mat")
black_foam = black_foam + F0pac(2,:);
load("black_foam_110_02_HOLD.mat")
black_foam = black_foam + F0pac(2,:);
load("black_foam_110_03_HOLD.mat")
black_foam = black_foam + F0pac(2,:);
load("black_foam_110_04_HOLD.mat")
black_foam = black_foam + F0pac(2,:);
load("black_foam_110_05_HOLD.mat")
black_foam = black_foam + F0pac(2,:);
load("black_foam_110_06_HOLD.mat")
black_foam = black_foam + F0pac(2,:);
load("black_foam_110_07_HOLD.mat")
black_foam = black_foam + F0pac(2,:);
load("black_foam_110_08_HOLD.mat")
black_foam = black_foam + F0pac(2,1:1000);
load("black_foam_110_09_HOLD.mat")
black_foam = black_foam + F0pac(2,:);
load("black_foam_110_10_HOLD.mat")
black_foam = black_foam + F0pac(2,:);


load("car_sponge_101_01_HOLD.mat")
car_sponge = car_sponge + F0pac(2,:);
load("car_sponge_101_02_HOLD.mat")
car_sponge = car_sponge + F0pac(2,:);
load("car_sponge_101_03_HOLD.mat")
car_sponge = car_sponge + F0pac(2,:);
load("car_sponge_101_04_HOLD.mat")
car_sponge = car_sponge + F0pac(2,:);
load("car_sponge_101_05_HOLD.mat")
car_sponge = car_sponge + F0pac(2,:);
load("car_sponge_101_06_HOLD.mat")
car_sponge = car_sponge + F0pac(2,:);
load("car_sponge_101_07_HOLD.mat")
car_sponge = car_sponge + F0pac(2,:);
load("car_sponge_101_08_HOLD.mat")
car_sponge = car_sponge + F0pac(2,:);
load("car_sponge_101_09_HOLD.mat")
car_sponge = car_sponge + F0pac(2,:);
load("car_sponge_101_10_HOLD.mat")
car_sponge = car_sponge + F0pac(2,:);

black_foam_avg = black_foam/10;
car_sponge_avg = car_sponge/10;
x_axis = [1:1000];


subplot(2,1,1);
hold on
plot(x_axis,black_foam_avg,'green');
plot(x_axis,car_sponge_avg,'blue');
xlabel("Time Step")
ylabel("Average Vibration Value")
title("Time Step against Average Vibration Value for Black Foam and Car Sponge")
legend([{'Black Foam'},{'Car Sponge'}]);
hold off

%Plots the steel vase values for all trials, and computes the average to
%plot this as well for all timesteps.


steel_vase = zeros(1,1000);
subplot(2,1,2);
hold on;
load("steel_vase_702_01_HOLD.mat")
plot(F0tdc);
steel_vase = steel_vase + F0tdc;
load("steel_vase_702_02_HOLD.mat")
plot(F0tdc);
steel_vase = steel_vase + F0tdc;
load("steel_vase_702_03_HOLD.mat")
plot(F0tdc);
steel_vase = steel_vase + F0tdc;
load("steel_vase_702_04_HOLD.mat")
plot(F0tdc);
steel_vase = steel_vase + F0tdc;
load("steel_vase_702_05_HOLD.mat")
plot(F0tdc);
steel_vase = steel_vase + F0tdc;
load("steel_vase_702_06_HOLD.mat")
plot(F0tdc);
steel_vase = steel_vase + F0tdc;
load("steel_vase_702_07_HOLD.mat")
plot(F0tdc);
steel_vase = steel_vase + F0tdc;
load("steel_vase_702_08_HOLD.mat")
plot(F0tdc);
steel_vase = steel_vase + F0tdc(:,1:1000);
load("steel_vase_702_09_HOLD.mat")
plot(F0tdc);
steel_vase = steel_vase + F0tdc;
load("steel_vase_702_10_HOLD.mat")
plot(F0tdc);
steel_vase = steel_vase + F0tdc;

steel_vase_avg = steel_vase/10;
x_axis = [1:1000];
plot(x_axis,steel_vase_avg);

legend([{'Trial 1'},{'Trial 2'}, {'Trial 3'}, {'Trial 4'}, {'Trial 5'}, ...
    {'Trial 6'}, {'Trial 7'}, {'Trial 8'}, {'Trial 9'}, {'Trial 10'}, ...
    {'Averaged Results'}])

xlabel("Time Step")
ylabel("Temperature Value")
title("Time Step against Temperature Value for Steel Vase")


hold off;
