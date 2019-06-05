C = 1;
Cg = 10000;
NumberOfDots = 10;
InitialSystem = rand(NumberOfDots,NumberOfDots);
NumberOfVoltageTests = 20;
VoltageOnSystem = zeros(1,NumberOfVoltageTests);
CurrentThroughSystem = zeros(1,NumberOfVoltageTests);
V_minusVt_dividedby_Vt = zeros(1,NumberOfVoltageTests);
I_Cg_N = zeros(1,NumberOfVoltageTests);
Q_AfterRun = zeros(NumberOfDots,NumberOfDots,NumberOfVoltageTests)
Max = 0;
framenumber = 1;
[NextMoveArray,IndexOfRemovedCharge] = TwoD_NextMoveArray_Generator(NumberOfDots);


%[Q,CurrentRow,CurrentCol,ChosenStep,EnergyDifference] = TwoD_Probabilistic_NextStep_Excecutor(Q,NextMoveArray,invCM,C,Vleft,NumberOfDots,IndexOfRemovedCharge);



[Vleft,Q,TotalTime,ChargingMovie] = Create_Charged_TwoD_System(C,Cg,NumberOfDots,InitialSystem);




ThresholdVoltage = Vleft;
VtCg_eN = ThresholdVoltage*Cg/NumberOfDots;
Vleft = ThresholdVoltage + (sqrt(10)^(-3))*ThresholdVoltage;

for n = 1:NumberOfVoltageTests
    %%VoltageOnSystem(1,n) = Vleft*Cg/NumberOfDots
   % Vleft = ThresholdVoltage + (sqrt(10)^(n-5))*ThresholdVoltage;
    %V_minusVt_dividedby_Vt(1,n) = (Vleft-ThresholdVoltage)/ThresholdVoltage

    
    %%Run Through Charged System Without Picture
%%    [TimeVector,TotalTime] = Run_Through_Charged_System_WithoutPics(Q,C,Cg,NumberOfDots,Vleft);


%% Run Through System
[AverageChargesTransfered,TotalTime,Current_Through_System,Calculated_Theshold_Voltage,NumberOfMoves,TimeBetween_DischargingCharges,CurrentThroughSystem,Q_Final,NumberOfCharges_InArray,AveragedState,Last20moves,LastMoveRecorderCount,f,Random_Number_Seed,Random_Number_Index] = TwoD_Constant_CurrentMode(Q,invCM,C,NumberOfRuns_AtEachVoltage,Cg,NumberOfDots,Vleft,ThresholdVoltage,PlotSystem,InitialSystem,Last20moves,LastMoveRecorderCount,TotalTimeAtEachVoltage,TimeOfEachRun,TotalTime,Random_Number_Seed,Random_Number_Index)



    %%Run Through Charged System With Picture
    TimeVector = zeros(round(NumberOfDots*NumberOfDots*NumberOfDots),round(1));
    [TotalTime,Q_Final,f] = TwoD_Run_Through_Charged_System(Q,C,Cg,NumberOfDots,Vleft,TimeVector,framenumber);
   
     for l = 1:max(size(f))
      M(Max+l) = f(l);
      end
        Max = max(size(M))
    
    %%Run Through Charged System With Picture
    
    Q_AfterRun(:,:,n) = Q_Final;
    Q = Q_Final;
    %%CurrentThroughSystem(1,n) = 100000/TotalTime;
    

    I_Cg_N(1,n) = Cg/(NumberOfDots*TotalTime)
end

        v = VideoWriter('Transport in 2D array Low CCg.avi','Uncompressed AVI');
       open(v)
        writeVideo(v,M)
        close(v)
%%plot(VoltageOnSystem,CurrentThroughSystem,'-s');
loglog(V_minusVt_dividedby_Vt,I_Cg_N,'-s');
%%plot(V_minusVt_dividedby_Vt,I_N_e_Cg,'-s');
grid on
xlabel('Relative Voltage Difference') % x-axis label
ylabel('Effective Current') % y-axis label
title('Effective Current As a function of Relative Voltage Difference')