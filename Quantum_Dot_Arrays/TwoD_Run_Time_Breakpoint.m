function [PlotSystemMovie_FromThisRun,EnergyLanscape_plot,EnergyFrameNumber,Averaged_Charges_InArray,Averaged_Current_Theshold_Voltage,TotalTime,Q_Reconfigured,NumberOfMove,ChargesRemoved,ChargesAdded,Last20moves,LastMoveRecorderCount,Random_Number_Seed,Random_Number_Index,Ix_front,Ix_back ,Iy_up ,Iy_down,Clogging_Event] = TwoD_Run_Time_Breakpoint(Q,C,Cg,NumberOfDots,Vleft,PlotSystem,Last20moves,LastMoveRecorderCount,TimeOfEachRun,TotalTime,InitialSystem,TotalTimeBefore,Random_Number_Seed,Random_Number_Index,NextMoveArray,IndexOfRemovedCharge,invCM,Ix_front,Ix_back ,Iy_up ,Iy_down,Plot_EnergyLanscape_plot,EnergyFrameNumber,EnergyLanscape_plot,TransitionProbabilityVector)

Vg = 0;
AveragingNumber = 1;
NumberOfVoltageTests  = 3;
ElectronInEachVoltage = 2;
if PlotSystem == 0
    f = 0;
end
TimeVector = zeros(NumberOfDots*NumberOfDots,1);
NumberOfTest = NumberOfVoltageTests;
VtAveragingMatrix = ones(AveragingNumber,1);
VoltageDifference = ones(4,NumberOfDots);
NextStep = 1;
OptimalCol =1;
NumberOfCharges = NumberOfDots*NumberOfDots*NumberOfDots;
CurrentRow = 1;
LastRow = 1;
LastCol = 1;
ChargeStuck =1;
I = 1;
TransferedElectrons = 0;
alpha = 0;
ChargingVoltageDifference = ones(NumberOfDots,1);
StepVoltageDifference = zeros(4,1);
DotOfLastTransfer = zeros(NumberOfTest,1);
NextVoltageMatrix = ones(NumberOfDots,1);
marker = 0;
NumberOfMove = 1;
SystemEquillibrium = 0;
ChosenStep = 0;
ExecutedMoves = 0;
ChargesRemoved = 0;
ChargesAdded = 0;
Averaged_Current_Theshold_Voltage = 0;
p = 1;
k = 1;
%%for reference Q(i,j) = Q(rows-TopToBottom, cols-LeftToRight)
Clogging_Event = 0;
stuck = 1;
framenumber = 1;


%% Running Higher Voltages on System
%%for NumberOfTest = 1:(2*NumberOfVoltageTests*ElectronInEachVoltage)
%%Averaging Loop
%%for n = 1:AveragingNumber
%%Q = rand(NumberOfDots,NumberOfDots);
%%Vleft = 0;
%%TransferedElectrons = 0;
%TotalTimeBefore = TotalTime - 1;

%% Running the system Loop - inserting charges by voltage

CurrentRow = 0;

for i = 1:NumberOfCharges
    
    
    % Adding time and checking breakpoint
    [Current_Theshold_Voltage(p)] = TwoD_Threshold_Voltage_Calculator(Q,NumberOfDots,invCM,C,Vleft);
    NumberOfCharges_InArray(p) = sum(sum(Q-InitialSystem));
    Averaged_Current_Theshold_Voltage = mean(Current_Theshold_Voltage);
    Averaged_Charges_InArray = mean(NumberOfCharges_InArray);
    p = p+1;
    %% Time Breakpoint
    if mod(TotalTime,TimeOfEachRun) < mod(TotalTimeBefore,TimeOfEachRun)
        break
    end
    
    
    %% Stuck Breakpoint
    if Clogging_Event == 1
        break
    end
    
    %%if TransferedElectrons >= 1
    %%break;
    %%end
    TransferedElectrons = 0;
    
    
    %% Charging Steps - It is possible that all this can be deleted from here
    
    
    
    
    %(MoveNumber= 4*NumberOfDots^2 - 3*NumberOfDots + 1 : 4*NumberOfDots^2 - 2*NumberOfDots)
    
    if ChosenStep >= 4*NumberOfDots^2 - 3*NumberOfDots + 1
        [ChargingTime] = OneD_ChargingTimeCalculator(Q,invCM,C,Vleft);
        [Current_Theshold_Voltage(p)] = TwoD_Threshold_Voltage_Calculator(Q,NumberOfDots,invCM,C,Vleft);
        NumberOfCharges_InArray(p) = sum(Q-InitialSystem);
        Averaged_Current_Theshold_Voltage = mean(Current_Theshold_Voltage);
        Averaged_Charges_InArray = mean(NumberOfCharges_InArray);
        %ChargesAdded = ChargesAdded +1;
        p = p+1;
        % recording move
        Last20moves(:,:,mod(LastMoveRecorderCount,20)+1) = Q;
        LastMoveRecorderCount = LastMoveRecorderCount +1;
        % Checking Time Difference
        %   Time_Difference_Of_Charging = TotalTime - TotalTimeBefore;
    end
    
    
    % Breakpoint
    
    %% When Charges cannot move anymore - Raise Voltage, And Add Charge
    if ChargeStuck >=1
        
        %% Breaking Point
        if CurrentRow >= NumberOfDots
            %                      break
        end
        
        %% Reseting Current Row
        if ExecutedMoves == 1;
            CurrentRow = 1;
        end
        if ExecutedMoves == 0;
            CurrentRow = CurrentRow + 1;
        end
        %% Taking a picture of the system
        if PlotSystem == 1
            [f(framenumber)] = TakePictureOfTheSystem(Q);
            framenumber = framenumber + 1;
        end
        if Plot_EnergyLanscape_plot == 1
            [EnergyLanscape_plot(EnergyFrameNumber)] = TwoD_EnergyLanscape_Plot(NumberOfDots,C,Cg,Q,invCM,Vleft);
            EnergyFrameNumber = EnergyFrameNumber +1;
        end
        
        % recording move
        Last20moves(:,:,mod(LastMoveRecorderCount,20)+1) = Q;
        LastMoveRecorderCount = LastMoveRecorderCount +1;
    end
    
    
    %% Until here
    
    %% Rebooting ChargeStuck so the system, and Tracking index
    ChargeStuck = 0;
    ExecutedMoves = 0;
    
    
    ResidualEnergyMatrix = zeros(NumberOfDots);
    
    %% Moving Charge to rest point algorithm %%
    while CurrentRow <= NumberOfDots+1
        
        
        %%CurrentRow
        
        %% Tracking Path Of Current
        %%LastRow(TrackingIndex) = CurrentRow;
        %%LastCol(TrackingIndex) = CurrentCol;
        %%TrackingIndex = TrackingIndex + 1;
        
        
        %% Probabilisticly Excecuting Next Step
        
        %  [Q,CurrentRow,CurrentCol,ChosenStep,EnergyDifference,Tunneling_Time,ChargeStuck] = TwoD_Probabilistic_NextStep_Excecutor(Q,NextMoveArray,invCM,C,Vleft,NumberOfDots,IndexOfRemovedCharge);
        Decay_Probability_Percentile = 0.3;
        
        %% Multiple Next Step Excecutor
        %[Q,CurrentRow,CurrentCol,EnergyDifference,Tunneling_Time,ChargeStuck,AddedChargesFromThisStep,RemovedChargesFromThisStep,ExcecutedMoves,ResidualEnergyMatrix] = TwoD_Probabilistic_Multiple_NextStep_Excecutor(Q,NextMoveArray,invCM,C,Cg,Vleft,NumberOfDots,IndexOfRemovedCharge,Decay_Probability_Percentile,TransitionProbabilityVector,ResidualEnergyMatrix);
        [Q,CurrentRow,CurrentCol,EnergyDifference,Tunneling_Time,ChargeStuck,AddedChargesFromThisStep,RemovedChargesFromThisStep,ExcecutedMoves,ResidualEnergyMatrix] = TwoD_Probabilistic_Multiple_NextStep_Excecutor(Q,NextMoveArray,invCM,C,Cg,Vleft,NumberOfDots,IndexOfRemovedCharge,Decay_Probability_Percentile,TransitionProbabilityVector,ResidualEnergyMatrix);

        [Ix_front,Ix_back,Iy_up,Iy_down] = TwoD_Gather_Flow_Data_NewAlgorithm(Ix_front,Ix_back,Iy_up,Iy_down,ExcecutedMoves,EnergyDifference,IndexOfRemovedCharge,NumberOfDots);
        
        
        ChargesAdded = ChargesAdded + AddedChargesFromThisStep;
        ChargesRemoved = ChargesRemoved + RemovedChargesFromThisStep;
        %  [Ix_front,Ix_back,Iy_up,Iy_down] = TwoD_Gather_Flow_Data(Ix_front,Ix_back,Iy_up,Iy_down,ChosenStep,EnergyDifference,IndexOfRemovedCharge,NumberOfDots);
        %Old Gather Flow Algorithm
        % [Ix_front,Ix_back,Iy_up,Iy_down] = TwoD_Gather_Flow_Data_NumberOnly(Ix_front,Ix_back,Iy_up,Iy_down,ChosenStep,EnergyDifference,IndexOfRemovedCharge,NumberOfDots);
        
        
        OptimalStep = ChosenStep;
        
        if ChosenStep ==0
            stuck = stuck + 1;
            if mod(stuck,1000) == 0
                Clogging_Event = 1;
                stuck = 1;
                break
            end
        end
        if ChosenStep ~=0
            stuck = 1;
        end
        
        
        if ChosenStep >= 4*NumberOfDots^2 - 3*NumberOfDots + 1
            %   [ChargingTime] = OneD_ChargingTimeCalculator(Q,invCM,C,Vleft);
            [Current_Theshold_Voltage(p)] = TwoD_Threshold_Voltage_Calculator(Q,NumberOfDots,invCM,C,Vleft);
            NumberOfCharges_InArray(p) = sum(sum(Q-InitialSystem));
            Averaged_Current_Theshold_Voltage = mean(Current_Theshold_Voltage);
            Averaged_Charges_InArray = mean(NumberOfCharges_InArray);
            %ChargesAdded = ChargesAdded +1;
            p = p+1;
            % recording move
            Last20moves(:,:,mod(LastMoveRecorderCount,20)+1) = Q;
            LastMoveRecorderCount = LastMoveRecorderCount +1;
            % Checking Time Difference
            %   Time_Difference_Of_Charging = TotalTime - TotalTimeBefore;
        end
        
        
        
        %% Old Probabilisticly Excecuting Next Step
        %%[Q,CurrentRow,ChosenStep,EnergyDifference] = OneD_Probabilistic_Excecution_Of_NextStep(Q,NextStepArray,invCM,C,Vleft,CurrentRow);
        %%OptimalStep = ChosenStep;
        
        
        % Adding time and checking breakpoint
        TotalTimeBefore = TotalTime;
        TotalTime = TotalTime + Tunneling_Time;
        
        if mod(TotalTime,TimeOfEachRun) <= mod(TotalTimeBefore,TimeOfEachRun)
            break
        end
        
        % Checking Time Difference
        Time_Difference_Of_Movement = TotalTime - TotalTimeBefore;
        
        %% Taking Picture of system
        %% Taking a picture of the system
        if PlotSystem == 1
            [f(framenumber)] = TakePictureOfTheSystem(Q);
            framenumber = framenumber + 1;
        end
        if Plot_EnergyLanscape_plot == 1
            [EnergyLanscape_plot(EnergyFrameNumber)] = TwoD_EnergyLanscape_Plot(NumberOfDots,C,Cg,Q,invCM,Vleft);
            EnergyFrameNumber = EnergyFrameNumber +1;
        end
        % recording move
        Last20moves(:,:,mod(LastMoveRecorderCount,20)+1) = Q;
        LastMoveRecorderCount = LastMoveRecorderCount +1;
        
        %Checking if charge made it through the system
        if TransferedElectrons >= 1
            if Q(NumberOfDots) <= 1
                ChargeStuck =0;
                ChargesRemoved = ChargesRemoved+1;
                CurrentRow = 1;
                break
            end
        end
        
        
        
        
        
    end
    
    %%if CurrentRow >= NumberOfDots
    %%    break
    %%end
    %%end of loop for single transfer of electron
    
end


%% Gathering data from current voltage test
%TotalTime = sum(TimeVector);
VoltageOnSystem(NumberOfTest,1) = Vleft;
%%DotOfLastTransfer(NumberOfTest,1) = CurrentCol;
TransferedElectrons = 0;
Q_Reconfigured = Q;
%% Taking Picture of system
%% Taking a picture of the system
if PlotSystem == 1
    [f(framenumber)] = TakePictureOfTheSystem(Q);
    framenumber = framenumber + 1;
end
if Plot_EnergyLanscape_plot == 1
    [EnergyLanscape_plot(EnergyFrameNumber)] = TwoD_EnergyLanscape_Plot(NumberOfDots,C,Cg,Q,invCM,Vleft);
    EnergyFrameNumber = EnergyFrameNumber +1;
end

% recording move
Last20moves(:,:,mod(LastMoveRecorderCount,20)+1) = Q;
LastMoveRecorderCount = LastMoveRecorderCount +1;

%% Puting into plot system
PlotSystemMovie_FromThisRun = f;
