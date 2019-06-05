function [MoveAngles,MoveSummery,InitialAngles,PrincipleAxis] = GenerateSwimmingMoves(NumberOfLimbs,NumberOfJointsPerLimb,LengthOfEachSegmentOfTheLimb,FoodLocation,MyLocation);



%% First task will be walking to the target
NumberOfLimbs = 4;
NumberOfJointsPerLimb = 2;
LengthOfEachSegmentOfTheLimb = 2;
FoodRange = 3;
FoodEaten = 0;

%% Initalization parameters
FoodLocation = 2*FoodRange*(rand(1,2)-0.5);
MyLocation = [0 0];

%Working On Locomotion alone
%FoodLocation = MyLocation;


Angles_Of_Each_Joint = zeros(1,NumberOfLimbs*NumberOfJointsPerLimb);

InitialDistanceToFood = pdist([FoodLocation;MyLocation],'euclidean');

%InitialAngle = 0;
InitialAngle = 0;
for i = 1:NumberOfLimbs
    
    %% symetric initial limbs
    InitialAngle = InitialAngle+ pi/NumberOfLimbs;
    
    %focused initial limbs
    %InitialAngle = InitialAngle+ 0.5*pi/NumberOfLimbs;
    
    for j = 1:NumberOfJointsPerLimb
        Angles_Of_Each_Joint((i-1)*NumberOfJointsPerLimb + j) = InitialAngle;
    end
end

InitialAngles = Angles_Of_Each_Joint;
PrincipleAxis = [mean(cos(InitialAngles)) mean(sin(InitialAngles))] ;

DirectionOfPrincipleAxis = zeros(4,1)
DirectionOfPrincipleAxis(2) = PrincipleAxis(1)
DirectionOfPrincipleAxis(4) = PrincipleAxis(2)
DegreesBetweenEachState = 10
%% Generating the state space


%% Examination of initial state
Xlimits = [-50 50];
Ylimits = [-50 50];
[f] = GNN_PlotBody(Xlimits,Ylimits,MyLocation,NumberOfLimbs,NumberOfJointsPerLimb,LengthOfEachSegmentOfTheLimb,Angles_Of_Each_Joint,FoodLocation);
%hold on
plot(DirectionOfPrincipleAxis(1:2),DirectionOfPrincipleAxis(3:4),'--r')



% General Input Vecotr
InputVector = [Angles_Of_Each_Joint MyLocation FoodLocation];

%% Locomotion Input Vecotr
PlotBody = 0;
%InputVector = [Angles_Of_Each_Joint];

NumberOfMoves = 10;
DistanceFromFood = zeros(NumberOfMoves,1);
TotalDistance = zeros(NumberOfMoves,1);
ActionVector = 5*(-3:1:3)*2*pi/360; %% 10 degrees moves


NumberOfMovesInSequence = 10;
NumberOfIndividuals_InEachGeneration = 5;
NumberOfGenerations = 5;
NumberOfFamilies = 10;
MutationSize = 1;
NumberOfTrainingCycles = 2;

FittnessWeights = [1000 -50 -50 -50 -10 -100];
TrainFor = 1
%FittnessWeights = [propermovement rotation bodysmoothness legsmoothness energy];

FittnessFunction = zeros(NumberOfIndividuals_InEachGeneration,1);
p = 1;

%CyclicSimilarity = zeros(NumberOfMoves/CycleLength,1);

%% Generating The Initial Weights
%load('GenerationalWeights','GenerationalWeights')
%GenerationalWeights = rand(length(ActionVector)*length(Angles_Of_Each_Joint),length(InputVector),NumberOfIndividuals_InEachGeneration)-0.5;


%% Creating The First Generation of the family
TrainFor = 0;
for i = 1:2 %% 1 is forward movement, 2 is rotations
    
    TrainFor = TrainFor + 1
    %TrainFor = 3
    MaxFittnes = -1000;
    %% InitialContest
    for family = 1:NumberOfFamilies
        family
        
        RandomMoveBankForGeneration = ceil(5*rand(NumberOfMovesInSequence,30*length(Angles_Of_Each_Joint)*NumberOfIndividuals_InEachGeneration));
        GoodMovesForGeneration = reshape(nonzeros(RandomMoveBankForGeneration *diag(mean(RandomMoveBankForGeneration) == 3)),NumberOfMovesInSequence,length(nonzeros(RandomMoveBankForGeneration *diag(mean(RandomMoveBankForGeneration) == 3)))/NumberOfMovesInSequence);
        
        % GoodMovesForGeneration = reshape(nonzeros(RandomMoveBankForGeneration *diag(mod(sum(RandomMoveBankForGeneration ),3) == 0)),NumberOfMovesInSequence,length(nonzeros(RandomMoveBankForGeneration *diag(mod(sum(RandomMoveBankForGeneration ),3) == 0)))/NumberOfMovesInSequence);
        SelectedMovesForIndividual = reshape(GoodMovesForGeneration(:,1:length(Angles_Of_Each_Joint)*NumberOfIndividuals_InEachGeneration),NumberOfMovesInSequence,length(Angles_Of_Each_Joint),NumberOfIndividuals_InEachGeneration);
        ExtendedNextActionMatrix = diag(ActionVector)*ones(length(ActionVector),length(Angles_Of_Each_Joint));
        AngleMovesMatrix = ExtendedNextActionMatrix(SelectedMovesForIndividual); % Move, Leg, Individual
        
        
        
        for generation = 1:NumberOfGenerations
            FittnessFunction = zeros(NumberOfIndividuals_InEachGeneration,1);
            
            for individual = 1:NumberOfIndividuals_InEachGeneration
                %% Testing The Fittness Of each individual of the generation
                MyLocation = [0 0];
                Angles_Of_Each_Joint = InitialAngles;
                
                
                [FittnessFunction(individual),SequenceSummery] = GNN_TestingFittnessOfIndividual(InitialAngles,NumberOfTrainingCycles,NumberOfMovesInSequence,AngleMovesMatrix(:,:,individual),PrincipleAxis,NumberOfLimbs,NumberOfJointsPerLimb,LengthOfEachSegmentOfTheLimb,PlotBody,Xlimits,Ylimits,FoodLocation,TrainFor);
                
            end
            
            
            %% Finding The Fittest individual Function for staright locomotion
            [M,I] = max(FittnessFunction);
            FittestIndividual = SelectedMovesForIndividual(:,:,I);
            FittestAngleMoves = AngleMovesMatrix(:,:,I);
            
            
            %% Generating the next generation from the fittest sequence
            RandomMoveBankForGeneration = repelem(FittestIndividual.',20*NumberOfIndividuals_InEachGeneration,1).' + round(MutationSize*(length(ActionVector)-1)*rand(NumberOfMovesInSequence,20*length(Angles_Of_Each_Joint)*NumberOfIndividuals_InEachGeneration)-MutationSize*(length(ActionVector)-1)/2);
            RandomMoveBankForGeneration = min(length(ActionVector),RandomMoveBankForGeneration);
            RandomMoveBankForGeneration = max(1,RandomMoveBankForGeneration);
            GoodMovesForGeneration = reshape(nonzeros(RandomMoveBankForGeneration *diag(mean(RandomMoveBankForGeneration) == 3)),NumberOfMovesInSequence,length(nonzeros(RandomMoveBankForGeneration *diag(mean(RandomMoveBankForGeneration) == 3)))/NumberOfMovesInSequence);
            SelectedMovesForIndividual = reshape(GoodMovesForGeneration(:,1:length(Angles_Of_Each_Joint)*NumberOfIndividuals_InEachGeneration),NumberOfMovesInSequence,length(Angles_Of_Each_Joint),NumberOfIndividuals_InEachGeneration);
            ExtendedNextActionMatrix = diag(ActionVector)*ones(length(ActionVector),length(Angles_Of_Each_Joint));
            AngleMovesMatrix = ExtendedNextActionMatrix(SelectedMovesForIndividual); % Move, Leg, Individual
            AngleMovesMatrix(:,:,1) = FittestAngleMoves; % insterting the previous fittest
        end
        
        
        if FittnessFunction(I) >= MaxFittnes
            MaxFittestIndividual = FittestIndividual;
            MaxFittestAngleMoves = FittestAngleMoves;
            MaxFittnes = FittnessFunction(I)
        end
        
    end
    %AngleMovesMatrix = MaxFittestAngleMoves;
    
    %% Optimizing The Fittest - with decreasing mutation rate (annealing)
    OptimizeTheFittest = 0;
    
    if OptimizeTheFittest == 1
        
        NumberOfGenerations = 30;
        initialMutationSize = 1;
        directionOfMovement = 0;
        
        
        % Creating a Generation from the fittest
        RandomMoveBankForGeneration = repelem(MaxFittestIndividual.',20*NumberOfIndividuals_InEachGeneration,1).' + round(MutationSize*(length(ActionVector)-1)*rand(NumberOfMovesInSequence,20*length(Angles_Of_Each_Joint)*NumberOfIndividuals_InEachGeneration)-MutationSize*(length(ActionVector)-1)/2);
        RandomMoveBankForGeneration = min(length(ActionVector),RandomMoveBankForGeneration);
        RandomMoveBankForGeneration = max(1,RandomMoveBankForGeneration);
        GoodMovesForGeneration = reshape(nonzeros(RandomMoveBankForGeneration *diag(mean(RandomMoveBankForGeneration) == 3)),NumberOfMovesInSequence,length(nonzeros(RandomMoveBankForGeneration *diag(mean(RandomMoveBankForGeneration) == 3)))/NumberOfMovesInSequence);
        SelectedMovesForIndividual = reshape(GoodMovesForGeneration(:,1:length(Angles_Of_Each_Joint)*NumberOfIndividuals_InEachGeneration),NumberOfMovesInSequence,length(Angles_Of_Each_Joint),NumberOfIndividuals_InEachGeneration);
        ExtendedNextActionMatrix = diag(ActionVector)*ones(length(ActionVector),length(Angles_Of_Each_Joint));
        AngleMovesMatrix = ExtendedNextActionMatrix(SelectedMovesForIndividual); % Move, Leg, Individual
        AngleMovesMatrix(:,:,1) = MaxFittestAngleMoves; % insterting the previous fittest
        
        
        for generation = 1:NumberOfGenerations
            FittnessFunction = zeros(NumberOfIndividuals_InEachGeneration,1);
            MutationSize = initialMutationSize*exp(-generation/NumberOfGenerations);
            
            
            for individual = 1:NumberOfIndividuals_InEachGeneration
                %% Testing The Fittness Of each individual of the generation
                MyLocation = [0 0];
                Angles_Of_Each_Joint = InitialAngles;
                
                [FittnessFunction(individual),SequenceSummery] = GNN_TestingFittnessOfIndividual(InitialAngles,NumberOfTrainingCycles,NumberOfMovesInSequence,AngleMovesMatrix(:,:,individual),PrincipleAxis,NumberOfLimbs,NumberOfJointsPerLimb,LengthOfEachSegmentOfTheLimb,PlotBody,Xlimits,Ylimits,FoodLocation,TrainFor);
                
            end
            
            %% Finding The Fittest individual Function for staright locomotion
            [M,I] = max(FittnessFunction);
            M
            FittestIndividual = SelectedMovesForIndividual(:,:,I);
            FittestAngleMoves = AngleMovesMatrix(:,:,I);
            
            
            %% Generating the next generation from the fittest sequence
            RandomMoveBankForGeneration = repelem(FittestIndividual.',20*NumberOfIndividuals_InEachGeneration,1).' + round(MutationSize*(length(ActionVector)-1)*rand(NumberOfMovesInSequence,20*length(Angles_Of_Each_Joint)*NumberOfIndividuals_InEachGeneration)-MutationSize*(length(ActionVector)-1)/2);
            RandomMoveBankForGeneration = min(length(ActionVector),RandomMoveBankForGeneration);
            RandomMoveBankForGeneration = max(1,RandomMoveBankForGeneration);
            GoodMovesForGeneration = reshape(nonzeros(RandomMoveBankForGeneration *diag(mean(RandomMoveBankForGeneration) == 3)),NumberOfMovesInSequence,length(nonzeros(RandomMoveBankForGeneration *diag(mean(RandomMoveBankForGeneration) == 3)))/NumberOfMovesInSequence);
            SelectedMovesForIndividual = reshape(GoodMovesForGeneration(:,1:length(Angles_Of_Each_Joint)*NumberOfIndividuals_InEachGeneration),NumberOfMovesInSequence,length(Angles_Of_Each_Joint),NumberOfIndividuals_InEachGeneration);
            ExtendedNextActionMatrix = diag(ActionVector)*ones(length(ActionVector),length(Angles_Of_Each_Joint));
            AngleMovesMatrix = ExtendedNextActionMatrix(SelectedMovesForIndividual); % Move, Leg, Individual
            AngleMovesMatrix(:,:,1) = FittestAngleMoves; % insterting the previous fittest
            
        end
        
        MaxFittestAngleMoves = FittestAngleMoves;
    end
    
    
    %% Viewing the fittest
    MyLocation = [0 0];
    Angles_Of_Each_Joint = InitialAngles;
    PlotBody = 0;
    NumberOfTrainingCycles = 10;
    
    [FittnessFunction(individual),SequenceSummery] = GNN_TestingFittnessOfIndividual(InitialAngles,NumberOfTrainingCycles,NumberOfMovesInSequence,MaxFittestAngleMoves,PrincipleAxis,NumberOfLimbs,NumberOfJointsPerLimb,LengthOfEachSegmentOfTheLimb,PlotBody,Xlimits,Ylimits,FoodLocation,TrainFor);
    PlotBody = 0;
    
    if TrainFor == 1
        MoveAngles(:,:,1) = FittestAngleMoves;
        MoveSummery(1,:) = SequenceSummery;
    end
    if TrainFor == 2
        MoveAngles(:,:,2) = FittestAngleMoves;
        MoveSummery(2,:) = SequenceSummery;
    end
    
end

PlotBody = 0;
for i = 1:2
    Angles_Of_Each_Joint = InitialAngles;
    [FittnessFunction(individual),SequenceSummery] = GNN_TestingFittnessOfIndividual(InitialAngles,NumberOfTrainingCycles,NumberOfMovesInSequence,MoveAngles(:,:,i),PrincipleAxis,NumberOfLimbs,NumberOfJointsPerLimb,LengthOfEachSegmentOfTheLimb,PlotBody,Xlimits,Ylimits,FoodLocation,TrainFor);
end

