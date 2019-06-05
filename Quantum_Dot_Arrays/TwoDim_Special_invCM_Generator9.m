



function [invCM,CM] = TwoDim_Special_invCM_Generator9(C,Cg,NumberOfDots)

%% Screening length Perpandicular Gradiant Of a factor of 10

%%\lambda = sqrt(c/cg)*100(y/NumberOfDots)





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
    % CurrentRow = (i-mod(i,NumberOfDots))/NumberOfDots
    for j = 1:NumberOfDots
        if mod(i,NumberOfDots) == j;
            if i <NumberOfDots
               CM(i,i+1) = -C*(100/NumberOfDots);
            end
            if i >=NumberOfDots
            CM(i,i+1) = -C*((i-mod(i,NumberOfDots))/NumberOfDots)*(1000/NumberOfDots);
            end
            CM(i+1,i) = CM(i,i+1);
        end
    end
end


%% setting the capacitance of a row to be the maximal value of that row
for i = 1:NumberOfDots^2
CM(i,:) = (CM(i,:) ~=0)*min(CM(i,:));
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

