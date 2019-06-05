N=200; % Number of frames in one Period
NumberOfPeriod = 0.75;
Ky = 1;
Kx = 1;
Velocity = 1;
FramesOfRotation = 40;
FramesOfAltitudeChange = 40;

[M] = PropogatingWavesInBothDirections_OppositePhase(N,NumberOfPeriod,Ky,Kx,Velocity,FramesOfRotation,FramesOfAltitudeChange);


if RecordVideo ==1
v = VideoWriter('WaveMovie3.avi','Uncompressed AVI');
open(v)
writeVideo(v,M)
close(v)
end