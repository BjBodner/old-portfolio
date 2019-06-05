function [a,b] = Plot_DistributionPlots(Full_TimeBetween_AddingCharges,Full_TimeBetween_DischargingCharges,InitialSystem,NumberOfDots)

%% Distibution Plot Of Added Charges
[~,I] = max(Full_TimeBetween_AddingCharges);
Full_TimeBetween_AddingCharges(I) = mean(Full_TimeBetween_AddingCharges);
a = figure ;
hist(Full_TimeBetween_AddingCharges,40)
title('Time Distribution Plot Of added charges')
Mean_TimeBetween_Addedcharges = mean(Full_TimeBetween_AddingCharges)

%% Distibution Plot Of Removed Charges
[~,I] = max(Full_TimeBetween_DischargingCharges);
Full_TimeBetween_AddingCharges(I) = mean(Full_TimeBetween_DischargingCharges);
b = figure ;
hist(Full_TimeBetween_DischargingCharges,40)
title('Time Distribution Plot Of Removed charges')
Mean_TimeBetween_Removedcharges = mean(Full_TimeBetween_DischargingCharges)

%%Upwards Step Distribution
figure
i = 1;
for n = 2:NumberOfDots
    if InitialSystem(n)>InitialSystem(n-1)
        UpwardStep(i) = InitialSystem(n)-InitialSystem(n-1);
        i = i+1;
    end
end
hist(UpwardStep,NumberOfDots/2)
title('Upwards Step Distibution in Initial System')