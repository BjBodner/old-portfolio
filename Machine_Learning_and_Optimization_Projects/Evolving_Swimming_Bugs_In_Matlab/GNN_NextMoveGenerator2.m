function [Angles_Of_Each_Joint] = GNN_NextMoveGenerator2(InputVector,Angles_Of_Each_Joint,Weights,ActionVector)


NumberOfExaminedMoves = 10;
ExtendedNextActionMatrix = diag(ActionVector)*ones(length(ActionVector),length(Angles_Of_Each_Joint));
PossibleMoves = ceil(length(ActionVector)*rand(length(Angles_Of_Each_Joint),NumberOfExaminedMoves));

for i = 1:NumberOfExaminedMoves
    for limb = 1:numberoflimbs
        Angles_Of_Each_Joint(limb)= Angles_Of_Each_Joint + ExtendedNextActionMatrix(PossibleMoves(limb,i)),limb);
    end
    [NewBodyLocation,Angles_Of_Each_Joint_Before,Angles_Of_Each_Joint_After] = GNN_NextMoveExcecutor(Angles_Of_Each_Joint_Before,Angles_Of_Each_Joint_After,MyLocation,NumberOfLimbs,NumberOfJointsPerLimb,LengthOfEachSegmentOfTheLimb)
    DistanceToTarget(i) = abs(NewBodyLocation-FoodLocation)
end

[M,I] = min(DistanceToTarget);
    for limb = 1:numberoflimbs
        Angles_Of_Each_Joint(limb)= Angles_Of_Each_Joint + ExtendedNextActionMatrix(PossibleMoves(limb,I)),limb);
    end
