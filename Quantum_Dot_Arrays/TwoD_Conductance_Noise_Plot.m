function [ConductancePlot] = TwoD_Conductance_Noise_Plot(Average_Current,Average_AppliedVoltage,C,Cg,NumberOfDots,DistributionIndex,ThresholdVoltage)

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
%ConductanceVariance = zeros(max(size(VoltageOnSystem)),1);



for i = 1:10
AverageConductance(i) = mean(InverseResistance((i-1)*round(length(CurrentThroughSystem)/10)+1:i*round(length(CurrentThroughSystem)/10)));
ConductanceVariance(i) = mean(abs(InverseResistance((i-1)*round(length(CurrentThroughSystem)/10)+1:i*round(length(CurrentThroughSystem)/10))-AverageConductance(i)));
AverageDistributionIndex(i) =  mean(DistributionIndex((i-1)*round(length(CurrentThroughSystem)/10)+1:i*round(length(CurrentThroughSystem)/10)));
AverageVoltageOnSystem(i) =  mean(VoltageOnSystem((i-1)*round(length(CurrentThroughSystem)/10)+1:i*round(length(CurrentThroughSystem)/10)));
end




% Cunductance as a fucntion of voltage
ax1 = subplot(3,1,1);
plot(ax1,VoltageOnSystem,InverseResistance,'-',VoltageOnSystem,ZeroLine,'--',AverageVoltageOnSystem,AverageConductance,'-rs');
title(ax1,['Conductance As a function of Voltage, Through 2D Array of ',num2str(NumberOfDots(1)*NumberOfDots(2)),' QDots, at C/Cg = ',num2str(CCg),''])
xlabel(ax1,'Voltage (V/Vt)') % x-axis label
ylabel(ax1,'Conductance()') % y-axis label
ylim([-0.5*max(AverageConductance) 2*max(AverageConductance)])
grid on


% Variance in conductance as a function of voltage
ax2 = subplot(3,1,2);
plot(ax2,AverageVoltageOnSystem,ConductanceVariance,'-s');
title(ax2,['Variance in conductance, Through 2D Array of ',num2str(NumberOfDots(1)*NumberOfDots(2)),' QDots, at C/Cg = ',num2str(CCg),''])
xlabel(ax2,'Voltage (V/Vt)') % x-axis label
ylabel(ax2,'Variance in Conductance ()') % y-axis label
grid on




% Fourier transform of the conductance as a function of 1/Voltage

Y = fft(InverseResistance);
        
        %% Part 1 - Copied Fourier Spectrum
        Fs = length(VoltageOnSystem)/(max(VoltageOnSystem)-min(VoltageOnSystem));            % Sampling frequency
        T = 1/Fs;             % Sampling period
        L = (max(VoltageOnSystem)-min(VoltageOnSystem));             % Length of signal
        t = (0:L-1)*T;        % Time vector
        
        %% Part 2 - Copied Fourier Spectrum
        P2 = abs(Y).^2/length(Y);
        P1 = P2(1:round(length(Y)/2));
        P1(2:end-1) = 2*P1(2:end-1);
        %% Part 3 - Copied Fourier Spectrum
        f = Fs*(0:length(Y)/2);
        f1 = (0:length(P1)-1)/((2*L));

ax3 = subplot(3,1,3);
plot(ax3,f1,P1,'-s');
title(ax3,['Frequency of Conductance Oscillations as a function of !/Voltage, Through 2D Array of ',num2str(NumberOfDots(1)*NumberOfDots(2)),' QDots, at C/Cg = ',num2str(CCg),''])
xlabel(ax3,'1/Voltage (1/(V/Vt))') % x-axis label
ylabel(ax3,'Frequency of Conductance Oscillations()') % y-axis label
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
