TimePeriod = 100;
NumberOfPeriods = 7;
AS_Waves_Amplitude = 0.2;
S_Waves_Amplitude = 0.2;
DomainDivision = 50;
plotcircle = 1;
plotarrow = 0;
plotsurface = 1;
RecordVideo =1;


w = 2*pi/TimePeriod;
el_limit = 0;
az_limit = 0;

for t = 1:NumberOfPeriods*TimePeriod
x = -DomainDivision/2*(1 + AS_Waves_Amplitude*cos(w*t) - S_Waves_Amplitude*sin(w*t)):(1 + AS_Waves_Amplitude*cos(w*t) - S_Waves_Amplitude*sin(w*t)):DomainDivision/2*(1 + AS_Waves_Amplitude*cos(w*t) - S_Waves_Amplitude*sin(w*t));
y = -DomainDivision/2*(1 - AS_Waves_Amplitude*cos(w*t) + S_Waves_Amplitude*sin(w*t)):(1 - AS_Waves_Amplitude*cos(w*t) + S_Waves_Amplitude*sin(w*t)):DomainDivision/2*(1 - AS_Waves_Amplitude*cos(w*t) + S_Waves_Amplitude*sin(w*t));
z = 0.01*sin(2*pi*x/100).'*sin(2*pi*y/100);
mesh(x,y,z);

if plotcircle == 1
        hold on
        r = DomainDivision/8;
        ang=0:2*pi/20:2*pi; 
        xp=r*cos(ang);
        yp=r*sin(ang);
        z2 = zeros(max(size(xp)),max(size(xp)));
        z3 = 0.05*ones(max(size(xp)),max(size(xp)));
        plot3((xp)*(1 + AS_Waves_Amplitude*cos(w*t) - S_Waves_Amplitude*sin(w*t)),(yp)*(1 - AS_Waves_Amplitude*cos(w*t) + S_Waves_Amplitude*sin(w*t)),z2, 'ro');
        plot3((xp)*(1 + AS_Waves_Amplitude*cos(w*t) - S_Waves_Amplitude*sin(w*t)),(yp)*(1 - AS_Waves_Amplitude*cos(w*t) + S_Waves_Amplitude*sin(w*t)),z3, 'ro');
        hold off
end





if plotarrow == 1

    drawArrow = @(x,y,z) quiver3( x(1),y(1),z(1),x(2)-x(1),y(2)-y(1),z(2)-z(1))  ;
    
    hold on
    x1 = [0  5*(1 + AS_Waves_Amplitude*cos(w*t) - S_Waves_Amplitude*sin(w*t))];
    y1 = [0 0];
    z1 = [0 0];
    drawArrow(x1,y1,z1);

    hold on
    x2 = [0  -5*(1 + AS_Waves_Amplitude*cos(w*t) - S_Waves_Amplitude*sin(w*t))];
    drawArrow(x2,y1,z1); 
    
    hold on
    x3 = [0 0];
    y2 = [0 5*(1 - AS_Waves_Amplitude*cos(w*t) + S_Waves_Amplitude*sin(w*t))];
    z1 = [0 0];
    drawArrow(x3,y2,z1);  
    
    hold on
    x3 = [0 0];
    y3 = [0 -5*(1 - AS_Waves_Amplitude*cos(w*t) + S_Waves_Amplitude*sin(w*t))];
    z1 = [0 0];
    drawArrow(x3,y3,z1);  
    
    hold off
end

if plotsurface == 1
map = [0,1,0];
end
if plotsurface == 0
map = [1,1,1];
end

colormap(map);
xlim([-DomainDivision/4 DomainDivision/4])
ylim([-DomainDivision/4 DomainDivision/4])
zlim([-1 1])
set(gca,'XTick',[])
set(gca,'YTick',[])
set(gca,'ZTick',[])

az = 322.5 +t/10;
el = 30+t/5;
if el>=90
    el_limit = 1;
end
if el_limit ==1
    el = 90;
    plotarrow = 1;

    if az>=359.5
    az = 359.5;
    end

    if t >= 500
        el = 190-t/5;
        az = 409.5  - t/10;
    end
    
end
    




view(az, el);

M1(t)=getframe(gcf); % leaving gcf out crops the frame in the movie.

end


if RecordVideo ==1
v = VideoWriter('GravityWaves_Circular_HighQual.avi','Uncompressed AVI');
open(v)
writeVideo(v,M1)
close(v)
end