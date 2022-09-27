% clear all;
load Data_CR3.mat

%%Plot the cancerous data in blue and benign in red
figure(3);clf;
plot3(Data_3D(Y_3D==0,1),Data_3D(Y_3D==0,2),Data_3D(Y_3D==0,3),'b.','MarkerSize',24);
hold on;
plot3(Data_3D(Y_3D==1,1),Data_3D(Y_3D==1,2),Data_3D(Y_3D==1,3),'r.','MarkerSize',24);

%{    LINEAR FIT    %}
%{
    bL3 contains the B0,B1,B2,B3 basis values in the linear fit  
    I rewrote the lines for readability
    Data_3D: Training Set
    Classify_Data3D: Test Set
%}

bL3 = LinFit(Data_3D,Y_3D);
xm = (1-0.1)*min(Data_3D(:,1));
xM = (1+0.1)*max(Data_3D(:,1));
ym = (1-0.1)*min(Data_3D(:,2));
yM = (1+0.1)*max(Data_3D(:,2));

%{
    linspace(xm,xM,101) generates 101 evenly space points between xm,xM
    meshgrid(x,y) returns 2D grid coordinates
    xx is a matrix where each row is a copy of x
    yy is a matrix where each column is a copy of y
%}
[xx,yy] = meshgrid(linspace(xm,xM,101),linspace(ym, yM, 101));

%{
    Here, we are solving for the z (zz) value in the linear fit equation
    zz = (B2*xx+B3*yy + B1 - 1/2)/B4
    The function surf(xx,yy,zz) creates a 3d surface plot
%}
zz = -(bL3(2)*xx+bL3(3)*yy+bL3(1)-1/2)/bL3(4);
h = surf(xx,yy,zz);

shading interp
axis off
plot3(Classify_Data3D(:,1),Classify_Data3D(:,2),Classify_Data3D(:,3),'kx','MarkerSize',24);
zlim([0.05 .2])


%{
    NONLINEAR FIT
    Same data points and xx,yy as linear fit, just using NonLinFit for the basis
    The zz is different because it's computed with different basis:
        zz= -(B2*xx+B3*yy+B1)/B4
%}

figure(4);clf;
plot3(Data_3D(Y_3D==0,1),Data_3D(Y_3D==0,2),Data_3D(Y_3D==0,3),'b.','MarkerSize',24);
hold on;
plot3(Data_3D(Y_3D==1,1),Data_3D(Y_3D==1,2),Data_3D(Y_3D==1,3),'r.','MarkerSize',24);

bN3 = NonLinFit(Data_3D,Y_3D);
zz = -(bN3(2)*xx+bN3(3)*yy+bN3(1))/bN3(4);
h = surf(xx,yy,zz);
shading interp
axis off
zlim([0.05 .2])

plot3(Classify_Data3D(:,1),Classify_Data3D(:,2),Classify_Data3D(:,3),'kx','MarkerSize',24);