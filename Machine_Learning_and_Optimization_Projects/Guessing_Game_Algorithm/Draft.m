function [Parameters,Cost] = Draft(Parameters,NumberRandomVectors)
clear
NumberRandomVectors = 5;
Parameters = rand(30,1);
dt = 0.01;
LearningRate = 0.1;
for itteration = 1:10
    
    RandomVectors = rand(length(Parameters),NumberRandomVectors)-0.5;
    for i = 1:NumberRandomVectors
        LengthOfVectors(i) = sqrt(RandomVectors(:,i).'*RandomVectors(:,i));
    end
    
    for vector = 1:NumberRandomVectors
        for i = 1:3
            ParametersArray(:,i + 3*(vector-1)) = Parameters + (i-2)*dt*RandomVectors(:,vector);
        end
    end
    
    
    %% Calculate Cost Function
    [CostVector] = CostFunction(ParametersArray);
    
    for i = 1:NumberRandomVectors
        %%Calculate Gradients
        Gradient(i) = (CostVector(3 + 3*(i-1)) - CostVector(1 + 3*(i-1)))/(LengthOfVectors(i)*dt);
        %% Calculate Diagonal Hessian
        Hessian(i) = (2*CostVector(2 + 3*(i-1)) - CostVector(3 + 3*(i-1)) - CostVector(1 + 3*(i-1)))/((LengthOfVectors(i)*dt)^2);
    end
    
    
    Parameters = Parameters - LearningRate*sum((RandomVectors*diag((Hessian>0).*Gradient./Hessian - (Hessian<0).*Gradient./Hessian)).').';
    
    [Cost(itteration )] = CostFunction(Parameters)
    
end
a = 1;