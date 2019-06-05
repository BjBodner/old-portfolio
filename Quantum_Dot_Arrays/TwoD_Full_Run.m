

function [Dynamic_State_Movie,DynamicStateframe,PlotSystemMovie] = TwoD_Full_Run(MainMenu_Choice,C,Cg,Vg,Rg,NumberOfDots,InitialSystem,DynamicStateframe,Dynamic_State_Movie,SizeAndDisorder_parameters)

%[Alpha_Graph,Vt_Graph] = TwoD_ThresholdVoltageTests(InitialSystem,NumberOfDots);
%[InitialFreeEnergy_Graph,FinalFreeEnergy_Graph] = TwoD_FreeEnergy_Tests(InitialSystem,NumberOfDots)



MainMenu_Choice;
%ArraySelection = 1;
%IndexOfBadArray = 1;
%IndexOfGoodArray = 1;

VoltageSequence_and_Test_Parameters = MainMenu_Choice.VoltageSequence_and_Test_Parameters
CapacitanceMatrixChoice = MainMenu_Choice.CapacitanceMatrixChoice;


TotalTimeOfRun = VoltageSequence_and_Test_Parameters.TotalTimeOfRun;
NumberOfVoltageTests = VoltageSequence_and_Test_Parameters.NumberOfVoltageTests;
NumberOfRuns_AtEachVoltage = VoltageSequence_and_Test_Parameters.NumberOf_Runs_at_each_Voltage;
TotalTimeAtEachVoltage = TotalTimeOfRun/NumberOfVoltageTests;
TimeOfEachRun = TotalTimeAtEachVoltage/NumberOfRuns_AtEachVoltage;
Time = 0:TotalTimeOfRun/NumberOfVoltageTests:TotalTimeOfRun - TotalTimeOfRun/NumberOfVoltageTests;
Random_Number_Seed = rand(10000,1);
Random_Number_Index = 1;
%NumberOfCycles_InTotalRun = 5;
%NumberOfPoints_perCycle = 10;
%AC_Amplitude = 0.2;
%NumberOfRuns_AtEachVoltage = 20;

PlotSystem = 0; StartingVoltageTest_forPlotSystem = 5; EndingVoltageTest_forPlotSystem = 11;
PlotCharging =0;
Plot_EnergyLanscape_plot = 0;
Plot_Dynamic_State = 1; az = 310; el =30;
Plot_FlowChart = 0;
Plot_Flow_NonAverage_Chart = 0;
DistributionPlot = 0;
PlotAverages = 0 ;
PlotNonAverages = 0;
tripleplot = 1;
PlotAverageState =0;
ChargesPlot =01;
CurrentPlot = 0;
StateEvolution_Plots =0;
AvalancheEventRecorder =0;
Double_AverageSateplot = 0;
ExtraChargesPerDot_Plot = 0;
Plot_InitialFinal_Difference_State = 1;
Backtrack = 0;
Backtrack2 = 0;
BackChange = 0;
BackTrackNeeded = 0;
BackTrackNow = 0;
NumberOfMeasurementForBacktrack = 0;

PlotSystem1 = PlotSystem;
SavingVeriablesOption =0;
EnergyFrameNumber = 1;
EnergyLanscape_plot = getframe(gcf);

%% Selecting Capacitance Matrix



Regular_Round_Matrix = CapacitanceMatrixChoice.Regular_Round_Matrix;
Eliptical1_Long_in_X_Direction_Matrix = CapacitanceMatrixChoice.Eliptical1_Long_In_X_Direction;
Eliptical1_Long_in_Y_Direction_Matrix = CapacitanceMatrixChoice.Eliptical1_Long_In_Y_Direction;
Oscliating_Rows_Only = CapacitanceMatrixChoice.OscliatingRowsOnly;
Oscilating_Lines_and_Rows = CapacitanceMatrixChoice.OscilatingLinesAndRows;
SideWays_Matrix = CapacitanceMatrixChoice.SideWays_Matrix;
Increasing_Screeninglength_Matrix = CapacitanceMatrixChoice.Increasing_Screeninglength_X_Matrix;
Decreasing_Screeninglength_Matrix = CapacitanceMatrixChoice.Decreasing_Screeninglength_1X_Matrix;
X2_Increasing_Screeninglength_Matrix = CapacitanceMatrixChoice.Increasing_Screeninglength_X2_Matrix;
Y_Gradient_10timeIncrease_Matrix = CapacitanceMatrixChoice.Y_Gradient_10timeIncrease_Matrix;

% Voltage Changing Sequences
%LogarithmicRaising__VoltageSequence = 0;    StartingPowerOfTen = -3;
%LinearRaising_VoltageSequence = 1;  VoltageRasingAmount = 0.2; BeginingVoltage = 1.02; %VoltageRasingAmount = 0.02;
%LinearRaising_and_Lowering_VoltageSequence = 0;
%AC_VoltageSequence = 0;     Number_Of_Cycles = 6;
%ConstantVoltage_VoltageSequence = 0;   % ConstantVoltage = 1.2*ThresholdVoltage;
%AC_Triangle_VoltageSequence = 0;% NumberOfCycles = NumberOfVoltageTests/CycleLength;
%Real_AC_VoltageSequence =0;
%StepFunction_Sequence = 0;  StepSize = 3;


%if Real_AC_VoltageSequence == 1

%TimeOfCycle = 2*pi/VoltageFrequency;
%NumberOfCycles_InTotalRun = TotalTimeOfRun/TimeOfCycle;
%TotalTimeAtEachVoltage = TotalTimeOfRun/(NumberOfCycles_InTotalRun*NumberOfPoints_perCycle);
% TimeOfEachRun = TotalTimeAtEachVoltage/NumberOf_Runs_at_each_Voltage;
%  t = -pi:2*pi/NumberOfPoints_perCycle:pi + 2*pi*(NumberOfCycles_InTotalRun-1);
%   NumberOfVoltageTests = max(size(t));
%Time = 0:TotalTimeOfRun/NumberOfVoltageTests:TotalTimeOfRun - TotalTimeOfRun/NumberOfVoltageTests;
%end







VoltageOnSystem = zeros(NumberOfVoltageTests,1);
CurrentThroughSystem = zeros(NumberOfVoltageTests,1);
NumberOfMoves = zeros(NumberOfVoltageTests,1);
RelativeChangeOf_Voltage_FromVt = zeros(NumberOfVoltageTests,1);
TimeBetweenAddingChargesTime = zeros(NumberOfVoltageTests,1);
Calculated_Theshold_Voltage = zeros(NumberOfVoltageTests,1);
%Time = zeros(NumberOfVoltageTests,1);

%Flow Parameters
%[x,y] = meshgrid(1:1:NumberOfDots,1:1:NumberOfDots);
%Ix_front = zeros(NumberOfDots,NumberOfDots);
%Ix_back = zeros(NumberOfDots,NumberOfDots);
%Iy_up = zeros(NumberOfDots,NumberOfDots);
%Iy_down = zeros(NumberOfDots,NumberOfDots);

[x,y] = meshgrid(1:1:NumberOfDots(1),1:1:NumberOfDots(2));
Ix_front = zeros(NumberOfDots(1),NumberOfDots(2));
Ix_back = zeros(NumberOfDots(1),NumberOfDots(2));
Iy_up = zeros(NumberOfDots(1),NumberOfDots(2));
Iy_down = zeros(NumberOfDots(1),NumberOfDots(2));
DistributionIndex = zeros(NumberOfVoltageTests,1)

Preallocation = 1;
if Preallocation == 1
    Full_TimeBetween_AddingCharges = zeros(NumberOfVoltageTests,NumberOfRuns_AtEachVoltage);
    Full_TimeBetween_DischargingCharges = zeros(NumberOfVoltageTests,NumberOfRuns_AtEachVoltage);
    Full_Calculated_Theshold_Voltage = zeros(NumberOfVoltageTests,NumberOfRuns_AtEachVoltage);
    Full_CurrentThroughSystem = zeros(NumberOfVoltageTests,NumberOfRuns_AtEachVoltage);
    Full_NumberOfMoves = zeros(NumberOfVoltageTests,NumberOfRuns_AtEachVoltage);
    Full_AppliedVoltage = zeros(NumberOfVoltageTests,NumberOfRuns_AtEachVoltage);
    Full_NumberOfCharges_InArray = zeros(NumberOfVoltageTests,NumberOfRuns_AtEachVoltage);
    Full_AveragedState = zeros(NumberOfVoltageTests,NumberOfDots(1),NumberOfDots(2));
    Full_ChargesTransfered = zeros(NumberOfVoltageTests,NumberOfRuns_AtEachVoltage);
end

%Last20moves = zeros(NumberOfDots,NumberOfDots,20);
%OrderedLast20moves = zeros(NumberOfDots,NumberOfDots,20);
Last20moves = zeros(NumberOfDots(1),NumberOfDots(2),20);
OrderedLast20moves = zeros(NumberOfDots(1),NumberOfDots(2),20);
LastMoveRecorderCount = 0;
NumberOfEvent = 1;
NumberOfVoltageTestsOfEvent = 0;



StepByStepMonitoring_Choices = MainMenu_Choice.StepByStepMonitoring_Choices;
PlotCharging = StepByStepMonitoring_Choices.PlotCharging;
PlotSystemVector = StepByStepMonitoring_Choices.PlotSystem;

PlotSystem1 = PlotSystemVector(1);

if PlotSystem1 == 0
    PlotSystemMovie = 0;
end

% Ploting Charging
if PlotCharging ==1
    PlotSystem = 1;
end
if PlotCharging ==0
    PlotSystem = 0;
end

SizeAndDisorder_parameters
SizeAndDisorder_parameters.TransitionDisorder
[invCM,CM] = TwoD_Create_Selected_invCM(C,Cg,NumberOfDots,Regular_Round_Matrix,Eliptical1_Long_in_X_Direction_Matrix,Eliptical1_Long_in_Y_Direction_Matrix,Oscilating_Lines_and_Rows,Oscliating_Rows_Only,SideWays_Matrix,Increasing_Screeninglength_Matrix,Decreasing_Screeninglength_Matrix,Y_Gradient_10timeIncrease_Matrix,X2_Increasing_Screeninglength_Matrix,SizeAndDisorder_parameters);
%[invCM,CM] = TwoD_Create_Selected_invCM(C,Cg,NumberOfDots,Regular_Round_Matrix,Eliptical1_Long_in_X_Direction_Matrix,Eliptical1_Long_in_Y_Direction_Matrix,Oscilating_Lines_and_Rows,Oscliating_Rows_Only,SideWays_Matrix);



[NextMoveArray,IndexOfRemovedCharge,TransitionProbabilityVector] = TwoD_NextMoveArray_Generator(NumberOfDots,SizeAndDisorder_parameters);


Vg1 = Vg;
%Rg = 10000; % this is not tunneling to ate this is the resistance of the ground to the gate
InitialSystem = SizeAndDisorder_parameters.InitialSystem;
            q_Gate_Old = ((2*C*Cg)/(2*C+Cg))*(Vg + 0/2) + (Cg/(2*C+Cg))*sum(sum(InitialSystem));
            q_Gate = q_Gate_Old ;

Vg = Vg1 + q_Gate/Cg;
%% Create Charged System With Pics
[Vleft,Q,TotalTime,f,framenumber,q_Gate] = TwoD_New_Create_Charged_System(C,Cg,Vg,Vg1,q_Gate,Rg,NumberOfDots,InitialSystem,NextMoveArray,IndexOfRemovedCharge,invCM,PlotSystem,TransitionProbabilityVector);

%[EnergyLanscape_plot] = TwoD_EnergyLanscape_Plot(NumberOfDots,C,Cg,Q,invCM)

ThresholdVoltage = Vleft
FirstChargedSystem = Q;
ChargingTime = TotalTime;
VoltageVector = ones(NumberOfVoltageTests,1);
Time = ChargingTime+TotalTimeOfRun/NumberOfVoltageTests : TotalTimeOfRun/NumberOfVoltageTests : TotalTimeOfRun;



% Fixing Ploting Charging
if PlotCharging ==1
    if PlotSystem1 == 0
        PlotSystem = 0;
    end
end
if PlotCharging ==0
    if PlotSystem1 == 1
        PlotSystem = 1;
    end
end


%[DistributionTest,VoltageTest,TimeBetweenAddingChargesTime,Calculated_Theshold_Voltage] = OneD_DistributionTest_AtCurentVoltage(Q,invCM,C,NumberOfVoltageTests,Cg,NumberOfDots,Vleft,ThresholdVoltage);

%if Real_AC_VoltageSequence == 1
% Generating AC Voltage Sequence
%AC_Amplitude = AC_Amplitude*ThresholdVoltage;
%AC_LowestVoltage = ThresholdVoltage;
%AC_BaseVoltage = ThresholdVoltage + AC_Amplitude;
%AC_Voltage_Sequence = ThresholdVoltage + 2*AC_Amplitude - AC_Amplitude*cos(Time*VoltageFrequency);
%end


DynamicFrame = figure;
VoltageByVoltageMonitoring_Choices = MainMenu_Choice.VoltageByVoltageMonitoring_Choices;
TestSummeryPlots_Choice = MainMenu_Choice.TestSummeryPlots_Choices;
VoltageSequence = VoltageSequence_and_Test_Parameters.VoltageSequence;




n = 1;
%for n = 1:NumberOfVoltageTests
%while n <= Backtrack + NumberOfVoltageTests
Sequence_n = 1;
VoltageOrdered_n = 1;



%% Add Effective Charge terms
UseEffectiveCharge = 0;
if UseEffectiveCharge == 1
    NewEffective_Q_ExtraTerms1 = Cg*(Vg-Vleft*C*sum(invCM(:,1:NumberOfDots(1):NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(1) + 1)));
    NewEffective_Q_ExtraTerms = reshape(NewEffective_Q_ExtraTerms1,length(Q(:,1)),length(Q(1,:)));
    
    Q = Q + NewEffective_Q_ExtraTerms;
    for w = 1:length(Q(1,:))*length(Q(:,1))
        Q = Q*((CM(w,w) - Cg)/(invCM(w,w)));
    end
    
    OLDEffective_Q_ExtraTerms = NewEffective_Q_ExtraTerms;
end


%% Main Loop

Total_Charge_InGate = 0;
for Sequence_n = 1:NumberOfVoltageTests
    
    VoltageOrdered_n = n;
    BackTrackNow = 1;
    Vleft = VoltageSequence(Sequence_n)*ThresholdVoltage
    while BackTrackNow ~= 0
        % if Backtrack == 0
        
        % end
        
        % VoltageOrdered_n =Sequence_n + Backtrack;
        if BackTrackNow == 2
            Vleft = ((VoltageSequence(Sequence_n) + VoltageSequence(Sequence_n-1))/2)*ThresholdVoltage
        end
        
       % Use_GateChargeTerm = 1;
        %if Use_GateChargeTerm == 1
       %     if Sequence_n == 1
      %      q_Gate_Old = ((2*C*Cg)/(2*C+Cg))*(Vg + Vleft/2) + (Cg/(2*C+Cg))*Q;
     %       q_Gate = q_Gate_Old ;
    %        end
        %    if Sequence_n > 1
        %        q_Gate_Old = q_Gate;
        %        q_Gate_New = ((2*C*Cg)/(2*C+Cg))*(Vg + Vleft/2) + (Cg/(2*C+Cg))*Q;
        %        q_Gate = q_Gate_Old + (q_Gate_New-q_Gate_Old)*(1-exp(-Time(n-1)/(Rg*Cg)));
        %    end

        %    Vg = Vg1 + q_Gate/Cg;
      %  end
        
        
        
        
        tryOldWay2 = 0;
        if tryOldWay2 == 1
            if Backtrack >= 1
                if n - NumberOfMeasurementForBacktrack == 1
                    Vleft = ((VoltageSequence(n-Backtrack) + VoltageSequence(n-Backtrack-1))/2)*ThresholdVoltage
                end
                if n - NumberOfMeasurementForBacktrack > 1
                    Vleft = VoltageSequence(n-Backtrack)*ThresholdVoltage
                end
            end
        end
        
        %%
        %  Q = Q - OldEffective_Q_ExtraTerms
        UseEffectiveCharge = 0;
        if UseEffectiveCharge == 1
            for w = 1:length(Q(1,:))*length(Q(:,1))
                Q = Q/((CM(w,w) - Cg)/(invCM(w,w)));
            end
            Q = Q - OLDEffective_Q_ExtraTerms;
            
            NewEffective_Q_ExtraTerms1 = Cg*(Vg-Vleft*C*sum(invCM(:,1:NumberOfDots(1):NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(1) + 1)));
            NewEffective_Q_ExtraTerms = reshape(NewEffective_Q_ExtraTerms1,length(Q(:,1)),length(Q(1,:)));
            
            Q = Q + NewEffective_Q_ExtraTerms;
            for w = 1:length(Q(1,:))*length(Q(:,1))
                Q = Q*((CM(w,w) - Cg)/(invCM(w,w)));
            end
            
            OLDEffective_Q_ExtraTerms = NewEffective_Q_ExtraTerms;
        end
        
        
        %% Ploting System
        if PlotSystem == 1
            PlotSystem1 = 0;
            if n>= PlotSystemVector(2)
                PlotSystem1 = 1;
                if n >= PlotSystemVector(3)
                    PlotSystem1 = 0;
                end
            end
        end
        
        %testnumber = n
        % Calculating Relative Change from Voltage %
        %% RelativeChangeOf_Voltage_FromVt(n) = (Vleft - ThresholdVoltage)/ThresholdVoltage;
        
        
        
        %% Run On Constant Current Mode %%
        
        %[TimeBetween_AddingChargesTime,Calculated_Theshold_Voltage,NumberOfMoves,TimeBetween_DischargingCharges,CurrentThroughSystem,Q_Final,NumberOfCharges_InArray,AveragedState,Last20moves,LastMoveRecorderCount,AvalancheEvent] = OneD_Multiple_Runs_AtCurentVoltage(Q,invCM,C,NumberOfRuns_AtEachVoltage,Cg,NumberOfDots,Vleft,ThresholdVoltage,PlotSystem,InitialSystem,Last20moves,LastMoveRecorderCount);
        [PlotSystemMovie_FromThisVoltage,EnergyLanscape_plot,EnergyFrameNumber,AverageChargesTransfered,TotalTime,Current_Through_System,Calculated_Theshold_Voltage,NumberOfMoves,TimeBetween_DischargingCharges,CurrentThroughSystem,Q_Final,NumberOfCharges_InArray,AveragedState,Last20moves,LastMoveRecorderCount,f,Random_Number_Seed,Random_Number_Index,framenumber,Ix_front,Ix_back ,Iy_up ,Iy_down,NumberOfClogging_Events,Vg1,q_Gate,Total_Charge_InGate] = TwoD_Constant_CurrentMode(Q,C,NumberOfRuns_AtEachVoltage,Cg,NumberOfDots,Vleft,Vg,Vg1,q_Gate,Total_Charge_InGate,Rg,ThresholdVoltage,PlotSystem1,InitialSystem,Last20moves,LastMoveRecorderCount,TotalTimeAtEachVoltage,TimeOfEachRun,TotalTime,Random_Number_Seed,Random_Number_Index,NextMoveArray,IndexOfRemovedCharge,invCM,f,framenumber,Ix_front,Ix_back ,Iy_up ,Iy_down,Plot_Flow_NonAverage_Chart,NumberOfVoltageTests,FirstChargedSystem,Plot_EnergyLanscape_plot,EnergyFrameNumber,EnergyLanscape_plot,TransitionProbabilityVector);
        Time(n) = TotalTime;
        Q = Q_Final;
        
        CurrentTime = TotalTime
        
        
       % GateCharge(n) = q_Gate;
        GateCharge(n) = Total_Charge_InGate;
        Vg = Vg1 + Total_Charge_InGate/Cg;
        %% Plot System Recording
        
        
        if length(PlotSystemMovie_FromThisVoltage) > 1
            if n == PlotSystemVector(2)
                PreviousLength = 0;
            end
            for k = 1:length(PlotSystemMovie_FromThisVoltage)
                PlotSystemMovie(PreviousLength + k) = PlotSystemMovie_FromThisVoltage(k);
            end
            PreviousLength = length(PlotSystemMovie);
        end
        
        %% Recording Loop
        % for l = 1:max(size(f))
        %  M(Max+l) = f(l);
        %end
        % Max = max(size(M))
        
        %% Gathering Data From Runs at curent voltage %%
        if BackTrackNow == 1 %this means no backtrack
            Full_NumberOfCharges_InArray(VoltageOrdered_n,:) = NumberOfCharges_InArray;
            Full_Calculated_Theshold_Voltage(VoltageOrdered_n,:) = Calculated_Theshold_Voltage;
            Full_CurrentThroughSystem(VoltageOrdered_n,:) = Current_Through_System;
            Full_NumberOfMoves(VoltageOrdered_n,:) = NumberOfMoves;
            Full_AppliedVoltage(VoltageOrdered_n,:) = Vleft*ones(1,NumberOfRuns_AtEachVoltage);
            Full_AveragedState(VoltageOrdered_n,:,:) = AveragedState;
            Full_ChargesTransfered(VoltageOrdered_n,:) = AverageChargesTransfered;
            BackTrackNow = 0;
        end
        
        %% Checking if backtrack is needed
        if VoltageOrdered_n >= 2
            if BackTrackNow ~= 2 % this means only one backtrack is allowed
                if mean(Full_CurrentThroughSystem(VoltageOrdered_n,:))/mean(Full_CurrentThroughSystem(VoltageOrdered_n-1,:)) >= 1.5
                    %Backtrack = Backtrack + 1;
                    BackTrackNeeded = 1;
                    VoltageOrdered_n_of_Backtrack = VoltageOrdered_n;
                end
                if mean(Full_CurrentThroughSystem(VoltageOrdered_n,:))/mean(Full_CurrentThroughSystem(VoltageOrdered_n-1,:)) <= 0.6
                    %Backtrack = Backtrack + 1;
                    BackTrackNeeded = 1;
                    VoltageOrdered_n_of_Backtrack = VoltageOrdered_n;
                end
            end
        end
        
        
        %% Moving all Elements forward
        if BackTrackNow == 2
            Full_NumberOfCharges_InArray(VoltageOrdered_n_of_Backtrack,:) = NumberOfCharges_InArray;
            Full_Calculated_Theshold_Voltage(VoltageOrdered_n_of_Backtrack,:) = Calculated_Theshold_Voltage;
            Full_CurrentThroughSystem(VoltageOrdered_n_of_Backtrack,:) = Current_Through_System;
            Full_NumberOfMoves(VoltageOrdered_n_of_Backtrack,:) = NumberOfMoves;
            Full_AppliedVoltage(VoltageOrdered_n_of_Backtrack,:) = Vleft*ones(1,NumberOfRuns_AtEachVoltage);
            Full_AveragedState(VoltageOrdered_n_of_Backtrack,:,:) = AveragedState;
            Full_ChargesTransfered(VoltageOrdered_n_of_Backtrack,:) = AverageChargesTransfered;
            BackTrackNow = 0;
        end
        
        if BackTrackNeeded == 1
            BackTrackNeeded = 0;
            BackTrackNow = 2;
            OriginalLength = length(Full_NumberOfCharges_InArray(:,1));
            
            Full_NumberOfCharges_InArray2 = zeros(OriginalLength+1,length(Full_NumberOfCharges_InArray(1,:)));
            Full_NumberOfCharges_InArray2(1:OriginalLength,:) = Full_NumberOfCharges_InArray;
            Full_NumberOfCharges_InArray2(VoltageOrdered_n_of_Backtrack+1:OriginalLength+1,:) = Full_NumberOfCharges_InArray(VoltageOrdered_n_of_Backtrack:OriginalLength,:);
            Full_NumberOfCharges_InArray = Full_NumberOfCharges_InArray2;
            
            Full_Calculated_Theshold_Voltage2 = zeros(OriginalLength+1,length(Full_NumberOfCharges_InArray(1,:)));
            Full_Calculated_Theshold_Voltage2(1:OriginalLength,:) = Full_Calculated_Theshold_Voltage;
            Full_Calculated_Theshold_Voltage2(VoltageOrdered_n_of_Backtrack+1:OriginalLength+1,:) = Full_Calculated_Theshold_Voltage(VoltageOrdered_n_of_Backtrack:OriginalLength,:);
            Full_Calculated_Theshold_Voltage = Full_Calculated_Theshold_Voltage2;
            
            Full_CurrentThroughSystem2 = zeros(OriginalLength+1,length(Full_NumberOfCharges_InArray(1,:)));
            Full_CurrentThroughSystem2(1:OriginalLength,:) = Full_CurrentThroughSystem;
            Full_CurrentThroughSystem2(VoltageOrdered_n_of_Backtrack+1:OriginalLength+1,:) = Full_CurrentThroughSystem(VoltageOrdered_n_of_Backtrack:OriginalLength,:);
            Full_CurrentThroughSystem = Full_CurrentThroughSystem2;
            
            Full_NumberOfMoves2 = zeros(OriginalLength+1,length(Full_NumberOfCharges_InArray(1,:)));
            Full_NumberOfMoves2(1:OriginalLength,:) = Full_NumberOfMoves;
            Full_NumberOfMoves2(VoltageOrdered_n_of_Backtrack+1:OriginalLength+1,:) = Full_NumberOfMoves(VoltageOrdered_n_of_Backtrack:OriginalLength,:);
            Full_NumberOfMoves = Full_NumberOfMoves2;
            
            Full_AppliedVoltage2 = zeros(OriginalLength+1,length(Full_NumberOfCharges_InArray(1,:)));
            Full_AppliedVoltage2(1:OriginalLength,:) = Full_AppliedVoltage;
            Full_AppliedVoltage2(VoltageOrdered_n_of_Backtrack+1:OriginalLength+1,:) = Full_AppliedVoltage(VoltageOrdered_n_of_Backtrack:OriginalLength,:);
            Full_AppliedVoltage = Full_AppliedVoltage2;
            
            Full_ChargesTransfered2 = zeros(OriginalLength+1,length(Full_NumberOfCharges_InArray(1,:)));
            Full_ChargesTransfered2(1:OriginalLength,:) = Full_ChargesTransfered;
            Full_ChargesTransfered2(VoltageOrdered_n_of_Backtrack+1:OriginalLength+1,:) = Full_ChargesTransfered(VoltageOrdered_n_of_Backtrack:OriginalLength,:);
            Full_ChargesTransfered = Full_ChargesTransfered2;
            
            Full_AveragedState2 = zeros(length(Full_AveragedState(:,1,1))+1,length(Full_AveragedState(1,:,1)),length(Full_AveragedState(1,1,:)));
            Full_AveragedState2(1:OriginalLength,:,:) =Full_AveragedState;
            Full_AveragedState2(VoltageOrdered_n_of_Backtrack+1:OriginalLength+1,:,:) = Full_AveragedState(VoltageOrdered_n_of_Backtrack:OriginalLength,:,:);
            Full_AveragedState = Full_AveragedState2;
            
            %Full_Calculated_Theshold_Voltage(n,:) = Calculated_Theshold_Voltage;
            %Full_CurrentThroughSystem(n,:) = Current_Through_System;
            %Full_NumberOfMoves(n,:) = NumberOfMoves;
            %Full_AppliedVoltage(n,:) = Vleft*ones(1,NumberOfRuns_AtEachVoltage);
            %Full_AveragedState(n,:,:) = AveragedState;
            %Full_ChargesTransfered(n,:) = AverageChargesTransfered;
            
            
            
        end
        
        
        
        
        
        
        
        
        if VoltageByVoltageMonitoring_Choices.Plot_FlowChart == 1
            [b] = TwoD_Plot_DoublePlot_AveragedSurface_and_Flowchart(NumberOfVoltageTests,InitialSystem,FirstChargedSystem,AveragedState,NumberOfDots,Ix_front,Ix_back ,Iy_up ,Iy_down,Vleft,C,Cg);
        end
        
        if VoltageByVoltageMonitoring_Choices.Plot_Dynamic_State == 1
            [Dynamic_State_Movie(DynamicStateframe),Time,VoltageVector] = TwoD_Plot_Dynamic_State(VoltageSequence_and_Test_Parameters,VoltageVector,NumberOfVoltageTests,FirstChargedSystem,AveragedState,Time,CurrentTime,NumberOfDots,Ix_front,Ix_back,Iy_up,Iy_down,Vleft,Vg,C,Cg,n,ThresholdVoltage,AverageChargesTransfered,TotalTime,TotalTimeOfRun,az,el,Full_CurrentThroughSystem,CM,TransitionProbabilityVector,NextMoveArray,SizeAndDisorder_parameters,Full_AppliedVoltage,NumberOfMeasurementForBacktrack);
            DynamicStateframe = DynamicStateframe +1;
        end
        
        if TestSummeryPlots_Choice.Plot_InitialFinal_Difference_State == 1
            if n == 1;
                [Initial_or_Final_state] = TwoD_InitialFinal_AverageStatePlot2(NumberOfVoltageTests,InitialSystem,FirstChargedSystem,AveragedState,NumberOfDots,Ix_front,Ix_back,Iy_up,Iy_down,n,Vleft,C,Cg);
                InitialDoublePlot = Initial_or_Final_state;
                savefig(Initial_or_Final_state,'InitialDoublePlot.fig');
                AveragedState_Initial = AveragedState;
                Voltage_Initial = Vleft;
            end
            if n == NumberOfVoltageTests
                [Initial_or_Final_state] = TwoD_InitialFinal_AverageStatePlot2(NumberOfVoltageTests,InitialSystem,FirstChargedSystem,AveragedState,NumberOfDots,Ix_front,Ix_back,Iy_up,Iy_down,n,Vleft,C,Cg);
                savefig(Initial_or_Final_state,'FinalDoublePlot.fig');
                FinalDoublePlot = Initial_or_Final_state;
                AveragedState_Final = AveragedState;
                Voltage_Final = Vleft;
            end
        end
        
        
        
        %% Generating Distribution index
        CurrentOff = Ix_front(NumberOfDots(1),:);
        NormalizedCurrentOff = CurrentOff/sum(CurrentOff);
        if max(CurrentOff) ~= 0
            %        DistributionIndex(n) = ((1/sum(nonzeros(NormalizedCurrentOff).^2)))/NumberOfDots(2);
        end
        if max(CurrentOff) == 0
            %         DistributionIndex(n)
        end
        
        
        n = n+1;
        %Sequence_n = Sequence_n + 1;
    end
end

NumberOfVoltageTests = max(NumberOfVoltageTests,n-1);



Full_CurrentThroughSystem



% Reshaping Data to vectors

Average_Calculated_Theshold_Voltage = mean(Full_Calculated_Theshold_Voltage.');
Average_AppliedVoltage = mean(Full_AppliedVoltage.');
Average_ChargesTransfered = mean(Full_ChargesTransfered.');
AverageTestNumber = 1:1:NumberOfVoltageTests;
Average_Current = mean(Full_CurrentThroughSystem.');
Average_NumberOfCharges = mean(Full_NumberOfCharges_InArray.');

% Calculating Stndard deviation
Current_Standard_Deviation = std(Full_CurrentThroughSystem,0,2);
Charges_Standard_Deviation = std(Full_NumberOfCharges_InArray,0,2);

if NumberOfRuns_AtEachVoltage == 1
    Average_Calculated_Theshold_Voltage = Full_Calculated_Theshold_Voltage.';
    Average_AppliedVoltage = Full_AppliedVoltage.';
    AverageTestNumber = 1:1:NumberOfVoltageTests;
    Average_Current = Full_CurrentThroughSystem.';
    Average_NumberOfCharges = Full_NumberOfCharges_InArray.';
end

%Full_TimeBetween_AddingCharges = reshape(Full_TimeBetween_AddingCharges,1,NumberOfRuns_AtEachVoltage*NumberOfVoltageTests);
%Full_TimeBetween_DischargingCharges = reshape(Full_TimeBetween_DischargingCharges,1,NumberOfRuns_AtEachVoltage*NumberOfVoltageTests);
Full_Calculated_Theshold_Voltage = reshape(Full_Calculated_Theshold_Voltage.',1,NumberOfRuns_AtEachVoltage*NumberOfVoltageTests);
Full_CurrentThroughSystem = reshape(Full_CurrentThroughSystem,1,NumberOfRuns_AtEachVoltage*NumberOfVoltageTests);
Full_NumberOfMoves = reshape(Full_NumberOfMoves,1,NumberOfRuns_AtEachVoltage*NumberOfVoltageTests);
Full_AppliedVoltage = reshape(Full_AppliedVoltage.',1,NumberOfRuns_AtEachVoltage*NumberOfVoltageTests);
Full_NumberOfCharges_InArray = reshape(Full_NumberOfCharges_InArray.',1,NumberOfRuns_AtEachVoltage*NumberOfVoltageTests);

%%%% Plots %%%%



%% current plot
if TestSummeryPlots_Choice.tripleplot == 1
    [triple_plot] = TwoD_TimeTriplePlot_Generator(Average_NumberOfCharges,Average_Current,Average_AppliedVoltage,NumberOfVoltageTests,ThresholdVoltage,Average_Calculated_Theshold_Voltage,FirstChargedSystem,InitialSystem,Time);
end
%% Plot state of system
if TestSummeryPlots_Choice.PlotAverageState ==1
    %   [Average_State] = Plot_AveragedCharge_Surface(NumberOfVoltageTests,InitialSystem,FirstChargedSystem,Full_AveragedState,NumberOfDots);
end
%% Plot_InitialFinal_Difference_State
if TestSummeryPlots_Choice.Plot_InitialFinal_Difference_State == 1
    % [Initial_Final_Difference_state] = TwoD_InitialFinal_DifferenceStatePlot(NumberOfDots,Ix_Initial,Iy_Initial,AveragedState_Initial,Ix_Final,Iy_Final,AveragedState_Final,n,Vleft,C,Cg)
end
%% Plot Distribution Plots
if TestSummeryPlots_Choice.DistributionPlot == 1
    %   [a,b] = Plot_DistributionPlots(Full_TimeBetween_AddingCharges,Full_TimeBetween_DischargingCharges,InitialSystem,NumberOfDots);
end
%% ChargesPlot
if TestSummeryPlots_Choice.ChargesPlot == 1
    %   [Charges_Plot] = TwoD_Charges_Plot_Generator(Average_NumberOfCharges,Average_Current,Average_AppliedVoltage,NumberOfVoltageTests,ThresholdVoltage,Average_Calculated_Theshold_Voltage,FirstChargedSystem,InitialSystem,Time,Average_ChargesTransfered, Charges_Standard_Deviation,Full_AveragedState,NumberOfDots);
end
%% CurrentPlot
if TestSummeryPlots_Choice.CurrentPlot == 1
    % [Current_Plot] = OneD_Triple_Current_Plot_Generator(Average_NumberOfCharges,Average_Current,Average_AppliedVoltage,NumberOfVoltageTests,ThresholdVoltage,Average_Calculated_Theshold_Voltage,FirstChargedSystem,InitialSystem,Time,Average_ChargesTransfered,  Current_Standard_Deviation);
end
%% Single Plot With Phase Chart
if TestSummeryPlots_Choice.I_V_Single_Plot == 1
    %   [I_V_Single_Plot] = OneD_Linear_I_V_Single_Plot(Average_Current,Average_AppliedVoltage,C,Cg,NumberOfDots,DistributionIndex,ThresholdVoltage)
end
%% ExtraChargesPerDot_Plot
if TestSummeryPlots_Choice.ExtraChargesPerDot_Plot == 1
    %  [f] = TwoD_ExtraChargesPerDot_Plot(Average_AppliedVoltage,C,Cg,FirstChargedSystem,Full_AveragedState,NumberOfDots);
end
%% Regular Conductance Plot
if TestSummeryPlots_Choice.Conductance_Plot == 1
    %  [ConductancePlot] = TwoD_Conductance_Plot(Average_Current,Average_AppliedVoltage,C,Cg,NumberOfDots,DistributionIndex,ThresholdVoltage);
end
%% Conductance Noise Plot
if TestSummeryPlots_Choice.Conductance_Noise_Plot == 1
    %  [ConductanceNoisePlot] = TwoD_Conductance_Noise_Plot(Average_Current,Average_AppliedVoltage,C,Cg,NumberOfDots,DistributionIndex,ThresholdVoltage)
end

PlotGateCharge = 1;
if PlotGateCharge == 1
    figure;
    x1 = 1:round(NumberOfVoltageTests/2);
    x2 = round(NumberOfVoltageTests/2):NumberOfVoltageTests;
    Average_AppliedVoltage;
    plot(Average_AppliedVoltage(x1),GateCharge(x1),'-bs',Average_AppliedVoltage(x2),GateCharge(x2),'-gs')
 %   title({'Charge in Gate as a function of the voltage' ,'Blue-going up, and Green-going down' 'Relaxation Time = '})
    title(sprintf('Charge in Gate as a function of the voltage:  Blue-going up, and Green-going down \n Vg = %g, Relaxation Time = %d',Vg,Rg))

    xlabel('Voltage (1/Cg)')
    ylabel('Charge in Gate (NU)')
end

PlotCurrentPlot_2 = 1;
if PlotCurrentPlot_2 == 1
    figure;
    x1 = 1:round(NumberOfVoltageTests/2);
    x2 = round(NumberOfVoltageTests/2):NumberOfVoltageTests;
    Average_AppliedVoltage;
    plot(Average_AppliedVoltage(x1),Average_Current(x1),'-bs',Average_AppliedVoltage(x2),Average_Current(x2),'-gs')
   % title({'Current as a function of the voltage' ,'Blue-going up, and Green-going down'})
    title(sprintf('Current as a function of the voltage:  Blue-going up, and Green-going down \n Vg = %g, Relaxation Time = %d',Vg,Rg))

    xlabel('Voltage (1/Cg)')
    ylabel('Current (Energy)')
end

%% Time Plot
%%[logTime] = OneD_Time_Graph(RelativeChangeOf_Voltage_FromVt,C,Cg,NumberOfDots,InternalMoves_Time,Charging_Time,CombinedTime)

%%[Lineatime] = OneD_Liner_Time_Graph(RelativeChangeOf_Voltage_FromVt,C,Cg,NumberOfDots,InternalMoves_Time,Charging_Time,CombinedTime)

%%Threshold Voltage Tests on System
%[Alpha_Graph,Vt_Graph] = TwoD_ThresholdVoltageTests(InitialSystem,NumberOfDots);


SizeAndDisorder_parameters

% Options for saving
SavingVeriablesOption = 0;
if SavingVeriablesOption == 1
    choice1 = menu(sprintf('Do you want to save the Variables?'),'Yes', 'No');
    if choice1 ==1
        save('aaa_system1.mat','InitialSystem','Average_Calculated_Theshold_Voltage','Average_AppliedVoltage','Average_ChargesTransfered','Average_Current','Average_NumberOfCharges','C','Cg','NumberOfDots');
        % save('Bad_Ten_DotSystem2.mat','BadSystems');
        
        
    end
    choice2 = menu(sprintf('Do you want to save the graphs?'),'Yes', 'No');
    if choice2 == 1
        %savefig(h,'aaa_CurentGraph.fig');
        savefig(triple_plot,'aaa_TriplePlot.fig');
        savefig(Charges_Plot,'aaa_ChargeGraph.fig');
        savefig(Current_Plot,'aaa_CurrentGraph.fig');
        savefig(Average_State,'aaa_AverageState.fig');
        
    end
    choice3= menu(sprintf('Close graphs?'),'Yes', 'No');
    if choice3 == 1
        %close(h);
        close(triple_plot);
        close(Charges_Plot);
        close(Average_State);
    end
    
end