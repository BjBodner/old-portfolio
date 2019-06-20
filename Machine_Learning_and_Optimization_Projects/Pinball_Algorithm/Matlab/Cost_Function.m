function [Cost] = Cost_Function(ParameterVector)

Cost = abs(sum(ParameterVector.^2));