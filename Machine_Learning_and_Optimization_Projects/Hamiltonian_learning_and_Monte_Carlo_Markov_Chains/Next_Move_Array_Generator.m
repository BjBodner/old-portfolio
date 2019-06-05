function [NextMoveArray] = Next_Move_Array_Generator(Locations_Of_Ants)

% first index is x,y
% second index is ant number
% third index is move number
NumberOfAnts = length(Locations_Of_Ants(1,:));
NextMoveArray = zeros(length(Locations_Of_Ants(:,1)),length(Locations_Of_Ants(1,:)),4*NumberOfAnts+1);

NextMoveArray(:,:,1) = Locations_Of_Ants;
for ant = 1:4*NumberOfAnts+1
    NextMoveArray(:,:,ant) = Locations_Of_Ants;
end

for ant = 1:NumberOfAnts
NextMoveArray(:,ant,1 + ant) = [(Locations_Of_Ants(1,ant)+1) Locations_Of_Ants(2,ant)];
end

for ant = 1:length(Locations_Of_Ants(1,:))
NextMoveArray(:,ant,NumberOfAnts + ant+1) = [(Locations_Of_Ants(1,ant)-1) Locations_Of_Ants(2,ant)];
end

for ant = 1:length(Locations_Of_Ants(1,:))
NextMoveArray(:,ant,2*NumberOfAnts + ant+1) = [Locations_Of_Ants(1,ant) (Locations_Of_Ants(2,ant)+1)];
end

for ant = 1:length(Locations_Of_Ants(1,:))
NextMoveArray(:,ant,3*NumberOfAnts + ant+1) = [Locations_Of_Ants(1,ant) (Locations_Of_Ants(2,ant)-1)];
end