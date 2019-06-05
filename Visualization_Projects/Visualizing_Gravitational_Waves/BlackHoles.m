[x,y,z] = sphere;
TimePeriod = 100;
NumberOfPeriods = 11;
R = 3
w = 2*pi/TimePeriod;
RecordVideo =0;

for t = 1:TimePeriod*NumberOfPeriods


surf(x + R*cos(w*t),y + R*sin(w*t),z) % centered at (3,-2,0) 
hold on 
surf(x - R*cos(w*t),y - R*sin(w*t),z) % centered at (0,1,-3)
map = [0,0,0];
colormap(map)
hold off

%set(gca,'XTick',[])
%set(gca,'YTick',[])
set(gca,'ZTick',[])
xlim([-(R+1) (R+1)])
ylim([-(R+1) (R+1)])
zlim([-(R+1) (R+1)])

az = 322.5;
el = 30;


if t>=200
    az = 322.5-(t-200)/5;
    el = 30+(t-200)/5;
    if t >=500
        el = 90;
    end
    if t >=700
            set(gca,'XTick',[])
            set(gca,'YTick',[])
            if t >= 913
                az = 180;
            end
    end

end

view(az, el);
M(t)=getframe(gcf);
end

if RecordVideo ==1
v = VideoWriter('Circular Black Holes.avi','Uncompressed AVI');
open(v)
writeVideo(v,M)
close(v)
end