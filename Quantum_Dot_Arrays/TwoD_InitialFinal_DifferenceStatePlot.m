function [Initial_Final_Difference_state] = TwoD_InitialFinal_DifferenceStatePlot(NumberOfDots,Ix_Initial,Iy_Initial,AveragedState_Initial,Ix_Final,Iy_Final,AveragedState_Final,n,Vleft,C,Cg)

Initial_Final_Difference_state = figure;
Ix = Ix_Final - Ix_Initial;
Iy = Ix_Final - Iy_Initial;
AveragedState = AveragedState_Final - AveragedState_Initial;
CCg = C/Cg;
CurrentNormalizationFactor = 1/1000;


ax1 = subplot(2,1,1);
bar3(ax1,AveragedState,'b')
zlim ([-2 2])
view(ax1,310,10)

ax2 = subplot(2,1,2); 
        [x,y] = meshgrid(1:1:NumberOfDots,1:1:NumberOfDots);
        Ix2 = CurrentNormalizationFactor*Ix.';
        Iy2 = CurrentNormalizationFactor*Iy.';
        quiver(ax2,x,y,Ix2,Iy2);
        xlim([0 NumberOfDots+1])
        ylim([0 NumberOfDots+1])
        
            title(sprintf('Difference Of Averaged States Final-Initial \n C/Cg = %g \n VLeft =  %f',CCg,Vleft))  
