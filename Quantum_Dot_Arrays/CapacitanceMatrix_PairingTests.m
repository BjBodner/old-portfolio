function [Energy_Graph] = CapacitanceMatrix_PairingTests(NumberOfDots)


   Q1_1 = rand(NumberOfDots,NumberOfDots);
   Q2 = rand(NumberOfDots,NumberOfDots);

   Q1_1(2,2) = Q1_1(2,2) + 1;
   Q1_1(12,12) = Q1_1(12,12) + 1;
   
   Q2(2,2) = Q2(2,2) + 1;
   Q2(5,2) = Q2(5,2) + 1;
   

       
   
[x,y] = meshgrid(1:1:NumberOfDots,1:1:NumberOfDots);
FinalCCg = 100
InitialCCg = 0.1
InitialCg = 1
InitialC = InitialCg*InitialCCg
NumberOfSteps = 20;
PowerDifference = log10(FinalCCg/InitialCCg)

for n = 1:NumberOfSteps
    C = InitialC*10^((n*(PowerDifference/NumberOfSteps))/2)
    Cg = InitialCg*10^(-(n*(PowerDifference/NumberOfSteps))/2)
 %   CCg = C/Cg;
    CCg(n) = C/Cg
    
    %% Regular invCM - Round Influence
   % [invCM,CM] = TwoDim_invCM_Generator(C,Cg,NumberOfDots);
    
    %% Different Lines invCM
   [invCM,CM] = TwoDim_Special_invCM_Generator1(C,Cg,NumberOfDots);

    %% Oscilating Left Right invCm
   % [invCM,CM] = TwoDim_Special_invCM_Generator2(C,Cg,NumberOfDots);

   %% Eliptic 1 invCM - long in x direction
 %  [invCM,CM] = TwoDim_Special_invCM_Generator3(C,Cg,NumberOfDots);
   
   %% Eliptic 2 invCM - long in y direction
   %[invCM,CM] = TwoDim_Special_invCM_Generator4(C,Cg,NumberOfDots);
   
    EnergyOfTwoSeperateDots(n) = 0.5*reshape(Q1_1,1,NumberOfDots*NumberOfDots)*invCM*reshape(Q1_1,NumberOfDots*NumberOfDots,1);

    EnergyOfTwoJoinedDots(n) = 0.5*reshape(Q2,1,NumberOfDots*NumberOfDots)*invCM*reshape(Q2,NumberOfDots*NumberOfDots,1);
    
end

Energy_Graph = loglog(CCg,EnergyOfTwoSeperateDots,'-rs',CCg,EnergyOfTwoJoinedDots,'-bs')
title(sprintf('Energy of 2 Charges, far apart in red, and close in blue \n For 2D array of  %g by %g dots',NumberOfDots,NumberOfDots))
