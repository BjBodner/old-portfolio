function [f] = OneD_Linear_I_V_Plot_WithPhasePlot(CurrentThroughSystem,RelativeChangeOf_Voltage_FromVt,NumberOfMoves,C,Cg,NumberOfDots)

CCg = C/Cg;

%%f = figure;
f = subplot(2,1,1) ;      % add first plot in 2 x 1 grid
plot(RelativeChangeOf_Voltage_FromVt,CurrentThroughSystem,'-s')
title(['Linear Current as a function of Relative change of Voltage, Through 1D Array of ',num2str(NumberOfDots),' QDots, at C/Cg = ',num2str(CCg),''])
xlabel('Relative change in Voltage From Vt(NU)') % x-axis label
ylabel('Current (Energy)') % y-axis label
grid on

subplot(2,1,2)       % add second plot in 2 x 1 grid
plot(RelativeChangeOf_Voltage_FromVt,NumberOfMoves,'-s')       % plot using + markers
title('Number of tunneling events as a function of Voltage')
xlabel('Relative change in Voltage From Vt(NU)') % x-axis label
ylabel('Number Of tunneling events (NU)') % y-axis label
grid on
colormap(hsv)
ylim([NumberOfDots max(2*NumberOfDots,max(NumberOfMoves))])
