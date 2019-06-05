clear
clear all
clc



%% First task will be walking to the target
NumberOfLimbs = 4;
NumberOfJointsPerLimb = 2;
LengthOfEachSegmentOfTheLimb = 2;
FoodRange = 5;
FoodEaten = 0;

%% Initalization parameters
FoodLocation = 2*FoodRange*(rand(1,2)-0.5);
MyLocation = [0 0];
AngleToFood = atan((FoodLocation(2) - MyLocation(2)/(FoodLocation(1) - MyLocation(1))));

%% Using Regular Genetic Nural Network Algorithm
%[MoveAngles,MoveSummery,InitialAngles,PrincipleAxis] = GenerateSwimmingMoves_ForGNN(NumberOfLimbs,NumberOfJointsPerLimb,LengthOfEachSegmentOfTheLimb,FoodLocation,MyLocation);

%% Using Regular Genetic Algorithm
[MoveAngles,MoveSummery,InitialAngles,PrincipleAxis] = GenerateSwimmingMoves(NumberOfLimbs,NumberOfJointsPerLimb,LengthOfEachSegmentOfTheLimb,FoodLocation,MyLocation);

TrainFor = 1;
PlotBody = 1;
Xlimits = [-15 15];
Ylimits = [-15 15];
NumberOfMovesInSequence = 10;
NumberOfTrainingCycles = 7;
for i = 1:2
    Angles_Of_Each_Joint = InitialAngles;
    [FittnessFunction,SequenceSummery] = GNN_TestingFittnessOfIndividual(InitialAngles,NumberOfTrainingCycles,NumberOfMovesInSequence,MoveAngles(:,:,i),PrincipleAxis,NumberOfLimbs,NumberOfJointsPerLimb,LengthOfEachSegmentOfTheLimb,PlotBody,Xlimits,Ylimits,FoodLocation,TrainFor);
end


%% Finding the current state
TotalMovesInLearningSesson = 100000
NumberOfTrainingCycles = 2;
AngularStates = -8:8;
NumberOfStates = 4*length(AngularStates);
PropForNextMove = 0.5*ones(4,length(AngularStates),2);
FinalPrincipleAxis = 0;
moveNumber = 1;
K_OfLastEatenFood = 0;
OldMinDistanceToFood = 0;
Probabalistic_Next_Action_Selection = 1;
Deterministic_Next_Action_Selection = 0;
Reward_and_PunishDistance = 0;
DistanceToFoodVector = zeros(TotalMovesInLearningSesson,1);
n = 1;
OldAvarageDistanceFromLast3Moves = 0;
Punish_Distance = 1;
Punish_BounceBack = 1;
Reward_Distance = 1;
OldMinDistanceToFood = 0;

for k = 1:TotalMovesInLearningSesson
    
    k
    MyLocation
    %AngleToFood = atan(MyLocation(2)/MyLocation(1)) - atan(FoodLocation(2)/FoodLocation(1));
    %% Finding the new state
    RelativeAngle = round((FinalPrincipleAxis - AngleToFood)*8/pi);
    DistanceToFood = pdist([FoodLocation;MyLocation],'euclidean');
    [M,I] = max([mod(DistanceToFood,3) mod(DistanceToFood,6) mod(DistanceToFood,10)]); %% returns the index of the upper estimate of the target]
    Positionstate = I;
    if DistanceToFood > 10
        Positionstate = 4;
    end
    [M,I] = max( AngularStates == RelativeAngle);
    Angularstate = I;
    
    %%  Probabalistic Next Action Selection
    if Probabalistic_Next_Action_Selection == 1
        RandomNumber = rand(1,1);
        if RandomNumber < PropForNextMove(Positionstate,Angularstate,1)
            [FinalPrincipleAxis,InitialAngles,MyLocation, MinDistanceToFood] = SwimSelectedMove(InitialAngles,NumberOfTrainingCycles,NumberOfMovesInSequence,MoveAngles(:,:,1),PrincipleAxis,NumberOfLimbs,NumberOfJointsPerLimb,LengthOfEachSegmentOfTheLimb,PlotBody,Xlimits,Ylimits,FoodLocation,MyLocation,TrainFor);
            selectedmove = 1;
            
        end
        if RandomNumber >= PropForNextMove(Positionstate,Angularstate,1)
            [FinalPrincipleAxis,InitialAngles,MyLocation, MinDistanceToFood] = SwimSelectedMove(InitialAngles,NumberOfTrainingCycles,NumberOfMovesInSequence,MoveAngles(:,:,2),PrincipleAxis,NumberOfLimbs,NumberOfJointsPerLimb,LengthOfEachSegmentOfTheLimb,PlotBody,Xlimits,Ylimits,FoodLocation,MyLocation,TrainFor);
            selectedmove = 2;
        end
        AngleToFood = atan((FoodLocation(2) - MyLocation(2)/(FoodLocation(1) - MyLocation(1))));
        FinalPrincipleAxis1 = atan(FinalPrincipleAxis(2)/FinalPrincipleAxis(1));
        FinalPrincipleAxis = FinalPrincipleAxis1;
    end
    
    
    MyLocation
    %%  Deterministic Next Action Selection
    if Deterministic_Next_Action_Selection == 1;
        [M,I] = max(PropForNextMove(Positionstate,Angularstate,:));
        selectedmove = I;
        [FinalPrincipleAxis,InitialAngles,MyLocation, MinDistanceToFood] = SwimSelectedMove(InitialAngles,NumberOfTrainingCycles,NumberOfMovesInSequence,MoveAngles(:,:,I),PrincipleAxis,NumberOfLimbs,NumberOfJointsPerLimb,LengthOfEachSegmentOfTheLimb,PlotBody,Xlimits,Ylimits,FoodLocation,MyLocation,TrainFor);
        AngleToFood = atan((FoodLocation(2) - MyLocation(2)/(FoodLocation(1) - MyLocation(1))));
        FinalPrincipleAxis1 = atan(FinalPrincipleAxis(2)/FinalPrincipleAxis(1));
        FinalPrincipleAxis = FinalPrincipleAxis1;
    end
    
    
    %% Reseting Location if it leave the perimiter of the screen
    BounceBack = 0;
    if MyLocation(1) < Xlimits (1)
        MyLocation(1) = MyLocation(1) + 5;
        BounceBack = 1;
    end
    if MyLocation(1) > Xlimits (2)
        MyLocation(1) = MyLocation(1) - 5;
        BounceBack = 1;
    end
    if MyLocation(2) < Ylimits (1)
        MyLocation(2) = MyLocation(2) + 5;
        BounceBack = 1;
    end
    if MyLocation(2) > Ylimits (2)
        MyLocation(2) = MyLocation(2) - 5;
        BounceBack = 1;
    end
    
    MyLocation
    %% Tracking the excecuted moves
    ExcecutedTransitions(moveNumber,:) = [Positionstate Angularstate selectedmove];
    moveNumber = moveNumber +1;
    
    
    %% If he eats the food he gets a big reward - Main reward
    
    if  MinDistanceToFood<2
        K_OfLastEatenFood = k;
        
        FoodLocation = 2*FoodRange*(rand(1,2)-0.5);
        % Update Propabilities
        for p = 1:length(ExcecutedTransitions(:,1))
            if ExcecutedTransitions(p,1) ~= 0
                PropForNextMove(ExcecutedTransitions(p,1),ExcecutedTransitions(p,2),ExcecutedTransitions(p,3)) = PropForNextMove(ExcecutedTransitions(p,1),ExcecutedTransitions(p,2),ExcecutedTransitions(p,3)) + 1;
            end
        end
        % normalization
        % this place can be vastly optimized
        for i = 1:length(AngularStates)
            for j = 1:4
                PropForNextMove(j,i,:) = PropForNextMove(j,i,:)/sum(PropForNextMove(j,i,:));
            end
        end
        %PropForNextMove
        moveNumber = 1;
        ExcecutedTransitions(:,:,:) = 0;
    end
    
    if mod(k,50) == 0
    PropForForwardMovements = PropForNextMove(:,:,1)
    PropForSideMovements = PropForNextMove(:,:,2)
    end
    
    %% If he didn't eat for a while - punnish those last moves - Main Punishment
    if moveNumber >= 10
        for p = 1:length(ExcecutedTransitions(:,1))
            j =  length(ExcecutedTransitions(:,1)) - p+1;
            if ExcecutedTransitions(j,1) ~= 0
                PropForNextMove(ExcecutedTransitions(j,1),ExcecutedTransitions(j,2),ExcecutedTransitions(j,3)) = 0.6*PropForNextMove(ExcecutedTransitions(j,1),ExcecutedTransitions(j,2),ExcecutedTransitions(j,3));
                n = n +1;
            end
            if n > 10
                break
            end
        end
        % normalization
        % this place can be vastly optimized
        for i = 1:length(AngularStates)
            for j = 1:4
                PropForNextMove(j,i,:) = PropForNextMove(j,i,:)/sum(PropForNextMove(j,i,:));
            end
        end
        %PropForNextMove
        moveNumber = 1;
        ExcecutedTransitions(:,:,:) = 0;
    end
    
    DistanceToFoodVector(k) = MinDistanceToFood;
    
    
    
    
    if Reward_and_PunishDistance == 1
        
        if Reward_Distance  == 1
            
            %% If he gets closer - give him a small reward
            if MinDistanceToFood > 10
                if BounceBack == 0
            if OldMinDistanceToFood -MinDistanceToFood  > 4
                % Update Propabilities
                for p = 1:length(ExcecutedTransitions(:,1))
                    j = length(ExcecutedTransitions(:,1)) - p+1;
                    if ExcecutedTransitions(j,1) ~= 0
                        PropForNextMove(ExcecutedTransitions(j,1),ExcecutedTransitions(j,2),ExcecutedTransitions(j,3)) = PropForNextMove(ExcecutedTransitions(j,1),ExcecutedTransitions(j,2),ExcecutedTransitions(j,3)) + 0.1;
                        break
                    end
                end
                n = 1;
                % normalization
                % this place can be vastly optimized
                for i = 1:length(AngularStates)
                    for j = 1:4
                        PropForNextMove(j,i,:) = PropForNextMove(j,i,:)/sum(PropForNextMove(j,i,:));
                    end
                end
            end
                end
            end
        end
        if Punish_Distance  == 1
            %% If he goes further - punish him a bit
            if MinDistanceToFood > 10
            if  MinDistanceToFood-OldMinDistanceToFood > 2
                
                % Update Propabilities
                for p = 1:length(ExcecutedTransitions(:,1))
                    j = length(ExcecutedTransitions(:,1)) - p+1;
                    if ExcecutedTransitions(j,1) ~= 0
                        if PropForNextMove(ExcecutedTransitions(j,1),ExcecutedTransitions(j,2),ExcecutedTransitions(j,3)) > 0.3
                            PropForNextMove(ExcecutedTransitions(j,1),ExcecutedTransitions(j,2),ExcecutedTransitions(j,3)) = 0.85*PropForNextMove(ExcecutedTransitions(j,1),ExcecutedTransitions(j,2),ExcecutedTransitions(j,3));
                            break
                        end
                    end
                end
                n = 1;
                % normalization
                % this place can be vastly optimized
                for i = 1:length(AngularStates)
                    for j = 1:4
                        PropForNextMove(j,i,:) = PropForNextMove(j,i,:)/sum(PropForNextMove(j,i,:));
                    end
                end
            end
            end
             
            
            %OldAvarageDistanceFromLast3Moves   = AvarageDistanceFromLast3Moves   ;
        end
        
        
        if Punish_BounceBack  == 1
            if BounceBack == 1
                        % Update Propabilities
                for p = 1:length(ExcecutedTransitions(:,1))
                    j = length(ExcecutedTransitions(:,1)) - p+1;
                    if ExcecutedTransitions(j,1) ~= 0
                        if PropForNextMove(ExcecutedTransitions(j,1),ExcecutedTransitions(j,2),ExcecutedTransitions(j,3)) > 0.3
                            PropForNextMove(ExcecutedTransitions(j,1),ExcecutedTransitions(j,2),ExcecutedTransitions(j,3)) = 0.85*PropForNextMove(ExcecutedTransitions(j,1),ExcecutedTransitions(j,2),ExcecutedTransitions(j,3));
                            n = n +1;
                        end
                        if n > 3
                            break
                        end
                    end
                end
                n = 1;
                % normalization
                % this place can be vastly optimized
                for i = 1:length(AngularStates)
                    for j = 1:4
                        PropForNextMove(j,i,:) = PropForNextMove(j,i,:)/sum(PropForNextMove(j,i,:));
                    end
                end
            end
        end
    end
    OldMinDistanceToFood = MinDistanceToFood;
end
