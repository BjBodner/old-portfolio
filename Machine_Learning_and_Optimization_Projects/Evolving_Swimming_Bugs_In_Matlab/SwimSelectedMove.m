function [FinalPrincipleAxis,InitialAngles,MyLocation, MinDistanceToFood] = SwimSelectedMove(InitialAngles,NumberOfTrainingCycles,NumberOfMovesInSequence,AngleMovesMatrix,PrincipleAxis,NumberOfLimbs,NumberOfJointsPerLimb,LengthOfEachSegmentOfTheLimb,PlotBody,Xlimits,Ylimits,FoodLocation,MyLocation,TrainFor)

 MinDistanceToFood = 1000;
FoodLocation
TotalDistance = zeros(NumberOfMovesInSequence,1);
%AngleMovesMatrix = AngleMovesMatrix(:,:,individual)
 %% Testing The Fittness Of each individual of the generation

            OldBodyLocation = MyLocation;
            Angles_Of_Each_Joint = InitialAngles;
            InitialPrincipleAxis = PrincipleAxis;
            ProperMovement = 0;
            MovementVarience = 0;
            Rotation = 0;
            BodyMovement = zeros(NumberOfMovesInSequence,2);
            
            % Running the sequence
            for cycle = 1:NumberOfTrainingCycles
                for Move = 1:NumberOfMovesInSequence
                    
                    %% Planning the move
                    Angles_Of_Each_Joint_Before = Angles_Of_Each_Joint;
                    Angles_Of_Each_Joint_After = Angles_Of_Each_Joint + AngleMovesMatrix(Move,:);
                    
                    %% The Problem is that somethine is killing the angles
                    
                    %% excecuting the move with the enviounment
                    [NewBodyLocation,Angles_Of_Each_Joint_Before,Angles_Of_Each_Joint_After] = GNN_NextMoveExcecutor(Angles_Of_Each_Joint_Before,Angles_Of_Each_Joint_After,MyLocation,NumberOfLimbs,NumberOfJointsPerLimb,LengthOfEachSegmentOfTheLimb);
                    
                    
                    MyLocation
                    %% MeasuringDistanceFromFood and Speed
                    %TotalDistance(Move) = pdist([NewBodyLocation ; MyLocation],'euclidean');
                    TotalDistance(Move) = pdist([NewBodyLocation ; 0 0],'euclidean');
                    BodyMovement(Move,1) = NewBodyLocation(1);
                    BodyMovement(Move,2) = NewBodyLocation(2);
                    
                    %% Updating Location and orientation
                    MyLocation = NewBodyLocation;
                    Angles_Of_Each_Joint = Angles_Of_Each_Joint_After;
                    
                    DistanceToFood = pdist([FoodLocation;MyLocation],'euclidean');
                    if DistanceToFood < MinDistanceToFood
                        MinDistanceToFood = DistanceToFood;
                    end
                    %% Ploting The Body
                    if PlotBody ==1
                        [f] = GNN_PlotBody(Xlimits,Ylimits,MyLocation,NumberOfLimbs,NumberOfJointsPerLimb,LengthOfEachSegmentOfTheLimb,Angles_Of_Each_Joint,FoodLocation);
                        f = getframe(gcf);
                    end
                end
            end
            
            %ProperMovement = ProperMovement/(MovementVarience);
            %ProperMovement = ProperMovement*(([NewBodyLocation(1) NewBodyLocation(2)]/(sqrt(NewBodyLocation*NewBodyLocation.')))*InitialPrincipleAxis.');
        %directionOfMovement = [NewBodyLocation(1) NewBodyLocation(2)]/sqrt(NewBodyLocation(1)^2 + NewBodyLocation(2)^2);
        %ProperMovement = -(directionOfMovement*PrincipleAxis.')*sqrt(NewBodyLocation(1)^2+ NewBodyLocation(2)^2);
        %Movement = sqrt(NewBodyLocation(1)^2+ NewBodyLocation(2)^2);
        InitialAngles = Angles_Of_Each_Joint;
        FinalPrincipleAxis = [mean(cos(Angles_Of_Each_Joint)) mean(sin(Angles_Of_Each_Joint))] ;
