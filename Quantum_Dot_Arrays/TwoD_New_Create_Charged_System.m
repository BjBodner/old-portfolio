function [Vleft,Q,TotalTime,f,framenumber,q_Gate] = TwoD_New_Create_Charged_System(C,Cg,Vg,Vg1,q_Gate,Rg,NumberOfDots,InitialSystem,NextMoveArray,IndexOfRemovedCharge,invCM,PlotSystem,TransitionProbabilityVector)

Vleft = 0;
Vright = 0;
%Vg = -1;
PlotSystem = 0;
Plot_EnergyLanscape_plot = 0;
EnergyFrameNumber = 1;
Q = InitialSystem;
NumberOfCharges = max(NumberOfDots)^3;
CurrentRow = 1;
CurrentCol = 1;
Oscillations = 0;
k = 1;
s = 1;
LastRow = 1;
LastCol = 1;
ChargeStuck =1;
I = 1;
TransferedElectrons = 0;
alpha = 0;
%ChargingVoltageDifference = ones(NumberOfDots,1);
ChargingVoltageDifference = ones(NumberOfDots(2),1);
StepVoltageDifference = zeros(4,1);
%NextVoltageMatrix = ones(NumberOfDots,1);
NextVoltageMatrix = ones(NumberOfDots(2),1);
marker = 0;
NumberOfMove = 1;
TimeVector = zeros(max(NumberOfDots)^3,1);
framenumber =  1;

if PlotSystem == 0
    f=0;
end
%%for reference Q(i,j) = Q(rows-TopToBottom, cols-LeftToRight)




%% Running Higher Voltages on System
%%for NumberOfTest = 1:(2*NumberOfVoltageTests*ElectronInEachVoltage)
%%Averaging Loop
%%for n = 1:AveragingNumber
%%Q = rand(NumberOfDots,NumberOfDots);
%%Vleft = 0;
%%TransferedElectrons = 0;


%% Running the system Loop - inserting charges by voltage


%for i = 1:NumberOfCharges
while TransferedElectrons < 10
    
    
    if TransferedElectrons >= 10
        break;
    end
    
    
    %% When Charges cannot move anymore - Raise Voltage, And Add Charge
    if ChargeStuck >=1
        %% Finding the requied voltage to add a charge into each one of the first dots
        UseNextVoltageAlgorithm = 0;
        if UseNextVoltageAlgorithm == 1
        [Vleft,Index_Of_Minimal_Calculated_Voltage] = NextVoltageCalculator(Q,NumberOfDots,invCM,C,Cg,Vleft,Vg);
        end
        Vleft = Vleft + 0.001
        %% Determanistic Adding Charge to First Dot
        %%[Q,CurrentRow,CurrentCol] = Determanistic_AddingChargeToFirstDot(Vleft,Q,Cg,NumberOfDots);
        
        %% Probabilistic Adding Charge to First Dot
        %   [Q,CurrentRow,CurrentCol,ChargingTime] = TwoD_Probabilistic_AddingChargeToFirstDot(Q,Cg,Vleft,NumberOfDots,invCM,C);
        
        %% New Execution of next step
        %  [Q,CurrentRow,CurrentCol,ChosenStep,EnergyDifference,Tunneling_Time,ChargeStuck] = TwoD_Probabilistic_NextStep_Excecutor(Q,NextMoveArray,invCM,C,Vleft,NumberOfDots,IndexOfRemovedCharge);
        ResidualEnergyMatrix = zeros(size(Q));
        Decay_Probability_Percentile = 0.3;
        [Q,CurrentRow,CurrentCol,EnergyDifference,Tunneling_Time,ChargeStuck,AddedChargesFromThisStep,RemovedChargesFromThisStep,ExcecutedMoves,ResidualEnergyMatrix,ExtraCharges_In_Gate] = TwoD_Probabilistic_Multiple_NextStep_Excecutor(Q,NextMoveArray,invCM,C,Cg,Vleft,Vg,NumberOfDots,IndexOfRemovedCharge,Decay_Probability_Percentile,TransitionProbabilityVector,ResidualEnergyMatrix);
        
        q_Gate_Old = q_Gate;
        if Tunneling_Time ~=inf
        q_Gate_New = ((2*C*Cg)/(2*C+Cg))*(Vg1 + Vleft/2) + (Cg/(2*C+Cg))*sum(sum(Q));
        q_Gate = q_Gate_Old + (q_Gate_New-q_Gate_Old)*(1-exp(-Tunneling_Time/(Rg*Cg)));
        end
        Vg = Vg1 + q_Gate/Cg;
       % Index_Of_Minimal_Calculated_Voltage;
        % NextMoveArray(:,:,ChosenStep)
        %% Taking a picture of the system
        
        if PlotSystem == 1
            [f(framenumber)] = TakePictureOfTheSystem(Q);
            framenumber = framenumber + 1;
        end
    end
    
    %% Rebooting ChargeStuck so the system, and Tracking index
    ChargeStuck = 0;
    TrackingIndex = 1;
    
    
    
    %% Moving Charge to rest point algorithm %%
    while CurrentRow < NumberOfDots+1
        
        if CurrentRow == 3
            a = 1
        end
        
        %% Tracking Path Of Current
        LastRow(TrackingIndex) = CurrentRow;
        LastCol(TrackingIndex) = CurrentCol;
        TrackingIndex = TrackingIndex + 1;
        
        
        %% New Probabilisticly Excecuting Next Step
        
        ResidualEnergyMatrix = zeros(size(Q));
        Decay_Probability_Percentile = 0.3;
        [Q,CurrentRow,CurrentCol,EnergyDifference,Tunneling_Time,ChargeStuck,AddedChargesFromThisStep,RemovedChargesFromThisStep,ExcecutedMoves,ResidualEnergyMatrix] = TwoD_Probabilistic_Multiple_NextStep_Excecutor(Q,NextMoveArray,invCM,C,Cg,Vleft,Vg,NumberOfDots,IndexOfRemovedCharge,Decay_Probability_Percentile,TransitionProbabilityVector,ResidualEnergyMatrix);
        
        
        q_Gate_Old = q_Gate;
        if Tunneling_Time ~=inf
        q_Gate_New = ((2*C*Cg)/(2*C+Cg))*(Vg1 + Vleft/2) + (Cg/(2*C+Cg))*sum(sum(Q));
        q_Gate = q_Gate_Old + (q_Gate_New-q_Gate_Old)*(1-exp(-Tunneling_Time/(Rg*Cg)));
        end
        Vg = Vg1 + q_Gate/Cg;
        
        
        %% Checking For Oscilations
       
            s = s+1;
            if sum(ExcecutedMoves) > 0
            if length(ExcecutedMoves) == 1
                MoveMemory(:,:,mod(k,3)+1) = NextMoveArray(:,:,ExcecutedMoves);
                MoveMemoryNumber(mod(k,3)+1) = ExcecutedMoves;
                s1(k) = s;
                k = k+1;
            end
            end
                
            if k > 3
                if s1(k-1) == s1(k-2)+1
                    if sum(sum(MoveMemory(:,:,mod(k-1,3)+1) == -MoveMemory(:,:,mod(k-2,3)+1))) == NumberOfDots(1)*NumberOfDots(2)
                        Oscillations = Oscillations + 1;
                    end
                end
            end
                
            if Oscillations == 3
                Oscillations = 0;
                CurrentRow = LastRow(TrackingIndex-1);
                CurrentCol = LastCol(TrackingIndex-1);
                ChargeStuck = 1;
                break
            end
        
        %[Q,CurrentRow,CurrentCol,ChosenStep,EnergyDifference,Tunneling_Time,ChargeStuck] = TwoD_Probabilistic_NextStep_Excecutor(Q,NextMoveArray,invCM,C,Vleft,NumberOfDots,IndexOfRemovedCharge);
        %OptimalStep = ChosenStep;
        
        %% Old Probabilisticly Excecuting Next Step
        %[Q,CurrentRow,CurrentCol,ChosenStep,EnergyDifference] = TwoD_Probabilistic_Excecution_Of_NextStep(Q,NextStepArray,invCM,C,Vleft,NumberOfDots);
        % OptimalStep = ChosenStep;
        
        %%
        %% Taking Picture of system
        if PlotSystem == 1
            [f(framenumber)] = TakePictureOfTheSystem(Q);
            framenumber = framenumber + 1;
        end
        if Plot_EnergyLanscape_plot == 1
            [EnergyLanscape_plot(EnergyFrameNumber)] = TwoD_EnergyLanscape_Plot(NumberOfDots,C,Cg,Q,invCM,Vleft,Vg);
            EnergyFrameNumber = EnergyFrameNumber +1;
        end
        
        %Checking if charge made it through the system
        
        %   if ChosenStep >= NumberOfDots^2 - NumberOfDots +1
        %       if ChosenStep <= NumberOfDots^2
        
        if RemovedChargesFromThisStep >=1
            TransferedElectrons = 1;
            break
        end
        
        %if ChosenStep >= NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(1) +1
        %    if ChosenStep <= NumberOfDots(1)*NumberOfDots(2)
        %        TransferedElectrons = 1
        %        break
        %    end
        %end
        
        
        %Checking if charge is stuck
        if sum(ExcecutedMoves) == 0
            %if ChargeStuck == 1
            CurrentRow = LastRow(TrackingIndex-1);
            CurrentCol = LastCol(TrackingIndex-1);
            break
        end
        
        % If only gate tunneling is possible
        if sum(ExcecutedMoves <= 4*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1)) == 0
            if sum(ExcecutedMoves > 6*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1)) == 0
            CurrentRow = LastRow(TrackingIndex-1);
            CurrentCol = LastCol(TrackingIndex-1);
            ChargeStuck = 1;
            break
            end
        end
    end
    
    %%end of loop for single transfer of electron
    
end

%% Clearing Last Dot
%%Q(CurrentRow,CurrentCol) = Q(CurrentRow,CurrentCol) - 1;

%% Taking Picture of system
if PlotSystem == 1
    [f(framenumber)] = TakePictureOfTheSystem(Q);
    framenumber = framenumber + 1;
end
if Plot_EnergyLanscape_plot == 1
    [EnergyLanscape_plot(EnergyFrameNumber)] = TwoD_EnergyLanscape_Plot(NumberOfDots,C,Cg,Q,invCM,Vleft,Vg);
    EnergyFrameNumber = EnergyFrameNumber +1;
end
%% Gathering data from current voltage test


TransferedElectrons = 0;
TotalTime = sum(TimeVector)


%% End ofVoltage change algortihm



%%if mod(NumberOfTest,ElectronInEachVoltage) == 0

%%	if NumberOfTest < NumberOfVoltageTests*ElectronInEachVoltage
%%		Vleft = Vleft + 1;
%%	end

%%	if NumberOfTest > NumberOfVoltageTests*ElectronInEachVoltage
%%		Vleft = Vleft - 1;
%%	end

%%end

%%Vthreshold = Vleft - Vright
%%VtAveragingMatrix(n) = Vthreshold;
%%end of averaging loop
%%end
%%alpha = mean(VtAveragingMatrix)/NumberOfDots



