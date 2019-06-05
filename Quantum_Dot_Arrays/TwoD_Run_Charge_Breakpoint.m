function [PlotSystemMovie_FromThisRun,EnergyLanscape_plot,EnergyFrameNumber,Averaged_Charges_InArray,Averaged_Current_Theshold_Voltage,TotalTime,Q_Reconfigured,NumberOfMove,ChargesRemoved,ChargesAdded,Last20moves,LastMoveRecorderCount,Random_Number_Seed,Random_Number_Index,Ix_front,Ix_back ,Iy_up ,Iy_down,Clogging_Event,Vg1,q_Gate,Total_Charge_InGate] = TwoD_Run_Charge_Breakpoint(Q,C,Cg,NumberOfDots,Vleft,Vg,Vg1,q_Gate,Total_Charge_InGate,Rg,PlotSystem,Last20moves,LastMoveRecorderCount,TimeOfEachRun,TotalTime,InitialSystem,TotalTimeBefore,Random_Number_Seed,Random_Number_Index,NextMoveArray,IndexOfRemovedCharge,invCM,Ix_front,Ix_back ,Iy_up ,Iy_down,Plot_EnergyLanscape_plot,EnergyFrameNumber,EnergyLanscape_plot,TransitionProbabilityVector)

%Vg = 0;
%AveragingNumber = 1;
NumberOfVoltageTests  = 3;
%ElectronInEachVoltage = 2;
PlotSystem = 1;
if PlotSystem == 0
    f = 0;
end

%TimeVector = zeros(NumberOfDots(1)*NumberOfDots(2),1);
NumberOfTest = NumberOfVoltageTests;
%VtAveragingMatrix = ones(AveragingNumber,1);
%VoltageDifference = ones(4,NumberOfDots(2));
%NextStep = 1;
%OptimalCol =1;
%NumberOfCharges = NumberOfDots*NumberOfDots*NumberOfDots;
AveragingNumber = 10;
AveragingNumber = 10;
%CurrentRow = 1;
%LastRow = 1;
%LastCol = 1;
ChargeStuck =0;
q = 1;
%I = 1;
%TransferedElectrons = 0;
%alpha = 0;
%ChargingVoltageDifference = ones(NumberOfDots(2),1);
%StepVoltageDifference = zeros(4,1);
%DotOfLastTransfer = zeros(NumberOfTest,1);
%NextVoltageMatrix = ones(NumberOfDots(2),1);
%marker = 0;
NumberOfMove = 1;
%SystemEquillibrium = 0;
ChosenStep = 0;
ExecutedMoves = 0;
ChargesRemoved = 0;
ChargesAdded = 0;
Averaged_Current_Theshold_Voltage = 0;
p = 1;
%k = 1;
%%for reference Q(i,j) = Q(rows-TopToBottom, cols-LeftToRight)
Clogging_Event = 0;
stuck = 1;
framenumber = 1;
t = 1;
TotalNumberOfTransferCharges = 800;

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
%Current_Theshold_Voltage = zeros(NumberOfCharges)

for i = 1:AveragingNumber
    
    i;
    % Adding time and checking breakpoint
    [Current_Theshold_Voltage(p)] = TwoD_Threshold_Voltage_Calculator(Q,NumberOfDots,invCM,C,Vleft);
    NumberOfCharges_InArray(p) = sum(sum(Q-InitialSystem));
    Averaged_Current_Theshold_Voltage = mean(Current_Theshold_Voltage);
    Averaged_Charges_InArray = mean(NumberOfCharges_InArray);
    
    
    % q_Gate_Old = q_Gate;
    % q_Gate_New = ((2*C*Cg)/(2*C+Cg))*(Vg + Vleft_New/2) + (Cg/(2*C+Cg))*sum(sum(Q));
    % q_Gate = q_Gate_Old + (q_Gate_New-q_Gate_Old)*(1-exp(-Time(n-1)/(Rg*Cg)));
    %Vg = Vg1 + q_Gate/Cg;
    Vg = Vg1 + Total_Charge_InGate/Cg;
    
    p = p+1;
    
    %% Time Breakpoint - Only if inf
    if TotalTime == inf
        break
    end
    
    
    %% Stuck Breakpoint
    if  Clogging_Event == 1
        %if Clogging_Event == 1
        break
    end
    
    %%if TransferedElectrons >= 1
    %%break;
    %%end
    TransferedElectrons = 0;
    
    
    %% Charging Steps - It is possible that all this can be deleted from here
    
    %  It seems like the algorithm never enters this section
    % if ChosenStep >= 4*NumberOfDots(1)*NumberOfDots(2) - 3*NumberOfDots(1) + 1
    %     [ChargingTime] = OneD_ChargingTimeCalculator(Q,invCM,C,Vleft);
    %     [Current_Theshold_Voltage(p)] = TwoD_Threshold_Voltage_Calculator(Q,NumberOfDots,invCM,C,Vleft);
    %     NumberOfCharges_InArray(p) = sum(Q-InitialSystem);
    %     Averaged_Current_Theshold_Voltage = mean(Current_Theshold_Voltage);
    %     Averaged_Charges_InArray = mean(NumberOfCharges_InArray);
    %ChargesAdded = ChargesAdded +1;
    %     p = p+1;
    % recording move
    %     Last20moves(:,:,mod(LastMoveRecorderCount,20)+1) = Q;
    %     LastMoveRecorderCount = LastMoveRecorderCount +1;
    % Checking Time Difference
    %   Time_Difference_Of_Charging = TotalTime - TotalTimeBefore;
    % end
    
    
    % Breakpoint
    
    %% It seems like the algorithm doesn't enter here too
    % if ChargeStuck >=1
    
    %% Breaking Point
    %  if CurrentRow >= NumberOfDots
    %      if CurrentRow >= NumberOfDots(1)
    %                      break
    %      end
    
    %% Reseting Current Row
    %      if ExecutedMoves == 1;
    %          CurrentRow = 1;
    %      end
    %      if ExecutedMoves == 0;
    %          CurrentRow = CurrentRow + 1;
    %      end
    
    
    %% Taking a picture of the system
    %      if PlotSystem == 1
    %          [f(framenumber)] = TakePictureOfTheSystem(Q);
    %          framenumber = framenumber + 1;
    %      end
    %      if Plot_EnergyLanscape_plot == 1
    %          [EnergyLanscape_plot(EnergyFrameNumber)] = TwoD_EnergyLanscape_Plot(NumberOfDots,C,Cg,Q,invCM,Vleft);
    %          EnergyFrameNumber = EnergyFrameNumber +1;
    %      end
    
    % recording move
    %      Last20moves(:,:,mod(LastMoveRecorderCount,20)+1) = Q;
    %      LastMoveRecorderCount = LastMoveRecorderCount +1;
    %  end
    
    
    %% Until here
    
    %% Rebooting ChargeStuck so the system, and Tracking index
    ChargeStuck = 0;
    ExecutedMoves = 0;
    
    
    ResidualEnergyMatrix = zeros(NumberOfDots(1),NumberOfDots(2));
    
    %% Moving Charge to rest point algorithm %%
    %while CurrentRow <= NumberOfDots+1
    while CurrentRow <= NumberOfDots(1)+1
        
        
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
        [Q,CurrentRow,CurrentCol,EnergyDifference,Tunneling_Time,ChargeStuck,AddedChargesFromThisStep,RemovedChargesFromThisStep,ExcecutedMoves,ResidualEnergyMatrix,ExtraCharges_In_Gate] = TwoD_Probabilistic_Multiple_NextStep_Excecutor(Q,NextMoveArray,invCM,C,Cg,Vleft,Vg,NumberOfDots,IndexOfRemovedCharge,Decay_Probability_Percentile,TransitionProbabilityVector,ResidualEnergyMatrix);
        
        [Ix_front,Ix_back,Iy_up,Iy_down] = TwoD_Gather_Flow_Data_NewAlgorithm(Ix_front,Ix_back,Iy_up,Iy_down,ExcecutedMoves,EnergyDifference,IndexOfRemovedCharge,NumberOfDots);
        
        NumberOfCharges_InArray1(t) = sum(sum(Q-InitialSystem));
        t = t+1;
        
        
        
        ChargesAdded = ChargesAdded + AddedChargesFromThisStep;
        ChargesRemoved = ChargesRemoved + RemovedChargesFromThisStep;
        %  [Ix_front,Ix_back,Iy_up,Iy_down] = TwoD_Gather_Flow_Data(Ix_front,Ix_back,Iy_up,Iy_down,ChosenStep,EnergyDifference,IndexOfRemovedCharge,NumberOfDots);
        %Old Gather Flow Algorithm
        % [Ix_front,Ix_back,Iy_up,Iy_down] = TwoD_Gather_Flow_Data_NumberOnly(Ix_front,Ix_back,Iy_up,Iy_down,ChosenStep,EnergyDifference,IndexOfRemovedCharge,NumberOfDots);
        
        
        
        %% It Seems that both these expressions are useless
        %  OptimalStep = ChosenStep;
        
        if sum(ExcecutedMoves) ==0
            
            stuck = stuck + 1;
            if mod(stuck,3000) == 0
                Clogging_Event = 1;
                stuck = 1;
                break
            end
        end
        % if ChosenStep ~=0
        %     stuck = 1;
        % end
        %% this one too
        % if ChosenStep >= 4*NumberOfDots(1)*NumberOfDots(2) - 3*NumberOfDots(1) + 1
        %   [ChargingTime] = OneD_ChargingTimeCalculator(Q,invCM,C,Vleft);
        %     [Current_Theshold_Voltage(p)] = TwoD_Threshold_Voltage_Calculator(Q,NumberOfDots,invCM,C,Vleft);
        %     NumberOfCharges_InArray(p) = sum(sum(Q-InitialSystem));
        %     Averaged_Current_Theshold_Voltage = mean(Current_Theshold_Voltage);
        %     Averaged_Charges_InArray = mean(NumberOfCharges_InArray);
        %ChargesAdded = ChargesAdded +1;
        %     p = p+1;
        % recording move
        %     Last20moves(:,:,mod(LastMoveRecorderCount,20)+1) = Q;
        %     LastMoveRecorderCount = LastMoveRecorderCount +1;
        % Checking Time Difference
        %   Time_Difference_Of_Charging = TotalTime - TotalTimeBefore;
        % end
        
        
        
        %% Old Probabilisticly Excecuting Next Step
        %%[Q,CurrentRow,ChosenStep,EnergyDifference] = OneD_Probabilistic_Excecution_Of_NextStep(Q,NextStepArray,invCM,C,Vleft,CurrentRow);
        %%OptimalStep = ChosenStep;
        
        
        % Adding time and checking breakpoint
        TotalTimeBefore = TotalTime;
        TotalTime = TotalTime + Tunneling_Time;
        Use_Gate_Potential_Relaxation = 0;
        if Use_Gate_Potential_Relaxation == 1
            q_Gate_Old = q_Gate;
            if TotalTime ~=inf
                q_Gate_New = ((2*C*Cg)/(2*C+Cg))*(Vg1 + Vleft/2) + (Cg/(2*C+Cg))*sum(sum(Q));
                q_Gate = q_Gate_Old + (q_Gate_New-q_Gate_Old)*(1-exp(-Tunneling_Time/(Rg*Cg)));
            end
            Vg = Vg1 + q_Gate/Cg;
        end
        
        Allow_Extra_GateCharges_tochange_the_GatePotential = 1;
        if Allow_Extra_GateCharges_tochange_the_GatePotential == 1
          %  Total_Charge_InGate = 0;
            if TotalTime ~=inf
                if ExtraCharges_In_Gate ~= 0
                TimeOfTunneling(q) = TotalTime;
                ExtraChargeVector(q) = ExtraCharges_In_Gate;             
                q = q+1;
                end
                if q>1
                Total_Charge_InGate = sum(ExtraChargeVector.*exp(-(TotalTime-TimeOfTunneling)/(Rg*Cg)));
                end
            end
            Vg = Vg1 + Total_Charge_InGate/Cg;
        end
        
        
        
        if TotalTime == inf
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
            [EnergyLanscape_plot(EnergyFrameNumber)] = TwoD_EnergyLanscape_Plot(NumberOfDots,C,Cg,Q,invCM,Vleft,Vg);
            EnergyFrameNumber = EnergyFrameNumber +1;
        end
        % recording move
        Last20moves(:,:,mod(LastMoveRecorderCount,20)+1) = Q;
        LastMoveRecorderCount = LastMoveRecorderCount +1;
        
        %Checking if charge made it through the system
        %if TransferedElectrons >= 1
        % if Q(NumberOfDots) <= 1
        %    if Q(NumberOfDots(1)) <= 1; Perhaps this is redundant
        %    ChargeStuck =0;
        %    ChargesRemoved = ChargesRemoved+1;
        %    CurrentRow = 1;
        %    break
        %     end
        %end
        
        %% Charge Breakpoint
        %if (ChargesRemoved+ChargesAdded)/2 >= i*TotalNumberOfTransferCharges/AveragingNumber
        if ChargesRemoved >= i*TotalNumberOfTransferCharges/AveragingNumber
            break
        end
        
        
    end
    NewAveragedCharges(p) = mean(NumberOfCharges_InArray1);
    NumberOfCharges_InArray1 = 0;
    t = 1;
    %% Charge Breakpoint
    %if (ChargesRemoved+ChargesAdded)/2 >= TotalNumberOfTransferCharges
    if ChargesRemoved >= TotalNumberOfTransferCharges
        break
    end
    
    
    
end




Averaged_Charges_InArray = mean(NewAveragedCharges);

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
    [EnergyLanscape_plot(EnergyFrameNumber)] = TwoD_EnergyLanscape_Plot(NumberOfDots,C,Cg,Q,invCM,Vleft,Vg);
    EnergyFrameNumber = EnergyFrameNumber +1;
end

% recording move
Last20moves(:,:,mod(LastMoveRecorderCount,20)+1) = Q;
LastMoveRecorderCount = LastMoveRecorderCount +1;

%% Puting into plot system
PlotSystemMovie_FromThisRun = f;
