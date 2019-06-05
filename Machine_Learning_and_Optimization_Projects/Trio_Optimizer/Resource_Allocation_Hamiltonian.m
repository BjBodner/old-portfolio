function [RecomendedResourceAllocation] = Resource_Allocation_Hamiltonian(Initial_Resource_Allocation,Current_Resource_Allocation,Changevector,MassVector,Self_Interaction_Spring_Constants,Neighboring_Algorithm_Interaction_Spring_Constants,Epsilon1)

if norm(Changevector) ~= 0
Changevector = Changevector/norm(Changevector);
end
R0 = Initial_Resource_Allocation;
R = Current_Resource_Allocation;
K0 = Self_Interaction_Spring_Constants;
K = Neighboring_Algorithm_Interaction_Spring_Constants; %K(1) = K12, K(2) = K23, K(3) = K31%

Epsilon = Epsilon1;
%Changevector = [3 2 1]; % This is the improvement of the cost function due to the last itteration
%R0 = [20 20 20];
%R = R0;
%MassVector = [3 3 3];
%K0 = [1 1 1];
%K = [2 2 2]; %K(1) = K12, K(2) = K23, K(3) = K31%


InteractionMatrix = [K(1)+K(3) -K(1) -K(2);  -K(1) K(1)+K(2) -K(2); -K(3) -K(2) K(2)+K(3)];

%% This system is equivilent to 3 springs connected in a ring with interactions between them, 
%% and a self sping connected to the tabel that tries to return them to equilibrium


for n = 1:1
%d_R = -(K0./MassVector).*(R-R0);

%d_R(1) = d_R(1) + (2*Changevector(1) - Changevector(2) - Changevector(3))/MassVector(1);
%d_R(2) = d_R(2) + (2*Changevector(2) - Changevector(1) - Changevector(3))/MassVector(2);
%d_R(3) = d_R(3) + (2*Changevector(3) - Changevector(1) - Changevector(2))/MassVector(3);

%R = R + d_R

H_Self = -(K0./MassVector).*(R-R0);
H_Interaction = InteractionMatrix*(Changevector./MassVector).';
H_tot = H_Self + H_Interaction.';

R = R + H_tot;
if H_tot/R<Epsilon
    break
end

end

RecomendedResourceAllocation = round(R);