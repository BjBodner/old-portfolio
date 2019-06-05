



function [invCM,CM] = TwoDim_Special_invCM_Generator6(C,Cg,NumberOfDots)

%% Screening length increases as a function of x

%%\lambda = sqrt(c/cg)*x


CM = zeros(NumberOfDots^2,NumberOfDots^2);
%% Adding the regular elements
for l = 0:NumberOfDots-1
	for p = 2:NumberOfDots
		CM(p + l*NumberOfDots, p - 1 + l*NumberOfDots) = -C;
		CM(p - 1 + l*NumberOfDots, p + l*NumberOfDots) = -C;
	end
end
for j = 1:NumberOfDots*NumberOfDots - NumberOfDots
	CM(NumberOfDots + j,j) = -C;
	CM(j,NumberOfDots + j) = -C;
end


%% adding the increasing with distance elements
for i = 1:NumberOfDots^2
    for j = 1:NumberOfDots
        if mod(i,NumberOfDots) == j;
            CM(i,i+1) = -C*j^2;
            CM(i+1,i) = CM(i,i+1);
        end
    end
end


%% suming all the adjacent elements, to get the self capacitance
for i = 1:NumberOfDots^2
    CM(i,i) = -sum(CM(i,:)) + Cg;
end

for i = 1:NumberOfDots:NumberOfDots^2 - NumberOfDots + 1
    CM(i,i) = CM(i,i) + C;
end
for i = NumberOfDots:NumberOfDots:NumberOfDots^2
    CM(i,i) = CM(i,i) + C;
end


CM;
invCM = inv(CM);

