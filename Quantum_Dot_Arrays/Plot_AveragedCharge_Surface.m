function [b] = Plot_AveragedCharge_Surface(NumberOfVoltageTests,InitialSystem,FirstChargedSystem,Full_AveragedState,NumberOfDots)

Full_FirstChargedSystem = ones(NumberOfVoltageTests,NumberOfDots)*diag(FirstChargedSystem);
b = figure;
bar3(Full_AveragedState.','r')
hold on
bar3(Full_FirstChargedSystem.','b')
hold off
view(295,10)