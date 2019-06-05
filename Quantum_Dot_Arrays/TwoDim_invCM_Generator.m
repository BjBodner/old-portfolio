

%% Propper CM for 2D

function [invCM,CM] = TwoDim_invCM_Generator(C,Cg,NumberOfDots)

%v = (3*C + Cg)*ones(NumberOfDots*NumberOfDots,1);
%v(NumberOfDots+1:NumberOfDots*NumberOfDots-NumberOfDots) = 4*C+Cg;

v = (3*C + Cg)*ones(NumberOfDots(1)*NumberOfDots(2),1);
v(NumberOfDots(1)+1:NumberOfDots(1)*NumberOfDots(2)-NumberOfDots(1)) = 4*C+Cg;
%% Before Change
%% v = (4*C + Cg)*ones(NumberOfDots*NumberOfDots,1);
CM = diag(v);

%for l = 0:NumberOfDots-1
%	for p = 2:NumberOfDots
%		CM(p + l*NumberOfDots, p - 1 + l*NumberOfDots) = -C;
%		CM(p - 1 + l*NumberOfDots, p + l*NumberOfDots) = -C;
%	end
%end

for l = 0:NumberOfDots(2)-1
	for p = 2:NumberOfDots(1)
		CM(p + l*NumberOfDots(1), p - 1 + l*NumberOfDots(1)) = -C;
		CM(p - 1 + l*NumberOfDots(1), p + l*NumberOfDots(1)) = -C;
	end
end


%% Adding interaction elements
%for j = 1:NumberOfDots*NumberOfDots - NumberOfDots
%	CM(NumberOfDots + j,j) = -C;
%	CM(j,NumberOfDots + j) = -C;
%end


for j = 1:NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(1)
	CM(NumberOfDots(1) + j,j) = -C;
	CM(j,NumberOfDots(1) + j) = -C;
end


%% Changing Self capacitance elements of edge dots


% Before Change 
%for t = 0:NumberOfDots-1
%	CM(1 + t*NumberOfDots,1 + t*NumberOfDots) = 3*C + Cg;
 %   CM(NumberOfDots + t*NumberOfDots,NumberOfDots + t*NumberOfDots) = 3*C + Cg;
%end

CM;
invCM = inv(CM);

