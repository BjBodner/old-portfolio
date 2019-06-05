function [InitialFreeEnergy_Graph,FinalFreeEnergy_Graph] = TwoD_FreeEnergy_Tests(InitialSystem,NumberOfDots)
%% Capacitance Sweep Test
MinC = 1;
MaxC = 10000;
MinCg = 1;
MaxCg = 10000;
AveragingNumber = 1;
VthresholdSum = 0;
FreeEnergyBeforeSum = 0;
FreeEnergyAfterSum = 0;

for a = 1:AveragingNumber
    InitialSystem = rand(NumberOfDots,NumberOfDots);

    [Vthreshold,CCg,ChargingTime,NumberOfCapacitanceTests,FreeEnergyBefore,FreeEnergyAfter] = TwoD_FreeEnergy_CapacitanceSweep(InitialSystem,MinC,MaxC,MinCg,MaxCg,NumberOfDots)
    FreeEnergyBeforeSum = FreeEnergyBeforeSum + FreeEnergyBefore;
    FreeEnergyAfterSum = FreeEnergyAfterSum + FreeEnergyAfter;
end

AverageFreeEnergyBefore = FreeEnergyBeforeSum/AveragingNumber;
AverageFreeEnergyAfter = FreeEnergyAfterSum/AveragingNumber;


figure
InitialFreeEnergy_Graph = loglog(CCg,AverageFreeEnergyBefore,'-s');
xlabel('CCg')
ylabel('AverageFreeEnergyBefore')
title(['AverageFreeEnergyBefore as a function of CCg, With 2D Array of ',num2str(NumberOfDots),' Dots'])
ylim([ 0 10*max(AverageFreeEnergyAfter) ])
grid on

figure
FinalFreeEnergy_Graph = loglog(CCg,AverageFreeEnergyAfter,'-s');
xlabel('CCg')
ylabel('AverageFreeEnergyAfter')
title(['AverageFreeEnergyAfter as a function of CCg, With 2D Array of ',num2str(NumberOfDots),' Dots'])
ylim([ 0 10*max(AverageFreeEnergyAfter) ])
grid on
