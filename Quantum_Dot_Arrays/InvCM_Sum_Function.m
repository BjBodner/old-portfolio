
SumFunction = zeros(10,10);
for n= 1:1
    C = sqrt(10)^(6-n);
    Cg = sqrt(10)^(-6+n);
        for j = 1:1
            NumberOfDots = 10*j;
            [invCM,CM] = TwoDim_invCM_Generator(C,Cg,NumberOfDots);
            
            
            SumFunction(n,j) = sum(invCM(1,1:NumberOfDots:NumberOfDots*NumberOfDots - NumberOfDots + 1));
        end
        CCG(n) = C/Cg;
        SizeOfArray(j) = NumberOfDots*NumberOfDots;
end

%% the index of "n" - is the number of dots as multiples of 10, i.e 10*n
%% the index of "CCg" - is the the logarithmic value, base 10, of the ratio C/Cg


%%surf(CCG,NumberOfDots,SumFunction()