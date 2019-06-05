function [W1_prev,W2_prev,W3_prev,b1_prev,b2_prev,b3_prev] = Update_WB(W1,W2,W3,b1,b2,b3,I)

b1_prev = b1(:,I);
b2_prev = b2(:,I);
b3_prev = b3(:,I);
W1_prev = W1(:,:,I);
W2_prev = W2(:,:,I);
W3_prev = W3(:,:,I);