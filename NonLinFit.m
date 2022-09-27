% function to fit an exponential to the data y at the points x.
%
% y is Nx1
% x is MxN
%
% the result is b of size (M+1)x1
%
% To classify a new point X evaluate G=1/(1 + exp(b(1) + b(2:end)'*X);
%
% G > 1/2 suggests X is in class A, else it is class B.
%
% b is found using Newton's method on (f(x_i)-y_i)^2 (NOT logistic regression)

function [b, f0, fn] = NonLinFit(x,y)


% get a good first guess.
X = [ones(size(y)) x];
b = -X\y;
f0 = f(b,X,y);
xx = linspace(-4,10,1001)';
XX = [ones(size(xx)) xx];

MaxIts = 15;
its = 1;
Tol = 1e-6;
err = 1;
while (err> Tol) && (its < MaxIts)
    gf = gf_sum(b,X,y);
    H = Hf_sum(b,X,y);
    db = -H\gf;
    err = norm(gf);
    b = b + db;
    its = its + 1;
end
fn = f(b,X,y);

%%%------------------------------
function gb = g(b,x)

gb = 0;
[m,~] = size(x);
for i=1:m
    gb = gb + 1/(1+exp(b'*x(i,:)'));
end

%%%------------------------------
function fb = f(b,x,y)

fb = 0;
[m,~] = size(y);
for i=1:m
    fb = fb + (g(b,x(i,:)) - y(i))^2;
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
