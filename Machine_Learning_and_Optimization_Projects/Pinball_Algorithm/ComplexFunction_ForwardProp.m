function [A1] = ComplexFunction_ForwardProp(X,W1_r,W1_i,W1_t,b1_r,b1_i)

% X is of size nx*m
%b1_t is of size n[l] which will be broadcast to n[l]*m, W1_t is of size n[t]
% Z1 is a vector of size n[l]*m
% this is an array of size n[t]*n[l]*m  

Z1 = W1_r.'*X + b1_r + (W1_i.'*X + b1_i)*1i; 
Transformations_Vector = Generate_Different_Transformations_Vector(Z1); 
A1 = reshape(W1_t.'*reshape(permute(Transformations_Vector,[3 1 2]),length(Transformations_Vector(1,1,:)),length(Transformations_Vector(:,1,1))*length(Transformations_Vector(1,:,1))),length(Transformations_Vector(:,1,1)),length(Transformations_Vector(1,:,1)));

%% Optional nomalization step
%A1 = A1./abs(A1);


