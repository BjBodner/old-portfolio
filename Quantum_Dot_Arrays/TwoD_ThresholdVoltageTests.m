function [Alpha_Graph,Vt_Graph] = TwoD_ThresholdVoltageTests(InitialSystem,NumberOfDots)
%% Capacitance Sweep Test
MinC = 1;
MaxC = 1000;
MinCg = 1;
MaxCg = 1000;
AveragingNumber = 1;
VthresholdSum = 0;
for a = 1:AveragingNumber
    InitialSystem = rand(NumberOfDots,NumberOfDots);
[Vthreshold,CCg,~,NumberOfCapacitanceTests] = TwoD_CapacitanceSweep(InitialSystem,MinC,MaxC,MinCg,MaxCg,NumberOfDots);
VthresholdSum = VthresholdSum+Vthreshold;
end
AverageVT = VthresholdSum/AveragingNumber;
Vthreshold = AverageVT;
Vthreshold
SecondDerrivative = diff(diff(AverageVT));
minimizedCCg = CCg(1:NumberOfCapacitanceTests-2);
%[Vt_Graph] = TwoD_SecondDerrivative_VT_GraphGenerator(SecondDerrivative,minimizedCCg,NumberOfDots);

%% Alpha Graph Generator
%[Alpha_Graph] = OneD_AlphaGraphGenerator(Vthreshold,CCg,NumberOfDots,NumberOfCapacitanceTests);
Alpha_Graph = 0;
%% Threshold Voltage Graph
[Vt_Graph] = OneD_VT_GraphGenerator(Vthreshold,CCg,NumberOfDots);