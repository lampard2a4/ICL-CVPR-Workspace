I = imread('eppr_raw.jpg');
epp=[9786, 9444];
figure;
imshow(I);
hold on;
plot(epp(1),epp(2),'or');