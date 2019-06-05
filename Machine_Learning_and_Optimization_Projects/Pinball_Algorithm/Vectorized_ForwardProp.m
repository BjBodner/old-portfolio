function [A3] = Vectorized_ForwardProp(X,W1,W2,W3,b1,b2,b3)

%X.'*W1

W1_r = squeeze(reshape(W1,length(W1(:,1,1)),length(W1(1,:,1))*length(W1(1,1,:)),1));
Z1_r = reshape(W1_r.'*X,length(W1(1,:,1)),length(X(1,:)),length(W1(1,1,:)))+b1;
Z1_r2 = reshape(Z1_r,length(W1(1,:,1)),length(X(1,:))*length(W1(1,1,:)));
A1 = 1./(1 + exp(-Z1_r2));

%A1_r = squeeze(reshape(A1,length(A1(:,1,1)),length(A1(1,:,1))*length(A1(1,1,:)),1));
W2_r = squeeze(reshape(W2,length(W2(:,1,1)),length(W2(1,:,1))*length(W2(1,1,:)),1));
Z2_r1 = reshape(W2_r.'*A1_r,length(W2(1,:,1)),length(W2(1,1,:)),length(X(1,:)),length(W2(1,1,:)));
Z2_r2 = permute(Z2_r1, [1 3 2 4]);
Z2_r3 = reshape(Z2_r2,length(W2(1,:,1)),length(X(1,:)),length(W2(1,1,:))*length(W2(1,1,:)));
Z2_r = Z2_r3(:,:,1:length(W2(1,1,:))+1:length(W2(1,1,:))^2) + b2;
A2 = 1./(1 + exp(-Z2_r));

A2_r = squeeze(reshape(A2,length(A2(:,1,1)),length(A2(1,:,1))*length(A2(1,1,:)),1));
W3_r = squeeze(reshape(W3,length(W3(:,1,1)),length(W3(1,:,1))*length(W3(1,1,:)),1));
Z3_r1 = reshape(W3_r.'*A2_r,length(W3(1,:,1)),length(W3(1,1,:)),length(X(1,:)),length(W3(1,1,:)));
Z3_r2 = permute(Z3_r1, [1 3 2 4]);
Z3_r3 = reshape(Z3_r2,length(W3(1,:,1)),length(X(1,:)),length(W3(1,1,:))*length(W3(1,1,:)));
Z3_r = Z3_r3(:,:,1:length(W3(1,1,:))+1:length(W3(1,1,:))^2) + b3;
A3 = 1./(1 + exp(-Z3_r));
