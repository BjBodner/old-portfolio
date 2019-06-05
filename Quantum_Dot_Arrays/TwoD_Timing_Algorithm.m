

function [TimeVector,NumberOfMove] = TwoD_Timing_Algorithm(EnergyDifference,NumberOfMove,TimeVector)
%% Calculating Time of Transfer
if EnergyDifference > 0
    TimeVector(NumberOfMove) = 1/EnergyDifference;
end
if EnergyDifference == 0
    TimeVector(NumberOfMove) = 0;
end

NumberOfMove = NumberOfMove+1;