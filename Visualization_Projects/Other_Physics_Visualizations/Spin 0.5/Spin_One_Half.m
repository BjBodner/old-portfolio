dx = 0.1;
plotSystem = 1;
plotTimeEvolution = 1;

x1 = -1:dx:1;
x2 = -x1;
y1 = sqrt(1-x1.^2);
y2 = -y1;
x = [x1 x2];
y = [y1 y2];

phi = 0:2*pi/length(x):2*pi-2*pi/length(x);
r = 1;
x = r*cos(phi);
y = r*sin(phi);
%phi(length(phi)/2+1:length(phi)) = pi- phi(1:length(phi)/2);

z = zeros(size(y));
scatter3(x,y,z,2,phi);

u = zeros(size(x));
v = zeros(size(x));
w = ones(size(x));
hold on
quiver3(x,y,z,u,v,w)
hold off
    xlim([-1 1]);
    ylim([-1 1]);
    zlim([-0.5 0.5]);
pause(1);


for t = 1:50
    y1 = y*exp(-t/10) + y.*cos(phi)*(1-exp(-t/10));
   % x1 = x*exp(-t/10) + x.*cos(phi)*(1-exp(-t/10));
    
   w1= w*exp(-t/10) + w.*cos(phi)*(1-exp(-t/10));
  % v1 = v*exp(-t/10) + exp(-t/10)*sin(pi*t/20);
    v1 = v*exp(-t/10) + sin(phi)*(1-exp(-t/10));
    
    if plotSystem == 1
   scatter3(x,y1,z,2,phi);
    hold on
    quiver3(x,y1,z,u,v1,w1);
    hold off
    xlim([-1 1]);
    ylim([-1 1]);
       zlim([-0.5 0.5]);
    getframe(gcf);
    end
    t
end




for t = 1:50
  %  y1 = y*exp(-t/10) + y.*cos(phi)*(1-exp(-t/10));
   x1 = x*exp(-t/10) + x.*cos(phi)*(1-exp(-t/10));
    
      w2= w1*exp(-t/10) + w1.*cos(phi)*(1-exp(-t/10));
    u1 = u*exp(-t/10) - sin(phi)*(1-exp(-t/10));
 
      if plotSystem == 1
    scatter3(x1,y1,z,2,phi);
    hold on
    quiver3(x1,y1,z,u1,v1,w2);
    hold off
    xlim([-1 1]);
    ylim([-1 1]);
       zlim([-0.5 0.5]);
    getframe(gcf);
      end
    t
end




for t = 1:50
  %  y1 = y*exp(-t/10) + y.*cos(phi)*(1-exp(-t/10));
x2 = x1 - 0.5*(1-exp(-t/10));
      if plotSystem == 1
    scatter3(x2,y1,z,2,phi);
    hold on
    quiver3(x2,y1,z,u1,v1,w2);
    hold off
    xlim([-1 1]);
    ylim([-1 1]);
    zlim([-0.5 0.5]);
    getframe(gcf);
      end
    t
end


%% Prograssing In Time
Period = 20;

Freq = 2*pi/Period;

x = y1;
y = x2;

for t = 1:100
     
    phi_1 = phi + Freq*t;
    
w1 = w.*cos(phi_1).^2;
u1 = - sin(phi_1);
v1 =  sin(phi_1);

   % y1 = y.*sin(phi_1);
  % x1 = x.*cos(phi_1);
    
    
      if plotTimeEvolution == 1
    scatter3(x2,y1,z,2,phi);
    hold on
    quiver3(x2,y1,z,u1,v1,w2);
    hold off
    xlim([-1 1]);
    ylim([-1 1]);
   %view(30,190)
       zlim([-0.5 0.5]);
    getframe(gcf);
      end
      t
end