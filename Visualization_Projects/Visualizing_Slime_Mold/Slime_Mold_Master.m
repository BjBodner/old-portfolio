FeedingRate = 0.5;
DyingRate = 0.1
GrowthRate = 2;
Sigma = 1;
CreatedFood = 0.6;

 RecordVideo = 1;
 
[x,y] = meshgrid(1:20,1:20);
PopulationSize = zeros(size(x));


FoodSupply = 0.1*ones(size(x)) + 0.01*rand(size(x));
GroundFood = FoodSupply;
dt = 0.1;
TotalTime = 2000*dt
SpreadingSize = 0.1;

AvailableFood = GroundFood;

for t = 0:dt:TotalTime
    
    %% random pertubation
    if mod(t,40*dt) == 0
        FoodSupply;
    PopulationSize(ceil(length(x)^2*rand(1,1))) = 1;
    end
    
    
d_FoodSupply = -FeedingRate*PopulationSize.*AvailableFood + CreatedFood*(PopulationSize > SpreadingSize).*AvailableFood ;


d_PopulationSize = (-DyingRate*PopulationSize + GrowthRate*FoodSupply.*PopulationSize)*dt;


FoodSupply = d_FoodSupply + FoodSupply;



PopulationSize = PopulationSize + d_PopulationSize;
x_WithPopulation = x.*(PopulationSize > SpreadingSize);
y_WithPopulation = y.*(PopulationSize > SpreadingSize);
for i = 1:length(x)^2
    for j = 1:length(x)^2
       PopulationSize(j) = PopulationSize(j) + d_PopulationSize(i)*exp(-((x_WithPopulation(i)-x(j))^2 + (y_WithPopulation(i)-y(j))^2)/(2*Sigma^2));
    end
end

PopulationSize = PopulationSize.*(PopulationSize >0);
FoodSupply = FoodSupply.*(FoodSupply>0);


s = surf(x,y,PopulationSize);
s.FaceColor = 'interp';
s.EdgeColor = 'none';
set(gca,'xtick',[]);
set(gca,'ytick',[]);
set(gca,'ztick',[]);
zlim([0 10])
view(0,60)
f(round(t/dt)+1) = getframe(gcf);

end

if RecordVideo ==1
v = VideoWriter('NonLinearDynaimcs.avi','Uncompressed AVI');
open(v)
writeVideo(v,f)
close(v)
end


%AvailableFood = GroundFood + TransferedFood
%TransferedFood = GroundFood.*(PopulationSize ~= 0)*exp(-((x-x')^2 + (y-y')^2)/sigma)