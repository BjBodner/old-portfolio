function [M,EndingFrame] = RotateSurfaceTo_YZ_Plane(X,Y,Z,FramesOfRotation,HighlightAxis,FramesOfAltitudeChange,EndingFrame,M)

% Default View is az = –37.5, el = 30.
StartingFrame = EndingFrame;

for i = 1:FramesOfRotation
    % Example of plot
    surf(X,Y,Z)
    az = 322.5 - 52.5*i/FramesOfRotation;
    el = 30;
    view(az, el);
    
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
    
    %title(sprintf('Traveling Waves in both directions \n Number of waves in  the X direction is %g \n Number of waves in the Y direction is %g',Kx,Ky))    
    % Store the frame
    M(i+StartingFrame)=getframe(gcf); % leaving gcf out crops the frame in the movie.
end

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
    xlim ([0 (1-(i-1)/FramesOfAltitudeChange)])
    xlabel('X direction   ---->')
    ylabel('<----   Y direction')
    zlabel('The Height of the wave')
    
    %title(sprintf('Traveling Waves in both directions \n Number of waves in  the X direction is %g \n Number of waves in the Y direction is %g',Kx,Ky))    
    % Store the frame
    M(i+FramesOfRotation+StartingFrame)=getframe(gcf); % leaving gcf out crops the frame in the movie.
end
EndingFrame = max(size(M));