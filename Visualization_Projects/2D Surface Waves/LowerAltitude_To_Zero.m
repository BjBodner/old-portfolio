function [M,el] = LowerAltitude_To_Zero(X,Y,Z,FramesOfAltitudeChange,HighlightAxis,az)

% Default View is az = –37.5, el = 30.

for i = 1:FramesOfAltitudeChange
    % Example of plot
    el = 30-30*i/FramesOfAltitudeChange;
    view(az, el);
    
    if HighlightAxis ==1
    hold on
        %contour3 (x,y,z, [0 0])
        plot3 ( X(X==0),Y(X==0),Z(X==0), 'rs' );
        plot3 ( X(Y==0),Y(Y==0),Z(Y==0), 'rs' );
        hold off
    end
    zlim ([-1 1])
    ylim ([0 (1-(i-1)/FramesOfAltitudeChange)])
    xlabel('X direction   ---->')
    ylabel('<----   Y direction')
    zlabel('The Height of the wave')
    
    %title(sprintf('Traveling Waves in both directions \n Number of waves in  the X direction is %g \n Number of waves in the Y direction is %g',Kx,Ky))    
    % Store the frame
    M(i)=getframe(gcf); % leaving gcf out crops the frame in the movie.
end