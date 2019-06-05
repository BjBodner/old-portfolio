function[] = Specific_TGA_Run()
UsePresetParameters = 1;

if UsePresetParameters == 1
NumberOfFamilies = 10;
NumberOfGenerations = 10;


TargetedSearchDecayRate = 1;
RandomSearchGrowthRate = 0.5;

TargetedMultiplicationFactor = 10;
RandomMultiplicationFactor = 0.1;

NumberOfFailedAttempts_ForGivingUp = 5;
SignificantChangeValue = 0.1;

NumberOfindividuals = 40;
end


Generation = zeros(NumberOfFamilies,1);
MinDistance = zeros(NumberOfFamilies,1);

for family = 1:NumberOfFamilies
    InitialPopulationLocation = rand(2,NumberOfindividuals);
    IndividualLocation = InitialPopulationLocation;
    Target = 30*rand(2,1);
    ImprovementItteration = 1;
    generation = 1;
    
    %for generation = 1:NumberOfGenerations
    while ImprovementItteration < NumberOfFailedAttempts_ForGivingUp
        if generation >1
            % targeted random search
            ChangeVector = NewFittestIndividual - OldFittestIndividual;
           % if sum(ChangeVector) < 0.2
           %     IndividualLocation = NewFittestIndividual + rand(2,NumberOfindividuals);
           % end
            if sum(abs(ChangeVector)) > SignificantChangeValue
                ImprovementItteration = 1;
            end
                TargetedSearch = exp(-(ImprovementItteration-1)/TargetedSearchDecayRate)*diag(TargetedMultiplicationFactor*(Old_M - New_M)*ChangeVector)*ones(2,NumberOfindividuals)*diag(rand(NumberOfindividuals,1));
                RandomSearch = exp((ImprovementItteration-1)*RandomSearchGrowthRate)*RandomMultiplicationFactor*(rand(2,NumberOfindividuals)-0.5);
                IndividualLocation = NewFittestIndividual + TargetedSearch + RandomSearch;
            
            
            IndividualLocation(:,1) = NewFittestIndividual;
            OldFittestIndividual = NewFittestIndividual;
            Old_M = New_M;
        end
        FittnessFunction = sum(sqrt((IndividualLocation - diag(Target)*ones(size(IndividualLocation))).^2));
        [New_M,I] = min(FittnessFunction);
        NewFittestIndividual = IndividualLocation(:,I);
        if generation == 1
            OldFittestIndividual = NewFittestIndividual;
            Old_M = New_M;
        end
        
        
        ImprovementItteration = ImprovementItteration +1;
        
        
        
        
        PlotSystem = 1;
        if PlotSystem == 1
            scatter(IndividualLocation(1,:),IndividualLocation(2,:));
            hold on
            scatter(Target(1),Target(2),'rd','filled');
            hold off
            xlim([0 30])
            ylim([0 30])
            getframe(gcf);
         
        end
        generation = generation + 1;
    end


IndividualLocation = diag(NewFittestIndividual)*ones(size(IndividualLocation));

            scatter(IndividualLocation(1,:),IndividualLocation(2,:));
            hold on
            scatter(Target(1),Target(2),'rd','filled');
            hold off
            xlim([0 30])
            ylim([0 30])
            getframe(gcf);

Generation(family) = generation;
MinDistance(family) = New_M;
end

Average_Generation = mean(Generation)
Average_MinDistance = mean(MinDistance)