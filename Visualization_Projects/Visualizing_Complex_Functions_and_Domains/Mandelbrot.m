M  = 10;

for t = 1:200
    
[x,y] = meshgrid(-2*exp(-t/20):0.001:2*exp(-t/20),-2*exp(-t/20):0.001:2*exp(-t/20));

z = x+1i*y;
KillingMatrix = ones(size(x));

for i = 1:length(x)
    for j = 1:length(x)
        for k = 1:20
            if k == 1
                f1 = z(i,j);
                continue
            end
            f1 = f1^2 + z(i,j);
            
            if f1 >M % This is the condition of divergence
                KillingMatrix(i,j) = 0;
                break
            end
        end
    end
end


s1 = surf(x,y,KillingMatrix);
s1.EdgeColor = 'none';
s1.FaceColor = 'interp';
view(0,90);
xlim([-2*exp(-t/20) 2*exp(-t/20)])
ylim([-2*exp(-t/20) 2*exp(-t/20)])
f = getframe(gcf);
end