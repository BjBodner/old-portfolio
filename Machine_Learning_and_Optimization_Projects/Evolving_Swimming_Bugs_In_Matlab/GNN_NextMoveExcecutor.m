function [NewBodyLocation,Angles_Of_Each_Joint_Before,Angles_Of_Each_Joint_After] = GNN_NextMoveExcecutor(Angles_Of_Each_Joint_Before,Angles_Of_Each_Joint_After,MyLocation,NumberOfLimbs,NumberOfJointsPerLimb,LengthOfEachSegmentOfTheLimb)



%% Changing the Location
BodyPlot_XLocationBefore(1) = MyLocation(1);
BodyPlot_XLocationAfter(1) = MyLocation(1);
BodyPlot_YLocationBefore(1) = MyLocation(2);
BodyPlot_YLocationAfter(1) = MyLocation(2);
n = 2;

for i = 1:NumberOfLimbs
    for j = 1:NumberOfJointsPerLimb
        BodyPlot_XLocationBefore(n) = BodyPlot_XLocationBefore(n-1) + LengthOfEachSegmentOfTheLimb*cos(Angles_Of_Each_Joint_Before((i-1)*NumberOfJointsPerLimb + j));
        BodyPlot_YLocationBefore(n) = BodyPlot_YLocationBefore(n-1) + LengthOfEachSegmentOfTheLimb*sin(Angles_Of_Each_Joint_Before((i-1)*NumberOfJointsPerLimb + j));
        
        BodyPlot_XLocationAfter(n) = BodyPlot_XLocationAfter(n-1) + LengthOfEachSegmentOfTheLimb*cos(Angles_Of_Each_Joint_After((i-1)*NumberOfJointsPerLimb + j));
        BodyPlot_YLocationAfter(n) = BodyPlot_YLocationAfter(n-1) + LengthOfEachSegmentOfTheLimb*sin(Angles_Of_Each_Joint_After((i-1)*NumberOfJointsPerLimb + j));
        n = n+1;
    end
    while j >= 1
        BodyPlot_XLocationBefore(n) = BodyPlot_XLocationBefore(n-1) - LengthOfEachSegmentOfTheLimb*cos(Angles_Of_Each_Joint_Before((i-1)*NumberOfJointsPerLimb + j));
        BodyPlot_YLocationBefore(n) = BodyPlot_YLocationBefore(n-1) - LengthOfEachSegmentOfTheLimb*sin(Angles_Of_Each_Joint_Before((i-1)*NumberOfJointsPerLimb + j));
        BodyPlot_XLocationAfter(n) = BodyPlot_XLocationAfter(n-1) - LengthOfEachSegmentOfTheLimb*cos(Angles_Of_Each_Joint_After((i-1)*NumberOfJointsPerLimb + j));
        BodyPlot_YLocationAfter(n) = BodyPlot_YLocationAfter(n-1) - LengthOfEachSegmentOfTheLimb*sin(Angles_Of_Each_Joint_After((i-1)*NumberOfJointsPerLimb + j));
        n = n+1;
        j = j-1;
    end
end

RealBodyPlot_XLocationBefore= zeros(NumberOfJointsPerLimb*NumberOfLimbs,1);
RealBodyPlot_XLocationAfter= zeros(NumberOfJointsPerLimb*NumberOfLimbs,1);
RealBodyPlot_YLocationBefore= zeros(NumberOfJointsPerLimb*NumberOfLimbs,1);
RealBodyPlot_YLocationAfter = zeros(NumberOfJointsPerLimb*NumberOfLimbs,1);

TotalXMovement = 0;
TotalYMovement = 0;

for i = 1:NumberOfLimbs
RealBodyPlot_XLocationBefore((i-1)*NumberOfJointsPerLimb + 1:i*NumberOfJointsPerLimb) = BodyPlot_XLocationBefore(2*NumberOfJointsPerLimb*(i-1)+2:2*NumberOfJointsPerLimb*(i-1)+1 + NumberOfJointsPerLimb);
RealBodyPlot_XLocationAfter((i-1)*NumberOfJointsPerLimb + 1:i*NumberOfJointsPerLimb) = BodyPlot_XLocationAfter(2*NumberOfJointsPerLimb*(i-1)+2:2*NumberOfJointsPerLimb*(i-1)+1 + NumberOfJointsPerLimb);
RealBodyPlot_YLocationBefore((i-1)*NumberOfJointsPerLimb + 1:i*NumberOfJointsPerLimb) = BodyPlot_YLocationBefore(2*NumberOfJointsPerLimb*(i-1)+2:2*NumberOfJointsPerLimb*(i-1)+1 + NumberOfJointsPerLimb);
RealBodyPlot_YLocationAfter((i-1)*NumberOfJointsPerLimb + 1:i*NumberOfJointsPerLimb) = BodyPlot_YLocationAfter(2*NumberOfJointsPerLimb*(i-1)+2:2*NumberOfJointsPerLimb*(i-1)+1 + NumberOfJointsPerLimb);
end

TotalXMovement = TotalXMovement + sum(RealBodyPlot_XLocationAfter - RealBodyPlot_XLocationBefore);
TotalYMovement = TotalYMovement + sum(RealBodyPlot_YLocationAfter - RealBodyPlot_YLocationBefore);


ForceMobilityFactor = 0.2;

NewBodyLocation(1) = MyLocation(1) - ForceMobilityFactor*TotalXMovement;
NewBodyLocation(2) = MyLocation(2) - ForceMobilityFactor*TotalYMovement;





%% Changing the orientation
RelativeXMovement = RealBodyPlot_XLocationAfter - RealBodyPlot_XLocationBefore;
RelativeYMovement = RealBodyPlot_YLocationAfter - RealBodyPlot_YLocationBefore;
RadiusFromCenterOfMass = sqrt((RealBodyPlot_XLocationBefore - MyLocation(1)).^2 + (RealBodyPlot_YLocationBefore - MyLocation(2)).^2);
TotalMovement = sqrt(RelativeXMovement.^2 + RelativeYMovement.^2);


AngleOfRadius = atan((RealBodyPlot_XLocationAfter - MyLocation(1))./(RealBodyPlot_YLocationAfter - MyLocation(2)));
AngleOfMovement = atan(RelativeYMovement./RelativeXMovement);
    %end
%if MyLocation(1) ~= 0
%AngleOfRadius = atan((BodyPlot_XLocationBefore - MyLocation(1).)/(BodyPlot_YLocationBefore - MyLocation(2)));
%end



%if sum(RelativeYMovement) ~= 0
%    if sum(RelativeXMovement) ~= 0

%    end
%end
%if sum(RelativeYMovement) == 0
%AngleOfMovement=0;
%end

Total_Torque = sum(RadiusFromCenterOfMass.*TotalMovement.*sin(AngleOfMovement - AngleOfRadius));

TorqueMobilityFactor = 2;
RotationAngle = TorqueMobilityFactor*Total_Torque/sum(RadiusFromCenterOfMass.^2);

Angles_Of_Each_Joint_Before = Angles_Of_Each_Joint_Before + RotationAngle;
Angles_Of_Each_Joint_After = Angles_Of_Each_Joint_After + RotationAngle;
