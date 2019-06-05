function [Suggested_Parameter_Samples_From_Guessing_Game,LengthOfVectors,RandomVectors] = Guessing_Game_Optimizer_Part1(Initial_Parameters,NumberRandomVectors,dt)


    RandomVectors = rand(length(Initial_Parameters),NumberRandomVectors)-0.5;
    
    for vector = 1:NumberRandomVectors
        LengthOfVectors(vector) = sqrt(RandomVectors(:,vector).'*RandomVectors(:,vector));
        for i = 1:3
            Suggested_Parameter_Samples_From_Guessing_Game(:,i + 3*(vector-1)) = Initial_Parameters + (i-2)*dt*RandomVectors(:,vector);
        end
    end
    
    