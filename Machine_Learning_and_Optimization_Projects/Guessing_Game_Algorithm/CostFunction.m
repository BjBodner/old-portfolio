function [CostVector] = CostFunction(ParametersArray)
CostVector = zeros(length(ParametersArray(1,:)),1);
for i = 1:length(ParametersArray(1,:))
    CostVector(i) = abs(sum(ParametersArray(:,i)))^2 +5*sum(ParametersArray(:,i))^2 + sum(ParametersArray(:,i).^2)  + sum(sin(ParametersArray(:,i)).^2);
end