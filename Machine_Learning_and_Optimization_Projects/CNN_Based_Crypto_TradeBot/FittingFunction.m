function [Extended_X,WeightedPrediction,ConfidenceIn_Fit,Calculated_Y2,x1,y1,z1,FitPrediction] = FittingFunction(TimeForwardFactor,y,Time,LengthOfPrediction)
GenerateRandomFunction = 0;
x = Time - Time(1);

if GenerateRandomFunction == 1
[x,y,ActualChoices] = RandomFunctionGenerator;
y = real(y);
end


%% Finding the fitting Parameters
tic

TimeForwardFactor = LengthOfPrediction/length(x);
[ConfidenceIn_Fit,Calculated_Y2,WeightedPrediction,Extended_X] = FindTheFittingParameters(y,x,TimeForwardFactor);
toc
%ActualChoices.RandomFunctionParameters



plot(x,y,'k')
hold on 
plot(Extended_X,WeightedPrediction,'rs')
hold off

Extended_X = Extended_X + Time(1);

Extended_Time = Extended_X;

ConfidenceIn_Fit = ConfidenceIn_Fit.^5;
    


% sticking the edges together
for i = 1:length(Calculated_Y2(1,:))
Calculated_Y2(:,i) = Calculated_Y2(:,i) - (Calculated_Y2(1,i)- y(length(y)));
end


y1_Range = min(min(Calculated_Y2)) - ((max(max(Calculated_Y2)) - min(min(Calculated_Y2)))/2):(-min(min(Calculated_Y2))+max(max(Calculated_Y2)))/50:max(max(Calculated_Y2));
%x1_Range = min(Extended_Time):(max(Extended_Time) - min(Extended_Time))/(2*length(Extended_Time)):max(Extended_Time);
%[x1,y1] = meshgrid(x1_Range,y1_Range);
[x1,y1] = meshgrid(Extended_Time,y1_Range);

z1 = zeros(size(x1));
FitPrediction= zeros(length(x1(:,1)),length(x1(1,:)),5);
Sigma1 = 1;
for i = 1:length(Calculated_Y2(:,1))
for j = 1:length(Calculated_Y2(1,:))
z1 = z1 + ConfidenceIn_Fit(j)*exp(-((10^-1)*(Calculated_Y2(i,j)-y1).^2 + 10^7*(x1-Extended_Time(i)).^2)/Sigma1);

FitPrediction(:,:,j) =FitPrediction(:,:,j) + ConfidenceIn_Fit(j)*exp(-((10^-1)*(Calculated_Y2(i,j)-y1).^2 + 10^7*(x1-Extended_Time(i)).^2)/Sigma1);
end
end


for i = 1:length(WeightedPrediction)
    z1 = z1 + exp(-((WeightedPrediction(1,i)-y1).^2 + 10^7*(x1-Extended_Time(i)).^2)/Sigma1);
    FitPrediction(:,:,5) =FitPrediction(:,:,5) + exp(-((WeightedPrediction(1,i)-y1).^2 + 10^7*(x1-Extended_Time(i)).^2)/Sigma1);
end


ConfidenceIn_Fit
