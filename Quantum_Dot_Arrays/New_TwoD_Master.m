C = 1;
Cg = 100000;
NumberOfDots = 5;
InitialSystem = rand(NumberOfDots,NumberOfDots);
NumberOfVoltageTests = 60;
NumberOfRuns_AtEachVoltage = 1;
VoltageRasingAmount = 0.01;
CycleLength = 10;
PlotSystem = 0;
DistributionPlot = 0;
PlotAverages = 0 ;
PlotNonAverages = 0;
tripleplot = 1;
PlotAverageState =0;


% Voltage Changing Sequences
LogarithmicRaising__VoltageSequence = 0;    StartingPowerOfTen = -3;
LinearRaising_VoltageSequence = 0; 
LinearRaising_and_Lowering_VoltageSequence = 0; 
AC_VoltageSequence = 0;     Number_Of_Cycles = 6;
ConstantVoltage_VoltageSequence = 0;    %ConstantVoltage = 1.2*ThresholdVoltage;
AC_Triangle_VoltageSequence = 1; NumberOfCycles = NumberOfVoltageTests/CycleLength;

VoltageOnSystem = zeros(NumberOfVoltageTests,1);
CurrentThroughSystem = zeros(NumberOfVoltageTests,1);
NumberOfMoves = zeros(NumberOfVoltageTests,1);
RelativeChangeOf_Voltage_FromVt = zeros(NumberOfVoltageTests,1);
TimeBetweenAddingChargesTime = zeros(NumberOfVoltageTests,1);
Calculated_Theshold_Voltage = zeros(NumberOfVoltageTests,1);

    Full_TimeBetween_AddingCharges = zeros(NumberOfVoltageTests,NumberOfRuns_AtEachVoltage);
    Full_TimeBetween_DischargingCharges = zeros(NumberOfVoltageTests,NumberOfRuns_AtEachVoltage);
    Full_Calculated_Theshold_Voltage = zeros(NumberOfVoltageTests,NumberOfRuns_AtEachVoltage);
    Full_CurrentThroughSystem = zeros(NumberOfVoltageTests,NumberOfRuns_AtEachVoltage);
    Full_NumberOfMoves = zeros(NumberOfVoltageTests,NumberOfRuns_AtEachVoltage);
    Full_AppliedVoltage = zeros(NumberOfVoltageTests,NumberOfRuns_AtEachVoltage);
    Full_NumberOfCharges_InArray = zeros(NumberOfVoltageTests,NumberOfRuns_AtEachVoltage);
    Full_AveragedState = zeros(NumberOfVoltageTests,NumberOfDots);

    
    Last20moves = zeros(NumberOfDots,20);
    OrderedLast20moves = zeros(NumberOfDots,20);
    LastMoveRecorderCount = 0;
    NumberOfEvent = 1;
    NumberOfVoltageTestsOfEvent = 0;
%% Generating Flat Initial System 
%%InitialSystem = 0.2*ones(NumberOfDots,1);

[invCM,CM] = TwoDim_invCM_Generator(C,Cg,NumberOfDots);
[NextMoveArray,IndexOfRemovedCharge] = TwoD_NextMoveArray_Generator(NumberOfDots);

%% Create Charged System With Pics
[Vleft,Q,TotalTime,f] = TwoD_New_Create_Charged_System(C,Cg,NumberOfDots,InitialSystem,NextMoveArray,IndexOfRemovedCharge,invCM);

%[Vleft,Q,TotalTime,f] = Create_Charged_OneD_System(C,Cg,NumberOfDots,InitialSystem,PlotSystem);
ThresholdVoltage = Vleft
FirstChargedSystem = Q;
%Sum(FirstChargedSystem-InitialSystem)
%Vleft = ThresholdVoltage + 0.4*ThresholdVoltage

%[DistributionTest,VoltageTest,TimeBetweenAddingChargesTime,Calculated_Theshold_Voltage] = OneD_DistributionTest_AtCurentVoltage(Q,invCM,C,NumberOfVoltageTests,Cg,NumberOfDots,Vleft,ThresholdVoltage);


for n = 1:NumberOfVoltageTests
    %VoltageOnSystem(n) = Vleft*Cg/NumberOfDots;
    
    % Logarithmic Raising Voltage Change %
    if LogarithmicRaising__VoltageSequence == 1
        Vleft = ThresholdVoltage + (sqrt(10)^(n+StartingPowerOfTen*2-1))*ThresholdVoltage
    end
        
    % Linear Raising Voltage Change %
    if LinearRaising_VoltageSequence == 1
        Vleft = ThresholdVoltage + VoltageRasingAmount*n*ThresholdVoltage
    end
    
    % Linear Raising+Lowering Voltage Change
    if LinearRaising_and_Lowering_VoltageSequence ==1
        [Vleft] = OneD_Linear_RaisingaLowering_Of_Voltage(NumberOfVoltageTests,n,Vleft,ThresholdVoltage,VoltageRasingAmount)
    end
    
    % Constant Voltage 
    if ConstantVoltage_VoltageSequence == 1
        Vleft = ConstantVoltage
    end
    
    % AC Triangle Voltage Change
    if AC_Triangle_VoltageSequence ==1
        [Vleft] = OneD_AC_Triangle_VoltageChange(NumberOfVoltageTests,n,Vleft,ThresholdVoltage,VoltageRasingAmount,NumberOfCycles)
   end
        testnumber = n
    % Calculating Relative Change from Voltage %
        %% RelativeChangeOf_Voltage_FromVt(n) = (Vleft - ThresholdVoltage)/ThresholdVoltage;
    
        

    %% Multiple Runs of system at current voltage %%

    [TimeBetween_AddingChargesTime,Calculated_Theshold_Voltage,NumberOfMoves,TimeBetween_DischargingCharges,CurrentThroughSystem,Q_Final,NumberOfCharges_InArray,AveragedState,Last20moves,LastMoveRecorderCount,AvalancheEvent] = OneD_Multiple_Runs_AtCurentVoltage(Q,invCM,C,NumberOfRuns_AtEachVoltage,Cg,NumberOfDots,Vleft,ThresholdVoltage,PlotSystem,InitialSystem,Last20moves,LastMoveRecorderCount);
    Q = Q_Final;
 
    
    %

    %% Gathering Data From Runs at curent voltage %%
    Full_NumberOfCharges_InArray(n,:) = NumberOfCharges_InArray;
    Full_TimeBetween_AddingCharges(n,:) = TimeBetween_AddingChargesTime;
    Full_TimeBetween_DischargingCharges(n,:) = TimeBetween_DischargingCharges;
    Full_Calculated_Theshold_Voltage(n,:) = Calculated_Theshold_Voltage;
    Full_CurrentThroughSystem(n,:) = CurrentThroughSystem;
    Full_NumberOfMoves(n,:) = NumberOfMoves;
    Full_AppliedVoltage(n,:) = Vleft*ones(1,NumberOfRuns_AtEachVoltage);
    Full_AveragedState(n,:) = AveragedState;
end

% Reshaping Data to vectors

Average_Calculated_Theshold_Voltage = mean(Full_Calculated_Theshold_Voltage.');
Average_AppliedVoltage = mean(Full_AppliedVoltage.');
AverageTestNumber = 1:1:NumberOfVoltageTests;
Average_Current = mean(Full_CurrentThroughSystem.');
Average_NumberOfCharges = mean(Full_NumberOfCharges_InArray.');

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

if LinearRaising_and_Lowering_VoltageSequence ==1
    if PlotNonAverages == 1
    CurrentWhileRaisingVoltage = Full_CurrentThroughSystem(1:max(size(Full_Calculated_Theshold_Voltage))/2);
    CurrentWhileLoweringVoltage = fliplr(Full_CurrentThroughSystem(max(size(Full_Calculated_Theshold_Voltage))/2+1:max(size(Full_Calculated_Theshold_Voltage))));
    AppliedVoltage = Full_AppliedVoltage(1:NumberOfRuns_AtEachVoltage*NumberOfVoltageTests/2)/ThresholdVoltage;
    AppliedVoltage2 = fliplr(Full_AppliedVoltage(NumberOfRuns_AtEachVoltage*NumberOfVoltageTests/2+1:NumberOfRuns_AtEachVoltage*NumberOfVoltageTests))/ThresholdVoltage;
    plot(AppliedVoltage, CurrentWhileRaisingVoltage,'-sb',AppliedVoltage2,CurrentWhileLoweringVoltage,'-sr');
    title('Current While Raising Voltage - Blue, While Lowering - Red, as a function of Applied Voltage');
    xlabel('V/VT relative Applied oltage');
    ylabel('Current');
    end
    
    if PlotAverages == 1
    figure
    Average_AppliedVoltage2 = Average_AppliedVoltage(1:NumberOfVoltageTests/2);
    Average_AppliedVoltage3 =  fliplr(Average_AppliedVoltage(NumberOfVoltageTests/2+1:NumberOfVoltageTests));
  Average_Current_WhileRaisingVoltage = Average_Current(1:NumberOfVoltageTests/2);
  Average_Current_WhileLoweringVoltage = fliplr(Average_Current(NumberOfVoltageTests/2+1:NumberOfVoltageTests));
      plot(Average_AppliedVoltage2,  Average_Current_WhileRaisingVoltage,'-sb',Average_AppliedVoltage3,Average_Current_WhileLoweringVoltage,'-sr');
    title('Avergage Current While Raising Voltage - Blue, While Lowering - Red, as a function of Applied Voltage');
    xlabel('V/VT relative Applied Voltage');
    ylabel('Current');
    end
    
    if PlotAverages == 1
    figure
    Average_NumberOfCharges_WhileRaisingVoltage = Average_NumberOfCharges(1:NumberOfVoltageTests/2);
    Average_NumberOfCharges_WhileLoweringVoltage = fliplr(Average_NumberOfCharges(NumberOfVoltageTests/2+1:NumberOfVoltageTests));
    plot(Average_AppliedVoltage2,  Average_NumberOfCharges_WhileRaisingVoltage,'-sb',Average_AppliedVoltage3,Average_NumberOfCharges_WhileLoweringVoltage,'-sr');
    title('Avergage Number of Charges in system as a function of Applied Voltage: Raising - Blue,Lowering - Red, ');
    xlabel('V/VT relative Applied Voltage');
    ylabel('Number of Charges');
    end
    


    
end


% Current Burst Replay
    if AvalancheEventRecorder ==1
            NumberOfVoltageTestsOfEvent
            for N = 1:NumberOfEvent-1

                for i = 1:20
                    [f] = TakePictureOfTheSystem(RecordedAvalanche_Events(N,:,i),Vleft,C,Cg,NumberOfDots);
                end
                % delay between events
                for j = 1:10
                    [f] = TakePictureOfTheSystem(RecordedAvalanche_Events(N,:,i),Vleft,C,Cg,NumberOfDots);
                end
            end
            
    end



%%%% Plots %%%%

    if tripleplot == 1
        [u] = OneD_TriplePlot_Generator(Average_NumberOfCharges,Average_Current,Average_AppliedVoltage,NumberOfVoltageTests,ThresholdVoltage,Average_Calculated_Theshold_Voltage,FirstChargedSystem,InitialSystem);
    end
    
    if PlotAverageState ==1
        [b] = Plot_AveragedCharge_Surface(NumberOfVoltageTests,InitialSystem,FirstChargedSystem,Full_AveragedState,NumberOfDots);
    end
%% Linear Double Plot With Phase Chart - Note the "Full_AppliedVoltage" Slot, Should be RelativeChangeOf_Voltage_FromVt
%[g] = OneD_Linear_I_V_Plot_WithPhasePlot(Full_CurrentThroughSystem,Full_AppliedVoltage,Full_NumberOfMoves,C,Cg,NumberOfDots);

%% Linear Double Plot With Phase Chart
%%[h] = OneD_Logarithmic_I_V_Plot_WithPhasePlot(CurrentThroughSystem,RelativeChangeOf_Voltage_FromVt,NumberOfMoves,C,Cg,NumberOfDots);

%% Single Plot With Phase Chart
%%[f] = OneD_Linear_I_V_Single_Plot(CurrentThroughSystem,VoltageOnSystem,C,Cg,NumberOfDots)

%% Plot Distribution Plots
if DistributionPlot == 1
[a,b] = Plot_DistributionPlots(Full_TimeBetween_AddingCharges,Full_TimeBetween_DischargingCharges,InitialSystem,NumberOfDots);
end

%% Ploting Voltages
if PlotNonAverages == 1
realVT = ThresholdVoltage*ones(1,NumberOfRuns_AtEachVoltage*NumberOfVoltageTests);
AppliedVoltage = Vleft*ones(1,NumberOfRuns_AtEachVoltage*NumberOfVoltageTests);
VoltageTestNumber = 1:1:NumberOfRuns_AtEachVoltage*NumberOfVoltageTests;

figure
plot(VoltageTestNumber,Full_Calculated_Theshold_Voltage,'-s',VoltageTestNumber,realVT,'-b',VoltageTestNumber,Full_AppliedVoltage,'r')
title('Calculated Theshold Voltage, Real Vt marked in blue, Applied Voltage in red')
%hist(TimeBetweenAddingChargesTime,20)
ylim ([0.9*ThresholdVoltage 1.1*max(Full_AppliedVoltage)])
grid on
end
%% Average Plot Voltages
if PlotAverages == 1
realVT = ThresholdVoltage*ones(1,NumberOfVoltageTests);
figure
plot(AverageTestNumber,Average_Calculated_Theshold_Voltage,'-s',AverageTestNumber,realVT,'-b',AverageTestNumber,Average_AppliedVoltage,'-rs')
title('Averaged: Calculated Theshold Voltage, Real Vt marked in blue, Applied Voltage in red')
%hist(TimeBetweenAddingChargesTime,20)
ylim ([0.9*ThresholdVoltage 1.1*max(Full_AppliedVoltage)])
ylabel('V/VT - relative voltage')
grid on
end

%% Time Plot
%%[logTime] = OneD_Time_Graph(RelativeChangeOf_Voltage_FromVt,C,Cg,NumberOfDots,InternalMoves_Time,Charging_Time,CombinedTime)

%%[Lineatime] = OneD_Liner_Time_Graph(RelativeChangeOf_Voltage_FromVt,C,Cg,NumberOfDots,InternalMoves_Time,Charging_Time,CombinedTime)



%% Linear Double Plot With Phase Chart
%%[h] = OneD_Logarithmic_I_V_Plot_WithPhasePlot(CurrentThroughSystem,RelativeChangeOf_Voltage_FromVt,NumberOfMoves,C,Cg,NumberOfDots);


 %%Threshold Voltage Tests on System
%%[Alpha_Graph,Vt_Graph] = OneD_ThresholdVoltageTests(InitialSystem,NumberOfDots);