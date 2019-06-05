function [f] = TwoD_ExtraChargesPerDot_Plot(Average_AppliedVoltage,C,Cg,FirstChargedSystem,Full_AveragedState,NumberOfDots)

Extended_FirstChargedSystem = zeros(max(size(Full_AveragedState(:,1,1))),NumberOfDots,NumberOfDots);

for n = 1:size(Full_AveragedState(:,1,1))
    Extended_FirstChargedSystem(n,:,:) = FirstChargedSystem;
end

ExtraCharges = Full_AveragedState - Extended_FirstChargedSystem;
ExtraCharges1 = permute(ExtraCharges,[2 3 1]);
ExtraChargesPerDot = sum(sum(ExtraCharges1))/NumberOfDots;
ExtraChargesPerDot = permute(ExtraChargesPerDot, [3 1 2]);

CCg = C/Cg;

f = figure;
%subplot(2,1,1)       % add first plot in 2 x 1 grid
plot(Average_AppliedVoltage,ExtraChargesPerDot,'-s')
title(['Average Extra Charges as a function of voltage, Through 1D Array of ',num2str(NumberOfDots),' QDots, at C/Cg = ',num2str(CCg),''])
xlabel('Voltage (1/Cg)') % x-axis label
ylabel('Extra Charges Per Dot (NU)') % y-axis label
grid on
