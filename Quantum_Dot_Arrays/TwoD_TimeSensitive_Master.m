C = 1;
Cg = 3;
NumberOfDots = 6;
InitialSystem = rand(NumberOfDots,NumberOfDots);
%InitialSystem(3,3) = InitialSystem(3,3) - 1;



%[Alpha_Graph,Vt_Graph] = TwoD_ThresholdVoltageTests(InitialSystem,NumberOfDots);
%[InitialFreeEnergy_Graph,FinalFreeEnergy_Graph] = TwoD_FreeEnergy_Tests(InitialSystem,NumberOfDots)



%ArraySelection = 1;
%IndexOfBadArray = 1;
%IndexOfGoodArray = 1;

            
TotalTimeOfRun = 10^5;
NumberOfVoltageTests = 3;
NumberOfRuns_AtEachVoltage = 2;
TotalTimeAtEachVoltage = TotalTimeOfRun/NumberOfVoltageTests;
TimeOfEachRun = TotalTimeAtEachVoltage/NumberOfRuns_AtEachVoltage;
Time = 0:TotalTimeOfRun/NumberOfVoltageTests:TotalTimeOfRun - TotalTimeOfRun/NumberOfVoltageTests;
Random_Number_Seed = rand(10000,1);
Random_Number_Index = 1;
%NumberOfCycles_InTotalRun = 5;
%NumberOfPoints_perCycle = 10;
%AC_Amplitude = 0.2;
%NumberOfRuns_AtEachVoltage = 20;

PlotSystem = 1; StartingVoltageTest_forPlotSystem = 1; EndingVoltageTest_forPlotSystem = 11;
PlotCharging =1;
Plot_EnergyLanscape_plot = 0;
Plot_Dynamic_State = 0; az = 310; el =30;
Plot_FlowChart = 0;
Plot_Flow_NonAverage_Chart = 0;
DistributionPlot = 0;
PlotAverages = 0 ;
PlotNonAverages = 0;
tripleplot = 1;
PlotAverageState =0;
ChargesPlot = 1;
CurrentPlot = 0;
StateEvolution_Plots =0;
AvalancheEventRecorder =0;
Double_AverageSateplot = 0;
ExtraChargesPerDot_Plot = 0;
Plot_InitialFinal_Difference_State = 0;

PlotSystem1 = PlotSystem;
SavingVeriablesOption =0;
EnergyFrameNumber = 1;
EnergyLanscape_plot = getframe(gcf);

%% Selecting Capacitance Matrix
Regular_Round_Matrix = 1;
Eliptical1_Long_in_X_Direction_Matrix = 0;
Eliptical1_Long_in_Y_Direction_Matrix = 0;
Oscliating_Rows_Only = 0;
Oscilating_Lines_and_Rows = 0;
SideWays_Matrix = 0;



% Voltage Changing Sequences
LogarithmicRaising__VoltageSequence = 0;    StartingPowerOfTen = -3;
LinearRaising_VoltageSequence = 0;  VoltageRasingAmount = 0.02; BeginingVoltage = 1.02; %VoltageRasingAmount = 0.02;
LinearRaising_and_Lowering_VoltageSequence = 1; 
AC_VoltageSequence = 0;     Number_Of_Cycles = 6;
ConstantVoltage_VoltageSequence = 0;   % ConstantVoltage = 1.2*ThresholdVoltage;
AC_Triangle_VoltageSequence = 0;% NumberOfCycles = NumberOfVoltageTests/CycleLength;
Real_AC_VoltageSequence =0;
StepFunction_Sequence = 0;  StepSize = 3;


if Real_AC_VoltageSequence == 1
    NumberOfCycles_InTotalRun = 5;
    NumberOfPoints_perCycle = 10;
    AC_Amplitude = 0.5;
    NumberOfRuns_AtEachVoltage = 20;
    TotalTimeAtEachVoltage = TotalTimeOfRun/(NumberOfCycles_InTotalRun*NumberOfPoints_perCycle);
    TimeOfEachRun = TotalTimeAtEachVoltage/NumberOfRuns_AtEachVoltage;
    TimeOfCycle = TotalTimeOfRun/NumberOfCycles_InTotalRun;
    VoltageFrequency = 2*pi/TimeOfCycle;
    t = -pi:2*pi/NumberOfPoints_perCycle:pi + 2*pi*(NumberOfCycles_InTotalRun-1);
    NumberOfVoltageTests = max(size(t));
    Time = 0:TotalTimeOfRun/NumberOfVoltageTests:TotalTimeOfRun - TotalTimeOfRun/NumberOfVoltageTests;
end
%NumberOfRuns_AtEachVoltage = TotalTimeAtEachVoltage/TimeOfEachRun;






VoltageOnSystem = zeros(NumberOfVoltageTests,1);
CurrentThroughSystem = zeros(NumberOfVoltageTests,1);
NumberOfMoves = zeros(NumberOfVoltageTests,1);
RelativeChangeOf_Voltage_FromVt = zeros(NumberOfVoltageTests,1);
TimeBetweenAddingChargesTime = zeros(NumberOfVoltageTests,1);
Calculated_Theshold_Voltage = zeros(NumberOfVoltageTests,1);
%Time = zeros(NumberOfVoltageTests,1);

%Flow Parameters
[x,y] = meshgrid(1:1:NumberOfDots,1:1:NumberOfDots);
%Ix = zeros(NumberOfDots,NumberOfDots);
%Iy = zeros(NumberOfDots,NumberOfDots);
Ix_front = zeros(NumberOfDots,NumberOfDots);
Ix_back = zeros(NumberOfDots,NumberOfDots);
Iy_up = zeros(NumberOfDots,NumberOfDots);
Iy_down = zeros(NumberOfDots,NumberOfDots);


    Full_TimeBetween_AddingCharges = zeros(NumberOfVoltageTests,NumberOfRuns_AtEachVoltage);
    Full_TimeBetween_DischargingCharges = zeros(NumberOfVoltageTests,NumberOfRuns_AtEachVoltage);
    Full_Calculated_Theshold_Voltage = zeros(NumberOfVoltageTests,NumberOfRuns_AtEachVoltage);
    Full_CurrentThroughSystem = zeros(NumberOfVoltageTests,NumberOfRuns_AtEachVoltage);
    Full_NumberOfMoves = zeros(NumberOfVoltageTests,NumberOfRuns_AtEachVoltage);
    Full_AppliedVoltage = zeros(NumberOfVoltageTests,NumberOfRuns_AtEachVoltage);
    Full_NumberOfCharges_InArray = zeros(NumberOfVoltageTests,NumberOfRuns_AtEachVoltage);
    Full_AveragedState = zeros(NumberOfVoltageTests,NumberOfDots,NumberOfDots);
    Full_ChargesTransfered = zeros(NumberOfVoltageTests,NumberOfRuns_AtEachVoltage);
    
    Last20moves = zeros(NumberOfDots,NumberOfDots,20);
    OrderedLast20moves = zeros(NumberOfDots,NumberOfDots,20);
    LastMoveRecorderCount = 0;
    NumberOfEvent = 1;
    NumberOfVoltageTestsOfEvent = 0;
    
    
    
    
    
%% InitialSystemStester
%[TotalChargeinDisorder,LastDotOfResistance,Relative_Extra_DownSteps,Relative_SumOf_Extra_DownSteps,AverageLengthSlope_Of_DownwardsSlope] = OneD_InitialConditionTester(InitialSystem)

% GoodBadSystem analysis
%[a]  = OneD_GoodBad_Systems_InitialConditions_Plots(GoodSystems,BadSystems)
%[b]  = OneD_GoodBad_Systems_ChargedConfiguration_Plots(GoodSystems,BadSystems,C,Cg,NumberOfDots)


%% Recording Loop
%p = 1;
%Max = 0;
%for n = 1:10
  %  C = C*(sqrt(10));
 %   Cg = Cg/(sqrt(10));  
%[Vleft,Q,TotalTime,f,p] = Create_Charged_OneD_System(C,Cg,NumberOfDots,InitialSystem,PlotSystem);
    %for l = 1:max(size(f))
   %    M(Max+l) = f(l)
  %  end
 %   Max = max(size(M))
%end



% Ploting Charging
if PlotCharging ==1
    PlotSystem = 1;
end
if PlotCharging ==0
    PlotSystem = 0;
end


%[invCM,CM] = TwoDim_invCM_Generator(C,Cg,NumberOfDots);

[invCM,CM] = TwoD_Create_Selected_invCM(C,Cg,NumberOfDots,Regular_Round_Matrix,Eliptical1_Long_in_X_Direction_Matrix,Eliptical1_Long_in_Y_Direction_Matrix,Oscilating_Lines_and_Rows,Oscliating_Rows_Only,SideWays_Matrix);

[NextMoveArray,IndexOfRemovedCharge] = TwoD_NextMoveArray_Generator(NumberOfDots);

%% Create Charged System With Pics
[Vleft,Q,TotalTime,f,framenumber] = TwoD_New_Create_Charged_System(C,Cg,NumberOfDots,InitialSystem,NextMoveArray,IndexOfRemovedCharge,invCM,PlotSystem);

ThresholdVoltage = Vleft
FirstChargedSystem = Q;
ChargingTime = TotalTime;
VoltageVector = ones(NumberOfVoltageTests,1)*BeginingVoltage;
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

if Real_AC_VoltageSequence == 1
% Generating AC Voltage Sequence
AC_Amplitude = AC_Amplitude*ThresholdVoltage;
AC_LowestVoltage = ThresholdVoltage;
AC_BaseVoltage = ThresholdVoltage + AC_Amplitude;
AC_Voltage_Sequence = ThresholdVoltage + 2*AC_Amplitude - AC_Amplitude*cos(Time*VoltageFrequency);
end

for n = 1:NumberOfVoltageTests
    %VoltageOnSystem(n) = Vleft*Cg/NumberOfDots;
    
    % Logarithmic Raising Voltage Change %
    if LogarithmicRaising__VoltageSequence == 1
        Vleft = ThresholdVoltage + (sqrt(10)^(n+StartingPowerOfTen*2-1))*ThresholdVoltage;
    end
        
    % Linear Raising Voltage Change %
    if LinearRaising_VoltageSequence == 1
        Vleft = BeginingVoltage*ThresholdVoltage + VoltageRasingAmount*n*ThresholdVoltage;
    end
    
    % Linear Raising+Lowering Voltage Change
    if LinearRaising_and_Lowering_VoltageSequence ==1
        [Vleft] = OneD_Linear_RaisingaLowering_Of_Voltage(NumberOfVoltageTests,n,Vleft,ThresholdVoltage,VoltageRasingAmount);
    end
    
    % Constant Voltage 
    if ConstantVoltage_VoltageSequence == 1
        Vleft = ConstantVoltage;
    end
    
    % AC Triangle Voltage Change
    if AC_Triangle_VoltageSequence ==1
        [Vleft] = OneD_AC_Triangle_VoltageChange(NumberOfVoltageTests,n,Vleft,ThresholdVoltage,VoltageRasingAmount,NumberOfCycles);
   end


    % Real AC Voltage
    if Real_AC_VoltageSequence ==1
        Vleft = AC_Voltage_Sequence(n);
    end
    
    % StepFunction Voltage
    if StepFunction_Sequence ==1
        if n >= 2
            Vleft = ThresholdVoltage + StepSize*ThresholdVoltage;
            if n >= 3
                Vleft = ThresholdVoltage + 0.005*ThresholdVoltage;
            end
        end

    end
    
    %% Ploting System
    if PlotSystem == 1
        PlotSystem1 = 0;
        if n>= StartingVoltageTest_forPlotSystem
            PlotSystem1 = 1;
                if n >= EndingVoltageTest_forPlotSystem
                    PlotSystem1 = 0;
                end
        end
    end
        
        %testnumber = n
    % Calculating Relative Change from Voltage %
        %% RelativeChangeOf_Voltage_FromVt(n) = (Vleft - ThresholdVoltage)/ThresholdVoltage;
    
        

    %% Run On Constant Current Mode %%

    %[TimeBetween_AddingChargesTime,Calculated_Theshold_Voltage,NumberOfMoves,TimeBetween_DischargingCharges,CurrentThroughSystem,Q_Final,NumberOfCharges_InArray,AveragedState,Last20moves,LastMoveRecorderCount,AvalancheEvent] = OneD_Multiple_Runs_AtCurentVoltage(Q,invCM,C,NumberOfRuns_AtEachVoltage,Cg,NumberOfDots,Vleft,ThresholdVoltage,PlotSystem,InitialSystem,Last20moves,LastMoveRecorderCount);
    [EnergyLanscape_plot,EnergyFrameNumber,AverageChargesTransfered,TotalTime,Current_Through_System,Calculated_Theshold_Voltage,NumberOfMoves,TimeBetween_DischargingCharges,CurrentThroughSystem,Q_Final,NumberOfCharges_InArray,AveragedState,Last20moves,LastMoveRecorderCount,f,Random_Number_Seed,Random_Number_Index,framenumber,Ix_front,Ix_back ,Iy_up ,Iy_down,NumberOfClogging_Events] = TwoD_Constant_CurrentMode(Q,C,NumberOfRuns_AtEachVoltage,Cg,NumberOfDots,Vleft,ThresholdVoltage,PlotSystem,InitialSystem,Last20moves,LastMoveRecorderCount,TotalTimeAtEachVoltage,TimeOfEachRun,TotalTime,Random_Number_Seed,Random_Number_Index,NextMoveArray,IndexOfRemovedCharge,invCM,f,framenumber,Ix_front,Ix_back ,Iy_up ,Iy_down,Plot_Flow_NonAverage_Chart,NumberOfVoltageTests,FirstChargedSystem,Plot_EnergyLanscape_plot,EnergyFrameNumber,EnergyLanscape_plot);
     Time(n) = TotalTime;
    Q = Q_Final;
  
    CurrentTime = TotalTime
    
%% Recording Loop
   % for l = 1:max(size(f))
     %  M(Max+l) = f(l);
    %end
   % Max = max(size(M))
    
    %% Gathering Data From Runs at curent voltage %%
    Full_NumberOfCharges_InArray(n,:) = NumberOfCharges_InArray;
    Full_Calculated_Theshold_Voltage(n,:) = Calculated_Theshold_Voltage;
    Full_CurrentThroughSystem(n,:) = Current_Through_System;
    Full_NumberOfMoves(n,:) = NumberOfMoves;
    Full_AppliedVoltage(n,:) = Vleft*ones(1,NumberOfRuns_AtEachVoltage);
    Full_AveragedState(n,:,:) = AveragedState;
    Full_ChargesTransfered(n,:) = AverageChargesTransfered;
    
    
    

    
    
    if Plot_FlowChart == 1
        [b] = TwoD_Plot_DoublePlot_AveragedSurface_and_Flowchart(NumberOfVoltageTests,InitialSystem,FirstChargedSystem,AveragedState,NumberOfDots,Ix_front,Ix_back ,Iy_up ,Iy_down,Vleft,C,Cg);
    end
    
    if Plot_Dynamic_State == 1
        [e,Time,VoltageVector] = TwoD_Plot_Dynamic_State(VoltageVector,NumberOfVoltageTests,FirstChargedSystem,AveragedState,Time,CurrentTime,NumberOfDots,Ix_front,Ix_back,Iy_up,Iy_down,Vleft,C,Cg,n,ThresholdVoltage,LinearRaising_VoltageSequence,LinearRaising_and_Lowering_VoltageSequence,VoltageRasingAmount,BeginingVoltage,AverageChargesTransfered,TotalTime,TotalTimeOfRun,az,el,Full_CurrentThroughSystem);
    end
    
    if n == 1;
        if Plot_InitialFinal_Difference_State == 1
            [Initial_or_Final_state] = TwoD_InitialFinal_AverageStatePlot2(NumberOfVoltageTests,InitialSystem,FirstChargedSystem,AveragedState,NumberOfDots,Ix_front,Ix_back,Iy_up,Iy_down,n,Vleft,C,Cg);
            
            % [Initial_or_Final_state] = TwoD_InitialFinal_AverageStatePlot(NumberOfVoltageTests,InitialSystem,FirstChargedSystem,AveragedState,NumberOfDots,Ix_front,Ix_back ,Iy_up ,Iy_down,n,Vleft,C,Cg);
            savefig(Initial_or_Final_state,'InitialDoublePlot.fig');
            AveragedState_Initial = AveragedState;
            Voltage_Initial = Vleft;
        end
    end
    if n == NumberOfVoltageTests
        if Plot_InitialFinal_Difference_State == 1
            [Initial_or_Final_state] = TwoD_InitialFinal_AverageStatePlot2(NumberOfVoltageTests,InitialSystem,FirstChargedSystem,AveragedState,NumberOfDots,Ix_front,Ix_back,Iy_up,Iy_down,n,Vleft,C,Cg);
            
            %[Initial_or_Final_state] = TwoD_InitialFinal_AverageStatePlot(NumberOfVoltageTests,InitialSystem,FirstChargedSystem,AveragedState,NumberOfDots,Ix_front,Ix_back ,Iy_up ,Iy_down,n,Vleft,C,Cg);
            savefig(Initial_or_Final_state,'FinalDoublePlot.fig');
            AveragedState_Final = AveragedState;
            Voltage_Final = Vleft;
        end
    end
end





 Full_CurrentThroughSystem

v = VideoWriter('Step Function Energy Plot.avi','Uncompressed AVI');
open(v)
writeVideo(v,EnergyLanscape_plot)
close(v)

EnergyLanscape_Plot
 
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

Full_TimeBetween_AddingCharges = reshape(Full_TimeBetween_AddingCharges,1,NumberOfRuns_AtEachVoltage*NumberOfVoltageTests);
Full_TimeBetween_DischargingCharges = reshape(Full_TimeBetween_DischargingCharges,1,NumberOfRuns_AtEachVoltage*NumberOfVoltageTests);    
Full_Calculated_Theshold_Voltage = reshape(Full_Calculated_Theshold_Voltage.',1,NumberOfRuns_AtEachVoltage*NumberOfVoltageTests);    
Full_CurrentThroughSystem = reshape(Full_CurrentThroughSystem,1,NumberOfRuns_AtEachVoltage*NumberOfVoltageTests);    
Full_NumberOfMoves = reshape(Full_NumberOfMoves,1,NumberOfRuns_AtEachVoltage*NumberOfVoltageTests);    
Full_AppliedVoltage = reshape(Full_AppliedVoltage.',1,NumberOfRuns_AtEachVoltage*NumberOfVoltageTests);    
Full_NumberOfCharges_InArray = reshape(Full_NumberOfCharges_InArray.',1,NumberOfRuns_AtEachVoltage*NumberOfVoltageTests);

%%%% Plots %%%%

    % current plot
    if tripleplot == 1
        [triple_plot] = TwoD_TimeTriplePlot_Generator(Average_NumberOfCharges,Average_Current,Average_AppliedVoltage,NumberOfVoltageTests,ThresholdVoltage,Average_Calculated_Theshold_Voltage,FirstChargedSystem,InitialSystem,Time);
    end
    
    % Plot state of system
    if PlotAverageState ==1
        [Average_State] = Plot_AveragedCharge_Surface(NumberOfVoltageTests,InitialSystem,FirstChargedSystem,Full_AveragedState,NumberOfDots);
    end
    
    if Plot_InitialFinal_Difference_State == 1
       % [Initial_Final_Difference_state] = TwoD_InitialFinal_DifferenceStatePlot(NumberOfDots,Ix_Initial,Iy_Initial,AveragedState_Initial,Ix_Final,Iy_Final,AveragedState_Final,n,Vleft,C,Cg)
    end
    %% Plot Distribution Plots
if DistributionPlot == 1
[a,b] = Plot_DistributionPlots(Full_TimeBetween_AddingCharges,Full_TimeBetween_DischargingCharges,InitialSystem,NumberOfDots);
end

if ChargesPlot == 1
    [Charges_Plot] = TwoD_Charges_Plot_Generator(Average_NumberOfCharges,Average_Current,Average_AppliedVoltage,NumberOfVoltageTests,ThresholdVoltage,Average_Calculated_Theshold_Voltage,FirstChargedSystem,InitialSystem,Time,Average_ChargesTransfered, Charges_Standard_Deviation,Full_AveragedState,NumberOfDots);

   % [Charges_Plot] = OneD_Triple_Charges_Plot_Generator(Average_NumberOfCharges,Average_Current,Average_AppliedVoltage,NumberOfVoltageTests,ThresholdVoltage,Average_Calculated_Theshold_Voltage,FirstChargedSystem,InitialSystem,Time,Average_ChargesTransfered, Charges_Standard_Deviation);
end

if CurrentPlot == 1
    [Current_Plot] = OneD_Triple_Current_Plot_Generator(Average_NumberOfCharges,Average_Current,Average_AppliedVoltage,NumberOfVoltageTests,ThresholdVoltage,Average_Calculated_Theshold_Voltage,FirstChargedSystem,InitialSystem,Time,Average_ChargesTransfered,  Current_Standard_Deviation);
end

if StateEvolution_Plots ==1
    [a,b] = OneD_StateEvolutionPlotter(NumberOfVoltageTests,Full_AveragedState);
end
%% Linear Double Plot With Phase Chart - Note the "Full_AppliedVoltage" Slot, Should be RelativeChangeOf_Voltage_FromVt
%[g] = OneD_Linear_I_V_Plot_WithPhasePlot(Full_CurrentThroughSystem,Full_AppliedVoltage,Full_NumberOfMoves,C,Cg,NumberOfDots);

%% Linear Double Plot With Phase Chart
%%[h] = OneD_Logarithmic_I_V_Plot_WithPhasePlot(CurrentThroughSystem,RelativeChangeOf_Voltage_FromVt,NumberOfMoves,C,Cg,NumberOfDots);

%% Single Plot With Phase Chart
[f] = OneD_Linear_I_V_Single_Plot(Average_Current,Average_AppliedVoltage,C,Cg,NumberOfDots)

if ExtraChargesPerDot_Plot == 1
[f] = TwoD_ExtraChargesPerDot_Plot(Average_AppliedVoltage,C,Cg,FirstChargedSystem,Full_AveragedState,NumberOfDots);
end



%% Time Plot
%%[logTime] = OneD_Time_Graph(RelativeChangeOf_Voltage_FromVt,C,Cg,NumberOfDots,InternalMoves_Time,Charging_Time,CombinedTime)

%%[Lineatime] = OneD_Liner_Time_Graph(RelativeChangeOf_Voltage_FromVt,C,Cg,NumberOfDots,InternalMoves_Time,Charging_Time,CombinedTime)



%% Linear Double Plot With Phase Chart
%%[h] = OneD_Logarithmic_I_V_Plot_WithPhasePlot(CurrentThroughSystem,RelativeChangeOf_Voltage_FromVt,NumberOfMoves,C,Cg,NumberOfDots);


 %%Threshold Voltage Tests on System
%[Alpha_Graph,Vt_Graph] = TwoD_ThresholdVoltageTests(InitialSystem,NumberOfDots);




% Options for saving
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