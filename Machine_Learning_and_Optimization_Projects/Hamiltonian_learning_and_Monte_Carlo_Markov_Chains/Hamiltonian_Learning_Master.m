
NumberOfAnts = 10;
NumberOfObsticles = 10;
NumberOfTargets = 2;
NumberOfItterations = 300;

Locations_Of_Ants = 10*rand(2,NumberOfAnts);
ObsticlesMatrix = 20*rand(2,NumberOfObsticles);
TargetsMatrix = 20 + 2*rand(2,NumberOfTargets);


for itteration = 1:NumberOfItterations
    itteration
[NextMoveArray] = Next_Move_Array_Generator(Locations_Of_Ants);
[Locations_Of_Ants] = Multiple_Porbabalistic_Next_Step_Excecutor(NextMoveArray,ObsticlesMatrix,TargetsMatrix);

scatter(Locations_Of_Ants(1,:),Locations_Of_Ants(2,:));

if mod(itteration ,40) == 0
TargetsMatrix = 20*rand(2,NumberOfTargets);
end

if mod(itteration ,3) == 0
hold on
scatter(ObsticlesMatrix(1,:),ObsticlesMatrix(2,:),'rs');
hold on
scatter(TargetsMatrix(1,:),TargetsMatrix(2,:),100,'d','filled');
hold off
xlim([0 25])
ylim([0 25])
f = getframe(gcf);
end
end