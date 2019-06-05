function [f] = OneD_TriplePlot_Generator(Average_NumberOfCharges,Average_Current,Average_AppliedVoltage,NumberOfVoltageTests,ThresholdVoltage,Average_Calculated_Theshold_Voltage,FirstChargedSystem,InitialSystem)

TestNumber = 1:NumberOfVoltageTests;
BaseNumberOfCharges = sum(FirstChargedSystem-InitialSystem)*ones(1,NumberOfVoltageTests);
realVT = ones(1,NumberOfVoltageTests);
Average_Calculated_Theshold_Voltage = Average_Calculated_Theshold_Voltage/ThresholdVoltage;
Average_AppliedVoltage = Average_AppliedVoltage/ThresholdVoltage;

f = figure;
ax1 = subplot(3,1,1);
Average_AppliedVoltage_forCurrent = Average_AppliedVoltage*min(Average_Current);
plot(ax1,TestNumber,  Average_Current,'-sb')
hold on
plot(ax1,TestNumber,Average_AppliedVoltage_forCurrent,'-r')
hold off
title(ax1,'Avergage Current as a function of Applied Voltage')
ylabel(ax1,'Current');
xlabel(ax1,'TestNumber');
%ylim(ax1,[0.95*min(mean(Average_Current)) 1.05*max(mean(Average_Current))])

ax2 = subplot(3,1,2);
%plot(ax2,TestNumber,  Average_NumberOfCharges,'-sb',TestNumber,Average_AppliedVoltage,'-r')
Average_AppliedVoltage_forNumberOfCharges = Average_AppliedVoltage*min(Average_NumberOfCharges);
plot(ax2,TestNumber,  Average_NumberOfCharges,'-sb')
hold on
plot(ax2,TestNumber,Average_AppliedVoltage_forNumberOfCharges,'-r',TestNumber,BaseNumberOfCharges,'-b')
hold off
title(ax2,'Avergage Number of Charges in system as a function of Applied Voltage')
ylabel(ax2,'Number of Charges');
xlabel(ax2,'TestNumber');
ylim(ax2,[0.95*min(Average_NumberOfCharges) 1.05*max(Average_NumberOfCharges)])

ax3 = subplot(3,1,3);


plot(ax3,TestNumber,Average_Calculated_Theshold_Voltage,'-s',TestNumber,realVT,'-b',TestNumber,Average_AppliedVoltage,'-rs')
title(ax3,'Averaged: Calculated Theshold Voltage, Real Vt marked in blue, Applied Voltage in red')
ylabel(ax3,'V/VT - relative voltage')
xlabel(ax3,'TestNumber');
ylim(ax2,[0.95*min(Average_NumberOfCharges) 1.05*max(Average_NumberOfCharges)])