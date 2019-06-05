
clear
AnyFunction_Transformation = 1;
PowerTransformation = 0;
x1 = -2:0.1:2;
y1 = -2:0.1:2;




x = ones(length(x1))*diag(x1);
y = diag(y1)*ones(length(x1));
plot(x,y,'-b',y,x,'-r')


if PowerTransformation == 1
InitialPower = 1;
FinalPower = -4;


power = fliplr(FinalPower:0.01:InitialPower);
for n = 1:length(power)
    pause(exp(-n+1));
z = x + 1i*y;
f =@(z) z.^(power(n));

w = f(z);
x1 = real(w);
y1 = imag(w);

plot(x1,y1,'-b',y1,x1,'-r');
xlim([-2 2]);
ylim([-2 2]);
f1(n) = getframe(gcf);

end


end




if AnyFunction_Transformation == 1
InitialPower = 1;
FinalPower = -4;


Coefficient = fliplr(FinalPower:0.01:InitialPower);
for n = 1:length(Coefficient)
    pause(exp(-n+1));
z = x + 1i*y;
f =@(z) (1/Coefficient(n))*sin(Coefficient(n)*z);

w = f(z);
x1 = real(w);
y1 = imag(w);

plot(x1,y1,'-b',y1,x1,'-r');
xlim([-2 2]);
ylim([-2 2]);
f1(n) = getframe(gcf);

end


end

savevideo = 0;
if savevideo == 1
        v = VideoWriter('Conformal Transformation Video.avi','Uncompressed AVI');
        open(v)
        writeVideo(v,f1)
        close(v)
end