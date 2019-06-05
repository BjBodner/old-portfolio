function [Suggested_Parameter_Samples_From_Guessing_Game] = Guessing_Game_Optimizer(Parameters,NumberRandomVectors)


%UsePresetParameters = 1;
%if UsePresetParameters == 1
%NumberRandomVectors = 5;
%Parameters = rand(100000,1);
%Epsilon = 0.0001;
%end

dt = 0.01;
LearningRate = 0.001;
%NumberOfItterations = 20;

%for itteration = 1:NumberOfItterations
    
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
    
    [Cost(itteration )] = CostFunction(Parameters);
    
    if itteration > 1
    if abs(Cost(itteration ) - Cost(itteration -1))/Cost(itteration )< Epsilon
        Final_Itteration = itteration
        break
    end
    end
%end



%plot(Cost)
%title(['Final Cost:', num2str(min(Cost))])
%getframe(gcf);

%a = 1;

%% Note - Because this converges so fast
%% it could be possible to just run many initializations in parallel for this
