function [A3] = ForwardProp(X,W1,W2,W3,b1,b2,b3)

Z1 = W1.'*X + b1;
A1 = 1./(1 + exp(-Z1));
Z2 = W2.'*A1 + b2;
A2 = 1./(1 + exp(-Z2));
Z3 = W3.'*A2 + b3;
A3 = 1./(1 + exp(-Z3));