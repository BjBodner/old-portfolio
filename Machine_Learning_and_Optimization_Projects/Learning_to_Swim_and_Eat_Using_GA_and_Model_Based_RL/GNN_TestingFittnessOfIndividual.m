function [FittnessOfIndividual,SequenceSummery] = GNN_TestingFittnessOfIndividual(InitialAngles,NumberOfTrainingCycles,NumberOfMovesInSequence,AngleMovesMatrix,PrincipleAxis,NumberOfLimbs,NumberOfJointsPerLimb,LengthOfEachSegmentOfTheLimb,PlotBody,Xlimits,Ylimits,FoodLocation,TrainFor)

TotalDistance = zeros(NumberOfMovesInSequence,1);
%AngleMovesMatrix = AngleMovesMatrix(:,:,individual)
 %% Testing The Fittness Of each individual of the generation
            MyLocation = [0 0];
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
                    
                    %% excecuting the move with the enviounment
                    [NewBodyLocation,Angles_Of_Each_Joint_Before,Angles_Of_Each_Joint_After] = GNN_NextMoveExcecutor(Angles_Of_Each_Joint_Before,Angles_Of_Each_Joint_After,MyLocation,NumberOfLimbs,NumberOfJointsPerLimb,LengthOfEachSegmentOfTheLimb);
                    
                    %% MeasuringDistanceFromFood and Speed
                    %TotalDistance(Move) = pdist([NewBodyLocation ; MyLocation],'euclidean');
                    TotalDistance(Move) = pdist([NewBodyLocation ; 0 0],'euclidean');
                    BodyMovement(Move,1) = NewBodyLocation(1);
                    BodyMovement(Move,2) = NewBodyLocation(2);
                    
                    %% Updating Location and orientation
                    MyLocation = NewBodyLocation;
                    Angles_Of_Each_Joint = Angles_Of_Each_Joint_After;
                    
                    %% Ploting The Body
                    if PlotBody ==1
                        [f] = GNN_PlotBody(Xlimits,Ylimits,MyLocation,NumberOfLimbs,NumberOfJointsPerLimb,LengthOfEachSegmentOfTheLimb,Angles_Of_Each_Joint,FoodLocation);
                        f = getframe(gcf);
                    end
                end
                MovementVarience = MovementVarience + var(BodyMovement(:,1))*var(BodyMovement(:,2));
                directionOfMovement = [(NewBodyLocation(1)-OldBodyLocation(1)) (NewBodyLocation(2)-OldBodyLocation(2))]/sqrt((NewBodyLocation(1)-OldBodyLocation(1))^2 + (NewBodyLocation(2)-OldBodyLocation(2))^2);
                TotalMovement = sqrt((NewBodyLocation-OldBodyLocation)*(NewBodyLocation-OldBodyLocation).');
                OldBodyLocation = NewBodyLocation;
                %ProperMovement = ProperMovement -(directionOfMovement*PrincipleAxis.')*TotalMovement;
                ProperMovement = ProperMovement + TotalMovement;
                PrincipleAxis = [mean(cos(Angles_Of_Each_Joint)) mean(sin(Angles_Of_Each_Joint))]; 
                
                FinalPrincipleAxis = [mean(cos(Angles_Of_Each_Joint)) mean(sin(Angles_Of_Each_Joint))] ;
                Rotation = Rotation + abs(atan(InitialPrincipleAxis(2)/InitialPrincipleAxis(1)) - atan(FinalPrincipleAxis(2)/FinalPrincipleAxis(1)));
                InitialPrincipleAxis = FinalPrincipleAxis;
                
                
                if cycle == 1
                    MovementFromOneSequence = TotalMovement;
                    FinalPrincipleAxis = [mean(cos(Angles_Of_Each_Joint)) mean(sin(Angles_Of_Each_Joint))] ;
                    Rotation1 = abs(atan(InitialPrincipleAxis(2)/InitialPrincipleAxis(1)) - atan(FinalPrincipleAxis(2)/FinalPrincipleAxis(1)));
                    SequenceSummery = [TotalMovement*directionOfMovement Rotation1];
                end
            end
            
            %ProperMovement = ProperMovement/(MovementVarience);
            %ProperMovement = ProperMovement*(([NewBodyLocation(1) NewBodyLocation(2)]/(sqrt(NewBodyLocation*NewBodyLocation.')))*InitialPrincipleAxis.');
        %directionOfMovement = [NewBodyLocation(1) NewBodyLocation(2)]/sqrt(NewBodyLocation(1)^2 + NewBodyLocation(2)^2);
        %ProperMovement = -(directionOfMovement*PrincipleAxis.')*sqrt(NewBodyLocation(1)^2+ NewBodyLocation(2)^2);
        %Movement = sqrt(NewBodyLocation(1)^2+ NewBodyLocation(2)^2);
        
        FinalPrincipleAxis = [mean(cos(Angles_Of_Each_Joint)) mean(sin(Angles_Of_Each_Joint))] ;
       % Rotation = abs(atan(InitialPrincipleAxis(2)/InitialPrincipleAxis(1)) - atan(FinalPrincipleAxis(2)/FinalPrincipleAxis(1)));
        SmoothnessOfBodyMovement = var(diff(TotalDistance))^2;
        SmoothnessOfLegMovement = sum(var(diff(AngleMovesMatrix)).^2);
        EnergyTerm = sum(sum(AngleMovesMatrix.^2));
        
        %FittnessVector = [ProperMovement Rotation SmoothnessOfBodyMovement  SmoothnessOfLegMovement  EnergyTerm  MovementVarience];
        
     %   FittnessOfIndividual = ProperMovement^2/(Rotation*SmoothnessOfBodyMovement*SmoothnessOfLegMovement*EnergyTerm*MovementVarience);
        
     if TrainFor == 1 %%train for movement
         FittnessOfIndividual = ProperMovement/(abs(Rotation)*(100*MovementVarience));
     end
        if TrainFor == 2 %%train for rotation
            FittnessOfIndividual = Rotation/(ProperMovement);
        end
        if TrainFor == 3 %%train for rotation
            FittnessOfIndividual = - Rotation/(ProperMovement);
        end
        
        %FittnessOfIndividual = FittnessWeights*FittnessVector.';