nl_1 = 10;
nx = 8;
m = 20;
n_t = 12;
X = rand(nx,m)-0.5;
W1_r = rand(nx,nl_1)-0.5;
W1_i = rand(nx,nl_1)-0.5;
W1_t = rand(n_t,1)-0.5;
b1_r = rand(nl_1,1)-0.5;
b1_i = rand(nl_1,1)-0.5;

NumberOfLayers = 1;

A1 = X;
for l = 1:NumberOfLayers
    %% Retrieve W1_r,W1_i,W1_t,b1_r,b1_i - from cache
    % W1_r,W1_i,W1_t,b1_r,b1_i = function for cache retrival
    
    %% Calculate activation for this layer
[A1] = ComplexFunction_ForwardProp(A1,W1_r,W1_i,W1_t,b1_r,b1_i);

end
% for final layer
A_last = 1./(1+exp(real(A1)));
a = 1