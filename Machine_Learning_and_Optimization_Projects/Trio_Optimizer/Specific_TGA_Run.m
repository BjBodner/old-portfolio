function[Average_Generation,Average_MinDistance] = Specific_TGA_Run(Individuals_Parameters,PlotSystem)





TargetedSearchDecayRate = Individuals_Parameters(1);
RandomSearchGrowthRate = Individuals_Parameters(2);

TargetedMultiplicationFactor = Individuals_Parameters(3);
RandomMultiplicationFactor = Individuals_Parameters(4);

NumberOfFailedAttempts_ForGivingUp = ceil(Individuals_Parameters(5));
SignificantChangeValue = Individuals_Parameters(6);

NumberOfindividuals = round(Individuals_Parameters(7));
NumberOfFamilies = round(Individuals_Parameters(8));




UsePresetParameters = 0;

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
NewFittestIndividual = 0;
LoopEnetered = 0;

for family = 1:NumberOfFamilies
    InitialPopulationLocation = rand(2,NumberOfindividuals);
    IndividualLocation = InitialPopulationLocation;
    Target = 30*rand(2,1);
    ImprovementItteration = 1;
    generation = 1;
    
    %for generation = 1:NumberOfGenerations
    while ImprovementItteration <= NumberOfFailedAttempts_ForGivingUp
        
        LoopEnetered =1;
        
        if generation >1

            ChangeVector = NewFittestIndividual - OldFittestIndividual;

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
        %insideGeneration = generation
        if ImprovementItteration > 50
            break
        end
        if generation >= 100
            break
        end
    end

if sum(NewFittestIndividual) ~= 0
IndividualLocation = diag(NewFittestIndividual)*ones(size(IndividualLocation));
end



if PlotSystem == 1
            scatter(IndividualLocation(1,:),IndividualLocation(2,:));
            hold on
            scatter(Target(1),Target(2),'rd','filled');
            hold off
            xlim([0 30])
            ylim([0 30])
            getframe(gcf);
end


if generation == 1
    generation = 1000;
end

if LoopEnetered == 0
    a = 1
end

Generation(family) = generation;
MinDistance(family) = New_M;

if family > 10
    break
end
end

Average_Generation = mean(Generation);
Average_MinDistance = mean(MinDistance);