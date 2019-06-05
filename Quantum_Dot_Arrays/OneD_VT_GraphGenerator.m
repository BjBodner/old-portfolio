function [Vt_Graph] = OneD_VT_GraphGenerator(Vthreshold,CCg,NumberOfDots)

%% Creating Graph
figure
Vt_Graph = loglog(CCg,Vthreshold,'-s');
xlabel('CCg')
ylabel('Threshold Voltage')
title(['Threshold Voltage as a function of CCg, With 2D Array of ',num2str(NumberOfDots),' Dots'])
ylim([ 0 10 ])
grid on