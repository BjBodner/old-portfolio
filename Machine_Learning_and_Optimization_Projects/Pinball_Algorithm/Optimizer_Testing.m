clear


ParameterVector1 = rand(200,1)-0.5;
Search_Ratio = 0.3;
NumberOfItterations = 50;
NumberOfSamples__In_Each_Itteration = 10;
AmplitudeOfLinearSearch = 0.1;
AmplitudeOfRandomSearch = 0.5;
Readout = 0;

[ParameterVector,CurrentCost,TotalTime] = Pinball_Optimizer_With_Cooling(ParameterVector1,Search_Ratio,NumberOfItterations,NumberOfSamples__In_Each_Itteration,AmplitudeOfLinearSearch,AmplitudeOfRandomSearch,Readout)

NumberOfHyperParameterSTests = 5;
HyperParameters(:,1) = 1*rand(NumberOfHyperParameterSTests,1); %% Linear Search
HyperParameters(:,2) = 2*rand(NumberOfHyperParameterSTests,1); %% Random Search
HyperParameters(:,3) = rand(NumberOfHyperParameterSTests,1); %% Search ratio
MaxSamples = 30;


%% Cooling tests
for coolingTest = 1:10
    Amplitude = exp(-(coolingTest-1)/3);
    ParameterVector1 = Amplitude*(rand(200,1)-0.5);
    HyperParameters(:,1) = 1*rand(NumberOfHyperParameterSTests,1); %% Linear Search
    HyperParameters(:,2) = 2*rand(NumberOfHyperParameterSTests,1); %% Random Search
    HyperParameters(:,3) = rand(NumberOfHyperParameterSTests,1); %% Search ratio
for n = 1:NumberOfHyperParameterSTests
    
    %AmplitudeOfLinearSearch = HyperParameters(n,1);
    %AmplitudeOfRandomSearch = HyperParameters(n,2);
    %Search_Ratio =  HyperParameters(n,3);
    
    Search_Ratio = 0.7-0.2*(coolingTest/10);
    AmplitudeOfRandomSearch = Amplitude;
    AmplitudeOfLinearSearch = Amplitude*(1-Search_Ratio);
    
    parfor NumberOfSamples__In_Each_Itteration = 1:MaxSamples
        [ParameterVector,CurrentCost,TotalTime] = Pinball_Optimizer(ParameterVector1,Search_Ratio,NumberOfItterations,NumberOfSamples__In_Each_Itteration,AmplitudeOfLinearSearch,AmplitudeOfRandomSearch,Readout);
        Cost(NumberOfSamples__In_Each_Itteration) = CurrentCost(NumberOfItterations);
        TotalTime1(NumberOfSamples__In_Each_Itteration) = TotalTime;
    end
    
    BestCost(n) = mean(Cost(15:20));
end
[M,I] = min(BestCost);
BestHyperParameters(coolingTest,:) = HyperParameters(I,:);
%CoolingTest(coolingTest,:) = [HyperParameters(I,:) M 0 Amplitude]
CoolingTest(coolingTest,:) = [AmplitudeOfLinearSearch AmplitudeOfRandomSearch  Search_Ratio M 0 Amplitude]

end


%% Conclusions from hyper parameter test - rules of thumb
% 1. the random search should have a larger amplitude than the linear search -
% very counter intuitive
% 2. the ratio Should be about the same as that of RS_A/(RS_A LS_A) - start
% with and 0.8 ratio
% 3. Both amplitudes should be of scale, but a bit smaller than the mean
% absolute change in the parameters, during the last the last 20 itterations or so
% 4. As the function converges - slowly change the ratio to be even at 0.5;
% This means there are two hyper parameters - 
% a. The initial Amplitude of the random search - start with any number, and change with optimization
% b. the number of samples, 20 seems to be a good number
% c. Number of itterations, 20 seems to be a good number


NumberOfSamples__In_Each_Itteration = 1:MaxSamples;
AveragingNumber = 10;
for n = 1:round(max(NumberOfSamples__In_Each_Itteration) /AveragingNumber)
    AverageSamples(n) = mean(NumberOfSamples__In_Each_Itteration(1 + (n-1)*AveragingNumber:AveragingNumber + (n-1)*AveragingNumber));
    AverageCost(n) = mean(Cost(1 + (n-1)*AveragingNumber:AveragingNumber + (n-1)*AveragingNumber));
end
ax1 = subplot(2,1,1);
%semilogy(ax1,NumberOfSamples__In_Each_Itteration,Cost,'-b');
%hold on
semilogy(ax1,AverageSamples,AverageCost,'-rs');
%hold off
title(ax1,'Cost as a function of Number Of Samples In Each Itteration');
ylim(ax1,[(10^-10) 10^3])
ax2 = subplot(2,1,2);
plot(ax2,NumberOfSamples__In_Each_Itteration,TotalTime1);
title(ax2,'Runtime as a function of Number Of Samples In Each Itteration');
