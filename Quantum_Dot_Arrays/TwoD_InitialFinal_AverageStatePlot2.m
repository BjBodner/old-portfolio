function [Initial_or_Final_state] = TwoD_InitialFinal_AverageStatePlot2(NumberOfVoltageTests,InitialSystem,FirstChargedSystem,AveragedState,NumberOfDots,Ix_front,Ix_back,Iy_up,Iy_down,n,Vleft,C,Cg)
Initial_or_Final_state = figure;
    
CCg = C/Cg;
CurrentNormalizationFactor = 1/1000;
ax1 = subplot(2,1,1);
bar3(ax1,AveragedState,'r')
%hold on
%bar3(ax1,FirstChargedSystem,'b')
%alpha(0.5)
%hold off 
zlim ([0 10])
view(ax1,310,10)

%%The nonzero matrixes are      :   Ix_front,Ix_back,Iy_up,Iy_down
        Iy_front = zeros(size(Ix_front));
        Iy_back = zeros(size(Ix_front));
        Ix_up = zeros(size(Ix_front));
        Ix_down = zeros(size(Ix_front));
        
        %% Normalizing 
        
        Ix_front = CurrentNormalizationFactor*Ix_front.';
        Ix_back = CurrentNormalizationFactor*Ix_back.';
        Iy_up = CurrentNormalizationFactor*Iy_up.';
        Iy_down = CurrentNormalizationFactor*Iy_down.';
      %  title(['Averaged State Of system ',num2str(NumberOfDots),' Dots'])
    title(sprintf('Averaged State of system \n C/Cg = %g \n VLeft =  %f',CCg,Vleft))   
ax2 = subplot(2,1,2); 
        [x,y] = meshgrid(1:1:NumberOfDots,1:1:NumberOfDots);
        %% Front Arrows
        quiver(ax2,x,y,Ix_front,Iy_front);
        %% Back Arrows
        hold on
                quiver(ax2,x,y,Ix_back,Iy_back);
        %% Up Arrows
        hold on
                quiver(ax2,x,y,Ix_up,Iy_up);
        %% Down Arrows
        hold on
                quiver(ax2,x,y,Ix_down,Iy_down);
                
                %% Dot Animation
                x = 1:NumberOfDots;
                for k = 1:NumberOfDots
                    y(k,1:NumberOfDots) = x(k)*ones(size(x));
                    hold on
                    scatter(x,y(k,:),'ks');
                    hold off
                end
        hold off
        xlim([0 NumberOfDots+1])
        ylim([0 NumberOfDots+1])
        grid on
        
        
        
        
        
if n == 1
%    title(ax1, 'Initial State of system - Averaged Charges and flow chart')
        title(sprintf('Initial Averaged State of system \n C/Cg = %g \n VLeft =  %f',CCg,Vleft))   
end
if n ==NumberOfVoltageTests
    title(sprintf('Final Averaged State of system \n C/Cg = %g \n VLeft =  %f',CCg,Vleft))   
    %   title(ax1, 'Final State of system - Averaged Charges and flow chart')
end