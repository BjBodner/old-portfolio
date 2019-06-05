clear
clear all
clc

RepeatTheWholeProcess = 5;
for Process = 1:RepeatTheWholeProcess 




Squarebody = zeros(5,2)
SquareWidth = 4;
SquareHeight = 2;
LimbLength = 2;
%InitialHeight = 3;
MutationSize = 0.05
Mobility_Coeficient =1;

Squarebody(1,:) = [0 0];
Squarebody(2,:) = [SquareWidth 0];
Squarebody(3,:) = [SquareWidth SquareHeight];
Squarebody(4,:) = [0 SquareHeight];
Squarebody(5,:) = [0 0];

plot(Squarebody(:,1),Squarebody(:,2),'-bs')
xlim([-10 10])
ylim([-10 10])



LimbAnlges = (rand(8,1)-0.5);
for i = 1:4
    LimbAnlges(2*i-1) = LimbAnlges(2*i-1) + (-3*pi/4 + (i-1)*pi/2);
    LimbAnlges(2*i) = LimbAnlges(2*i) + LimbAnlges(2*i-1);
end

Limbs = zeros(4,3,2);
for i = 1:4
    Limbs(i,1,:) = Squarebody(i,:);
    Limbs(i,2,1) = Limbs(i,1,1) + LimbLength*cos(LimbAnlges(2*i-1));
    Limbs(i,2,2) = Limbs(i,1,2) + LimbLength*sin(LimbAnlges(2*i-1));
    Limbs(i,3,1) = Limbs(i,2,1) + LimbLength*cos(LimbAnlges(2*i));
    Limbs(i,3,2) = Limbs(i,2,2) + LimbLength*sin(LimbAnlges(2*i));
    
    hold on
    plot(Limbs(i,:,1),Limbs(i,:,2),'-bs')
end
hold off
hold off
hold off
hold off


%% The sequence number is the like the individual in a generation
%% the run is the number of attempts of that sequence
%% the move is the specific 4-hand movement (each sequence has 20 moves)

%% Generating Swimming Sequences
NumberOfSequences = 10; %% size of population
TotalNumberOfGenerations = 40; %% Generations from single parent
TotalNumberOfBatches = 50; %% The number of different families - which compete at the end
LengthOfSequency = 8;
NumberOfTimesToRunEachSequence = 1;
TotalMovement = zeros(NumberOfSequences,1);
MovementVarience= zeros(NumberOfSequences,1);


for NumberofBatch = 1:TotalNumberOfBatches
    
    %NumberofBatch
    
    LimbAngleSequence = rand(NumberOfSequences,LengthOfSequency,8)-0.5;
    
    for SequenceNumber = 1:NumberOfSequences
        for i = 2:LengthOfSequency/2
            LimbAngleSequence(SequenceNumber,i,:) = LimbAngleSequence(SequenceNumber,i,:) + LimbAngleSequence(SequenceNumber,i-1,:);
            LimbAngleSequence(SequenceNumber,LengthOfSequency -i + 1,:) = LimbAngleSequence(SequenceNumber,LengthOfSequency -i + 1,:) + LimbAngleSequence(SequenceNumber,LengthOfSequency -i + 2,:);
        end
        
        x = 2*(1:LengthOfSequency)/LengthOfSequency;
        y = zeros(length(x),1);
        for j = 1:8
            y(1:LengthOfSequency/2) = (LimbAngleSequence(SequenceNumber,LengthOfSequency/2,j) - LimbAngleSequence(SequenceNumber,LengthOfSequency/2+1,j))*x((1:LengthOfSequency/2)) + 0.2*rand(1,1);
            LimbAngleSequence(SequenceNumber,:,j) = LimbAngleSequence(SequenceNumber,:,j) - y.';
        end
    end
    
    %% The Generation loop
    for NumberOfGeneration = 1:TotalNumberOfGenerations
        
        
        %% Running Sequence 3 times
        
        for SequenceNumber = 1:NumberOfSequences
            
            %% Initializing the bidy for each attempt of a sequence
            Squarebody(1,:) = [0 0];
            Squarebody(2,:) = [SquareWidth 0];
            Squarebody(3,:) = [SquareWidth SquareHeight];
            Squarebody(4,:) = [0 SquareHeight];
            Squarebody(5,:) = [0 0];
            TotalRotationAngle = 0;
            RotationAngleBofore = 0;
            
            for Run = 1:NumberOfTimesToRunEachSequence
                for NumberOfMove = 1:LengthOfSequency
                    
                    LimbAnlges = LimbAngleSequence(SequenceNumber,NumberOfMove,:);
                    % LimbAnlges = LimbAnlges + TotalRotationAngle;
                    
                    for i = 1:4
                        LimbAnlges(2*i-1) = LimbAnlges(2*i-1) + (-3*pi/4 + (i-1)*pi/2);
                        LimbAnlges(2*i) = LimbAnlges(2*i) + LimbAnlges(2*i-1);
                    end
                    
                    Limbs = zeros(4,3,2);
                    for i = 1:4 %% index (i,:,1) is the x axis of limb i %% index (i,:,2) is the y axis of that limb
                        Limbs(i,1,:) = Squarebody(i,:);
                        Limbs(i,2,1) = Limbs(i,1,1) + LimbLength*cos(LimbAnlges(2*i-1));
                        Limbs(i,2,2) = Limbs(i,1,2) + LimbLength*sin(LimbAnlges(2*i-1));
                        Limbs(i,3,1) = Limbs(i,2,1) + LimbLength*cos(LimbAnlges(2*i));
                        Limbs(i,3,2) = Limbs(i,2,2) + LimbLength*sin(LimbAnlges(2*i));
                    end
                    
                    PlotMoves = 0;
                    if PlotMoves == 1
                        plot(Limbs(1,:,1),Limbs(1,:,2),'-bs',Limbs(2,:,1),Limbs(2,:,2),'-bs',Limbs(3,:,1),Limbs(3,:,2),'-bs',Limbs(4,:,1),Limbs(4,:,2),'-bs',Squarebody(:,1),Squarebody(:,2),'-bs');
                        xlim([-40 40]);
                        ylim([-40 40]);
                        getframe(gcf);
                    end
                    
                    LimbsAfter = Limbs;
                    if NumberOfMove == 1
                        Total_Movement = zeros(1,2);
                    end
                    
                    if NumberOfMove >=2
                        %% Moving the body
                        for k = 1:2
                            MoveMentArray(:,:,k) = LimbsAfter(:,2:3,k) - LimbsBefore(:,2:3,k) - Total_Movement(k);
                        end
                        Total_Movement(1) = sum(sum(MoveMentArray(:,:,1)));
                        Total_Movement(2) = sum(sum(MoveMentArray(:,:,2)));
                        SquarebodyAfter(:,1) = Squarebody(:,1) + Mobility_Coeficient*Total_Movement(1);
                        SquarebodyAfter(:,2) = Squarebody(:,2) + Mobility_Coeficient*Total_Movement(2);
                        Squarebody = SquarebodyAfter;
                        BodyMovement(NumberOfMove,:) = [Total_Movement(1) Total_Movement(2)];
                        
                        %% Rotating the body
                        rotatebody = 0;
                        if rotatebody == 1
                            Rcm = [mean(Squarebody(:,1)) mean(Squarebody(:,2))];
                            RotationAngle = 0;
                            for limb = 1:4
                                for point = 1:2
                                    %sign( atan(MoveMentArray(limb,point,2)/MoveMentArray(limb,point,1)))
                                    RotationAngle = RotationAngle + sign( atan(MoveMentArray(limb,point,2)/MoveMentArray(limb,point,1)))*pdist([reshape(MoveMentArray(limb,point,:),1,2,1) ; 0 0],'euclidean')/pdist([reshape(LimbsAfter(limb,point+1,:),1,2,1) ; 0 0],'euclidean');
                                end
                            end
                            %RotationAngle = RotationAngle - RotationAngleBofore;
                            SquarebodyAfter(:,1) = Squarebody(:,1)*cos(RotationAngle) - Squarebody(:,2)*sin(RotationAngle);
                            SquarebodyAfter(:,2) = Squarebody(:,2)*cos(RotationAngle) + Squarebody(:,1)*sin(RotationAngle);
                            %   Squarebody = SquarebodyAfter;
                            
                            % LimbsAfter(:,2:3,1) = LimbsAfter(:,2:3,1)*cos(RotationAngle) - LimbsAfter(:,2:3,2)*sin(RotationAngle);
                            % LimbsAfter(:,2:3,2) = LimbsAfter(:,2:3,2)*cos(RotationAngle) - LimbsAfter(:,2:3,1)*sin(RotationAngle);
                            
                            RotationAngleBofore = RotationAngle;
                            TotalRotationAngle = TotalRotationAngle + RotationAngle;
                        end
                    end
                    LimbsBefore = LimbsAfter;
                    
                end
            end
            
            X = [0 0;Squarebody(1,:)];
            TotalMovement(SequenceNumber) = pdist(X,'euclidean');
            MovementVarience(SequenceNumber) = var(BodyMovement(:,1))*var(BodyMovement(:,2));
        end
        
        (TotalMovement./(MovementVarience)).';
        TotalMovement.';
        %% finding the fittest sequence
        [M,I] = max(TotalMovement./(MovementVarience.^2));
        FittestSequence = LimbAngleSequence(I,:,:);
        FittestMovemet = TotalMovement(I);
        %% creating the next generation with small mutations
        LimbAngleSequence(1,:,:) = FittestSequence;
        for k = 2:NumberOfSequences
            LimbAngleSequence(k,:,:) = FittestSequence + MutationSize*(rand(1,LengthOfSequency,8)-0.5);
        end
        TotalMovement = zeros(NumberOfSequences,1);
        MovementVarience= zeros(NumberOfSequences,1);
    end
    
    FittestMovemet_FromThisBatch = FittestMovemet;
    if NumberofBatch == 1
        TopSequence = FittestSequence;
        TopMovemet = FittestMovemet;
    end
    
    
    
    if NumberofBatch > 1
        if FittestMovemet_FromThisBatch > TopMovemet
            TopSequence = FittestSequence;
            TopMovemet = FittestMovemet
        end
    end
end

FittestSequence = TopSequence;
FittestMovemet = TopMovemet;


%% Play movie of the fittest individual
Replay = 2;
DemoRuns = 10;

for ReplayNumber = 1:Replay
    
    %% Initializing the bidy for each attempt of a sequence
    Squarebody(1,:) = [0 0];
    Squarebody(2,:) = [SquareWidth 0];
    Squarebody(3,:) = [SquareWidth SquareHeight];
    Squarebody(4,:) = [0 SquareHeight];
    Squarebody(5,:) = [0 0];
    
    for Run = 1:DemoRuns
        for NumberOfMove = 1:LengthOfSequency
            
            LimbAnlges = FittestSequence(1,NumberOfMove,:);
            
            for i = 1:4
                LimbAnlges(2*i-1) = LimbAnlges(2*i-1) + (-3*pi/4 + (i-1)*pi/2);
                LimbAnlges(2*i) = LimbAnlges(2*i) + LimbAnlges(2*i-1);
            end
            
            Limbs = zeros(4,3,2);
            for i = 1:4 %% index (i,:,1) is the x axis of limb i %% index (i,:,2) is the y axis of that limb
                Limbs(i,1,:) = Squarebody(i,:);
                Limbs(i,2,1) = Limbs(i,1,1) + LimbLength*cos(LimbAnlges(2*i-1));
                Limbs(i,2,2) = Limbs(i,1,2) + LimbLength*sin(LimbAnlges(2*i-1));
                Limbs(i,3,1) = Limbs(i,2,1) + LimbLength*cos(LimbAnlges(2*i));
                Limbs(i,3,2) = Limbs(i,2,2) + LimbLength*sin(LimbAnlges(2*i));
            end
            
            PlotMoves = 1;
            if PlotMoves == 1
                plot(Limbs(1,:,1),Limbs(1,:,2),'-b',Limbs(2,:,1),Limbs(2,:,2),'-b',Limbs(3,:,1),Limbs(3,:,2),'-b',Limbs(4,:,1),Limbs(4,:,2),'-b',Squarebody(:,1),Squarebody(:,2),'-b');
                xlim([-100 100]);
                ylim([-100 100]);
                f(NumberOfMove + (Run-1)*LengthOfSequency + LengthOfSequency*DemoRuns*(ReplayNumber-1) + (Process-1)*Replay*LengthOfSequency*DemoRuns) = getframe(gcf);
                NumberOfMove + (Run-1)*LengthOfSequency + LengthOfSequency*DemoRuns*(ReplayNumber-1) + (Process-1)*Replay*LengthOfSequency*DemoRuns
                %NumberOfMove + (Run-1)*LengthOfSequency + (ReplayNumber-1)*LengthOfSequency*(Run-1) + (Process-1)*(ReplayNumber-1)*LengthOfSequency*(Run-1)
            end
            
            LimbsAfter = Limbs;
            if NumberOfMove == 1
                Total_Movement = zeros(1,2);
            end
            
            if NumberOfMove >=2
                %% Moving the body
                for k = 1:2
                    MoveMentArray(:,:,k) = LimbsAfter(:,2:3,k) - LimbsBefore(:,2:3,k) - Total_Movement(k);
                end
                Total_Movement(1) = sum(sum(MoveMentArray(:,:,1)));
                Total_Movement(2) = sum(sum(MoveMentArray(:,:,2)));
                SquarebodyAfter(:,1) = Squarebody(:,1) + Mobility_Coeficient*Total_Movement(1);
                SquarebodyAfter(:,2) = Squarebody(:,2) + Mobility_Coeficient*Total_Movement(2);
                Squarebody = SquarebodyAfter;
                
                %% Rotating the body
                
                BodyMovement(NumberOfMove,:) = [Total_Movement(1) Total_Movement(2)];
            end
            LimbsBefore = LimbsAfter;
            
        end
    end
end

end

RecordVideo = 1;
if RecordVideo ==1
v = VideoWriter('SwimmingAI2.avi','Uncompressed AVI');
open(v)
writeVideo(v,f)
close(v)
end

%save('FittestSequence_10000Families','FittestSequence')