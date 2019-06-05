function [Suggested_Parameter_Samples_From_Two_Mode,ImprovementItteration] = Two_Mode_Optimizer(InitialParameters,NumberOfSamples,Parameter_ChangeVector,Cost_Change,ImprovementItteration,TargetedSearchDecayRate,RandomSearchGrowthRate,TargetedMultiplicationFactor,RandomMultiplicationFactor,SignificantChangeValue)

Vectorized_Implimentation = 0;
For_Loop_Implimentation = 1;

if sum(abs(Parameter_ChangeVector)) > SignificantChangeValue
    ImprovementItteration = 1;
end

if Vectorized_Implimentation == 1
TargetedSearch = exp(-(ImprovementItteration-1)/TargetedSearchDecayRate)*diag(TargetedMultiplicationFactor*(-Cost_Change)*Parameter_ChangeVector)*ones(length(InitialParameters),NumberOfSamples)*diag(rand(NumberOfSamples,1));
RandomSearch = exp((ImprovementItteration-1)*RandomSearchGrowthRate)*RandomMultiplicationFactor*(rand(length(InitialParameters),NumberOfSamples)-0.5);
end

if For_Loop_Implimentation == 1
    RandomNumbers = rand(NumberOfSamples,1);
    TargetedSearch_Amplitude = RandomNumbers*exp(-(ImprovementItteration-1)/TargetedSearchDecayRate)*TargetedMultiplicationFactor*(-Cost_Change);
    for sample = 1:NumberOfSamples
        TargetedSearch(:,sample) = TargetedSearch_Amplitude(sample)*Parameter_ChangeVector;
    end
    
    RandomSearch = min(exp((ImprovementItteration-1)*RandomSearchGrowthRate)*RandomMultiplicationFactor,0.1)*(rand(length(InitialParameters),NumberOfSamples)-0.5);
    if min(exp((ImprovementItteration-1)*RandomSearchGrowthRate)*RandomMultiplicationFactor,0.1) == 0.1
    RandomSearch = sin((ImprovementItteration-1)*2*RandomSearchGrowthRate + pi/2)*0.1*(rand(length(InitialParameters),NumberOfSamples)-0.5);
    end
end

Suggested_Parameter_Samples_From_Two_Mode = InitialParameters + TargetedSearch + RandomSearch;
Suggested_Parameter_Samples_From_Two_Mode(:,1) = InitialParameters;

ImprovementItteration = ImprovementItteration +1;


