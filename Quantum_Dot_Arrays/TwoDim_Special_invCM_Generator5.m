



function [invCM,CM] = TwoDim_Special_invCM_Generator5(C,Cg,NumberOfDots)
%v = (3*C + Cg)*ones(NumberOfDots*NumberOfDots,1);
%v(NumberOfDots+1:NumberOfDots*NumberOfDots-NumberOfDots) = 4*C+Cg;
%% Before Change
%% v = (4*C + Cg)*ones(NumberOfDots*NumberOfDots,1);
%CM = diag(v);
CM = zeros(NumberOfDots^2,NumberOfDots^2);
C1 = 0.5*C;
C2 = 5*C;

for i = 1:NumberOfDots^2
    
    if mod(i,NumberOfDots) ~= 0
        if mod(floor((i-1)/NumberOfDots) +1,2) == 1
            if mod(mod(i,NumberOfDots),2) == 1
                CM(i,i+1) = -C1;
                CM(i+1,i) = CM(i,i+1);
            end
            if mod(mod(i,NumberOfDots),2) == 0
                CM(i,i+1) = -C2;
                CM(i+1,i) = CM(i,i+1);
            end
        end
        
        if mod(floor((i-1)/NumberOfDots) +1,2) == 0
            if mod(mod(i,NumberOfDots),2) == 1
                CM(i,i+1) = -C2;
                CM(i+1,i) = CM(i,i+1);
            end
            if mod(mod(i,NumberOfDots),2) == 0
                CM(i,i+1) = -C1;
                CM(i+1,i) = CM(i,i+1);
            end
        end
        
    end
    
    
    if floor((i-1)/NumberOfDots)+1 >= 2
        if mod(i,2) == 1
            CM(i,i-NumberOfDots) = -C1;
        end
        if mod(i,2) == 0
            CM(i,i-NumberOfDots) = -C2;
        end
    end
    
    if floor((i-1)/NumberOfDots) +1 <= NumberOfDots-1
        if mod(i,2) == 1
            CM(i,i+NumberOfDots) = -C2;
        end
        if mod(i,2) == 0
            CM(i,i+NumberOfDots) = -C1;
        end
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

