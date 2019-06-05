

function [PlotSystemMovie_FromThisVoltage,EnergyLanscape_plot,EnergyFrameNumber,AverageChargesTransfered,TotalTime,Current_Through_System,Calculated_Theshold_Voltage,NumberOfMoves,TimeBetween_DischargingCharges,CurrentThroughSystem,Q_Final,NumberOfCharges_InArray,AveragedState,Last20moves,LastMoveRecorderCount,f,Random_Number_Seed,Random_Number_Index,framenumber,Ix_front,Ix_back ,Iy_up ,Iy_down,NumberOfClogging_Events,Vg1,q_Gate,Total_Charge_InGate] = TwoD_Constant_CurrentMode(Q,C,NumberOfRuns_AtEachVoltage,Cg,NumberOfDots,Vleft,Vg,Vg1,q_Gate,Total_Charge_InGate,Rg,ThresholdVoltage,PlotSystem,InitialSystem,Last20moves,LastMoveRecorderCount,TotalTimeAtEachVoltage,TimeOfEachRun,TotalTime,Random_Number_Seed,Random_Number_Index,NextMoveArray,IndexOfRemovedCharge,invCM,f,framenumber,Ix_front,Ix_back ,Iy_up ,Iy_down,Plot_Flow_NonAverage_Chart,NumberOfVoltageTests,FirstChargedSystem,Plot_EnergyLanscape_plot,EnergyFrameNumber,EnergyLanscape_plot,TransitionProbabilityVector)

NumberOfRuns_AtEachVoltage = TotalTimeAtEachVoltage/TimeOfEachRun;
%TimeBetween_AddingChargesTime = zeros(NumberOfRuns_AtEachVoltage,1);
Calculated_Theshold_Voltage = zeros(NumberOfRuns_AtEachVoltage,1);
NumberOfMoves = zeros(NumberOfRuns_AtEachVoltage,1);
CurrentThroughSystem = zeros(NumberOfRuns_AtEachVoltage,1);
%InternalMoves_Time = zeros(NumberOfRuns_AtEachVoltage,1);
%Charging_Time = zeros(NumberOfRuns_AtEachVoltage,1);
TimeBetween_DischargingCharges = zeros(NumberOfRuns_AtEachVoltage,1);
NumberOfCharges_InArray = zeros(NumberOfRuns_AtEachVoltage,1);
%  SumOfStates = zeros(NumberOfDots,NumberOfDots);
SumOfStates = zeros(NumberOfDots(1),NumberOfDots(2));
%MeanCurrent = 0.05;
%AvalancheEvent = 0;
Current_Through_System = zeros(NumberOfRuns_AtEachVoltage,1);
AverageChargesTransfered = zeros(NumberOfRuns_AtEachVoltage,1);
    %CurrentNormalizationFactor = 1/Cg;
    Ix_front = zeros(NumberOfDots(1),NumberOfDots(2));
    Ix_back  = zeros(NumberOfDots(1),NumberOfDots(2));
    Iy_up = zeros(NumberOfDots(1),NumberOfDots(2));
    Iy_down = zeros(NumberOfDots(1),NumberOfDots(2));
    
    Ix_front_test = zeros(NumberOfRuns_AtEachVoltage,NumberOfDots(1),NumberOfDots(2));
    Ix_back_test= zeros(NumberOfRuns_AtEachVoltage,NumberOfDots(1),NumberOfDots(2));
    Iy_up_test= zeros(NumberOfRuns_AtEachVoltage,NumberOfDots(1),NumberOfDots(2));
    Iy_down_test= zeros(NumberOfRuns_AtEachVoltage,NumberOfDots(1),NumberOfDots(2));
    Clogging_Events = zeros(NumberOfRuns_AtEachVoltage,1);
    
   
for n = 1:NumberOfRuns_AtEachVoltage

    %% Exicute one time run
    TotalTimeBefore = TotalTime;
    
    % Reseting FlowChart
    %Ix = zeros(NumberOfDots(1),NumberOfDots(2));
    %Iy = zeros(NumberOfDots(1),NumberOfDots(2));
    
    
%% Time BreakPoint
   %[PlotSystemMovie_FromThisRun,EnergyLanscape_plot,EnergyFrameNumber,Averaged_Charges_InArray,Averaged_Current_Theshold_Voltage,TotalTime,Q_Reconfigured,NumberOfMove,ChargesRemoved,ChargesAdded,Last20moves,LastMoveRecorderCount,Random_Number_Seed,Random_Number_Index,Ix_front,Ix_back ,Iy_up ,Iy_down,Clogging_Event] = TwoD_Run_Time_Breakpoint(Q,C,Cg,NumberOfDots,Vleft,PlotSystem,Last20moves,LastMoveRecorderCount,TimeOfEachRun,TotalTime,InitialSystem,TotalTimeBefore,Random_Number_Seed,Random_Number_Index,NextMoveArray,IndexOfRemovedCharge,invCM,Ix_front,Ix_back ,Iy_up ,Iy_down,Plot_EnergyLanscape_plot,EnergyFrameNumber,EnergyLanscape_plot,TransitionProbabilityVector)

  %% Charge BreakPoint
  tic
     [PlotSystemMovie_FromThisRun,EnergyLanscape_plot,EnergyFrameNumber,Averaged_Charges_InArray,Averaged_Current_Theshold_Voltage,TotalTime,Q_Reconfigured,NumberOfMove,ChargesRemoved,ChargesAdded,Last20moves,LastMoveRecorderCount,Random_Number_Seed,Random_Number_Index,Ix_front,Ix_back ,Iy_up ,Iy_down,Clogging_Event,Vg1,q_Gate,Total_Charge_InGate] = TwoD_Run_Charge_Breakpoint(Q,C,Cg,NumberOfDots,Vleft,Vg,Vg1,q_Gate,Total_Charge_InGate,Rg,PlotSystem,Last20moves,LastMoveRecorderCount,TimeOfEachRun,TotalTime,InitialSystem,TotalTimeBefore,Random_Number_Seed,Random_Number_Index,NextMoveArray,IndexOfRemovedCharge,invCM,Ix_front,Ix_back ,Iy_up ,Iy_down,Plot_EnergyLanscape_plot,EnergyFrameNumber,EnergyLanscape_plot,TransitionProbabilityVector);
    toc
    %% This is the TwoD Version that is very primitive
 %   [TotalTime,Q_Final,f] = TwoD_Run_WithTime_Breakpoint(Q,C,Cg,NumberOfDots,Vleft,TimeVector,framenumber)

    Q = Q_Reconfigured; 
    
    


    %% Plot System Recording
    if n == 1
    PreviousLength = 0;
    end
    if length(PlotSystemMovie_FromThisRun) > 1
        for k = 1:length(PlotSystemMovie_FromThisRun)
            PlotSystemMovie_FromThisVoltage(PreviousLength + k) = PlotSystemMovie_FromThisRun(k);
        end
        PreviousLength = length(PlotSystemMovie_FromThisVoltage);
    end
    
    %% 
    if TotalTime == Inf
        TotalTime = TotalTimeBefore + TotalTimeAtEachVoltage
        Clogging_Events(n) = Clogging_Event;
        
        %% this could be the way to break stuck situations
        n = NumberOfRuns_AtEachVoltage
    end
    
    Clogging_Events(n) = Clogging_Event;
    Ix_front_test(n,:,:) =     Ix_front;
    Ix_back_test(n,:,:) =     Ix_back;
    Iy_up_test(n,:,:) =     Iy_up;
    Iy_down_test(n,:,:) =     Iy_down;
    % Gathering infor about system
    SumOfStates = SumOfStates + Q;
    NumberOfCharges_InArray(n) = Averaged_Charges_InArray;
    NumberOfMoves(n) = NumberOfMove;
    Calculated_Theshold_Voltage(n) = Averaged_Current_Theshold_Voltage;
  %  Current_Through_System(n) = (ChargesRemoved+ChargesAdded/2)/(TotalTime-TotalTimeBefore);
        %Current_Through_System(n) = (ChargesAdded+ChargesRemoved)/(2*(TotalTime-TotalTimeBefore));
        Current_Through_System(n) = ChargesRemoved/(TotalTime-TotalTimeBefore);
        if TotalTime == TotalTimeBefore 
        Current_Through_System = 0;
        end

    if Plot_Flow_NonAverage_Chart == 1
       AveragedState =  SumOfStates/n;
    [b] = TwoD_Plot_DoublePlot_AveragedSurface_and_Flowchart(NumberOfVoltageTests,InitialSystem,FirstChargedSystem,AveragedState,NumberOfDots,Ix_front,Ix_back,Iy_up,Iy_down,Vleft,C,Cg);
    end
    
    %ActualTimeDifference = (TotalTime-TotalTimeBefore);
    TimeOfEachRun;
   % AverageChargesTransfered(n) = (ChargesRemoved+ChargesAdded/2);
    %AverageChargesTransfered(n) = ChargesAdded;
    AverageChargesTransfered(n) = ChargesRemoved;
    
end

if PlotSystem == 0
    PlotSystemMovie_FromThisVoltage = 0;
end

AveragedState = SumOfStates/(NumberOfRuns_AtEachVoltage);
Q_Final = Q;
NumberOfClogging_Events = sum(Clogging_Events);

    Ix_front_test(n,:,:) =     Ix_front;
    Ix_back_test(n,:,:) =     Ix_back;
    Iy_up_test(n,:,:) =     Iy_up;
    Iy_down_test(n,:,:) =     Iy_down;
    
    Ix_front_average = sum(Ix_front_test)/NumberOfRuns_AtEachVoltage;
        Ix_back_average = sum(Ix_back_test)/NumberOfRuns_AtEachVoltage;
               Iy_up_average = sum(Iy_up_test)/NumberOfRuns_AtEachVoltage;
                      Iy_down_average = sum(Iy_down_test)/NumberOfRuns_AtEachVoltage;
        Ix_front = permute(Ix_front_average,[2,3,1]);
        Ix_back = permute(Ix_back_average,[2,3,1]);
        Iy_up = permute(Iy_up_average,[2,3,1]);
        Iy_down = permute(Iy_down_average,[2,3,1]);
        
 %   Ix_Average = sum(Ix_Test)/NumberOfRuns_AtEachVoltage;
  %  Iy_Average = sum(Iy_Test)/NumberOfRuns_AtEachVoltage;  
   % Ix = permute(Ix_Average,[2,3,1]);
    %Iy = permute(Iy_Average,[2,3,1]);