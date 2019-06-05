function [Lineatime] = OneD_Liner_Time_Graph(RelativeChangeOf_Voltage_FromVt,C,Cg,NumberOfDots,InternalMoves_Time,Charging_Time,CombinedTime)



CCg = C/Cg;

%% Internal moves Time Graph
Lineatime = subplot(2,1,1) ;      % add first plot in 2 x 1 grid
plot(RelativeChangeOf_Voltage_FromVt,InternalMoves_Time,'-s')
title(['Time of Internal Moves as a function of Relative change of Voltage, ',num2str(NumberOfDots),' QDots, at C/Cg = ',num2str(CCg),''])
xlabel('Relative change in Voltage From Vt(NU)') % x-axis label
ylabel('Time of Internal Moves (1/Energy)') % y-axis label
grid on

LowerLimitOfGraph_1 = (max(InternalMoves_Time) + min(InternalMoves_Time))/2 - 0.6*(max(InternalMoves_Time) - min(InternalMoves_Time));
UpperLimitOfGraph_1 = (max(InternalMoves_Time) + min(InternalMoves_Time))/2 + 0.6*(max(InternalMoves_Time) - min(InternalMoves_Time));
ylim([LowerLimitOfGraph_1 UpperLimitOfGraph_1])

%% Charging Time Graph
subplot(2,1,2)       % add second plot in 2 x 1 grid
plot(RelativeChangeOf_Voltage_FromVt,Charging_Time,'-s')       % plot using + markers
title(['Charging Time as a function of Relative change of Voltage, ',num2str(NumberOfDots),' QDots, at C/Cg = ',num2str(CCg),''])
xlabel('Relative change in Voltage From Vt(NU)') % x-axis label
ylabel('Charging Time (1/Energy)') % y-axis label
grid on

LowerLimitOfGraph_2 = (max(Charging_Time) + min(Charging_Time))/2 - 0.6*(max(Charging_Time) - min(Charging_Time));
UpperLimitOfGraph_2 = (max(Charging_Time) + min(Charging_Time))/2 + 0.6*(max(Charging_Time) - min(Charging_Time));
ylim([max(0,LowerLimitOfGraph_2) UpperLimitOfGraph_2])
