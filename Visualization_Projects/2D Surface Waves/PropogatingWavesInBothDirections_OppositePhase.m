function [M] = PropogatingWavesInBothDirections_OppositePhase(N,NumberOfPeriod,Ky,Kx,Velocity,FramesOfRotation,FramesOfAltitudeChange)

HighlightAxis = 1;
FramesOfRotation = 40;
FramesOfAltitudeChange = 40;
RecordVideo =1;

StartingPhase = 0;
StartingFrame = 0;
EndingFrame = 0;
% Creates a 2D Mesh to plot surface
x=linspace(0,1,100);
[X,Y] = meshgrid(x,x);
plot3(X,Y,X);
M=getframe(gcf);

%% Initial 2D wave
[M,Z,EndingFrame] = PropogatingWavesInBothDirection(X,Y,N,NumberOfPeriod,Ky,Kx,Velocity,HighlightAxis,StartingPhase,EndingFrame,M);

%% Rotating to X direction wave
HighlightAxis = 1;
[M,EndingFrame] = RotateSurfaceTo_XZ_Plane(X,Y,Z,FramesOfRotation,HighlightAxis,FramesOfAltitudeChange,EndingFrame,M);
[M,EndingFrame] = RotateSurface_Back_From_XZ_Plane(X,Y,Z,FramesOfRotation,HighlightAxis,FramesOfAltitudeChange,EndingFrame,M);

%% Rotating to X direction wave
StartingPhase = NumberOfPeriod;
NumberOfPeriod = 0.125;
[M,Z,EndingFrame] = PropogatingWavesInBothDirection(X,Y,N,NumberOfPeriod,Ky,Kx,Velocity,HighlightAxis,StartingPhase,EndingFrame,M);
[M,EndingFrame] = RotateSurfaceTo_YZ_Plane(X,Y,Z,FramesOfRotation,HighlightAxis,FramesOfAltitudeChange,EndingFrame,M);
[M,EndingFrame] = RotateSurface_Back_From_YZ_Plane(X,Y,Z,FramesOfRotation,HighlightAxis,FramesOfAltitudeChange,EndingFrame,M);

%% Initial 2D wave
StartingPhase =StartingPhase + NumberOfPeriod;
NumberOfPeriod = 1;
[M,~,~] = PropogatingWavesInBothDirection(X,Y,N,NumberOfPeriod,Ky,Kx,Velocity,HighlightAxis,StartingPhase,EndingFrame,M);
