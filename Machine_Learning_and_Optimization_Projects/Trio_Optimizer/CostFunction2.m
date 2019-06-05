function [CostVector] = CostFunction2(ParametersArray1)



a = open('Data_From_Mnist.mat');
X = a.X;
Y = a.Y;
NumberOfSamples = length(X(1,:));

if length(ParametersArray1(1,:)) > 1
CostVector = zeros(length(ParametersArray1(1,:)),1);
for i = 1:length(ParametersArray1(1,:))
    
W1 = reshape(ParametersArray1(1:23520,i),length(X(:,1)),30);
W2 = reshape(ParametersArray1(23521:24120,i),30,20);
W3 = reshape(ParametersArray1(24121:24320,i),20,length(Y(:,1)));
b1 = reshape(ParametersArray1(24321:24350,i),30,1);
b2 = reshape(ParametersArray1(24351:24370,i),20,1);
b3 = reshape(ParametersArray1(24371:24380,1),length(Y(:,1)),1);

%% Run Nerual Network Predictions    
Z1 = W1.'*X + b1;
A1 = 1./(1 + exp(-Z1));
Z2 = W2.'*A1 + b2;
A2 = 1./(1 + exp(-Z2));
Z3 = W3.'*A2 + b3;
A3 = 1./(1 + exp(-Z3));


CostVector(i) = (1/(2*NumberOfSamples))*sum(sum(-Y.*log(A3) - (1-Y).*log(1-A3)));
end
end


if length(ParametersArray1(1,:)) == 1
CostVector = 0;
%for i = 1:length(ParametersArray(1,:))
    
W1 = reshape(ParametersArray1(1:23520),length(X(:,1)),30);
W2 = reshape(ParametersArray1(23521:24120),30,20);
W3 = reshape(ParametersArray1(24121:24320),20,length(Y(:,1)));
b1 = reshape(ParametersArray1(24321:24350),30,1);
b2 = reshape(ParametersArray1(24351:24370),20,1);
b3 = reshape(ParametersArray1(24371:24380),length(Y(:,1)),1);

%% Run Nerual Network Predictions    
Z1 = W1.'*X + b1;
A1 = 1./(1 + exp(-Z1));
Z2 = W2.'*A1 + b2;
A2 = 1./(1 + exp(-Z2));
Z3 = W3.'*A2 + b3;
A3 = 1./(1 + exp(-Z3));


CostVector = (1/(2*NumberOfSamples))*sum(sum(-Y.*log(A3) - (1-Y).*log(1-A3)));
%end
end