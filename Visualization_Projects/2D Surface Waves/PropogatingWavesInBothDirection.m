function [M,Z,EndingFrame] = PropogatingWavesInBothDirection(X,Y,N,NumberOfPeriod,Ky,Kx,Velocity,HighlightAxis,StartingPhase,EndingFrame,M)

StartingFrame = EndingFrame;

for i = 1:N*NumberOfPeriod
    % Example of plot
    Z = sin(2*pi*Kx*(X-StartingPhase-Velocity*(i/N))).*sin(2*pi*Ky*(Y-StartingPhase-Velocity*(i/N)));
    surf(X,Y,Z)
    if HighlightAxis ==1
    hold on
        %contour3 (x,y,z, [0 0])
        plot3 ( X(X==0),Y(X==0),Z(X==0), 'rs' );
        plot3 ( X(Y==0),Y(Y==0),Z(Y==0), 'rs' );
        hold off
    end
    zlim ([-1 1])
    xlabel('X direction   ---->')
    ylabel('<----   Y direction')
    zlabel('The Height of the wave')
    
    title(sprintf('Traveling Waves in both directions \n Number of waves in  the X direction is %g \n Number of waves in the Y direction is %g',Kx,Ky))    
    % Store the frame
    M(i+StartingFrame)=getframe(gcf); % leaving gcf out crops the frame in the movie.
end
EndingFrame = max(size(M));