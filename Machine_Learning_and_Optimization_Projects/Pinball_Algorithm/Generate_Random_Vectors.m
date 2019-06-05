function [RandomVector_W1,RandomVector_W2,RandomVector_W3,RandomVector_b1,RandomVector_b2,RandomVector_b3] = Generate_Random_Vectors(X1,Y1)


RandomVector_W1 = rand(length(X1(:,1)),30)-0.5;
RandomVector_W2 = rand(30,20)-0.5;
RandomVector_W3 = rand(20,length(Y1(:,1)))-0.5;
RandomVector_b1 = rand(30,1)-0.5;
RandomVector_b2 = rand(20,1)-0.5;
RandomVector_b3 = rand(length(Y1(:,1)),1)-0.5;