function [Suggested_Parameter_Samples_From_Guessing_Game] = Guessing_Game_Optimizer_Part2(Initial_Parameters,NumberRandomVectors,CostVector,dt,RandomVectors,LengthOfVectors,LearningRate)

Gradient = zeros(NumberRandomVectors,1);
Hessian = zeros(NumberRandomVectors,1);
    for i = 1:NumberRandomVectors
        %%Calculate Gradients
        Gradient(i) = (CostVector(3 + 3*(i-1)) - CostVector(1 + 3*(i-1)))/(LengthOfVectors(i)*dt);
        %% Calculate Diagonal Hessian
        Hessian(i) = (2*CostVector(2 + 3*(i-1)) - CostVector(3 + 3*(i-1)) - CostVector(1 + 3*(i-1)))/((LengthOfVectors(i)*dt)^2);
    end
    
    
    Suggested_Parameter_Samples_From_Guessing_Game = Initial_Parameters - LearningRate*sum((RandomVectors*diag((Hessian>0).*Gradient./Hessian - (Hessian<0).*Gradient./Hessian)).').';

