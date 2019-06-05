%% Generating Seed For The Inside Algorithm
NumberOfFamilies = 10;
NumberOfGenerations = 10;
TargetedSearchDecayRate = 1;
RandomSearchGrowthRate = 0.5;
TargetedMultiplicationFactor = 10;
RandomMultiplicationFactor = 0.1;
NumberOfFailedAttempts_ForGivingUp = 5;
SignificantChangeValue = 0.1;
NumberOfindividuals = 40;

InitialSeedOfParameters = [TargetedSearchDecayRate RandomSearchGrowthRate TargetedMultiplicationFactor RandomMultiplicationFactor NumberOfFailedAttempts_ForGivingUp SignificantChangeValue NumberOfindividuals NumberOfFamilies].';



%% Generating Seed For The Optimizing Algorithm
NumberOfFamilies = 1;
NumberOfGenerations = 10;
TargetedSearchDecayRate = 1;
RandomSearchGrowthRate = 0.5;
TargetedMultiplicationFactor = 10;
RandomMultiplicationFactor = 0.1;
NumberOfFailedAttempts_ForGivingUp = 5;
SignificantChangeValue = 0.1;
NumberOfindividuals = 200;

PlotSystem = 0;
FittestParameters = zeros(length(InitialSeedOfParameters),NumberOfFamilies);
FittestNumberOfGenerations= zeros(1,NumberOfFamilies);

for family = 1:NumberOfFamilies
    
    InitialPopulationLocation = InitialSeedOfParameters + 10*(rand(length(InitialSeedOfParameters),NumberOfindividuals)-0.5);
    
    Individuals_Parameters = InitialPopulationLocation;

    ImprovementItteration = 1;
    generation = 1;
    tic
    %for generation = 1:NumberOfGenerations
    while ImprovementItteration < NumberOfFailedAttempts_ForGivingUp
        if generation >1

            ChangeVector = NewFittestIndividual - OldFittestIndividual;

            if sum(abs(ChangeVector)) > SignificantChangeValue
                ImprovementItteration = 1;
            end
                TargetedSearch = exp(-(ImprovementItteration-1)/TargetedSearchDecayRate)*diag(TargetedMultiplicationFactor*(Old_M - New_M)*ChangeVector)*ones(length(InitialSeedOfParameters),NumberOfindividuals)*diag(rand(NumberOfindividuals,1));
                RandomSearch = exp((ImprovementItteration-1)*RandomSearchGrowthRate)*RandomMultiplicationFactor*(rand(length(InitialSeedOfParameters),NumberOfindividuals)-0.5);
                Individuals_Parameters = NewFittestIndividual + TargetedSearch + RandomSearch;
            
            
            Individuals_Parameters(:,1) = NewFittestIndividual;
            OldFittestIndividual = NewFittestIndividual;
            Old_M = New_M;
        end
        Individuals_Parameters = abs(Individuals_Parameters);
        AlgorithmFittnessFunction  = zeros(1,NumberOfindividuals);
        
        for individual = 1:NumberOfindividuals
        [Average_Generation,Average_MinDistance] = Specific_TGA_Run(Individuals_Parameters(:,individual),PlotSystem);
        
        AlgorithmFittnessFunction(individual) = (Average_MinDistance < 0.1)*(1000-Average_Generation);
        %FittnessFunction = sum(sqrt((Individuals_Parameters - diag(Target)*ones(size(Individuals_Parameters))).^2));
        end
        
        
        
        [New_M,I] = max(AlgorithmFittnessFunction);
        NewFittestIndividual = Individuals_Parameters(:,I);
        if generation == 1
            OldFittestIndividual = NewFittestIndividual;
            Old_M = New_M;
        end
        
        
        ImprovementItteration = ImprovementItteration +1;
        

        generation = generation + 1
        
        if New_M > 988
            break
        end
    end
toc

%Individuals_Parameters = diag(NewFittestIndividual)*ones(size(Individuals_Parameters));
FittestParameters(:,family) = NewFittestIndividual;

PlotSystem = 0;
[Average_Generation,Average_MinDistance] = Specific_TGA_Run(NewFittestIndividual,PlotSystem);
PlotSystem = 0;
FittestNumberOfGenerations(family) = Average_Generation;

generation
New_M
end



%% PlayBack Of Top 3 Solutions
PlotSystem = 1;
for i = 1:3
    i
    [M,I] = min(FittestNumberOfGenerations);
    FittestParameters(8,I) = 5;
[Average_Generation,Average_MinDistance] = Specific_TGA_Run(FittestParameters(:,I),PlotSystem);

FittestNumberOfGenerations(I) = 10*FittestNumberOfGenerations(I);
end