
function [f] = OneD_Linear_I_V_Single_Plot(Average_Current,Average_AppliedVoltage,C,Cg,NumberOfDots,DistributionIndex,ThresholdVoltage)

CurrentThroughSystem = Average_Current
VoltageOnSystem = Average_AppliedVoltage/ThresholdVoltage

for i = 1:10
AverageCurrentThroughSystem(i) = mean(CurrentThroughSystem((i-1)*round(length(CurrentThroughSystem)/10)+1:i*round(length(CurrentThroughSystem)/10)));
AverageDistributionIndex(i) =  mean(DistributionIndex((i-1)*round(length(CurrentThroughSystem)/10)+1:i*round(length(CurrentThroughSystem)/10)));
AverageVoltageOnSystem(i) =  mean(VoltageOnSystem((i-1)*round(length(CurrentThroughSystem)/10)+1:i*round(length(CurrentThroughSystem)/10)));
end

CCg = C/Cg;

f = figure;

ax1 = subplot(3,1,1)       % add first plot in 2 x 1 grid
plot(ax1,VoltageOnSystem,CurrentThroughSystem,'-s');
title(ax1,['Current As a function of Voltage, Through 2D Array of ',num2str(NumberOfDots(1)*NumberOfDots(2)),' QDots, at C/Cg = ',num2str(CCg),''])
xlabel(ax1,'Voltage (V/Vt)') % x-axis label
ylabel(ax1,'Calculated Current (Energy)') % y-axis label
grid on


% Distribution Index as a function of voltage
OneLine = ones(size(VoltageOnSystem));
ax2 = subplot(3,1,2);
plot(ax2,VoltageOnSystem,DistributionIndex,'-s',VoltageOnSystem,OneLine,'--');
title(ax2,['Distribution Index as a function of voltage, Through 2D Array of ',num2str(NumberOfDots(1)*NumberOfDots(2)),' QDots, at C/Cg = ',num2str(CCg),''])
xlabel(ax2,'Voltage (V/Vt)') % x-axis label
ylabel(ax2,'DistributionIndex (NU)') % y-axis label
grid on


ax3 = subplot(3,1,3)       % add first plot in 2 x 1 grid
plot(ax3,DistributionIndex,CurrentThroughSystem,'-',AverageDistributionIndex,AverageCurrentThroughSystem,'-rs');
title(ax3,['Current As a function of DistributionIndex, Through 1D Array of ',num2str(NumberOfDots(1)*NumberOfDots(2)),' QDots, at C/Cg = ',num2str(CCg),''])
xlabel(ax3,'DistributionIndex') % x-axis label
ylabel(ax3,'Calculated Current (Energy)') % y-axis label
grid on

