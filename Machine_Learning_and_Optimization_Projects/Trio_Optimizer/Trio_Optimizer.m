function [Final_Parameters] = Trio_Optimizer(Initial_Parameters,Number_Of_Ittertions,Number_Of_Samples_Per_itteration)

UsePreset_Variables = 1;
if UsePreset_Variables == 1
    TotalNumber_OfParameters = 24380;
    Initial_Parameters = rand(TotalNumber_OfParameters,1)-0.5;
    Number_Of_Samples_Per_itteration = 90;
    Number_Of_Ittertions = 10;
end

%[InitialCost] = CostFunction(Initial_Parameters)
[InitialCost] = CostFunction2(Initial_Parameters)

%% Resource Distribution Algorithm - HyperParameters
Initial_Resource_Allocation = [30 30 30];
Current_Resource_Allocation =Initial_Resource_Allocation;
Best_Change_In_CostFunction_FromAlgorithm = [0 0 0];
MassVector = 10*[1 1 1];
Self_Interaction_Spring_Constants = 5*[1 1 1];
Neighboring_Algorithm_Interaction_Spring_Constants = 20*[1 1 1];
Epsilon1 = 0.01;




%% Guessing Game HyperParameters
dt = 0.01;
LearningRate = 0.05;



%% Pinball HyperParameters
Search_Ratio = 0.7;
AmplitudeOfLinearSearch = 0.05;
AmplitudeOfRandomSearch = 0.1;
Linear_Search_Vector = rand(length(Initial_Parameters),1)-0.5;


%% Two Mode HyperParameters
TargetedSearchDecayRate = 1;
RandomSearchGrowthRate = 0.5;
TargetedMultiplicationFactor = 0.0001;
RandomMultiplicationFactor = 0.1;
SignificantChangeValue = 0.1;
Parameter_ChangeVector = zeros(length(Initial_Parameters),1);
Cost_Change = 0;
ImprovementItteration = 1;

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
        NumberRandomVectors = RecomendedResourceAllocation(1)/3;
        [Suggested_Parameter_Samples_From_Guessing_Game,LengthOfVectors,RandomVectors] = Guessing_Game_Optimizer_Part1(Initial_Parameters,NumberRandomVectors,dt);
    end
    
    if RecomendedResourceAllocation(2) > 0
        [Suggested_Parameter_Samples_From_Pinball] = Pinball_Optimizer(Initial_Parameters,RecomendedResourceAllocation(2),Search_Ratio,AmplitudeOfLinearSearch,AmplitudeOfRandomSearch,Linear_Search_Vector);
    end
    
    if RecomendedResourceAllocation(3) > 0
        [Suggested_Parameter_Samples_From_Two_Mode,ImprovementItteration] = Two_Mode_Optimizer(Initial_Parameters,RecomendedResourceAllocation(3),Parameter_ChangeVector,Cost_Change,ImprovementItteration,TargetedSearchDecayRate,RandomSearchGrowthRate,TargetedMultiplicationFactor,RandomMultiplicationFactor,SignificantChangeValue);
    end
    
    
    %% Connecting and testing the cost function of all samples
    ParametersArray = [ Suggested_Parameter_Samples_From_Guessing_Game  Suggested_Parameter_Samples_From_Pinball Suggested_Parameter_Samples_From_Two_Mode Initial_Parameters];
    %[CostVector] = CostFunction(ParametersArray);
    [CostVector] = CostFunction2(ParametersArray);

    
    
    %% Finding the best improvement of each algorithm
    
    
    %% From Guessing Game
    if RecomendedResourceAllocation(1) > 0 % Part 2 of Guessing_Game_Optimizer
        [Suggested_Parameter_Samples_From_Guessing_Game] = Guessing_Game_Optimizer_Part2(Initial_Parameters,NumberRandomVectors,CostVector,dt,RandomVectors,LengthOfVectors,LearningRate);
        %[CostVector(1)] = CostFunction(Suggested_Parameter_Samples_From_Guessing_Game);
        [CostVector(1)] = CostFunction2(Suggested_Parameter_Samples_From_Guessing_Game);
        ParametersArray(:,1) = Suggested_Parameter_Samples_From_Guessing_Game;
    end
    [~,I1] = min(CostVector(1:RecomendedResourceAllocation(1)));
    Best_Change_In_CostFunction_FromAlgorithm(1) = - (CostVector(1 + I1-1) - InitialCost);
    
    
    
    %% From Pinball
    [~,I2] = min(CostVector(RecomendedResourceAllocation(1) + 1:RecomendedResourceAllocation(1) + RecomendedResourceAllocation(2)));
    Best_Change_In_CostFunction_FromAlgorithm(2) = - (CostVector(RecomendedResourceAllocation(1) + 1 + I2-1) - InitialCost);
    Number_Of_Linear_Samples = round(Search_Ratio*RecomendedResourceAllocation(2));

    
    
    %% From Two Mode
    [~,I3] = min(CostVector(RecomendedResourceAllocation(1) + RecomendedResourceAllocation(2) + 1:RecomendedResourceAllocation(1) + RecomendedResourceAllocation(2)+ RecomendedResourceAllocation(3)+1));
    Best_Change_In_CostFunction_FromAlgorithm(3) = - (CostVector(RecomendedResourceAllocation(1) + RecomendedResourceAllocation(2) + 1 + I3-1) - InitialCost);
    
    
    
    
    %% Finding Absolute Best Sample, and reseting the initial parameter vector
    [InitialCost1,I] = min(CostVector)
    Cost_Change = InitialCost1 - InitialCost;
    Parameter_ChangeVector = ParametersArray(:,I) - Initial_Parameters ;
    Initial_Parameters = ParametersArray(:,I);
    InitialCost = InitialCost1;
    CostTracking(itteration) = InitialCost1;
    
    %% This is for the pinball algorithm
        % Find the best choice for the next linear search vector - For the
    if I == I2 && I2 >Number_Of_Linear_Samples
        %if I2 >Number_Of_Linear_Samples                                          %% If the best vector was from the random batch
        Linear_Search_Vector = New_ParameterVector - Old_ParameterVector;   %% Take a vector that follows the gradient
    else                                                                    %% If no better vector is found
        Linear_Search_Vector = rand(length(Initial_Parameters),1)-0.5;         %% Take a random vector
    end
    
    Current_Resource_Allocation = RecomendedResourceAllocation;
    
    if itteration == 200 %% Make this a dynamic hyperparameter - of the guessing game
        LearningRate = 0.005;
        TargetedMultiplicationFactor = 0.01;
        AmplitudeOfLinearSearch = 0.01;
    end
    
    BestChangeArray(:,itteration) = Best_Change_In_CostFunction_FromAlgorithm;
end

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

a = 1;
