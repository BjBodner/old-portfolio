
function [Q,CurrentRow,CurrentCol,EnergyDifference,Tunneling_Time,ChargeStuck,AddedChargesFromThisStep,RemovedChargesFromThisStep,ExcecutedMoves,ResidualEnergyMatrix,ExtraCharges_In_Gate] = TwoD_Probabilistic_Multiple_NextStep_Excecutor(Q,NextMoveArray,invCM,C,Cg,Vleft,Vg,NumberOfDots,IndexOfRemovedCharge,Decay_Probability_Percentile,TransitionProbabilityVector,ResidualEnergyMatrix)
%% Finding Which Step will give th minimum energy, Applying SLides to see
%%EnergyBefore = 0.5*(Q).'*invCM*(Q) + C*Vleft*invCM(:,1).'*Q;
%%EnergyMatrix = zeros(9,1);

   K = 6*10^-1;
   TransitionProbabilityVector(1:4*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1)) = (1/(Cg*exp(K*Vg)))*TransitionProbabilityVector(1:4*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1));
   
   

%TotalNumberOFMoves = 4*NumberOfDots^2 - 2*NumberOfDots;
TotalNumberOFMoves = length(NextMoveArray(1,1,:));
MoveNumber = 1;
%Vg = 0;
Extended_Q = zeros(NumberOfDots(1),NumberOfDots(2),TotalNumberOFMoves);
VLeftEnergy = zeros(TotalNumberOFMoves,1);
VGateEnergy = zeros(TotalNumberOFMoves,1);
%VLeftEnergy(4*NumberOfDots^2 - 3*NumberOfDots + 1 : 4*NumberOfDots^2 - 2*NumberOfDots) = -Vleft;
VLeftEnergy(4*NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2)-2*NumberOfDots(1) + 1 : 4*NumberOfDots(1)*NumberOfDots(2) -2*NumberOfDots(1)) = -Vleft;
VLeftEnergy(4*NumberOfDots(1)*NumberOfDots(2) -2*NumberOfDots(1) + 1 : 4*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1)) = Vleft;
VGateEnergy( 4*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1)+1:5*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1)) = Vg;
VGateEnergy( 5*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1)+1:6*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1)) = -Vg;

EnergyDifference =0;
EnergyDifferenceForTimeCalculation = 0;
ChargeStuck = 0;
Tunneling_Time = 0;
n = 1;
CurrentRow = 0;
CurrentCol = 0;
overlap = 0;
ExcecutedMoves = 0;
AddedChargesFromThisStep = 0;
RemovedChargesFromThisStep = 0;


for MoveNumber = 1:TotalNumberOFMoves
   % Extended_Q(:,:,MoveNumber) = Q + ResidualEnergyMatrix;
        Extended_Q(:,:,MoveNumber) = Q;
end
Extended_Q = Extended_Q +   NextMoveArray;


%% Old Inefficient Method
%for MoveNumber = 1:TotalNumberOFMoves
%    Extended_Q(:,:,MoveNumber) = Q + NextMoveArray(:,:,MoveNumber);
%end

%CapacictanceEnergy = diag(0.5*permute(reshape(Extended_Q,1,NumberOfDots*NumberOfDots,TotalNumberOFMoves),[3 2 1])*invCM*permute(reshape(Extended_Q,1,NumberOfDots*NumberOfDots,TotalNumberOFMoves),[2 3 1]));
CapacictanceEnergy = diag(0.5*permute(reshape(Extended_Q,1,NumberOfDots(1)*NumberOfDots(2),TotalNumberOFMoves),[3 2 1])*invCM*permute(reshape(Extended_Q,1,NumberOfDots(1)*NumberOfDots(2),TotalNumberOFMoves),[2 3 1]));

% Without Gate Energy
%ExternalVoltagesEnergy = (C*Vleft*sum(invCM(:,1:NumberOfDots(1):NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(1) + 1).')*permute(reshape(Extended_Q,1,NumberOfDots(1)*NumberOfDots(2),TotalNumberOFMoves),[2 3 1])).';
% With Gate Energy
ExternalVoltagesEnergy = (C*Vleft*sum(invCM(:,1:NumberOfDots(1):NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(1) + 1).')*permute(reshape(Extended_Q,1,NumberOfDots(1)*NumberOfDots(2),TotalNumberOFMoves),[2 3 1])).' ...
    +( Cg*Vg*sum(invCM.')*permute(reshape(Extended_Q,1,NumberOfDots(1)*NumberOfDots(2),TotalNumberOFMoves),[2 3 1])).';

% Without Gate Energy
%EnergyBefore = ones(TotalNumberOFMoves,1)*(0.5*reshape(Q,1,NumberOfDots(1)*NumberOfDots(2))*invCM*reshape(Q,NumberOfDots(1)*NumberOfDots(2),1) + C*Vleft*sum(invCM(:,1:NumberOfDots(1):NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(1) + 1).')*reshape(Q,NumberOfDots(1)*NumberOfDots(2),1));
% With Gate Energy
EnergyBefore = ones(TotalNumberOFMoves,1)*(0.5*reshape(Q,1,NumberOfDots(1)*NumberOfDots(2))*invCM*reshape(Q,NumberOfDots(1)*NumberOfDots(2),1) + C*Vleft*sum(invCM(:,1:NumberOfDots(1):NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(1) + 1).')*reshape(Q,NumberOfDots(1)*NumberOfDots(2),1)...
    + Cg*Vg*sum(invCM)*reshape(Q,NumberOfDots(1)*NumberOfDots(2),1));

%EnergyDifference_Vecotor = CapacictanceEnergy + VLeftEnergy + ExternalVoltagesEnergy - EnergyBefore;
EnergyDifference_Vecotor = CapacictanceEnergy + VGateEnergy + VLeftEnergy + ExternalVoltagesEnergy - EnergyBefore;




%EnergyDifference_Vecotor(4*NumberOfDots^2 - 3*NumberOfDots + 1 : 4*NumberOfDots^2 - 2*NumberOfDots)
ChargeRemovalLocation  = 0;
TransitionProbability = 0;
StepsToExcecute = 0;
TimeOfStep = 0;

if min(EnergyDifference_Vecotor) < 0
    ChargingMove = 0;
    
    for MoveNumber = 1:TotalNumberOFMoves
        if EnergyDifference_Vecotor(MoveNumber) < 0
            %  if MoveNumber >= (4*NumberOfDots^2 - 3*NumberOfDots + 1 )
            if MoveNumber >= 4*NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2)-2*NumberOfDots(1) + 1 % charging moves
                if MoveNumber <=  4*NumberOfDots(1)*NumberOfDots(2) -2*NumberOfDots(1)
                EnergyDifference(n) = -EnergyDifference_Vecotor(MoveNumber);
                EnergyDifferenceForTimeCalculation(n) = -EnergyDifference_Vecotor(MoveNumber);
                TransitionProbability(n) = TransitionProbabilityVector(MoveNumber);
                Associated_MoveNumber(n) = MoveNumber;
                n = n+1;
                ChargingMove = 1;
                end
            end

                
            if ChargingMove ~=1
              %  if Q(IndexOfRemovedCharge(1,MoveNumber),IndexOfRemovedCharge(2,MoveNumber)) >= 1
                    EnergyDifference(n) = -EnergyDifference_Vecotor(MoveNumber);
                    EnergyDifferenceForTimeCalculation(n) = -EnergyDifference_Vecotor(MoveNumber);
                    TransitionProbability(n) = TransitionProbabilityVector(MoveNumber);
                    ChargeRemovalLocation(n) = IndexOfRemovedCharge(1,MoveNumber) + NumberOfDots(1)*(IndexOfRemovedCharge(2,MoveNumber)-1);
                    Associated_MoveNumber(n) = MoveNumber;
                    
                    % for discharging
                    if MoveNumber > 4*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1)
                         %   EnergyDifferenceForTimeCalculation(n) = -EnergyDifference_Vecotor(MoveNumber);
                         
                    EnergyDifference(n) = -EnergyDifference_Vecotor(MoveNumber);
                    EnergyDifferenceForTimeCalculation(n) = -EnergyDifference_Vecotor(MoveNumber);
                    TransitionProbability(n) = TransitionProbabilityVector(MoveNumber);
                    ChargeRemovalLocation(n) = IndexOfRemovedCharge(1,MoveNumber) + NumberOfDots(1)*(IndexOfRemovedCharge(2,MoveNumber)-1);
                    Associated_MoveNumber(n) = MoveNumber;
                    end
                    n = n+1;
             %   end
            end
            ChargingMove = 0;
            
            if Associated_MoveNumber(n-1) > 190
            if TransitionProbability(n-1) > 0
                
                    a =1;
                end
            end
            
        end
    end
    
    
    %% New Next step Excecution Algorithm

   % TimeOfStep = - log(1-Decay_Probability_Percentile)/max(max(TransitionProbability.*EnergyDifference));


    TimeOfStep = - log(1-Decay_Probability_Percentile)/max(max(TransitionProbability.*EnergyDifferenceForTimeCalculation));
    
    if TimeOfStep ~= Inf
    ExcecutionProbability = 1 - exp(-TransitionProbability.*EnergyDifference*TimeOfStep);
    end
    if TimeOfStep == Inf
        ExcecutionProbability = 0;
    end
    
    
    TransitionProbabilityVector(1:4*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1)) = TransitionProbabilityVector(1:4*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1))/(1/(Cg*exp(K*Vg)));
    
    RandomNumberVector = rand(1,max(size(ExcecutionProbability)));
    
    StepsToExcecute = RandomNumberVector <= ExcecutionProbability;
    

    
    %% Finding how many charges tunneled into and out of the gate
    % MoveNumbers For tunneling onto the gate
    NumberCharges_That_Tunneled_OntoTheGate = sum(((Associated_MoveNumber.*StepsToExcecute)>=4*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1)+1).*((Associated_MoveNumber.*StepsToExcecute)<=5*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1)));
  %  4*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1)+1:5*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1);
    
  % Movenumbers for tunneling off the gate
    NumberCharges_That_Tunneled_OffTheGate = sum(((Associated_MoveNumber.*StepsToExcecute)>=5*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1)+1).*((Associated_MoveNumber.*StepsToExcecute)<=6*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1)));
   % 5*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1)+1:6*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1);
    
   ExtraCharges_In_Gate = NumberCharges_That_Tunneled_OntoTheGate - NumberCharges_That_Tunneled_OffTheGate;
    
   %% These are the questions to see if a move that involves removal was chosen
    if max(size(StepsToExcecute)) > 1
        if sum(StepsToExcecute) > 1
            if max(size(ChargeRemovalLocation))  > 1
                
                
                n = 2;
                for i = 1:max(size(ChargeRemovalLocation))
                    for j = 1:max(size(ChargeRemovalLocation))
                        if ChargeRemovalLocation(i) > 0
                            if i ~= j
                                if ChargeRemovalLocation(i) == ChargeRemovalLocation(j)
                                    
                                    %% Storing overlap information
                                    if Associated_MoveNumber(i) ~= 0
                                        Energy_Difference_Of_Overlap(1) = EnergyDifference(i);
                                        Move_Number_Of_Overlap(1) = Associated_MoveNumber(i);
                                    end
                                    % This is without taking into accound the
                                    % transition rate
                                    %Energy_Difference_Of_Overlap(n) = EnergyDifference(j);
                                    
                                    % This is without taking into accound the
                                    % transition rate
                                    
                                    Energy_Difference_Of_Overlap(n) = TransitionProbability(j)*EnergyDifference(j);
                                    Move_Number_Of_Overlap(n) = Associated_MoveNumber(j);
                                    
                                    %% Zeroing overlap value as not to do calculations twice
                                    Associated_MoveNumber(j)  = 0;
                                    Associated_MoveNumber(i)  = 0;
                                    ChargeRemovalLocation(j) = 0;
                                    n = n + 1;
                                    overlap = 1;
                                end
                            end
                        end
                    end
                    
                    
                    %% this will happen only in case we have found an overlap
                    
                    if overlap == 1
                        overlap = 0;
                        %% after running on all othe j indexes, now we will probabalisticly choose the step
                        Normalized_Energy_Difference_Of_Overlap = Energy_Difference_Of_Overlap / sum(Energy_Difference_Of_Overlap);
                        NextStepDomain = zeros(max(size(Normalized_Energy_Difference_Of_Overlap)),1);
                        
                        for n = 2:max(size(Normalized_Energy_Difference_Of_Overlap)) + 1
                            NextStepDomain(n) = Normalized_Energy_Difference_Of_Overlap(n-1);
                            NextStepDomain(n) = NextStepDomain(n) + NextStepDomain(n-1);
                        end
                        
                        %% Dice Roll
                        RandomNumber = rand(1,1);
                        
                        %% Checking Where the random Number falls
                        for n = 1:max(size(Normalized_Energy_Difference_Of_Overlap))
                            if RandomNumber > NextStepDomain(n)
                                if RandomNumber < NextStepDomain(n+1)
                                    Associated_MoveNumber(i) = Move_Number_Of_Overlap(n);
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end



%% Old Attempt of finding overlaps - delete if possible





p = 1;
%% Excecuting all Chosen steps

for n = 1:max(size(StepsToExcecute))
    if StepsToExcecute(n) > 0
        if Associated_MoveNumber(n) > 0
            Q(:,:) = Q + NextMoveArray(:,:,Associated_MoveNumber(n));
            ExcecutedMoves(p) = Associated_MoveNumber(n);
            p = p+1;
            
            
            %% This needs more work in which charges get added
            %if Associated_MoveNumber(n) >= (4*NumberOfDots^2 - 3*NumberOfDots + 1 );
            if Associated_MoveNumber(n) >= (4*NumberOfDots(1)*NumberOfDots(2) - 3*NumberOfDots(1) + 1 );
                AddedChargesFromThisStep = AddedChargesFromThisStep + 1;
            end
            
           
            %if Associated_MoveNumber(n) >= NumberOfDots^2 - NumberOfDots+1;
           %    if Associated_MoveNumber(n) <= NumberOfDots^2;
           if Associated_MoveNumber(n) >= NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(1)+1
                if Associated_MoveNumber(n) <= NumberOfDots(1)*NumberOfDots(2)
                    RemovedChargesFromThisStep = RemovedChargesFromThisStep + 1;
                end
            end
        end
    end
end



Tunneling_Time = TimeOfStep;


ResidualEnergyMatrix = zeros(NumberOfDots(1),NumberOfDots(2));
%% Risidual Energy matrix
 UsdeRisidualMatrix = 0;
 
if UsdeRisidualMatrix == 1
DisipationFactor = 0.5;
if min(size(nonzeros(StepsToExcecute))) > 0
    if min(size(nonzeros(ExcecutedMoves))) > 0
        ResidualEnergy = (1-DisipationFactor)*EnergyDifference_Vecotor(ExcecutedMoves);
        for i = 1:length(ExcecutedMoves)
            ResidualEnergyMatrix = ResidualEnergyMatrix - ResidualEnergy(i)*(NextMoveArray(:,:,ExcecutedMoves(i))>0);
        end
    end
end
end

        if sum(sum(ExcecutedMoves>=190)) > 0
            a = 1;
        end

%if max(max(EnergyDifference)) >0
%Executing Next Step
% Q = Extended_Q(:,:,ChosenStep);

%%Calculating Chosen Energy Difference
% EnergyDifference = -EnergyDifference_Vecotor(ChosenStep);
%  Tunneling_Time = 1/EnergyDifference;
%% Finding, and Setting The new Location of Current dot

%[~,Index] = max(reshape(NextMoveArray(:,:,ChosenStep),1,NumberOfDots*NumberOfDots));
%[I_row, I_col] = ind2sub(size(NextMoveArray(:,:,2)),Index);
%CurrentRow = I_row;
%CurrentCol = I_col;
%end
if TimeOfStep == Inf
    ChargeStuck =1;
    ChosenStep = 0;
end
if min(EnergyDifference_Vecotor) >=0
    ChargeStuck =1;
    ChosenStep = 0;
end
if min(EnergyDifference) ==0
    ChargeStuck =1;
    ChosenStep = 0;
end
