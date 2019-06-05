clear
%% algorithm = 1 is GG2.0 , algorithm = 2 is pinball, algorithm = 3 is two mode, algorithm 4 is random search, algorithm = 5 is genetic algorithm
algorithm = 1;


Initial_Parameters = zeros(6,1);


for algorithm = 5:5
%% Initial hyperparameters to be optimized

if algorithm == 1
%% Guessing Game HyperParameters
dt = 0.001;
LearningRate = 0.0007;

%% Guessing Game 2.0 HyperParameters
dt = 0.001;
NumberRandomVectors = 4;
NumberOfSamples_For_AverageVector = 4;
AmplitudeOf_SingleVectors = 0.01;
AmplitudeOf_EvenVectors = 0.01;
AmplitudeOf_RandomVectors = 0.02;


Initial_Parameters(1)=dt;
Initial_Parameters(2)=NumberRandomVectors;
Initial_Parameters(3)=NumberOfSamples_For_AverageVector;
Initial_Parameters(4)=AmplitudeOf_SingleVectors;
Initial_Parameters(5)=AmplitudeOf_EvenVectors;
Initial_Parameters(6)=AmplitudeOf_RandomVectors;
end

if algorithm == 2
%% Pinball HyperParameters
Search_Ratio = 0.7;
AmplitudeOfLinearSearch = 0.1;
AmplitudeOfRandomSearch = 0.4;
%Linear_Search_Vector = rand(length(Initial_Parameters),1)-0.5;


Initial_Parameters(1)=Search_Ratio;
Initial_Parameters(2)=AmplitudeOfLinearSearch;
Initial_Parameters(3)=AmplitudeOfRandomSearch;

end

if algorithm == 3
%% Two Mode HyperParameters
TargetedSearchDecayRate = 0.5;
RandomSearchGrowthRate = 0.02;
TargetedMultiplicationFactor = 0.0002;
RandomMultiplicationFactor = 0.01;
SignificantChangeValue = 0.5;

Parameter_ChangeVector = zeros(length(Initial_Parameters),1);
Cost_Change = 0;
ImprovementItteration = 1;

Initial_Parameters(1)=TargetedSearchDecayRate;
Initial_Parameters(2)=RandomSearchGrowthRate;
Initial_Parameters(3)=TargetedMultiplicationFactor;
Initial_Parameters(4)=RandomMultiplicationFactor;
Initial_Parameters(5)=SignificantChangeValue;
end

if algorithm == 5
%% Genetic algorithm
MutationAmplitude = 0.1;

Initial_Parameters(1)=MutationAmplitude;
end





%% Meta learning two mode optimization hyperparameters
TargetedSearchDecayRate = 0.2;
RandomSearchGrowthRate = 0.1;
TargetedMultiplicationFactor = 0.05;
RandomMultiplicationFactor = 0.05;
SignificantChangeValue = 0.05;

Parameter_ChangeVector = zeros(length(Initial_Parameters),1);
Cost_Change = 0;
ImprovementItteration = 1;


NumberOfSamples = 8;



Vectorized_Implimentation = 0;
For_Loop_Implimentation = 1;
NumberOf_Hyperparameter_Optimization_Itterations = 20;
Number_Of_Itterations_On_Cost = 40;
NumberOfInitializationTests = 12;

CostVector_before_mean = zeros(NumberOfInitializationTests,NumberOfSamples);
    InitialCost = 0;
    
    TotalNumber_OfParameters = 24380;
    Initialized_Regular_Parameters = rand(TotalNumber_OfParameters,NumberOfInitializationTests)-0.5;
    


for itteration = 1:NumberOf_Hyperparameter_Optimization_Itterations
 
    sum(abs(Parameter_ChangeVector))*(-Cost_Change > 0)
if sum(abs(Parameter_ChangeVector))*(-Cost_Change > 0) > SignificantChangeValue
    ImprovementItteration = 1;
end

if Vectorized_Implimentation == 1
TargetedSearch = exp(-(ImprovementItteration-1)/TargetedSearchDecayRate)*diag(TargetedMultiplicationFactor*(-Cost_Change)*Parameter_ChangeVector)*ones(length(Initial_Parameters),NumberOfSamples)*diag(rand(NumberOfSamples,1));
RandomSearch = exp((ImprovementItteration-1)*RandomSearchGrowthRate)*RandomMultiplicationFactor*(rand(length(Initial_Parameters),NumberOfSamples)-0.5);
end

if For_Loop_Implimentation == 1
    RandomNumbers = rand(NumberOfSamples,1);
    TargetedSearch_Amplitude = RandomNumbers*exp(-(ImprovementItteration-1)/TargetedSearchDecayRate)*TargetedMultiplicationFactor*(-Cost_Change);
    for sample = 1:NumberOfSamples
        TargetedSearch(:,sample) = TargetedSearch_Amplitude(sample)*Parameter_ChangeVector;
    end
    RandomSearch = min(exp((ImprovementItteration-1)*RandomSearchGrowthRate)*RandomMultiplicationFactor,0.1)*(rand(length(Initial_Parameters),NumberOfSamples)-0.5);
end

Suggested_Parameter_Samples_From_Two_Mode = Initial_Parameters + TargetedSearch + RandomSearch;
Suggested_Parameter_Samples_From_Two_Mode(:,1) = Initial_Parameters;



ImprovementItteration = ImprovementItteration +1;

%% adjustments for each algorithm
if algorithm == 1
Suggested_Parameter_Samples_From_Two_Mode(2,:) = round(Suggested_Parameter_Samples_From_Two_Mode(2,:));
Suggested_Parameter_Samples_From_Two_Mode(3,:) = round(Suggested_Parameter_Samples_From_Two_Mode(3,:));
end

%% Testing the hyperparameters
tic
for i = 1:NumberOfSamples
    for initialization = 1:NumberOfInitializationTests
        %[CostVector_before_mean(initialization,i)]= Test_To_Find_Hyperparameters_Cost1(Number_Of_Itterations_On_Cost,algorithm,Suggested_Parameter_Samples_From_Two_Mode(:,i),Initialized_Regular_Parameters(:,initialization));
        [CostVector_before_mean(initialization,i)]= Test_To_Find_Hyperparameters_Cost2(Number_Of_Itterations_On_Cost,algorithm,Suggested_Parameter_Samples_From_Two_Mode(:,i),Initialized_Regular_Parameters(:,initialization));
    
    end
end
toc
CostVector = mean(CostVector_before_mean);
ParametersArray = Suggested_Parameter_Samples_From_Two_Mode;

    %% Finding Absolute Best Sample, and reseting the initial parameter vector
    [InitialCost1,I] = min(CostVector);
    Cost_Change = InitialCost1 - InitialCost;
    Parameter_ChangeVector = ParametersArray(:,I) - Initial_Parameters ;
    Initial_Parameters = ParametersArray(:,I);
    InitialCost = InitialCost1;
    CostTracking(itteration) = InitialCost1;
    
    InitialCost1
    Initial_Parameters.'
end

if algorithm == 1
    BestCostForGG20 = InitialCost1
save('Hyperparameters_For_GG20_cost2','Initial_Parameters')
end
if algorithm == 2
    BestCostForPinball = InitialCost1
save('Hyperparameters_For_Pinball_cost2','Initial_Parameters')
end
if algorithm == 3
    BestCostForTwoMode = InitialCost1
save('Hyperparameters_For_TwoMode_cost2','Initial_Parameters')
end
if algorithm == 5
    BestCostForGeneticAlgorithm = InitialCost1
save('Hyperparameters_For_GeneticAlgorithm_cost2','Initial_Parameters')
end

end