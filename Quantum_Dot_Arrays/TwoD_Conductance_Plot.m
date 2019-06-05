function [ConductancePlot] = TwoD_Conductance_Plot(Average_Current,Average_AppliedVoltage,C,Cg,NumberOfDots,DistributionIndex,ThresholdVoltage)

CurrentThroughSystem = Average_Current
VoltageOnSystem = Average_AppliedVoltage/ThresholdVoltage


ConductancePlot = figure

CCg = C/Cg;

%% Conductance as a functino of the voltage
InverseResistance = zeros(max(size(VoltageOnSystem)),1);
derivative = diff(CurrentThroughSystem);
InverseResistance(2:max(size(VoltageOnSystem)),1) = derivative;
InverseResistance(1,1) = 0;
ZeroLine = zeros(size(VoltageOnSystem));

for i = 1:10
AverageConductance(i) = mean(InverseResistance((i-1)*round(length(CurrentThroughSystem)/10)+1:i*round(length(CurrentThroughSystem)/10)));
AverageDistributionIndex(i) =  mean(DistributionIndex((i-1)*round(length(CurrentThroughSystem)/10)+1:i*round(length(CurrentThroughSystem)/10)));
AverageVoltageOnSystem(i) =  mean(VoltageOnSystem((i-1)*round(length(CurrentThroughSystem)/10)+1:i*round(length(CurrentThroughSystem)/10)));
end

% Cunductance as a fucntion of voltage
ax1 = subplot(3,1,1);
plot(ax1,VoltageOnSystem,InverseResistance,'-',VoltageOnSystem,ZeroLine,'--',AverageVoltageOnSystem,AverageConductance,'-rs');
title(ax1,['Conductance As a function of Voltage, Through 2D Array of ',num2str(NumberOfDots(1)*NumberOfDots(2)),' QDots, at C/Cg = ',num2str(CCg),''])
xlabel(ax1,'Voltage (V/Vt)') % x-axis label
ylabel(ax1,'Conductance()') % y-axis label
ylim([-2*max(AverageConductance) 2*max(AverageConductance)])
grid on


% Distribution Index as a function of voltage
OneLine = ones(size(VoltageOnSystem));
SaturationLine = ones(size(VoltageOnSystem));
ax2 = subplot(3,1,2);
plot(ax2,VoltageOnSystem,DistributionIndex,'-s',AverageVoltageOnSystem,AverageDistributionIndex,'-rs',VoltageOnSystem,OneLine,'--',VoltageOnSystem,SaturationLine,'--');
title(ax2,['Distribution Index as a function of voltage, Through 2D Array of ',num2str(NumberOfDots(1)*NumberOfDots(2)),' QDots, at C/Cg = ',num2str(CCg),''])
xlabel(ax2,'Voltage (V/Vt)') % x-axis label
ylabel(ax2,'DistributionIndex (NU)') % y-axis label
grid on




% cunductance as a function of Distribution Index
ax3 = subplot(3,1,3);
plot(ax3,DistributionIndex,ZeroLine,'--',AverageDistributionIndex,AverageConductance,'-rs');
title(ax3,['Conductance As a function of DistributionIndex, Through 2D Array of ',num2str(NumberOfDots(1)*NumberOfDots(2)),' QDots, at C/Cg = ',num2str(CCg),''])
xlabel(ax3,'DistributionIndex (NU)') % x-axis label
ylabel(ax3,'Conductance()') % y-axis label
grid on

% the Distribution Index is a measure of how distributed is the current off
% the array - the more it is distributed, the larger it will be
% the equation for it is: D = sum( Pi*CNi ), 
%
% where D is the distribution index, p is
% the percentage of current that channel is carrying, and CN is the Channel
% number (first, second, third, etc..) that is carrying that percantage of
% current. 
% for an evenly distributed current upon N channels we will get D = (N+1)/2
