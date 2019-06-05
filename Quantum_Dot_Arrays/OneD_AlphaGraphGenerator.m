function [Alpha_Graph] = OneD_AlphaGraphGenerator(Vthreshold,CCg,NumberOfDots,NumberOfCapacitanceTests)

alphafunction = zeros(NumberOfCapacitanceTests,1);
figure
for n = 1:NumberOfCapacitanceTests 
alphafunction(n,1) = Vthreshold(n,1)*CCg(n,1);
end

%% Creating Graph
Alpha_Graph = loglog(CCg,alphafunction,'-s');
xlabel('CCg')
ylabel('Alpha Function')
title(['Alpha Function as a function of CCg, With 1D Array of ',num2str(NumberOfDots),' Dots'])
grid on