function [Angles_Of_Each_Joint] = GNN_NextMoveGenerator(InputVector,Angles_Of_Each_Joint,Weights,ActionVector)


ExtendedNextActionMatrix = diag(ActionVector)*ones(length(ActionVector),length(Angles_Of_Each_Joint));
ExtendedNextActionVector = reshape(ExtendedNextActionMatrix,length(ActionVector)*length(Angles_Of_Each_Joint),1);
Hypothesis = reshape(1./(1 + exp(Weights*InputVector.')),length(ActionVector),length(Angles_Of_Each_Joint));

%Hypothesis1Vector = 1./(1 + exp(Weights*InputVector.'));
%Hypothesis2 = reshape(1./(1 + exp(Weights2*Hypothesis1Vector.')),length(ActionVector),length(Angles_Of_Each_Joint));

%Weights2 = (length(ActionVector)*length(Angles_Of_Each_Joint)^2)

ChosenNextMove = zeros(size(Angles_Of_Each_Joint));
for joint = 1:length(Angles_Of_Each_Joint)
[M,I] = max(Hypothesis(:,joint));
ChosenNextMove(joint) = ExtendedNextActionMatrix(I,joint);
end

%% Implimenting Change
Angles_Of_Each_Joint = Angles_Of_Each_Joint + ChosenNextMove;