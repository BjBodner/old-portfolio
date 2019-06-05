function [ConfidenceIn_Fit,Calculated_Y2,WeightedPrediction,Extended_X] = FindTheFittingParameters(true_Y,x,TimeForwardFactor)

%RandomFunctionParameters = rand(4,1) -0.5;
dx1 = (max(x)-min(x))/length(x);
x = 0.01*x/dx1;
dx = (max(x)-min(x))/length(x);

lambda = 0.1;
%FittingParameters = 0;
ConfidenceIn_Fit = 0;
Calculated_Y = zeros(length(true_Y),4);
TimeInTheFutureFactor = 1.2;
%if I == 1
%% 2rd order Polynomial
NameOfChosenFunction1 = '2rd order Polynomial';
%Estimated_Y = RandomFunctionParameters(2)*x.^2 + RandomFunctionParameters(3)*x + RandomFunctionParameters(4);
CostFunction = @(RandomFunctionParameters)sum((RandomFunctionParameters(2)*x.^2 + RandomFunctionParameters(3)*x + RandomFunctionParameters(4)- true_Y).^2) + lambda*sum(RandomFunctionParameters.^2);
x0 = rand(4,1);
x0(4) = true_Y(1);
% finding the optimized parameters
FittingParameters1 = fminunc(CostFunction,x0) ;

% Calculating Normalized Error
Calculated_Y(:,1) = FittingParameters1(2)*x.^2 + FittingParameters1(3)*x + FittingParameters1(4);
%NormalizedError(1) = sum(((Calculated_Y(:,1)-mean(Calculated_Y(:,1)))./(max(Calculated_Y(:,1)-min(Calculated_Y(:,1)))) - (true_Y.'-mean(true_Y.'))./(max(true_Y.')-min(true_Y.'))).^2);
NormalizedError(1) = sum((((Calculated_Y(:,1)-mean(Calculated_Y(:,1))) - (true_Y-mean(true_Y)))./(max(true_Y)-min(true_Y))).^2);
ConfidenceIn_Fit(1) = (10-NormalizedError)/10;

%plot(x,Calculated_Y,'r',x,true_Y,'b')



%% Exponent
NameOfChosenFunction2 = 'Exponent';
%Estimated_Y = RandomFunctionParameters(4)*exp(RandomFunctionParameters(1)*x + RandomFunctionParameters(2)) + RandomFunctionParameters(3);

CostFunction = @(RandomFunctionParameters)sum((RandomFunctionParameters(4)*exp(RandomFunctionParameters(1)*x + RandomFunctionParameters(2)) + RandomFunctionParameters(3)- true_Y).^2) + lambda*sum(RandomFunctionParameters.^2);
%CostFunction = @(RandomFunctionParameters)sum((RandomFunctionParameters(4)*exp(RandomFunctionParameters(1)*x + RandomFunctionParameters(2)) + RandomFunctionParameters(3)- true_Y).^2);

x0 = zeros(4,1);
x0(3) = true_Y(1);
FittingParameters2 = fminunc(CostFunction,x0) ;

% Calculating Normalized Error
Calculated_Y(:,2) = FittingParameters2(4)*exp(FittingParameters2(1)*x + FittingParameters2(2)) + FittingParameters2(3);


%NormalizedError(1) = sum(((Calculated_Y(:,2)-mean(Calculated_Y(:,2)))./(max(Calculated_Y(:,2))-min(Calculated_Y(:,2))) - (true_Y.'-mean(true_Y.'))./(max(true_Y.')-min(true_Y.'))).^2);

%ConfidenceIn_Fit(2) = 1-NormalizedError;

%NormalizedError(1) = sum(((Calculated_Y(:,2)-mean(Calculated_Y(:,2)))./(max(Calculated_Y(:,2)-min(Calculated_Y(:,2)))) - (true_Y.'-mean(true_Y.'))./(max(true_Y.')-min(true_Y.'))).^2);
NormalizedError(1) = sum((((Calculated_Y(:,2)-mean(Calculated_Y(:,2))) - (true_Y-mean(true_Y)))./(max(true_Y)-min(true_Y))).^2);
ConfidenceIn_Fit(2) = (10-NormalizedError)/10;


%plot(x,Calculated_Y,'r',x,true_Y,'b')




%% Sin Wave
NameOfChosenFunction3 = 'Sin Wave';
%Estimated_Y = RandomFunctionParameters(3)*sin(RandomFunctionParameters(1)*x + RandomFunctionParameters(2)) + RandomFunctionParameters(4);

CostFunction = @(RandomFunctionParameters)sum((RandomFunctionParameters(3)*sin(RandomFunctionParameters(1)*x + RandomFunctionParameters(2)) + RandomFunctionParameters(4)- true_Y).^2) + lambda*sum(RandomFunctionParameters.^2);


x0 = rand(4,1);
x0(4) = true_Y(1);
FittingParameters3 = fminunc(CostFunction,x0) ;

% Calculating Normalized Error

Calculated_Y(:,3) = FittingParameters3(3)*sin(FittingParameters3(1)*x + FittingParameters3(2)) + FittingParameters3(4);


%NormalizedError(1) = sum(((Calculated_Y(:,3)-mean(Calculated_Y(:,3)))./(max(Calculated_Y(:,3))-min(Calculated_Y(:,3))) - (true_Y.'-mean(true_Y.'))./(max(true_Y.')-min(true_Y.'))).^2);

%ConfidenceIn_Fit(3) = 1-NormalizedError;

%NormalizedError(1) = sum(((Calculated_Y(:,3)-mean(Calculated_Y(:,3)))./(max(Calculated_Y(:,3)-min(Calculated_Y(:,3)))) - (true_Y.'-mean(true_Y.'))./(max(true_Y.')-min(true_Y.'))).^2);
NormalizedError(1) = sum((((Calculated_Y(:,3)-mean(Calculated_Y(:,3))) - (true_Y-mean(true_Y)))./(max(true_Y)-min(true_Y))).^2);
ConfidenceIn_Fit(3) = (10-NormalizedError)/10;




%% Step Function
NameOfChosenFunction4 = 'Step Function';
CostFunction = @(RandomFunctionParameters)sum((RandomFunctionParameters(1)*(1./(1 + exp(-RandomFunctionParameters(4)*(x-RandomFunctionParameters(2))))) + RandomFunctionParameters(3)- true_Y).^2) + lambda*sum(RandomFunctionParameters.^2);
x0 = rand(4,1);
x0(3) = true_Y(1);
FittingParameters4 = fminunc(CostFunction,x0) ;
Calculated_Y(:,4) = FittingParameters4(1)*(1./(1 + exp(-FittingParameters4(4)*(x-FittingParameters4(2))))) + FittingParameters4(3);

%ConfidenceIn_Fit(4) = 1-NormalizedError;
NormalizedError(1) = sum((((Calculated_Y(:,4)-mean(Calculated_Y(:,4))) - (true_Y-mean(true_Y)))./(max(true_Y)-min(true_Y))).^2);
ConfidenceIn_Fit(4) = (10-NormalizedError)/10;


%% Killing Bad Fits
ConfidenceIn_Fit = (ConfidenceIn_Fit>=0).*ConfidenceIn_Fit;


%% Create Weigthed prediction
Extended_X = max(x):dx:max(x) + TimeForwardFactor*dx*(length(x));

Calculated_Y2 = zeros(length(Extended_X),4);

Calculated_Y2(:,1) = FittingParameters1(2)*Extended_X.^2 + FittingParameters1(3)*Extended_X + FittingParameters1(4);
Calculated_Y2(:,2) = FittingParameters2(4)*exp(FittingParameters2(1)*Extended_X + FittingParameters2(2)) + FittingParameters2(3);
Calculated_Y2(:,3) = FittingParameters3(3)*sin(FittingParameters3(1)*Extended_X + FittingParameters3(2)) + FittingParameters3(4);
Calculated_Y2(:,4) = FittingParameters4(1)*(1./(1 + exp(-FittingParameters4(4)*(Extended_X-FittingParameters4(2))))) + FittingParameters4(3);

plot(x,true_Y,'k');
xlim([x(1) x(length(x))])
hold on
plot(x,Calculated_Y);
hold off
hold on
plot(Extended_X ,Calculated_Y2)
hold off
if sum(ConfidenceIn_Fit) ~= 0
WeightedPrediction = sum(diag(ConfidenceIn_Fit.^2)*Calculated_Y2.')/sum(ConfidenceIn_Fit);
end
if sum(ConfidenceIn_Fit) == 0
    WeightedPrediction = true_Y(length(true_Y));
    Extended_X = max(x);
end
WeightedPrediction = WeightedPrediction - (WeightedPrediction(1) - true_Y(length(true_Y)));

hold on 
plot(Extended_X ,WeightedPrediction,'rs')
hold off

Extended_X = Extended_X*dx1/0.01
