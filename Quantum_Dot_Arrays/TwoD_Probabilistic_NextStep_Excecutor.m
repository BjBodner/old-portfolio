
function [Q,CurrentRow,CurrentCol,ChosenStep,EnergyDifference,Tunneling_Time,ChargeStuck] = TwoD_Probabilistic_NextStep_Excecutor(Q,NextMoveArray,invCM,C,Vleft,NumberOfDots,IndexOfRemovedCharge)
%% Finding Which Step will give th minimum energy, Applying SLides to see

% Without different sizes
%TotalNumberOFMoves = 4*NumberOfDots^2 - 2*NumberOfDots;
% without back draining
%TotalNumberOFMoves = 4*NumberOfDots(1)*NumberOfDots(2) - 2*NumberOfDots(1);
TotalNumberOFMoves = 4*NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(1);

TotalNumberOFMoves = length(NextMoveArray(1,1,:));
MoveNumber = 1;
%Extended_Q = zeros(NumberOfDots,NumberOfDots,TotalNumberOFMoves);
Extended_Q = zeros(NumberOfDots(1),NumberOfDots(2),TotalNumberOFMoves);
VLeftEnergy = zeros(TotalNumberOFMoves,1);
%VLeftEnergy(4*NumberOfDots^2 - 3*NumberOfDots + 1 : 4*NumberOfDots^2 - 2*NumberOfDots) = -Vleft;
VLeftEnergy(4*NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2)-2*NumberOfDots(1) + 1 : 4*NumberOfDots(1)*NumberOfDots(2) -2*NumberOfDots(1)) = -Vleft;
VLeftEnergy(4*NumberOfDots(1)*NumberOfDots(2) -2*NumberOfDots(1) + 1 : 4*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1)) = Vleft;
EnergyDifference =0;
ChargeStuck = 0;
Tunneling_Time = 0;
n = 1;
    CurrentRow = 0;
    CurrentCol = 0;
    
    
    for MoveNumber = 1:TotalNumberOFMoves
        Extended_Q(:,:,MoveNumber) = Q;
    end
    Extended_Q = Extended_Q +   NextMoveArray;
    
  
%% Old meathod with square array

%CapacictanceEnergy = diag(0.5*permute(reshape(Extended_Q,1,NumberOfDots*NumberOfDots,TotalNumberOFMoves),[3 2 1])*invCM*permute(reshape(Extended_Q,1,NumberOfDots*NumberOfDots,TotalNumberOFMoves),[2 3 1]));

%ExternalVoltagesEnergy = (C*Vleft*sum(invCM(:,1:NumberOfDots:NumberOfDots*NumberOfDots - NumberOfDots + 1).')*permute(reshape(Extended_Q,1,NumberOfDots*NumberOfDots,TotalNumberOFMoves),[2 3 1])).';

%EnergyBefore = ones(TotalNumberOFMoves,1)*(0.5*reshape(Q,1,NumberOfDots*NumberOfDots)*invCM*reshape(Q,NumberOfDots*NumberOfDots,1) + C*Vleft*sum(invCM(:,1:NumberOfDots:NumberOfDots*NumberOfDots - NumberOfDots + 1).')*reshape(Q,NumberOfDots*NumberOfDots,1));

%EnergyDifference_Vecotor = CapacictanceEnergy + VLeftEnergy + ExternalVoltagesEnergy - EnergyBefore;

%% New method
CapacictanceEnergy = diag(0.5*permute(reshape(Extended_Q,1,NumberOfDots(1)*NumberOfDots(2),TotalNumberOFMoves),[3 2 1])*invCM*permute(reshape(Extended_Q,1,NumberOfDots(1)*NumberOfDots(2),TotalNumberOFMoves),[2 3 1]));

ExternalVoltagesEnergy = (C*Vleft*sum(invCM(:,1:NumberOfDots(1):NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(1) + 1).')*permute(reshape(Extended_Q,1,NumberOfDots(1)*NumberOfDots(2),TotalNumberOFMoves),[2 3 1])).';

EnergyBefore = ones(TotalNumberOFMoves,1)*(0.5*reshape(Q,1,NumberOfDots(1)*NumberOfDots(2))*invCM*reshape(Q,NumberOfDots(1)*NumberOfDots(2),1) + C*Vleft*sum(invCM(:,1:NumberOfDots(1):NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(1) + 1).')*reshape(Q,NumberOfDots(1)*NumberOfDots(2),1));

EnergyDifference_Vecotor = CapacictanceEnergy + VLeftEnergy + ExternalVoltagesEnergy - EnergyBefore;


if min(EnergyDifference_Vecotor) < 0
    ChargingMove = 0;
    
    for MoveNumber = 1:TotalNumberOFMoves
        if EnergyDifference_Vecotor(MoveNumber) < 0
            %  if MoveNumber >= (4*NumberOfDots^2 - 3*NumberOfDots + 1 )
            if MoveNumber >= 4*NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2)-2*NumberOfDots(1) + 1 % charging moves
                if MoveNumber <=  4*NumberOfDots(1)*NumberOfDots(2) -2*NumberOfDots(1)
                    EnergyDifference(MoveNumber,n) = -EnergyDifference_Vecotor(MoveNumber);
                    n = n+1;
                    ChargingMove = 1;
                end
            end
            %  if MoveNumber <= (4*NumberOfDots^2 - 3*NumberOfDots)
            if ChargingMove ~=1
                if Q(IndexOfRemovedCharge(1,MoveNumber),IndexOfRemovedCharge(2,MoveNumber)) >= 1
                    EnergyDifference(MoveNumber,n) = -EnergyDifference_Vecotor(MoveNumber);
                    n = n+1;
                end
            end
            ChargingMove = 0;
        end
    end
    
    
    %   ChosenStep = MinimalEnergy;
    
    [Lmax,Nmax] = size(EnergyDifference);
    
    %% Normalizing Energy Difference
    Nomalization = sum(sum(EnergyDifference));
    Normalized_EnergyDifference = EnergyDifference/Nomalization;
    
    %% Creating Ordered Domains for Probabalistic dice roll
    NextStep_Domain(:,1) = zeros(Lmax,1);
    for n = 2:Nmax+1
        [~,IndexOfStep] = max(Normalized_EnergyDifference(:,n-1));
        NextStep_Domain(:,n) =  Normalized_EnergyDifference(:,n-1);
        NextStep_Domain(IndexOfStep,n) = NextStep_Domain(IndexOfStep,n) + max(NextStep_Domain(:,n-1));
    end
    
    %% Dice Roll
    RandomNumber = rand(1,1);
    %% Checking Where the random Number falls
    for n = 1:Nmax
        if RandomNumber > max(NextStep_Domain(:,n))
            if RandomNumber < max(NextStep_Domain(:,n+1))
                [~,ChosenStep] = max(Normalized_EnergyDifference(:,n));
                break
            end
        end
    end
    

    
    
    
end

if max(max(EnergyDifference)) >0 
    %Executing Next Step
    Q = Extended_Q(:,:,ChosenStep);
    
    %%Calculating Chosen Energy Difference
    EnergyDifference = -EnergyDifference_Vecotor(ChosenStep);
    Tunneling_Time = 1/EnergyDifference;
    %% Finding, and Setting The new Location of Current dot
    
 %   [~,Index] = max(reshape(NextMoveArray(:,:,ChosenStep),1,NumberOfDots*NumberOfDots));
        [~,Index] = max(reshape(NextMoveArray(:,:,ChosenStep),1,NumberOfDots(1)*NumberOfDots(2)));
    [I_row, I_col] = ind2sub(size(NextMoveArray(:,:,2)),Index);
    CurrentRow = I_row;
    CurrentCol = I_col;
end   

if min(EnergyDifference_Vecotor) >=0
    ChargeStuck =1;
    ChosenStep = 0;
end
if min(EnergyDifference) ==0
    ChargeStuck =1;
    ChosenStep = 0;
end
