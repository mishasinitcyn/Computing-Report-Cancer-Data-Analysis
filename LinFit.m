% function to fit a hyperplane to the data y at the points x.
%
% y is Nx1
% x is MxN
%
% the result is b of size (M+1)x1
%
% To classify a new point X evaluate H=b(1) + b(2:end)'*X;
%
% H > 1/2 suggests X is in class A, else it is class B.

function b = LinFit(x,y)


A = [ones(size(y)) x];
b = A\y;
