function [Suggested_Parameter_Samples_From_Guessing_Game,LengthOfVectors,RandomVectors] = Guessing_Game_Optimizer_Version2_Part1(Initial_Parameters,NumberRandomVectors,dt)


    RandomVectors = rand(length(Initial_Parameters),NumberRandomVectors)-0.5;
    LengthOfVectors = zeros(NumberRandomVectors,1);
    Suggested_Parameter_Samples_From_Guessing_Game(:,1) = Initial_Parameters;
    
    for vector = 1:NumberRandomVectors
        LengthOfVectors(vector) = sqrt(RandomVectors(:,vector).'*RandomVectors(:,vector));
        Suggested_Parameter_Samples_From_Guessing_Game(:,2 + 2*(vector-1)) = Initial_Parameters -dt*RandomVectors(:,vector);
        Suggested_Parameter_Samples_From_Guessing_Game(:,3 + 2*(vector-1)) = Initial_Parameters +dt*RandomVectors(:,vector);
    end
    
    