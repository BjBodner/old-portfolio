function [b1,b2,b3,W1,W2,W3] = Advance_Wb_Along_Vector(W1_prev,W2_prev,W3_prev,b1_prev,b2_prev,b3_prev,RandomVector_W1,RandomVector_W2,RandomVector_W3,RandomVector_b1,RandomVector_b2,RandomVector_b3,t)


b1 = b1_prev + RandomVector_b1*t;
b2 = b2_prev + RandomVector_b2*t;
b3 = b3_prev + RandomVector_b3*t;
W1 = W1_prev + RandomVector_W1*t;
W2 = W2_prev + RandomVector_W2*t;
W3 =W3_prev + RandomVector_W3*t;