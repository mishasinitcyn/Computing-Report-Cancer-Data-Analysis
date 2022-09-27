% clear all;
load Data_CR3.mat

temp_Classify = Classify_Data30D(:, [1,2,3]);
temp_Data = Data_30D(:, [1,2,3]);

%%{

figure(3);clf;
plot3(temp_Data(Y_30D==0,1),temp_Data(Y_30D==0,2),temp_Data(Y_30D==0,3),'b.','MarkerSize',24);
hold on;
plot3(temp_Data(Y_30D==1,1),temp_Data(Y_30D==1,2),temp_Data(Y_30D==1,3),'r.','MarkerSize',24);
hold on;

bL3 = LinFit(Data_30D,Y_30D);
temp_bL3 = LinFit(temp_Data,Y_30D);
xm = (1-.1*sign(min(temp_Data(:,1))))*min(temp_Data(:,1));
xM = (1+.1*sign(max(temp_Data(:,1))))*max(temp_Data(:,1));
ym = (1-.1*sign(min(temp_Data(:,2))))*min(temp_Data(:,2));
yM = (1+.1*sign(max(temp_Data(:,2))))*max(temp_Data(:,2));
[xx,yy] = meshgrid(linspace(xm,xM,101),linspace(ym, yM, 101));
zz = -(temp_bL3(2)*xx+temp_bL3(3)*yy+temp_bL3(1)-1/2)/temp_bL3(4);
h = surf(xx,yy,zz);
shading interp
axis off
%plot3(Classify_Data30D(:,1),Classify_Data30D(:,2),Classify_Data30D(:,3),'kx','MarkerSize',24);
%zlim([0.05 .2])

LFit = [];
for i=1:10 
    class = bL3(1);
    for j = 1:30
        class = class + Classify_Data30D(i,j)*bL3(j+1);
    end
    if class > 1/2
        LFit = [LFit, 1];
    else
        LFit = [LFit, 0];
    end
end

LFit

L1Fit = 0;

for i=1:559
    class = bL3(1);
    for j = 1:30
        class = class + Data_30D(i,j)*bL3(j+1);
    end
    if class > 1/2 && Y_30D(i) == 1
        L1Fit=L1Fit+1;
    elseif class <= 1/2 && Y_30D(i) == 0
        L1Fit=L1Fit+1;
    end
end

L1Fit

plot3(temp_Classify(LFit==0,1),temp_Classify(LFit==0,2),temp_Classify(LFit==0,3),'cyan.','MarkerSize',24);
hold on;
plot3(temp_Classify(LFit==1,1),temp_Classify(LFit==1,2),temp_Classify(LFit==1,3),'magenta.','MarkerSize',24);
hold on;

figure(4);clf;
plot3(temp_Data(Y_30D==0,1),temp_Data(Y_30D==0,2),temp_Data(Y_30D==0,3),'b.','MarkerSize',24);
hold on;
plot3(temp_Data(Y_30D==1,1),temp_Data(Y_30D==1,2),temp_Data(Y_30D==1,3),'r.','MarkerSize',24);
hold on;
bN3 = NonLinFit(Data_30D,Y_30D);

temp_bN3 = NonLinFit(temp_Data,Y_30D);
zz = -(temp_bN3(2)*xx+temp_bN3(3)*yy+temp_bN3(1))/temp_bN3(4);

h = surf(xx,yy,zz);
shading interp
axis off
%zlim([0.05 .2])

NFit = [];
for i=1:10 
    class = bN3(1);
    for j = 1:30
        class = class + Classify_Data30D(i,j)*bN3(j+1);
    end
    class = 1/(1+exp(class));
    if class > 1/2
        NFit = [NFit, 1];
    else
        NFit = [NFit, 0];
    end
end

NFit

N1Fit = 0;

for i=1:559
    class = bN3(1);
    for j = 1:30
        class = class + Data_30D(i,j)*bN3(j+1);
    end
    class = 1/(1+exp(class));
    if class > 1/2 && Y_30D(i) == 1
        N1Fit=N1Fit+1;
    elseif class <= 1/2 && Y_30D(i) == 0
        N1Fit=N1Fit+1;
    end
end

N1Fit

%plot3(Classify_Data30D(:,1),Classify_Data30D(:,2),Classify_Data30D(:,3),'kx','MarkerSize',24);
plot3(temp_Classify(NFit==0,1),temp_Classify(NFit==0,2),temp_Classify(NFit==0,3),'cyan.','MarkerSize',24);
hold on;
plot3(temp_Classify(NFit==1,1),temp_Classify(NFit==1,2),temp_Classify(NFit==1,3),'magenta.','MarkerSize',24);

%%}
