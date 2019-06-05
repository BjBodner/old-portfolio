function [Vthreshold,CCg,ChargingTime,NumberOfCapacitanceTests] = TwoD_CapacitanceSweep(InitialSystem,MinC,MaxC,MinCg,MaxCg,NumberOfDots)

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
[Vleft,Q,TotalTime,f,framenumber] = TwoD_New_Create_Charged_System(C,Cg,NumberOfDots,InitialSystem,NextMoveArray,IndexOfRemovedCharge,invCM,PlotSystem);

%% Create Charged System With Pics
%%[Vleft,~,TotalTime,~] = Create_Charged_OneD_System(C,Cg,NumberOfDots,InitialSystem);


Vthreshold(n) = Vleft*Cg/NumberOfDots;
CCg(n) = C/Cg;
ChargingTime(n) = TotalTime;
end
