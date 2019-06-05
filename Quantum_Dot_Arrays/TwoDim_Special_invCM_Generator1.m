



function [invCM,CM] = TwoDim_Special_invCM_Generator1(C,Cg,NumberOfDots)
%v = (3*C + Cg)*ones(NumberOfDots*NumberOfDots,1);
%v(NumberOfDots+1:NumberOfDots*NumberOfDots-NumberOfDots) = 4*C+Cg;
%% Before Change
%% v = (4*C + Cg)*ones(NumberOfDots*NumberOfDots,1);
%CM = diag(v);
CM = zeros(NumberOfDots^2,NumberOfDots^2);
Ceven = 0.5*C;
Codd = 5*C;


for l = 0:NumberOfDots-1
	for p = 2:NumberOfDots
		CM(p + l*NumberOfDots, p - 1 + l*NumberOfDots) = -C;
		CM(p - 1 + l*NumberOfDots, p + l*NumberOfDots) = -C;
	end
end

%% Adding interaction elements
for j = 1:NumberOfDots*NumberOfDots - NumberOfDots
    
    if mod(j,2) == 1
        CM(NumberOfDots + j,j) = -Codd;
        CM(j,NumberOfDots + j) = -Codd;
    end
    if mod(j,2) == 0
        CM(NumberOfDots + j,j) = -Ceven;
        CM(j,NumberOfDots + j) = -Ceven;
    end    
    
end



for i = 1:NumberOfDots^2
    CM(i,i) = -sum(CM(i,:)) + Cg;
end

for i = 1:NumberOfDots:NumberOfDots^2 - NumberOfDots + 1
    CM(i,i) = CM(i,i) + C;
end
for i = NumberOfDots:NumberOfDots:NumberOfDots^2
    CM(i,i) = CM(i,i) + C;
end
%%Changing Self capacitance elements of edge dots


% Before Change 
%for t = 0:NumberOfDots-1
%	CM(1 + t*NumberOfDots,1 + t*NumberOfDots) = 3*C + Cg;
 %   CM(NumberOfDots + t*NumberOfDots,NumberOfDots + t*NumberOfDots) = 3*C + Cg;
%end

CM;
invCM = inv(CM);

