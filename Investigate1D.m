load Data_CR3.mat
figure(1);clf;
%% Plot the data to see what is going on:
plot(x1,y1,'x',x2,y2,'o','MarkerSize',4);hold on;
title('Data for fitting','FontSize',14)
ylabel('Category','FontSize',14)
xlabel('x','FontSize',14)

%% First lets do linear fits:
bL1 = LinFit(x1,y1);
bL2 = LinFit(x2,y2);

% how do the parameters compare?
disp(['Fitting (x1,y1) gives: bL1 = ',num2str(bL1')])
disp(['Fitting (x2,y2) gives: bL2 = ',num2str(bL2')])

%% Now nonlinear fits.
bN1 = NonLinFit(x1,y1);
bN2 = NonLinFit(x2,y2);

disp(['Fitting (x1,y1) gives: bN1 = ',num2str(bN1')])
disp(['Fitting (x2,y2) gives: bN2 = ',num2str(bN2')])

%% Compare them all on a plot:
X = linspace(x1(1),x1(end),1001);
yL1 = bL1(1) + X*bL1(2);
yL2 = bL2(1) + X*bL2(2);
yN1 = 1./(1+exp(bN1(1)+bN1(2)*X));
yN2 = 1./(1+exp(bN2(1)+bN2(2)*X));
pause;
plot(X,yL1,X,yL2,X,yN1,X,yN2);
leg = legend('y1','y2','Linear fit to (x1,y1)','Linear fit to (x2,y2)', ... 
    'Nonlinear fit to (x1,y1)','Nonlinear fit to (x2,y2)','FontSize',14,'Location','SouthEast');
set(leg,'AutoUpdate','off')
xlim([0 10])

xL1 = (1/2-bL1(1))/bL1(2);
xL2 = (1/2-bL2(1))/bL2(2);
xN1 = (-bN1(1))/bN1(2);
xN2 = (-bN2(1))/bN2(2);
% Cut-offs
disp('  Method                   |  x cut-off')
disp('---------------------------|-------------')
disp(['Linear fit for (x1,y1)     |   ',num2str(xL1)])
disp(['Linear fit for (x2,y2)     |   ',num2str(xL2)])
disp(['Nonlinear fit for (x1,y1)  |   ',num2str(xN1)])
disp(['Nonlinear fit for (x2,y2)  |   ',num2str(xN2)])

plot([xL1 xL1],[0 1],'k-.',[xL2 xL2],[0 1],'k-.', ... 
    [xN1 xN1],[0 1],'k--',[xN2 xN2],[0 1],'k--','LineWidth',1);
ylim([-.1 1.1])
hold off;
pause;
%% Let's look at the function we are minimizing for the nonlinear fit.

b1 = NonLinFit(x1,y1);
b2M = 0;
b2m = 2*b1(2);
b1m = 0;
b1M = 2*b1(1);
[b1, b2] = meshgrid(linspace(b1m,b1M,201),linspace(b2m,b2M,201));

z = zeros(size(b1));
X = [ones(size(y1)) x1];
for i=1:length(z(:))
    b = [b1(i);b2(i)];
    z(i) = f(b,X,y1);
end

b0 = [12;-20];
gfb = gf_sum(b0,X,y1);
Hfb = Hf_sum(b0,X,y1);
fb0 = f(b0,X,y1); 

figure(2);clf;
surf(b1,b2,z);
shading flat;
hold on;
plot3(b0(1),b0(2),fb0,'.','MarkerSize',36);
vSD = -gfb;
vN = -Hfb\gfb;
fbN = f(b0+vN,X,y1);

disp(['At b = ', num2str(b0')])
disp('The length of the gradient is:')
disp(norm(vSD))
disp('The length of the Newton direction is:')
disp(norm(vN))
title('Function for nonlinear fitting','FontSize',14)
axis off

%%%------------------------------
function gb = g(b,x)

gb = 0;
[m,~] = size(x);
for i=1:m
    gb = gb + 1/(1+exp(b'*x(i,:)'));
end
end

%%%------------------------------
function fb = f(b,x,y)

fb = 0;
[m,~] = size(y);
for i=1:m
    fb = fb + (g(b,x(i,:)) - y(i))^2;
end
end

%%%------------------------------
function gfb = gf_sum(b,x,y)

gfb = zeros(size(b));
m = length(b);
n = length(y);
for j=1:m
    for i=1:n
        gg = g(b,x(i,:));
        gfb(j) = gfb(j) + 2*(gg - y(i)).*gg.*(1-gg)*x(i,j);
    end
end
end
%%%------------------------------
function Hfb = Hf_sum(b,x,y)

m = length(b);
Hfb = zeros(m,m);

db = 1e-7;
for i=1:m
    bs = b;
    bs(i) = b(i) + db;
    gp = gf_sum(bs,x,y);
    bs(i) = b(i) - db;
    gm = gf_sum(bs,x,y);
    Hfb(:,i) = (gp-gm);
end
Hfb = .5*Hfb/db;
end



