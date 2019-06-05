%function [Final_Parameters] = Trio_Optimizer(Initial_Parameters,Number_Of_Ittertions,Number_Of_Samples_Per_itteration)
clear
clear all
UseCostFunction1 = 0;
UseCostFunction2 = 1;
NumberOfRuns = 0;
CostTracking_OfAlgorithms_Sum = 0;
CostTracking_OfAlgorithms_Sum_No_Resizing = 0;
UseLoadedHyperparameter = 1;

UsePreset_Variables = 1;
if UsePreset_Variables == 1
    TotalNumber_OfParameters = 24380;
    Initial_Parameters = rand(TotalNumber_OfParameters,1)-0.5;
    Initial_Parameters_1 = Initial_Parameters;
    Number_Of_Samples_Per_itteration = 180;
    Number_Of_Ittertions = 500;
    Number_Of_Initialization_Tests = 10;
end

%% Resource Distribution Algorithm - HyperParameters
Initial_Resource_Allocation = [60 60 60];
Current_Resource_Allocation =Initial_Resource_Allocation;
Best_Change_In_CostFunction_FromAlgorithm = [0 0 0];
MassVector = 10*[1 1 1];
Self_Interaction_Spring_Constants = 5*[1 1 1];
Neighboring_Algorithm_Interaction_Spring_Constants = 90*[1 1 1];
Epsilon1 = 0.01;
for i = 1:20
    Changevector = [-1 0 0];
    [RecomendedResourceAllocation] = Resource_Allocation_Hamiltonian(Initial_Resource_Allocation,Current_Resource_Allocation,Changevector,MassVector,Self_Interaction_Spring_Constants,Neighboring_Algorithm_Interaction_Spring_Constants,Epsilon1);
    Current_Resource_Allocation = RecomendedResourceAllocation;
end
Minimal_Allocation = min(Current_Resource_Allocation);
for i = 1:20
    Changevector = [1 0 0];
    [RecomendedResourceAllocation] = Resource_Allocation_Hamiltonian(Initial_Resource_Allocation,Current_Resource_Allocation,Changevector,MassVector,Self_Interaction_Spring_Constants,Neighboring_Algorithm_Interaction_Spring_Constants,Epsilon1);
    Current_Resource_Allocation = RecomendedResourceAllocation;
end
Maximal_Allocation = max(Current_Resource_Allocation);


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
if UseLoadedHyperparameter == 1
    % a = open('Hyperparameters_For_GG20_50itterations.mat');
    a = open('Hyperparameters_For_GG20_cost2.mat');
    HyperParameters = a.Initial_Parameters;
    dt = HyperParameters(1);
    NumberRandomVectors = HyperParameters(2);
    NumberOfSamples_For_AverageVector = HyperParameters(3);
    AmplitudeOf_SingleVectors = HyperParameters(4);
    AmplitudeOf_EvenVectors = HyperParameters(5);
    AmplitudeOf_RandomVectors = HyperParameters(6);
end

%% Pinball HyperParameters
Search_Ratio = 0.7;
AmplitudeOfLinearSearch = 0.1;
AmplitudeOfRandomSearch = 0.4;
Linear_Search_Vector = rand(length(Initial_Parameters),1)-0.5;
if UseLoadedHyperparameter == 1
    %a = open('Hyperparameters_For_Pinball_50itterations.mat');
    a = open('Hyperparameters_For_Pinball_cost2.mat');
    HyperParameters = a.Initial_Parameters;
    Search_Ratio = HyperParameters(1);
    AmplitudeOfLinearSearch = HyperParameters(2);
    AmplitudeOfRandomSearch = HyperParameters(3);
end

%% Two Mode HyperParameters
TargetedSearchDecayRate = 0.5;
RandomSearchGrowthRate = 0.02;
TargetedMultiplicationFactor = 0.0002;
RandomMultiplicationFactor = 0.01;
SignificantChangeValue = 0.5;
Parameter_ChangeVector = zeros(length(Initial_Parameters),1);
Cost_Change = 0;
ImprovementItteration = 1;
if UseLoadedHyperparameter == 1
    %a = open('Hyperparameters_For_TwoMode_50itterations.mat');
    a = open('Hyperparameters_For_TwoMode_cost2.mat');
    HyperParameters = a.Initial_Parameters;
    TargetedSearchDecayRate = HyperParameters(1);
    RandomSearchGrowthRate = HyperParameters(2);
    TargetedMultiplicationFactor = HyperParameters(3);
    RandomMultiplicationFactor = HyperParameters(4);
    SignificantChangeValue = HyperParameters(5);
end

%% Genetic algorithm
MutationAmplitude = 0.1166; % this is from the cost 2 hyperparameter search
t1 = tic
for initialization = 1:Number_Of_Initialization_Tests
    Parameter_ChangeVector = zeros(length(Initial_Parameters),1);
    Cost_Change = 0;
    ImprovementItteration = 1;
    Initial_Resource_Allocation = [60 60 60];
    Current_Resource_Allocation =Initial_Resource_Allocation;
    Best_Change_In_CostFunction_FromAlgorithm = [0 0 0];
    Initial_Parameters = rand(TotalNumber_OfParameters,1)-0.5;
    Initial_Parameters_1 = Initial_Parameters;
    Initial_Parameters2 =  Initial_Parameters;
    
    if UseCostFunction1 == 1
        [InitialCost] = CostFunction(Initial_Parameters)
    end
    if UseCostFunction2 == 1
        [InitialCost] = CostFunction2(Initial_Parameters)
    end
    
    tic
    for itteration = 1:Number_Of_Ittertions
        
        
        [RecomendedResourceAllocation] = Resource_Allocation_Hamiltonian(Initial_Resource_Allocation,Current_Resource_Allocation,Best_Change_In_CostFunction_FromAlgorithm,MassVector,Self_Interaction_Spring_Constants,Neighboring_Algorithm_Interaction_Spring_Constants,Epsilon1);
        
        ResourceAllocationArray(:,itteration) = RecomendedResourceAllocation;
        %% Redistributing Resources so that the first algorithm gets a resource that is a multiple of 3
        if mod(RecomendedResourceAllocation(1),3) == 1
            RecomendedResourceAllocation(1) = RecomendedResourceAllocation(1)-1;
            RecomendedResourceAllocation(2) = RecomendedResourceAllocation(2) + 1;
        elseif mod(RecomendedResourceAllocation(1),3) == 2
            RecomendedResourceAllocation(1) = RecomendedResourceAllocation(1)-2;
            RecomendedResourceAllocation(2) = RecomendedResourceAllocation(2) + 1;
            RecomendedResourceAllocation(3) = RecomendedResourceAllocation(3) + 1;
        end
        
        
        if RecomendedResourceAllocation(1) > 0 % Part 1 of Guessing_Game_Optimizer
            % Part 1 of Guessing_Game_Optimizer
            %NumberRandomVectors = RecomendedResourceAllocation(1)/3;
            % [Suggested_Parameter_Samples_From_Guessing_Game,LengthOfVectors,RandomVectors] = Guessing_Game_Optimizer_Part1(Initial_Parameters,NumberRandomVectors,dt);
            [Suggested_Parameter_Samples_From_Guessing_Game1,LengthOfVectors,RandomVectors] = Guessing_Game_Optimizer_Version2_Part1(Initial_Parameters,NumberRandomVectors,dt);
            
            NumberOfSamples_For_Round2 = RecomendedResourceAllocation(1) - length(Suggested_Parameter_Samples_From_Guessing_Game1(1,:));
            %[CostVector] = CostFunction(Suggested_Parameter_Samples_From_Guessing_Game1);
            [CostVector] = CostFunction2(Suggested_Parameter_Samples_From_Guessing_Game1);
            %Normalizing Cost
            %CostVector = CostVector/CostVector(1);
            % Part 2 of Guessing_Game_Optimizer
            [Suggested_Parameter_Samples_From_Guessing_Game2] = Guessing_Game_Optimizer_Version2_Part2(Initial_Parameters,NumberRandomVectors,CostVector,dt,RandomVectors,LengthOfVectors,NumberOfSamples_For_Round2,NumberOfSamples_For_AverageVector,AmplitudeOf_SingleVectors, AmplitudeOf_EvenVectors,AmplitudeOf_RandomVectors);
        end
        
        if RecomendedResourceAllocation(2) > 0
            [Suggested_Parameter_Samples_From_Pinball] = Pinball_Optimizer(Initial_Parameters,RecomendedResourceAllocation(2),Search_Ratio,AmplitudeOfLinearSearch,AmplitudeOfRandomSearch,Linear_Search_Vector);
        end
        
        if RecomendedResourceAllocation(3) > 0
            [Suggested_Parameter_Samples_From_Two_Mode,ImprovementItteration] = Two_Mode_Optimizer(Initial_Parameters,RecomendedResourceAllocation(3),Parameter_ChangeVector,Cost_Change,ImprovementItteration,TargetedSearchDecayRate,RandomSearchGrowthRate,TargetedMultiplicationFactor,RandomMultiplicationFactor,SignificantChangeValue);
        end
        
        
        
        
        %% Finding the best improvement of each algorithm
        
        
        % From Guessing Game
        %  if RecomendedResourceAllocation(1) > 0 % Part 2 of Guessing_Game_Optimizer
        % [Suggested_Parameter_Samples_From_Guessing_Game] = Guessing_Game_Optimizer_Part2(Initial_Parameters,NumberRandomVectors,CostVector,dt,RandomVectors,LengthOfVectors,LearningRate);
        %     NumberOfSamples_For_Round2 = RecomendedResourceAllocation(1) - length(Suggested_Parameter_Samples_From_Guessing_Game1(1,:));
        %      [Suggested_Parameter_Samples_From_Guessing_Game2] = Guessing_Game_Optimizer_Version2_Part2(Initial_Parameters,NumberRandomVectors,CostVector,dt,RandomVectors,LengthOfVectors,NumberOfSamples_For_Round2,NumberOfSamples_For_AverageVector,AmplitudeOf_SingleVectors, AmplitudeOf_EvenVectors,AmplitudeOf_RandomVectors);
        %  end
        
        
        %% Connecting and testing the cost function of all samples
        ParametersArray = [ Suggested_Parameter_Samples_From_Guessing_Game2  Suggested_Parameter_Samples_From_Pinball Suggested_Parameter_Samples_From_Two_Mode Initial_Parameters];
        if UseCostFunction1 == 1
            [CostVector] = CostFunction(ParametersArray);
        end
        if UseCostFunction2 == 1
            [CostVector] = CostFunction2(ParametersArray);
        end
        
        plot(CostVector)
        %% From Guessing Game 2.0
        [~,I1] = min(CostVector(1:NumberOfSamples_For_Round2));
        if  size((CostVector(1 + I1-1) - InitialCost),1) == 0
            a = 1
        end
        Best_Change_In_CostFunction_FromAlgorithm(1) = - (CostVector(1 + I1-1) - InitialCost);
        
        
        
        %% From Pinball
        [~,I2] = min(CostVector(NumberOfSamples_For_Round2 + 1:NumberOfSamples_For_Round2 + RecomendedResourceAllocation(2)));
        Best_Change_In_CostFunction_FromAlgorithm(2) = - (CostVector(NumberOfSamples_For_Round2 + 1 + I2-1) - InitialCost);
        Number_Of_Linear_Samples = round(Search_Ratio*RecomendedResourceAllocation(2));
        
        
        
        %% From Two Mode
        [~,I3] = min(CostVector(NumberOfSamples_For_Round2 + RecomendedResourceAllocation(2) + 1:NumberOfSamples_For_Round2 + RecomendedResourceAllocation(2)+ RecomendedResourceAllocation(3)+1));
        Best_Change_In_CostFunction_FromAlgorithm(3) = - (CostVector(NumberOfSamples_For_Round2 + RecomendedResourceAllocation(2) + 1 + I3-1) - InitialCost);
        
        
        
        
        %% Finding Absolute Best Sample, and reseting the initial parameter vector
        [InitialCost1,I] = min(CostVector);
        I
        Cost_Change = InitialCost1 - InitialCost;
        Parameter_ChangeVector = ParametersArray(:,I) - Initial_Parameters ;
        Initial_Parameters = ParametersArray(:,I);
        InitialCost = InitialCost1;
        
        
        [LastCost] = CostFunction2(Initial_Parameters2);
        [Cost,I] = min([LastCost InitialCost]);
        Cost
        CostTracking(itteration) = Cost;
        if I == 1
            Initial_Parameters = Initial_Parameters2;
            Initial_Parameters2 = Initial_Parameters2;
        end
        if I == 2
            Initial_Parameters = Initial_Parameters;
            Initial_Parameters2 = Initial_Parameters;
        end
        
        %% This is for the pinball algorithm
        % Find the best choice for the next linear search vector - For the
        if I == I2 && I2 >Number_Of_Linear_Samples
            %if I2 >Number_Of_Linear_Samples                                          %% If the best vector was from the random batch
            %  Linear_Search_Vector = New_ParameterVector - Old_ParameterVector;   %% Take a vector that follows the gradient
            Linear_Search_Vector = Parameter_ChangeVector;
        else                                                                    %% If no better vector is found
            Linear_Search_Vector = rand(length(Initial_Parameters),1)-0.5;         %% Take a random vector
        end
        
        Current_Resource_Allocation = RecomendedResourceAllocation;
        
        if itteration == 5 %% Make this a dynamic hyperparameter - of the guessing game
            % LearningRate = 0.005;
            % TargetedMultiplicationFactor = 0.01;
            %AmplitudeOfLinearSearch = 0.01;
        end
        
        BestChangeArray(:,itteration) = Best_Change_In_CostFunction_FromAlgorithm;
    end
    figure
    Final_Parameters = Initial_Parameters;
    ax1 = subplot(3,1,1);
    plot(ax1,CostTracking)
    ylabel(ax1,'Value of Cost Function')
    xlabel(ax1,'Itterations')
    title(ax1,['Final Cost :' num2str(InitialCost1)])
    
    
    n = 1:length(CostTracking);
    ax2 = subplot(3,1,2);
    plot(ax2,n,ResourceAllocationArray(1,:),'-b',n,ResourceAllocationArray(2,:),'-r',n,ResourceAllocationArray(3,:),'-k')
    title(ax2,'Resource Allocation')
    ylabel(ax2,'Samples per algorithm')
    xlabel(ax2,'Itterations')
    legend(ax2,'Guessing Game','Pinball','Two Mode')
    
    
    ax3 = subplot(3,1,3);
    semilogy(ax3,n,BestChangeArray(1,:),'-bs',n,BestChangeArray(2,:),'-rs',n,BestChangeArray(3,:),'-ks')
    title(ax3,'Best Changes Due to algorithms')
    ylim(ax3,[min(min(BestChangeArray)) max(max(BestChangeArray))])
    ylabel(ax3,'Cost Improvement from Algorithm')
    xlabel(ax3,'Itterations')
    legend(ax3,'Guessing Game','Pinball','Two Mode')
    toc
    a = 1;
    
    
    %% Testing Accuracy
    if UseCostFunction2 == 1
        a = open('Data_From_Mnist.mat');
        X = a.X;
        Y = a.Y;
        NumberOfSamples = length(X(1,:));
        
        
        W1 = reshape(Final_Parameters(1:23520,1),length(X(:,1)),30);
        W2 = reshape(Final_Parameters(23521:24120,1),30,20);
        W3 = reshape(Final_Parameters(24121:24320,1),20,length(Y(:,1)));
        b1 = reshape(Final_Parameters(24321:24350,1),30,1);
        b2 = reshape(Final_Parameters(24351:24370,1),20,1);
        b3 = reshape(Final_Parameters(24371:24380,1),length(Y(:,1)),1);
        
        
        Z1 = W1.'*X + b1;
        A1 = 1./(1 + exp(-Z1));
        Z2 = W2.'*A1 + b2;
        A2 = 1./(1 + exp(-Z2));
        Z3 = W3.'*A2 + b3;
        A3 = 1./(1 + exp(-Z3));
        
        
        Predictions = zeros(length(Y(:,1)),length(Y(1,:)));
        if length(Y(:,1)) > 1
            for sample = 1:length(Y(1,:))
                [~,I] = max(A3(:,sample));
                Predictions(I,sample) = 1;
            end
        end
        
        Train_Error = 100*sum(sum((Predictions ~= Y))/(max(length(Y(:,1)),2)*length(Y(1,:))))
        
        
    end
    
    
    
    %%
    Initial_Parameters = Initial_Parameters_1;
    Initial_Parameters2 = Initial_Parameters_1;
    SecondBest_Parameters = Initial_Parameters ;
    RecomendedResourceAllocation = zeros(3,1);
    
    for algorithm1 = 1:5
        algorithm = 6-algorithm1
        
        Initial_Parameters = Initial_Parameters_1;
        Initial_Parameters2 = Initial_Parameters_1;
        if UseCostFunction1 == 1
            [InitialCost] = CostFunction(Initial_Parameters)
        end
        if UseCostFunction2 == 1
            [InitialCost] = CostFunction2(Initial_Parameters)
        end
        
        for itteration = 1:Number_Of_Ittertions
            
            if algorithm == 1
                % NumberRandomVectors = Number_Of_Samples_Per_itteration/3;
                %[ParametersArray,LengthOfVectors,RandomVectors] = Guessing_Game_Optimizer_Part1(Initial_Parameters,NumberRandomVectors,dt);
                [Suggested_Parameter_Samples_From_Guessing_Game1,LengthOfVectors,RandomVectors] = Guessing_Game_Optimizer_Version2_Part1(Initial_Parameters,NumberRandomVectors,dt);
                
                NumberOfSamples_For_Round2 = Number_Of_Samples_Per_itteration - length(Suggested_Parameter_Samples_From_Guessing_Game1(1,:));
                %[CostVector] = CostFunction(Suggested_Parameter_Samples_From_Guessing_Game1);
                [CostVector] = CostFunction2(Suggested_Parameter_Samples_From_Guessing_Game1);
                %Normalizing Cost
                %CostVector = CostVector/CostVector(1);
                % Part 2 of Guessing_Game_Optimizer
                [Suggested_Parameter_Samples_From_Guessing_Game2] = Guessing_Game_Optimizer_Version2_Part2(Initial_Parameters,NumberRandomVectors,CostVector,dt,RandomVectors,LengthOfVectors,NumberOfSamples_For_Round2,NumberOfSamples_For_AverageVector,AmplitudeOf_SingleVectors, AmplitudeOf_EvenVectors,AmplitudeOf_RandomVectors);
                ParametersArray = [Suggested_Parameter_Samples_From_Guessing_Game2 Suggested_Parameter_Samples_From_Guessing_Game1(:,1)];
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
            %   if algorithm == 1
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
            %    end
            
            
            %% From Pinball
            %   if algorithm == 2
            %       [~,I2] = min(CostVector);
            %       Best_Change_In_CostFunction_FromAlgorithm(2) = - (CostVector(RecomendedResourceAllocation(1) + 1 + I2-1) - InitialCost);
            %       Number_Of_Linear_Samples = round(Search_Ratio*Number_Of_Samples_Per_itteration);
            %   end
            
            
            %% From Two Mode
            %   if algorithm == 3
            %       [~,I3] = min(CostVector);
            %       Best_Change_In_CostFunction_FromAlgorithm(3) = - (CostVector(RecomendedResourceAllocation(1) + RecomendedResourceAllocation(2) + 1 + I3-1) - InitialCost);
            %   end
            
            
            
            %% Finding Absolute Best Sample, and reseting the initial parameter vector
            [InitialCost1,I] = min(CostVector);
            I
            Cost_Change = InitialCost1 - InitialCost;
            Parameter_ChangeVector = ParametersArray(:,I) - Initial_Parameters ;
            Initial_Parameters = ParametersArray(:,I);
            InitialCost = InitialCost1;
            
            
            CostVector(I) = max(CostVector);
            [InitialCost2,I2] = min(CostVector);
            SecondBest_Parameters = ParametersArray(:,I2);
            
            
            [LastCost] = CostFunction2(Initial_Parameters2);
            [Cost,I] = min([LastCost InitialCost]);
            Cost
            CostTracking_OfAlgorithms(itteration,algorithm) = Cost;
            if I == 1
                Initial_Parameters = Initial_Parameters2;
                Initial_Parameters2 = Initial_Parameters2;
            end
            if I == 2
                Initial_Parameters = Initial_Parameters;
                Initial_Parameters2 = Initial_Parameters;
            end
            
            
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
            
            BestChangeArray(:,itteration) = Best_Change_In_CostFunction_FromAlgorithm;
        end
    end
    toc
    
    Initial_Parameters = Initial_Parameters_1;
    if UseCostFunction1 == 1
        [InitialCost] = CostFunction(Initial_Parameters)
    end
    if UseCostFunction2 == 1
        [InitialCost] = CostFunction2(Initial_Parameters)
    end
    
    
    CostTracking_OfAlgorithms(:,6) = CostTracking.';
    CostTracking_OfAlgorithms1 = [ones(6,1)*InitialCost CostTracking_OfAlgorithms.'].';
    CostTracking_OfAlgorithms = CostTracking_OfAlgorithms1;
    CostTracking_OfAlgorithms = CostTracking_OfAlgorithms/max(max(CostTracking_OfAlgorithms));
    
    %% Resizing to between 0 and 1
    CostTracking_OfAlgorithms1 = CostTracking_OfAlgorithms;
    CostTracking_OfAlgorithms_Sum_No_Resizing = CostTracking_OfAlgorithms_Sum_No_Resizing + CostTracking_OfAlgorithms1;
    CostTracking_Array_Of_All_Runs_Sum_No_Resizing(:,:,initialization) = CostTracking_OfAlgorithms1;
    
    CostTracking_OfAlgorithms = (CostTracking_OfAlgorithms - min(min(CostTracking_OfAlgorithms)))/(1-min(min(CostTracking_OfAlgorithms)));
    CostTracking_OfAlgorithms_Sum = CostTracking_OfAlgorithms_Sum + CostTracking_OfAlgorithms;
    CostTracking_Array_Of_All_Runs(:,:,initialization) = CostTracking_OfAlgorithms;
    
    NumberOfRuns = NumberOfRuns+1;
    CostTracking_OfAlgorithms = 0;
    CostTracking_OfAlgorithms1 = 0;
end

t2 = toc


Mean_CostTracking_OfAlgorithms = CostTracking_OfAlgorithms_Sum/NumberOfRuns ;
CostTracking_OfAlgorithms = Mean_CostTracking_OfAlgorithms;

Mean_CostTracking_OfAlgorithms1 = CostTracking_OfAlgorithms_Sum_No_Resizing/NumberOfRuns ;
CostTracking_OfAlgorithms1 = Mean_CostTracking_OfAlgorithms1;

ErrorVector = zeros(size(CostTracking_OfAlgorithms));
ErrorVector_NoResizing = zeros(size(CostTracking_OfAlgorithms));
for i = 1:6
    %  ErrorVector(:,i) = std(squeeze(permute(CostTracking_Array_Of_All_Runs(:,i,:),[1 3 2])).').';
    %  ErrorVector_NoResizing(:,i) = std(squeeze(permute(CostTracking_Array_Of_All_Runs_Sum_No_Resizing(:,i,:),[1 3 2])).').';
    for initialization = 1:Number_Of_Initialization_Tests
        ErrorVector_NoResizing(:,i) = ErrorVector_NoResizing(:,i) + (CostTracking_Array_Of_All_Runs_Sum_No_Resizing(:,i,initialization) - Mean_CostTracking_OfAlgorithms1(:,i)).^2;
        ErrorVector(:,i) = ErrorVector_NoResizing(:,i) + (CostTracking_Array_Of_All_Runs(:,i,initialization) - Mean_CostTracking_OfAlgorithms(:,i)).^2;
    end
    ErrorVector_NoResizing(:,i) = sqrt(ErrorVector_NoResizing(:,i)/NumberOfRuns );
    ErrorVector(:,i) = sqrt(ErrorVector(:,i)/NumberOfRuns );
    
    % ErrorVector(:,i) = squeeze(permute(CostTracking_Array_Of_All_Runs(:,i,:),[1 3 2])).'.';
    % ErrorVector_NoResizing(:,i) = squeeze(permute(CostTracking_Array_Of_All_Runs_Sum_No_Resizing(:,i,:),[1 3 2])).'.';
    
    
end

n = 1:length(CostTracking_OfAlgorithms(:,1));

%% Plot with resizing
figure
hold on
for i = 1:6
    if i <=5
        errorbar(n,CostTracking_OfAlgorithms(:,i),ErrorVector(:,i))
    end
    if i == 6
        errorbar(n,CostTracking_OfAlgorithms(:,i),ErrorVector(:,i),'k')
    end
end
hold off
%plot(n,CostTracking_OfAlgorithms(:,1),'-b',n,CostTracking_OfAlgorithms(:,2),'-r',n,CostTracking_OfAlgorithms(:,3),'-g',n,CostTracking_OfAlgorithms(:,4),'-c',n,CostTracking_OfAlgorithms(:,5),'-y',n,CostTracking_OfAlgorithms(:,6),'-k')
title('Rescaled and resized cost function optimization of the different algorithms')
legend('Guessing Game','Pinball','Two Mode','RandomSearch','GeneticAlgorithm','Trio')
xlabel('Itteration (NU)')
ylabel('Rescaled Cost Function -C/C0 (NU)')

%% Plot without resizing
figure
hold on
for i = 1:6
    if i <=5
        errorbar(n,CostTracking_OfAlgorithms1(:,i),ErrorVector_NoResizing(:,i))
    end
    if i == 6
        errorbar(n,CostTracking_OfAlgorithms1(:,i),ErrorVector_NoResizing(:,i),'k')
    end
end
hold off
%plot(n,CostTracking_OfAlgorithms(:,1),'-b',n,CostTracking_OfAlgorithms(:,2),'-r',n,CostTracking_OfAlgorithms(:,3),'-g',n,CostTracking_OfAlgorithms(:,4),'-c',n,CostTracking_OfAlgorithms(:,5),'-y',n,CostTracking_OfAlgorithms(:,6),'-k')
title('Rescaled only cost function optimization of the different algorithms')
legend('Guessing Game','Pinball','Two Mode','RandomSearch','GeneticAlgorithm','Trio')
xlabel('Itteration (NU)')
ylabel('Rescaled Cost Function -C/C0 (NU)')


%% all the runs of the trio algorithm with rescaling and
figure
hold on
for initialization = 1:Number_Of_Initialization_Tests
    plot(n,squeeze(CostTracking_Array_Of_All_Runs_Sum_No_Resizing(:,6,initialization)),'k');
end
errorbar(n,CostTracking_OfAlgorithms1(:,6),ErrorVector_NoResizing(:,6),'k','LineWidth',2.5);
hold off
title('Different initialization of the Trio algorithm - the mean is in bold')
xlabel('Itteration (NU)')
ylabel('Rescaled Cost Function -C/C0 (NU)')