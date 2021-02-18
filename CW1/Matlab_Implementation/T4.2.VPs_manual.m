%%
%load the image.
I1 = rgb2gray(imread('fd_1_3.jpg'));

%If misoriented, rotate the image
%I1 = imrotate(I1,-90);
%%
%manual sampling vanishing points
figure;
imshow(I1);

%select a pair of lines that will converge to a vanishing point
%and calculate

%select two crossing lines of the first vanishing point.
%one by one.
[x1,y1] = getpts();

%compute the coefficients for the first pair of crosing lines
k1=(y1(2)-y1(1))/(x1(2)-x1(1));
k2=(y1(4)-y1(3))/(x1(4)-x1(3));
a1=k1;b1=-1;c1=y1(1)-k1*x1(1);
d1=k2;e1=-1;f1=y1(3)-k2*x1(3);

%get the first crossing point
%which is also the first vanishing point
X1=(c1*e1-b1*f1)/(b1*d1-a1*e1);Y1=(a1*f1-c1*d1)/(b1*d1-a1*e1);
VP1=round([X1,Y1]);
%%
%find another vanishing point
figure;
imshow(I1);
[x2,y2] = getpts();
k3=(y2(2)-y2(1))/(x2(2)-x2(1));
k4=(y2(4)-y2(3))/(x2(4)-x2(3));

a2=k3;b2=-1;c2=y2(1)-k3*x2(1);
d2=k4;e2=-1;f2=y2(3)-k4*x2(3);

X2=(c2*e2-b2*f2)/(b2*d2-a2*e2);Y2=(a2*f2-c2*d2)/(b2*d2-a2*e2);
VP2=round([X2,Y2]);
%%
%get the horizon with two different vanishing points
K=(VP2(2)-VP1(2))/(VP2(1)-VP1(1));
A=K;B=-1;C=VP1(2)-K*VP1(1);
%%
%disaplay vanishing points and the horizon.
figure;
imshow(I1);
hold on;
plot(VP1(1),VP1(2),'or');
plot(VP2(1),VP2(2),'or');
plot([VP2(1),VP1(1)],[VP2(2),VP1(2)],'g');