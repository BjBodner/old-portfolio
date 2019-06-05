function [Initial_or_Final_state] = TwoD_InitialFinal_AverageStatePlot(NumberOfVoltageTests,InitialSystem,FirstChargedSystem,AveragedState,NumberOfDots,Ix,Iy,n,Vleft,C,Cg)
Initial_or_Final_state = figure;

CCg = C/Cg
CurrentNormalizationFactor = 1/1000;
ax1 = subplot(2,1,1);
bar3(ax1,AveragedState,'r')
%hold on
%bar3(ax1,FirstChargedSystem,'b')
%alpha(0.5)
%hold off 
zlim ([0 10])
view(ax1,310,10)

ax2 = subplot(2,1,2); 
        [x,y] = meshgrid(1:1:NumberOfDots,1:1:NumberOfDots);
        Ix2 = CurrentNormalizationFactor*Ix.';
        Iy2 = CurrentNormalizationFactor*Iy.';
        quiver(ax2,x,y,Ix2,Iy2);
        xlim([0 NumberOfDots+1])
        ylim([0 NumberOfDots+1])

if n == 1
%    title(ax1, 'Initial State of system - Averaged Charges and flow chart')
        title(sprintf('Initial Averaged State of system \n C/Cg = %g \n VLeft =  %f',CCg,Vleft))   
end
if n ==NumberOfVoltageTests
    title(sprintf('Final Averaged State of system \n C/Cg = %g \n VLeft =  %f',CCg,Vleft))   
    %   title(ax1, 'Final State of system - Averaged Charges and flow chart')
end