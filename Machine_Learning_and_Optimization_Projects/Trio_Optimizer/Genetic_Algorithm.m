function [Suggested_Parameter_Samples_From_Genetic_Algorithm] = Genetic_Algorithm(InitialParameters,SecondBest_Parameters,NumberOfSamples,MutationAmplitude)

KillingVector = rand(length(InitialParameters),NumberOfSamples)>0.5;
Mutation = MutationAmplitude*(rand(length(InitialParameters),NumberOfSamples) - 0.5);
Suggested_Parameter_Samples_From_Genetic_Algorithm = zeros(length(InitialParameters),NumberOfSamples);

for i = 1:NumberOfSamples
Suggested_Parameter_Samples_From_Genetic_Algorithm(:,i) = InitialParameters.*KillingVector(:,i) + SecondBest_Parameters.*(1-KillingVector(:,i)) + Mutation(:,i);
end