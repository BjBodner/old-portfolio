clear
dt = 0.1
T_total = 100
x0 = 5
v0 = 1

r= [x0, 0, 0]
v= [0, v0, 0]
m = 1
run_simulation = 0
if run_simulation == 1
l = m*norm(r)*norm(v)
F = -r*4*pi^2./(norm(r)^3) + r*l^2/(m*norm(r)^4)
for i = 1:T_total/dt
    F = -r*4*pi^2./(norm(r)^3) + r*l^2/(m*norm(r)^4);
    v = v + (F/m)*dt;
    r = r + v*dt + 0.5*(F/m)*dt^2;
    r_vector(:,i) = r;
    plot(r_vector(1,:),r_vector(2,:))
    hold on
    scatter(r_vector(1,i),r_vector(2,i))
    hold off
    xlim([-10 10])
    ylim([-10 10])
    getframe(gcf)
    
    Lagrangian(i) = 0.5*m*norm(v)^2  + 4*pi^2./(norm(r)^1)
end

end



v = 2
k = 1
x = 0
[X,Y] = meshgrid(1:3,10:14)
[x1,v1] = meshgrid(-5:0.1:5,-5:0.1:5)
Lagrangian = 0.5*m*v1.^2  - 0.5*k*x1.^2
v = 2
k = 1
x = 0
dt = 0.01
Lagrangian_Integral = 0;
for i = 1:5000
F = -k*x
v = v + (F/m)*dt;
x = x + v*dt + 0.5*(F/m)*dt^2;
x_vector(i) = x;
v_vector(i) = v;
Lagrangian_Integral = Lagrangian_Integral + 0.5*m*v.^2  - 0.5*k*x.^2;
Lagrangian_Integral_Vector(i) = Lagrangian_Integral;
end
figure
surf(x1,v1,Lagrangian)
z = zeros(1,length(x_vector));
hold on
plot3(x_vector,v_vector,z,'r','LineWidth',2)
hold off

figure
plot(Lagrangian_Integral_Vector)