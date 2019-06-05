function [f] = GNN_PlotBody(Xlimits,Ylimits,MyLocation,NumberOfLimbs,NumberOfJointsPerLimb,LengthOfEachSegmentOfTheLimb,Angles_Of_Each_Joint,FoodLocation);

%% Ploting initial state
BodyPlot_XLocation(1) = MyLocation(1);
BodyPlot_YLocation(1) = MyLocation(2);
n = 2;


for i = 1:NumberOfLimbs
    for j = 1:NumberOfJointsPerLimb
        BodyPlot_XLocation(n) = BodyPlot_XLocation(n-1) + LengthOfEachSegmentOfTheLimb*cos(Angles_Of_Each_Joint((i-1)*NumberOfJointsPerLimb + j));
        BodyPlot_YLocation(n) = BodyPlot_YLocation(n-1) + LengthOfEachSegmentOfTheLimb*sin(Angles_Of_Each_Joint((i-1)*NumberOfJointsPerLimb + j));
        n = n+1;
    end
    while j >= 1
        BodyPlot_XLocation(n) = BodyPlot_XLocation(n-1) - LengthOfEachSegmentOfTheLimb*cos(Angles_Of_Each_Joint((i-1)*NumberOfJointsPerLimb + j));
        BodyPlot_YLocation(n) = BodyPlot_YLocation(n-1) - LengthOfEachSegmentOfTheLimb*sin(Angles_Of_Each_Joint((i-1)*NumberOfJointsPerLimb + j));
        n = n+1;
        j = j-1;
    end
end

f = plot(BodyPlot_XLocation,BodyPlot_YLocation,'-',FoodLocation(1),FoodLocation(2),'rs');
        xlim([Xlimits(1) Xlimits(2)])
        ylim([Ylimits(1) Ylimits(2)])