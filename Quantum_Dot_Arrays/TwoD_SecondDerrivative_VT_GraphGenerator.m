function [Vt_Graph] = TwoD_SecondDerrivative_VT_GraphGenerator(SecondDerrivative,minimizedCCg,NumberOfDots)

%% Creating Graph
figure
Vt_Graph = loglog(CCg,Vthreshold,'-s');
xlabel('CCg')
ylabel('Threshold Voltage')
title(['Second Derrivative Threshold Voltage as a function of CCg, With 2D Array of ',num2str(NumberOfDots),' Dots'])
ylim([ 0 10 ])
grid on