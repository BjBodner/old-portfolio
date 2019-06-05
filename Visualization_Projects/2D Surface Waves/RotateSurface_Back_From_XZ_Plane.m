function [M,EndingFrame] = RotateSurface_Back_From_XZ_Plane(X,Y,Z,FramesOfRotation,HighlightAxis,FramesOfAltitudeChange,EndingFrame,M)

StartingFrame = EndingFrame;

for i = 1:FramesOfAltitudeChange
    % Example of plot
    el = 0+30*i/FramesOfAltitudeChange;
    az = 360;
    view(az, el);
    
    
    if HighlightAxis ==1
    hold on
        %contour3 (x,y,z, [0 0])
        plot3 ( X(X==0),Y(X==0),Z(X==0), 'rs' );
        plot3 ( X(Y==0),Y(Y==0),Z(Y==0), 'rs' );
        hold off
    end
    zlim ([-1 1])
    ylim ([0 (0+(i)/FramesOfAltitudeChange)])
    xlabel('X direction   ---->')
    ylabel('<----   Y direction')
    zlabel('The Height of the wave')
    
    %title(sprintf('Traveling Waves in both directions \n Number of waves in  the X direction is %g \n Number of waves in the Y direction is %g',Kx,Ky))    
    % Store the frame
    M(i+StartingFrame)=getframe(gcf); % leaving gcf out crops the frame in the movie.
end
size_M = max(size(M));

for i = 1:FramesOfRotation
    % Example of plot
    surf(X,Y,Z)
    az = 360 - 37.5*i/FramesOfRotation;
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
    M(i+FramesOfAltitudeChange+StartingFrame)=getframe(gcf); % leaving gcf out crops the frame in the movie.
end
EndingFrame = max(size(M));