function [ParameterVector,CurrentCost,TotalTime] = Pinball_Optimizer(ParameterVector,Search_Ratio,NumberOfItterations,NumberOfSamples__In_Each_Itteration,AmplitudeOfLinearSearch,AmplitudeOfRandomSearch,Readout)


%% Initalize infunction arrays
ParameterArray = zeros(length(ParameterVector),NumberOfSamples__In_Each_Itteration);
Cost = zeros(NumberOfSamples__In_Each_Itteration,1);
CurrentCost = zeros(NumberOfItterations,1);
TotalTime = 0;

%% Calculate Number if linear search samples
Number_Of_Linear_Samples = round(Search_Ratio*NumberOfSamples__In_Each_Itteration);
%Number_Of_Random_Samples = round((1-Search_Ratio)*NumberOfSamples__In_Each_Itteration);
%% Generate Step Size Vector for the linear search
dL = AmplitudeOfLinearSearch/Number_Of_Linear_Samples;
Step_Size_Vector = -AmplitudeOfLinearSearch/2:dL:AmplitudeOfLinearSearch/2-dL;
%% Find the index of the zero step amplitude - as to not loose the previous location
[~,I] = min(abs(Step_Size_Vector));
Index_Of_Starting_Point = I;
Step_Size_Vector(I) = 0;



%% Initialize Linear Search vectors
Linear_Search_Vector = rand(length(ParameterVector),1)-0.5;
Old_ParameterVector = ParameterVector;
p = 1:NumberOfSamples__In_Each_Itteration;
%% Run Pinball for a certain number of itterations
for itteration = 1:10
    if Readout == 1
    tic
    end
    %% Generate New Samples - and measure their cost
    for k = 1:NumberOfSamples__In_Each_Itteration % This loop can be parallelized
        if k <=Number_Of_Linear_Samples
        ParameterArray(:,k) = Old_ParameterVector + Linear_Search_Vector*Step_Size_Vector(k);                       %% Generate Linear Search Samples around the inital parameter vector
        else
        ParameterArray(:,k) = Old_ParameterVector + 2*AmplitudeOfRandomSearch*(rand(length(ParameterVector),1)-0.5);%% Generate Random Search Samples around the inital parameter vector
        end
        Cost(k) = Cost_Function(ParameterArray(:,k)); %% If the cost requires more inputs, enter them here
    end

    %% Take the minimal Cost
    [CurrentCost(itteration),I] = min(Cost);                                %% Find the sample with minimal cost
    New_ParameterVector = ParameterArray(:,I);                              %% define that sample as the new parameter vector
    
    %% Find the best choice for the next linear search vector
    if I >Number_Of_Linear_Samples                                          %% If the best vector was from the random batch
        Linear_Search_Vector = New_ParameterVector - Old_ParameterVector;   %% Take a vector that follows the gradient
    else                                                                    %% If no better vector is found
        Linear_Search_Vector = rand(length(ParameterVector),1)-0.5;         %% Take a random vector
    end
    Old_ParameterVector = New_ParameterVector;                              %% Redifine the inital parameter vector to be the new best sample
    
    if Readout == 1
    %% Measure Run Time
    t2= toc;
    TotalTime = TotalTime + t2;
    
    %% Readout
    
        a1 = strcat('Current Itteration:  ,',num2str(itteration),' ,','CurrentCost:       ,',num2str(CurrentCost(itteration)));
        a2 = strcat('Running time for this itteration:  ,',num2str(t2),'  ,','Total Time:   ,',num2str(TotalTime));
        disp(a1);

        disp(a2);
        disp(' ');
    end
end
end
ParameterVector = New_ParameterVector;
