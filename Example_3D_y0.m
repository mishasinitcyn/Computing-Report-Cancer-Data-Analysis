% clear all;
load Data_CR3.mat

figure(3);clf;
plot3(Data_3D(Y_3D==0,1),Data_3D(Y_3D==0,2),Data_3D(Y_3D==0,3),'b.','MarkerSize',24);
hold on;
plot3(Data_3D(Y_3D==1,1),Data_3D(Y_3D==1,2),Data_3D(Y_3D==1,3),'r.','MarkerSize',24);
hold on;
bL3 = LinFit(Data_3D,Y_3D);
xm = (1-.1*sign(min(Data_3D(:,1))))*min(Data_3D(:,1));
xM = (1+.1*sign(max(Data_3D(:,1))))*max(Data_3D(:,1));
ym = (1-.1*sign(min(Data_3D(:,2))))*min(Data_3D(:,2));
yM = (1+.1*sign(max(Data_3D(:,2))))*max(Data_3D(:,2));
[xx,yy] = meshgrid(linspace(xm,xM,101),linspace(ym, yM, 101));
zz = -(bL3(2)*xx+bL3(3)*yy+bL3(1)-0.5)/bL3(4);
zz1 = -(bL3(2)*xx+bL3(3)*yy+bL3(1)-0.99)/bL3(4);
h = surf(xx,yy,zz);
h = surf(xx,yy,zz1);
shading interp
axis off
%plot3(Classify_Data3D(:,1),Classify_Data3D(:,2),Classify_Data3D(:,3),'kx','MarkerSize',24);
zlim([0.05 .2])

%bL3(3) = 1;

LFit = [];
for i=1:10 
    class = bL3(1);
    for j = 1:3
        class = class + Classify_Data3D(i,j)*bL3(j+1);
    end
    if class > 0.99
        LFit = [LFit, 1];
    else
        LFit = [LFit, 0];
    end
end

LFit

L1Fit = 0;

for i=1:559
    class = bN3(1);
    for j = 1:3
        class = class + Data_3D(i,j)*bL3(j+1);
    end
    if class > 0.99 && Y_3D(i) == 1
        L1Fit=L1Fit+1;
    elseif class < 0.99 && Y_3D(i) == 0
        L1Fit=L1Fit+1;
    end
end

L1Fit


plot3(Classify_Data3D(LFit==0,1),Classify_Data3D(LFit==0,2),Classify_Data3D(LFit==0,3),'cyan.','MarkerSize',24);
hold on;
plot3(Classify_Data3D(LFit==1,1),Classify_Data3D(LFit==1,2),Classify_Data3D(LFit==1,3),'magenta.','MarkerSize',24);
hold on;

figure(4);clf;
plot3(Data_3D(Y_3D==0,1),Data_3D(Y_3D==0,2),Data_3D(Y_3D==0,3),'b.','MarkerSize',24);
hold on;
plot3(Data_3D(Y_3D==1,1),Data_3D(Y_3D==1,2),Data_3D(Y_3D==1,3),'r.','MarkerSize',24);
hold on;
bN3 = NonLinFit(Data_3D,Y_3D);
zz = -(bN3(2)*xx+bN3(3)*yy+bN3(1))/bN3(4);
zz1 = (log(1/99)-bN3(2)*xx-bN3(3)*yy-bN3(1))/bN3(4);
h = surf(xx,yy,zz);
h1 = surf(xx,yy,zz1);
shading interp
axis off
zlim([0.05 .2])

%bN3(3) = 1;

NFit = [];
for i=1:10 
    class = bN3(1);
    for j = 1:3
        class = class + Classify_Data3D(i,j)*bN3(j+1);
    end
    class = 1/(1+exp(class));
    if class > 0.99
        NFit = [NFit, 1];
    else
        NFit = [NFit, 0];
    end
end

NFit

N1Fit = 0;

for i=1:559
    class = bN3(1);
    for j = 1:3
        class = class + Data_3D(i,j)*bN3(j+1);
    end
    class = 1/(1+exp(class));
    if class > 0.99 && Y_3D(i) == 1
        N1Fit=N1Fit+1;
    elseif class < 0.99 && Y_3D(i) == 0
        N1Fit=N1Fit+1;
    end
end

N1Fit

%plot3(Classify_Data3D(:,1),Classify_Data3D(:,2),Classify_Data3D(:,3),'kx','MarkerSize',24);
plot3(Classify_Data3D(NFit==0,1),Classify_Data3D(NFit==0,2),Classify_Data3D(NFit==0,3),'cyan.','MarkerSize',24);
hold on;
plot3(Classify_Data3D(NFit==1,1),Classify_Data3D(NFit==1,2),Classify_Data3D(NFit==1,3),'magenta.','MarkerSize',24);
