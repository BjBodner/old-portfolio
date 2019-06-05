function [FinalCost]= Test_To_Find_Hyperparameters_Cost2(Number_Of_Itterations_On_Cost,algorithm,HyperParameters,Initialized_Regular_Parameters)

InitialParameters = HyperParameters;
Initial_Parameters_1 = InitialParameters;
UseCostFunction1 = 0;
UseCostFunction2 = 1;
Number_Of_Ittertions = Number_Of_Itterations_On_Cost;


if algorithm == 1
%% Guessing Game HyperParameters
dt = 0.001;
LearningRate = 0.0007;

%% Guessing Game 2.0 HyperParameters
dt = InitialParameters(1);
NumberRandomVectors = InitialParameters(2);
NumberOfSamples_For_AverageVector = InitialParameters(3);
AmplitudeOf_SingleVectors = InitialParameters(4);
AmplitudeOf_EvenVectors = InitialParameters(5);
AmplitudeOf_RandomVectors = InitialParameters(6);

end

if algorithm == 2
%% Pinball HyperParameters
Search_Ratio = InitialParameters(1);
AmplitudeOfLinearSearch = InitialParameters(2);
AmplitudeOfRandomSearch = InitialParameters(3);
end

if algorithm == 3
%% Two Mode HyperParameters
TargetedSearchDecayRate = InitialParameters(1);
RandomSearchGrowthRate = InitialParameters(2);
TargetedMultiplicationFactor = InitialParameters(3);
RandomMultiplicationFactor = InitialParameters(4);
SignificantChangeValue = InitialParameters(5);


Cost_Change = 0;
ImprovementItteration = 1;

end

if algorithm == 5
%% Genetic algorithm
 MutationAmplitude =InitialParameters(1);
end




    TotalNumber_OfParameters = 24380;
    Initial_Parameters = rand(TotalNumber_OfParameters,1)-0.5;
    Initial_Parameters_1 = Initial_Parameters;
    Number_Of_Samples_Per_itteration = 90;
    %Number_Of_Ittertions = 10;
    Number_Of_Initialization_Tests = 2;
    Parameter_ChangeVector = zeros(length(Initial_Parameters),1);
    %%
    Initial_Parameters = Initial_Parameters_1;
    SecondBest_Parameters = Initial_Parameters ;
    RecomendedResourceAllocation = zeros(3,1);
    Linear_Search_Vector = rand(length(Initial_Parameters),1)-0.5;
    %for algorithm1 = 1:5
    %    algorithm = 6-algorithm1

        Initial_Parameters = Initial_Parameters_1;
        if UseCostFunction1 == 1
            [InitialCost] = CostFunction(Initial_Parameters);
        end
        if UseCostFunction2 == 1
            [InitialCost] = CostFunction2(Initial_Parameters);
        end
        
        for itteration = 1:Number_Of_Ittertions
            
            if algorithm == 1
               % NumberRandomVectors = Number_Of_Samples_Per_itteration/3;
                %[ParametersArray,LengthOfVectors,RandomVectors] = Guessing_Game_Optimizer_Part1(Initial_Parameters,NumberRandomVectors,dt);
                 [Suggested_Parameter_Samples_From_Guessing_Game1,LengthOfVectors,RandomVectors] = Guessing_Game_Optimizer_Version2_Part1(Initial_Parameters,NumberRandomVectors,dt);
            
            NumberOfSamples_For_Round2 = Number_Of_Samples_Per_itteration - length(Suggested_Parameter_Samples_From_Guessing_Game1(1,:));
            [CostVector] = CostFunction(Suggested_Parameter_Samples_From_Guessing_Game1);
            %Normalizing Cost
            %CostVector = CostVector/CostVector(1);
            % Part 2 of Guessing_Game_Optimizer
            [Suggested_Parameter_Samples_From_Guessing_Game2] = Guessing_Game_Optimizer_Version2_Part2(Initial_Parameters,NumberRandomVectors,CostVector,dt,RandomVectors,LengthOfVectors,NumberOfSamples_For_Round2,NumberOfSamples_For_AverageVector,AmplitudeOf_SingleVectors, AmplitudeOf_EvenVectors,AmplitudeOf_RandomVectors);
            ParametersArray = Suggested_Parameter_Samples_From_Guessing_Game2;
            end
            if algorithm == 2
                [ParametersArray] = Pinball_Optimizer(Initial_Parameters,Number_Of_Samples_Per_itteration,Search_Ratio,AmplitudeOfLinearSearch,AmplitudeOfRandomSearch,Linear_Search_Vector);
            end
            if algorithm == 3
                [ParametersArray,ImprovementItteration] = Two_Mode_Optimizer(Initial_Parameters,Number_Of_Samples_Per_itteration,Parameter_ChangeVector,Cost_Change,ImprovementItteration,TargetedSearchDecayRate,RandomSearchGrowthRate,TargetedMultiplicationFactor,RandomMultiplicationFactor,SignificantChangeValue);
            end
            
            if algorithm == 4
                ParametersArray = Initial_Parameters + 0.1*(rand(length(Initial_Parameters),Number_Of_Samples_Per_itteration)-0.5);
                ParametersArray(:,1) = Initial_Parameters;
            end
            
            if algorithm == 5
                [ParametersArray] = Genetic_Algorithm(Initial_Parameters,SecondBest_Parameters,Number_Of_Samples_Per_itteration,MutationAmplitude);
                ParametersArray(:,1) = Initial_Parameters;
            end
            
            if UseCostFunction1 == 1
                [CostVector] = CostFunction(ParametersArray);
            end
            if UseCostFunction2 == 1
                [CostVector] = CostFunction2(ParametersArray);
            end
            
            
            %% Finding the best improvement of each algorithm
            
            
            %% From Guessing Game
            if algorithm == 1
                %if RecomendedResourceAllocation(1) > 0 % Part 2 of Guessing_Game_Optimizer
              %  [Suggested_Parameter_Samples_From_Guessing_Game] = Guessing_Game_Optimizer_Part2(Initial_Parameters,NumberRandomVectors,CostVector,dt,RandomVectors,LengthOfVectors,LearningRate);
             %   if UseCostFunction1 == 1
             %       [CostVector(1)] = CostFunction(Suggested_Parameter_Samples_From_Guessing_Game);
             %   end
             %   if UseCostFunction2 == 1
             %       [CostVector(1)] = CostFunction2(Suggested_Parameter_Samples_From_Guessing_Game);
             %   end
             %   ParametersArray(:,1) = Suggested_Parameter_Samples_From_Guessing_Game;
                % end
             %   [~,I1] = min(CostVector);
             %   Best_Change_In_CostFunction_FromAlgorithm(1) = - (CostVector(1 + I1-1) - InitialCost);
            end
            
            
            %% From Pinball
            if algorithm == 2
                [~,I2] = min(CostVector);
                Best_Change_In_CostFunction_FromAlgorithm(2) = - (CostVector(RecomendedResourceAllocation(1) + 1 + I2-1) - InitialCost);
                Number_Of_Linear_Samples = round(Search_Ratio*Number_Of_Samples_Per_itteration);
            end
            
            
            %% From Two Mode
            if algorithm == 3
                [~,I3] = min(CostVector);
                Best_Change_In_CostFunction_FromAlgorithm(3) = - (CostVector(RecomendedResourceAllocation(1) + RecomendedResourceAllocation(2) + 1 + I3-1) - InitialCost);
            end
            
            
            
            %% Finding Absolute Best Sample, and reseting the initial parameter vector
            [InitialCost1,I] = min(CostVector);
            Cost_Change = InitialCost1 - InitialCost;
            Parameter_ChangeVector = ParametersArray(:,I) - Initial_Parameters ;
            Initial_Parameters = ParametersArray(:,I);
            InitialCost = InitialCost1;
            CostTracking_OfAlgorithms(itteration) = InitialCost1;
            
            CostVector(I) = max(CostVector);
            [InitialCost2,I2] = min(CostVector);
            SecondBest_Parameters = ParametersArray(:,I2);
            
            %% This is for the pinball algorithm
            if algorithm == 2
                % Find the best choice for the next linear search vector - For the
                if I == I2 && I2 >Number_Of_Linear_Samples
                    %if I2 >Number_Of_Linear_Samples                                          %% If the best vector was from the random batch
                    Linear_Search_Vector = Parameter_ChangeVector;   %% Take a vector that follows the gradient
                else                                                                    %% If no better vector is found
                    Linear_Search_Vector = rand(length(Initial_Parameters),1)-0.5;         %% Take a random vector
                end
            end
            Current_Resource_Allocation = RecomendedResourceAllocation;
            
            if itteration == 200 %% Make this a dynamic hyperparameter - of the guessing game
                %  LearningRate = 0.005;
                %  TargetedMultiplicationFactor = 0.01;
                %  AmplitudeOfLinearSearch = 0.01;
            end
            
           % BestChangeArray(:,itteration) = Best_Change_In_CostFunction_FromAlgorithm;
        end
    %end
    
    
    Initial_Parameters = Initial_Parameters_1;
    if UseCostFunction1 == 1
        [InitialCost] = CostFunction(Initial_Parameters);
    end
    if UseCostFunction2 == 1
        [InitialCost] = CostFunction2(Initial_Parameters);
    end
    
    
    %CostTracking_OfAlgorithms(:,6) = CostTracking.';
    %CostTracking_OfAlgorithms1 = [ones(6,1)*InitialCost CostTracking_OfAlgorithms.'].';
    %CostTracking_OfAlgorithms = CostTracking_OfAlgorithms1;
    CostTracking_OfAlgorithms = CostTracking_OfAlgorithms/max(max(CostTracking_OfAlgorithms(1)));
    
    FinalCost = CostTracking_OfAlgorithms(itteration);
    
    %% Resizing to between 0 and 1
%    CostTracking_OfAlgorithms1 = CostTracking_OfAlgorithms;
%    CostTracking_OfAlgorithms_Sum_No_Resizing = CostTracking_OfAlgorithms_Sum_No_Resizing + CostTracking_OfAlgorithms1;
%    CostTracking_Array_Of_All_Runs_Sum_No_Resizing(:,:,initialization) = CostTracking_OfAlgorithms1;
    
%    CostTracking_OfAlgorithms = (CostTracking_OfAlgorithms - min(min(CostTracking_OfAlgorithms)))/(1-min(min(CostTracking_OfAlgorithms)));
%    CostTracking_OfAlgorithms_Sum = CostTracking_OfAlgorithms_Sum + CostTracking_OfAlgorithms;
%    CostTracking_Array_Of_All_Runs(:,:,initialization) = CostTracking_OfAlgorithms;
    
%    NumberOfRuns = NumberOfRuns+1;
%    CostTracking_OfAlgorithms = 0;
%    CostTracking_OfAlgorithms1 = 0;
%end




%Mean_CostTracking_OfAlgorithms = CostTracking_OfAlgorithms_Sum/NumberOfRuns ;
%CostTracking_OfAlgorithms = Mean_CostTracking_OfAlgorithms;

%Mean_CostTracking_OfAlgorithms1 = CostTracking_OfAlgorithms_Sum_No_Resizing/NumberOfRuns ;
%CostTracking_OfAlgorithms1 = Mean_CostTracking_OfAlgorithms1;

%ErrorVector = zeros(size(CostTracking_OfAlgorithms));
%ErrorVector_NoResizing = zeros(size(CostTracking_OfAlgorithms));
%for i = 1:6
%    ErrorVector(:,i) = std(squeeze(permute(CostTracking_Array_Of_All_Runs(:,i,:),[1 3 2])).').';
%    ErrorVector_NoResizing(:,i) = std(squeeze(permute(CostTracking_Array_Of_All_Runs_Sum_No_Resizing(:,i,:),[1 3 2])).').';
%end

%n = 1:length(CostTracking_OfAlgorithms(:,1));

