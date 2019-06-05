function [f] = OneD_Triple_Charges_Plot_Generator(Average_NumberOfCharges,Average_Current,Average_AppliedVoltage,NumberOfVoltageTests,ThresholdVoltage,Average_Calculated_Theshold_Voltage,FirstChargedSystem,InitialSystem,Time,Average_ChargesTransfered, Charges_Standard_Deviation)

%TestNumber = 1:NumberOfVoltageTests;
BaseNumberOfCharges = sum(FirstChargedSystem-InitialSystem)*ones(1,NumberOfVoltageTests);
realVT = ones(1,NumberOfVoltageTests);
Average_Calculated_Theshold_Voltage = Average_Calculated_Theshold_Voltage/ThresholdVoltage;
Average_AppliedVoltage = Average_AppliedVoltage/ThresholdVoltage;

ExtraChargesInSystem = Average_NumberOfCharges - BaseNumberOfCharges;
AverageTransferingTime_ThroughSystem = (ExtraChargesInSystem./Average_ChargesTransfered)./Average_Current;


f = figure;
ax1 = subplot(3,1,1);
Average_AppliedVoltage_forAverageTransferingTime = Average_AppliedVoltage*mean(AverageTransferingTime_ThroughSystem);
plot(ax1,Time,  AverageTransferingTime_ThroughSystem,'-sb')
hold on
plot(ax1,Time,Average_AppliedVoltage_forAverageTransferingTime,'-rs')
hold off
title(ax1,'Avergage Time For charge to pass through system')
ylabel(ax1,'Average Transfering Time');
xlabel(ax1,'Time (1/Energy)');
%ylim(ax1,[0.95*min(mean(Average_Current)) 1.05*max(mean(Average_Current))])

ax2 = subplot(3,1,2);
%plot(ax2,TestNumber,  Average_NumberOfCharges,'-sb',TestNumber,Average_AppliedVoltage,'-r')

Average_AppliedVoltage_forNumberOfCharges = Average_AppliedVoltage*min(Average_NumberOfCharges);
plot(ax2,Time,  Average_NumberOfCharges,'-sb')
hold on
plot(ax2,Time,Average_AppliedVoltage_forNumberOfCharges,'-rs',Time,BaseNumberOfCharges,'-b')
hold off
title(ax2,'Avergage Number of Charges in system as a function of time')
ylabel(ax2,'Number of Charges');
xlabel(ax2,'Time (1/Energy)');
ylim(ax2,[0.95*min(Average_NumberOfCharges) 1.05*max(Average_NumberOfCharges)])

ax3 = subplot(3,1,3);


plot(ax3,Time, Charges_Standard_Deviation,'-s',Time,Average_AppliedVoltage,'-rs')
title(ax3,'Starndard deviation of the number of charges')
ylabel(ax3,'Charges Standard Deviation')
xlabel(ax3,'Time ');
%ylim(ax3,[0.95*min(Charges_Standard_Deviation) 1.05*max(Charges_Standard_Deviation)])