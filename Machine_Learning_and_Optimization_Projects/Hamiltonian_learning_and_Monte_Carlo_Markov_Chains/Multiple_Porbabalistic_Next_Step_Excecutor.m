function [Locations_Of_Ants] = Multiple_Porbabalistic_Next_Step_Excecutor(NextMoveArray,ObsticlesMatrix,TargetsMatrix,Hamiltonian_Parameters,Locations_Of_Enemy_Ants,ChangeVector_Of_Enemy_Ants,Locations_Of_Friendly_Ants_Before,ChangeVector_Of_Friendly_Ants,Use_TargetsAndObsticles)


%% r^2 is a long range potential whic decays at small distances
%% 1/r^2 is the oposite


InteractionStrength = 1;
ObsticleInteractionStrength = 10;
TargetInteractionStrength = 1;

TransitionProbability = 1;
Decay_Probability_Percentile = 1;
TotalNumberOFMoves = length(NextMoveArray(1,1,:));
NumberOfAnts = length(NextMoveArray(1,:,1));

%% Preallocating Interaction terms
Distance_InteractionEnergy_WithComrades = zeros(1,TotalNumberOFMoves);
DistanceInteractionEnergy_With_Enemies= zeros(1,TotalNumberOFMoves);
DotProductInteraction = zeros(1,TotalNumberOFMoves);
ObsticlesEnergy = zeros(1,TotalNumberOFMoves);
TargetsEnergy = zeros(1,TotalNumberOFMoves);
Right_Vector_Product_Interaction= zeros(1,TotalNumberOFMoves);
Left_Vector_Product_Interaction= zeros(1,TotalNumberOFMoves);

Locations_Of_Ants = NextMoveArray(:,:,1);


%% This is the loop for calculating the interaction terms for all possible moves
for move = 1:TotalNumberOFMoves
    
    %% This is the distance Ineraction between ants in the same army
Relative_X = diag(NextMoveArray(1,:,move))*ones(NumberOfAnts) - ones(NumberOfAnts)*diag(NextMoveArray(1,:,move));
Relative_Y = diag(NextMoveArray(2,:,move))*ones(NumberOfAnts)  - ones(NumberOfAnts)*diag(NextMoveArray(2,:,move));

RelativePositionSquared = Relative_X.^2 + Relative_Y.^2;
% Leonard Jones like Interaction energy
Distance_InteractionEnergy_WithComrades(move) = sum(sum(Hamiltonian_Parameters(1)./(nonzeros(RelativePositionSquared.^2)) - Hamiltonian_Parameters(1)./nonzeros(RelativePositionSquared)));


%% This is the Distance Interaction with the Enemies
Relative_X = diag(NextMoveArray(1,:,move))*ones(NumberOfAnts) - ones(NumberOfAnts)*diag(Locations_Of_Enemy_Ants(1,:));
Relative_Y = diag(NextMoveArray(2,:,move))*ones(NumberOfAnts)  - ones(NumberOfAnts)*diag(Locations_Of_Enemy_Ants(2,:));

RelativePositionSquared = Relative_X.^2 + Relative_Y.^2;
% Leonard Jones like Interaction energy
%DistanceInteractionEnergy_With_Enemies(move) = sum(sum(InteractionStrength./(nonzeros(RelativePositionSquared.^2)) - InteractionStrength./nonzeros(RelativePositionSquared)));

% Pure Attraction / Repulsion Interaction energy
DistanceInteractionEnergy_With_Enemies(move) = sum(sum(Hamiltonian_Parameters(2)./(nonzeros(RelativePositionSquared.^2)+0.1)));


%% This is the Vector Dot Product And Distance - interacting term
% Note that here in the calculation there is no vector decay
DistanceMatrix = sqrt(RelativePositionSquared);
    ChangeVector_OfFriendlyAnts = -(Locations_Of_Friendly_Ants_Before - NextMoveArray(:,:,move)).*(Locations_Of_Friendly_Ants_Before ~= NextMoveArray(:,:,move)) + ChangeVector_Of_Friendly_Ants.*(Locations_Of_Friendly_Ants_Before == NextMoveArray(:,:,move));

for i = 1:length(ChangeVector_OfFriendlyAnts)
    for j = 1:length(ChangeVector_Of_Enemy_Ants)
        DotProductInteraction(move) = DotProductInteraction(move) + Hamiltonian_Parameters(3)*ChangeVector_OfFriendlyAnts(:,i).'*ChangeVector_Of_Enemy_Ants(:,j)/(DistanceMatrix(i,j)+0.1);
    end
end

LeftRotationMatrix = [0 1; -1 0];
RightRotationMatrix = [0 -1; 1 0];

%% Left Vector Product interation
for i = length(ChangeVector_OfFriendlyAnts)
    for j = 1:length(ChangeVector_Of_Enemy_Ants)
        Left_Vector_Product_Interaction(move) = Left_Vector_Product_Interaction(move) + Hamiltonian_Parameters(4)*((LeftRotationMatrix*ChangeVector_OfFriendlyAnts(:,i)).')*ChangeVector_Of_Enemy_Ants(:,j)/(DistanceMatrix(i,j)+0.1);
    end
end

%% Right Vector Product interation
for i = length(ChangeVector_OfFriendlyAnts)
    for j = 1:length(ChangeVector_Of_Enemy_Ants)
        Right_Vector_Product_Interaction(move) = Right_Vector_Product_Interaction(move) + Hamiltonian_Parameters(5)*((RightRotationMatrix*ChangeVector_OfFriendlyAnts(:,i)).')*ChangeVector_Of_Enemy_Ants(:,j)/(DistanceMatrix(i,j)+0.1);
    end
end



if Use_TargetsAndObsticles == 1
for obsticle = 1:length(ObsticlesMatrix(1,:))
ObsticlesEnergy(move) = ObsticlesEnergy(move) + ObsticleInteractionStrength*sum(1./((NextMoveArray(1,:,move) - ObsticlesMatrix(1,obsticle)).^2 + (NextMoveArray(2,:,move) - ObsticlesMatrix(2,obsticle)).^2));
end

for target = 1:length(TargetsMatrix(1,:))
%TargetsEnergy(move) = TargetsEnergy(move) + TargetInteractionStrength*sum(((NextMoveArray(1,:,move) - TargetsMatrix(1,target)).^2 + (NextMoveArray(2,:,move) - TargetsMatrix(2,target)).^2) - 100./sqrt(sqrt((NextMoveArray(1,:,move) - TargetsMatrix(1,target)).^2 + (NextMoveArray(2,:,move) - TargetsMatrix(2,target)).^2)));
TargetsEnergy(move) = TargetsEnergy(move) + TargetInteractionStrength*sum(- 100./sqrt(sqrt((NextMoveArray(1,:,move) - TargetsMatrix(1,target)).^2 + (NextMoveArray(2,:,move) - TargetsMatrix(2,target)).^2)));

end
end
% Enviounemt Potential

% Path Potenetial

end




EnergyBefore = Distance_InteractionEnergy_WithComrades(1) + DistanceInteractionEnergy_With_Enemies(1) + ObsticlesEnergy(1) + TargetsEnergy(1) + Right_Vector_Product_Interaction + Left_Vector_Product_Interaction + DotProductInteraction;

EnergyDifference_Vector = Distance_InteractionEnergy_WithComrades + DistanceInteractionEnergy_With_Enemies + ObsticlesEnergy + TargetsEnergy + Right_Vector_Product_Interaction + Left_Vector_Product_Interaction + DotProductInteraction - EnergyBefore;


n = 1;
if min(EnergyDifference_Vector) < 0
    ChargingMove = 0;
    
    for MoveNumber = 1:TotalNumberOFMoves
        if EnergyDifference_Vector(MoveNumber) < 0
                EnergyDifference(n) = -EnergyDifference_Vector(MoveNumber);
                Associated_MoveNumber(n) = MoveNumber;
                n = n+1;
        end
    end
    
    
    %% New Next step Excecution Algorithm
    TimeOfStep = - log(1-Decay_Probability_Percentile)/max(max(EnergyDifference));
    ExcecutionProbability = 1 - exp(-TransitionProbability.*EnergyDifference*TimeOfStep);
    
    RandomNumberVector = rand(1,max(size(ExcecutionProbability)));
    
    StepsToExcecute = RandomNumberVector <= ExcecutionProbability;
    



p = 1;

for n = 1:max(size(StepsToExcecute))
    if StepsToExcecute(n) > 0
        if Associated_MoveNumber(n) > 0
            Locations_Of_Ants1 = Locations_Of_Ants + (NextMoveArray(:,:,Associated_MoveNumber(n)) - NextMoveArray(:,:,1));
            [M,I] = max(sum((NextMoveArray(:,:,Associated_MoveNumber(n)) - NextMoveArray(:,:,1))));
            X = [Locations_Of_Ants1(:,I).';0 0];
            
            if pdist(X,'euclidean')> 2
            Locations_Of_Ants = Locations_Of_Ants1;
            ExcecutedMoves(p) = Associated_MoveNumber(n);
            p = p+1;
            end
        end
    end
end

end