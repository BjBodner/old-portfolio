function [Suggested_Parameter_Samples_From_Guessing_Game] = Guessing_Game_Optimizer_Version2_Part2(Initial_Parameters,NumberRandomVectors,CostVector,dt,RandomVectors,LengthOfVectors,NumberOfSamples_For_Round2,NumberOfSamples_For_AverageVector,AmplitudeOf_SingleVectors, AmplitudeOf_EvenVectors,AmplitudeOf_RandomVectors)

Gradient = zeros(NumberRandomVectors,1);
Hessian = zeros(NumberRandomVectors,1);
Suggested_Parameter_Samples_From_Guessing_Game = zeros(length(Initial_Parameters),NumberOfSamples_For_Round2);

for vector = 1:NumberRandomVectors
    %% Calculate Gradients
    Gradient(vector) = (CostVector(3 + 2*(vector-1)) - CostVector(2 + 2*(vector-1)))/(LengthOfVectors(vector)*dt);
    %% Calculate Diagonal Hessian
    Hessian(vector) = (2*CostVector(1) - CostVector(3 + 2*(vector-1)) - CostVector(2 + 2*(vector-1)))/((LengthOfVectors(vector)*dt)^2);
end

ResizedVectorArray = (RandomVectors*diag((Hessian>0).*Gradient./Hessian - (Hessian<0).*Gradient./Hessian)).';


for sample = 1:NumberOfSamples_For_Round2
    if sample <=NumberRandomVectors
        vector = sample;
        Suggested_Parameter_Samples_From_Guessing_Game(:,sample) = Initial_Parameters - AmplitudeOf_SingleVectors*ResizedVectorArray(vector,:).';
    end
    if sample > NumberRandomVectors && sample <= NumberRandomVectors + NumberOfSamples_For_AverageVector
        Suggested_Parameter_Samples_From_Guessing_Game(:,sample) = Initial_Parameters -  AmplitudeOf_EvenVectors*rand(1,1)*sum(ResizedVectorArray).';
    end
    if sample > NumberRandomVectors + NumberOfSamples_For_AverageVector
        Suggested_Parameter_Samples_From_Guessing_Game(:,sample) = Initial_Parameters -  AmplitudeOf_RandomVectors*sum(diag(rand(NumberRandomVectors,1))*ResizedVectorArray).';
    end
end

