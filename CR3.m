% clear all;
load Data_CR3.mat

figure(3);clf;
plot3(Data_30D(Y_30D==0,1),Data_30D(Y_30D==0,2),Data_30D(Y_30D==0,3),'b.','MarkerSize',24);
hold on;
plot3(Data_30D(Y_30D==1,1),Data_30D(Y_30D==1,2),Data_30D(Y_30D==1,3),'r.','MarkerSize',24);

bL30 = LinFit(Data_30D,Y_30D);

xm = (1-.1*sign(min(Data_30D(:,1))))*min(Data_30D(:,1));
% x maximum
xM = (1+.1*sign(max(Data_30D(:,1))))*max(Data_30D(:,1));
% y minimum
ym = (1-.1*sign(min(Data_30D(:,15))))*min(Data_30D(:,15));
% y maximum
yM = (1+.1*sign(max(Data_30D(:,15))))*max(Data_30D(:,15));
[xx,yy] = meshgrid(linspace(xm,xM,101),linspace(ym, yM, 101));
zz = -(bL30(2)*xx+bL30(16)*yy+bL30(1)-1/2)/bL30(31);
h = surf(xx,yy,zz);
shading interp
axis off
plot3(Classify_Data30D(:,1),Classify_Data30D(:,2),Classify_Data30D(:,3),'kx','MarkerSize',24);
%zlim([0.05 .2])

figure(4);clf;
plot3(Data_30D(Y_30D==0,7),Data_30D(Y_30D==0,8),Data_30D(Y_30D==0,9),'b.','MarkerSize',24);
hold on;
plot3(Data_30D(Y_30D==1,7),Data_30D(Y_30D==1,8),Data_30D(Y_30D==1,9),'r.','MarkerSize',24);

bN3 = NonLinFit(Data_30D,Y_30D);
zz = -(bN3(2)*xx+bN3(3)*yy+bN3(1))/bN3(4);
h = surf(xx,yy,zz);
shading interp
axis off
%zlim([0.05 .2])

plot3(Classify_Data30D(:,1),Classify_Data30D(:,2),Classify_Data30D(:,3),'kx','MarkerSize',24);