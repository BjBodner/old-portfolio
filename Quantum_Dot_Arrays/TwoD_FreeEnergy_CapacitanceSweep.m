function [Vthreshold,CCg,ChargingTime,NumberOfCapacitanceTests,FreeEnergyBefore,FreeEnergyAfter] = TwoD_FreeEnergy_CapacitanceSweep(InitialSystem,MinC,MaxC,MinCg,MaxCg,NumberOfDots)

NumberOfCapacitanceTests = 4*log10(MaxC*MaxCg/MinC*MinCg) + 1;
Vthreshold = zeros(NumberOfCapacitanceTests,1);
CCg = zeros(NumberOfCapacitanceTests,1);
ChargingTime = zeros(NumberOfCapacitanceTests,1);
PlotSystem = 0;
for n = 1:NumberOfCapacitanceTests

    %% Changing Capacitance
    C = MinC;
 %   C = MinC*((sqrt(sqrt(10)))^(n-1));
    Cg = MaxCg/((sqrt(sqrt(10)))^(n-1));
    
    
[invCM,CM] = TwoDim_invCM_Generator(C,Cg,NumberOfDots);
[NextMoveArray,IndexOfRemovedCharge] = TwoD_NextMoveArray_Generator(NumberOfDots);

%% Create Charged System With Pics
Q = InitialSystem;
    FreeEnergyBefore(n) = 0.5*reshape(Q,1,NumberOfDots*NumberOfDots)*invCM*reshape(Q,NumberOfDots*NumberOfDots,1);
[Vleft,Q,TotalTime,f,framenumber] = TwoD_New_Create_Charged_System(C,Cg,NumberOfDots,InitialSystem,NextMoveArray,IndexOfRemovedCharge,invCM,PlotSystem);
    FreeEnergyAfter(n) = 0.5*reshape(Q,1,NumberOfDots*NumberOfDots)*invCM*reshape(Q,NumberOfDots*NumberOfDots,1);

Vthreshold(n) = Vleft*Cg/NumberOfDots;
CCg(n) = C/Cg;
ChargingTime(n) = TotalTime;
end
