function [Winner,PointsFromRound] = Run_Battle_Simulation(H1_Parameters, H2_Parameters,PlotSystem)



UseDefaultParameters = 0;
if UseDefaultParameters == 1
    H1_Parameters = 5*(rand(5,1)-0.5);
    H1_Parameters(1) = 0;
    H1_Parameters(2) = -10;
    H1_Parameters(3) = -10;
    H1_Parameters(4) = -10;
    H1_Parameters(5) = -10;
    
    H2_Parameters= H1_Parameters;
end

PointsFromRound = zeros(2,1);
NumberOfAnts = 10;
NumberOfObsticles = 10;
NumberOfTargets = 2;
NumberOfItterations = 50;

Locations_Of_Ants1 = 5*(rand(2,NumberOfAnts)-0.5) + 5;
Locations_Of_Ants2 = 5*(rand(2,NumberOfAnts)-0.5) + 25;

KillingVector1 = ones(size(Locations_Of_Ants2));
KillingVector2 = ones(size(Locations_Of_Ants2));

InitialLocations_Of_Ants1 = Locations_Of_Ants1;
InitialLocations_Of_Ants2 = Locations_Of_Ants2;

Locations_Of_Ants1_Before = Locations_Of_Ants1;
Locations_Of_Ants2_Before = Locations_Of_Ants2;

ChangeVector_OfAnts1 = zeros(size(Locations_Of_Ants1));
ChangeVector_OfAnts2 = zeros(size(Locations_Of_Ants1));


%PlotSystem = 0;
ObsticlesMatrix = zeros(2,1);
TargetsMatrix = zeros(2,1);

Use_TargetsAndObsticles = 0;
if Use_TargetsAndObsticles == 1
    ObsticlesMatrix = 20*rand(2,NumberOfObsticles);
    TargetsMatrix = 20 + 2*rand(2,NumberOfTargets);
end


for repeat = 1:1
    
    Locations_Of_Ants1 = 5*(rand(2,NumberOfAnts)-0.5) + 5;
    Locations_Of_Ants2 = 5*(rand(2,NumberOfAnts)-0.5) + 25;
    
    KillingVector1 = ones(size(Locations_Of_Ants2));
    KillingVector2 = ones(size(Locations_Of_Ants2));
    
    Locations_Of_Ants1_Before = Locations_Of_Ants1;
    Locations_Of_Ants2_Before = Locations_Of_Ants2;
    
    ChangeVector_OfAnts1 = zeros(size(Locations_Of_Ants1));
    ChangeVector_OfAnts2 = zeros(size(Locations_Of_Ants1));
    
    
    for itteration = 1:NumberOfItterations
        
        itteration;
        
        %% Finds All the possible Moves
        [NextMoveArray1] = Next_Move_Array_Generator(Locations_Of_Ants1);
        [NextMoveArray2] = Next_Move_Array_Generator(Locations_Of_Ants2);
        
        %% Calculated the propability of excecuting all the moves
        Locations_Of_Ants1_Before = Locations_Of_Ants1;
        Locations_Of_Ants2_Before = Locations_Of_Ants2;
        
        [Locations_Of_Ants1] = Multiple_Porbabalistic_Next_Step_Excecutor(NextMoveArray1,ObsticlesMatrix,TargetsMatrix,H1_Parameters,Locations_Of_Ants2,ChangeVector_OfAnts2,Locations_Of_Ants1_Before,ChangeVector_OfAnts1,Use_TargetsAndObsticles);
        [Locations_Of_Ants2] = Multiple_Porbabalistic_Next_Step_Excecutor(NextMoveArray2,ObsticlesMatrix,TargetsMatrix,H2_Parameters,Locations_Of_Ants1,ChangeVector_OfAnts1,Locations_Of_Ants2_Before,ChangeVector_OfAnts2,Use_TargetsAndObsticles);
        
        ChangeVector_OfAnts1 = -(Locations_Of_Ants1_Before - Locations_Of_Ants1).*(Locations_Of_Ants1_Before ~= Locations_Of_Ants1) + 0.2*ChangeVector_OfAnts1.*(Locations_Of_Ants1_Before == Locations_Of_Ants1);
        ChangeVector_OfAnts2 = -(Locations_Of_Ants2_Before - Locations_Of_Ants2).*(Locations_Of_Ants2_Before ~= Locations_Of_Ants2) + 0.2*ChangeVector_OfAnts2.*(Locations_Of_Ants2_Before == Locations_Of_Ants2);
        
        if PlotSystem == 1
            if mod(itteration ,1) == 0
                scatter(Locations_Of_Ants1(1,:),Locations_Of_Ants1(2,:),'b');
                hold on
                scatter(Locations_Of_Ants2(1,:),Locations_Of_Ants2(2,:),'r');
                hold off
               % ylim([min(0,min(Locations_Of_Ants2(1,2),Locations_Of_Ants2(1,2))-2) max(30,max(Locations_Of_Ants2(1,2),Locations_Of_Ants2(1,2))+2)])
                ylim([-10 40])
               % ylim([min(0,min(Locations_Of_Ants2(1,1),Locations_Of_Ants2(1,1))-2) max(30,max(Locations_Of_Ants2(1,1),Locations_Of_Ants2(1,1))+2)])
                xlim([-10 40])
                getframe(gcf);
                
            end
            if Use_TargetsAndObsticles == 1
                if mod(itteration ,3) == 0
                    hold on
                    scatter(ObsticlesMatrix(1,:),ObsticlesMatrix(2,:),'rs');
                    hold on
                    scatter(TargetsMatrix(1,:),TargetsMatrix(2,:),100,'d','filled');
                    hold off
                    xlim([0 25])
                    ylim([0 25])
                    f = getframe(gcf);
                end
            end
        end
        
        if Use_TargetsAndObsticles == 1
            if mod(itteration ,40) == 0
                TargetsMatrix = 20*rand(2,NumberOfTargets);
            end
        end
        
        
        %% Killing Off Who needs to be killed
        Relative_X = diag(Locations_Of_Ants1(1,:))*ones(NumberOfAnts) - ones(NumberOfAnts)*diag(Locations_Of_Ants2(1,:));
        Relative_Y = diag(Locations_Of_Ants1(2,:))*ones(NumberOfAnts)  - ones(NumberOfAnts)*diag(Locations_Of_Ants2(2,:));
        
        RelativePosition = sqrt(Relative_X.^2 + Relative_Y.^2);
        
        if sum(sum(RelativePosition <=2)) > 0
            % first index is colony 1
            % Secong index is colony 2
            CloseContactMatrix = RelativePosition <=2;
            n = 1;
            while sum(sum(CloseContactMatrix)) > 0
                [~,Index] = max(reshape(CloseContactMatrix,1,NumberOfAnts*NumberOfAnts));
                [I_row(n), I_col(n)] = ind2sub(size(CloseContactMatrix),Index);
                CloseContactMatrix(I_row(n), I_col(n)) = 0;
                
                %% Calculating Survival Propability
                DisplacementVectorBetweenTwoAnts = Locations_Of_Ants1(:,I_row(n)) - Locations_Of_Ants2(:,I_col(n)); % enemy minus me
                Distplacement_Product_With_ChangeVector(2) = (ChangeVector_OfAnts1(:,I_row(n)).'*(-DisplacementVectorBetweenTwoAnts));
                Distplacement_Product_With_ChangeVector(1) = (ChangeVector_OfAnts2(:,I_col(n)).'*(DisplacementVectorBetweenTwoAnts));
                
             %   SurvivalPropability = min(1,1-exp(-0.1*Distplacement_Product_With_ChangeVector));
                SurvivalPropability = min(1,exp(-Distplacement_Product_With_ChangeVector));
                Dice = rand(2,1);
                
                if SurvivalPropability(1) < Dice(1)
                    % did not survive encounter
                    KillingVector1(:,I_row(n)) = 0;
                end
                if SurvivalPropability(2) < Dice(2)
                    % did not survive encounter
                    KillingVector2(:,I_col(n)) = 0;
                end
                
                Locations_Of_Ants1 = Locations_Of_Ants1.*KillingVector1;
                Locations_Of_Ants2 = Locations_Of_Ants2.*KillingVector2;
                ChangeVector_OfAnts1 = ChangeVector_OfAnts1.*KillingVector1;
                ChangeVector_OfAnts2 = ChangeVector_OfAnts2.*KillingVector2;
                n = n+1;
            end
            
        end
        
        %% This is the breaking condition for when one team looses
        if sum(sum(KillingVector1))*sum(sum(KillingVector2)) == 0
            
            %% Count Up the score of the
            if sum(sum(KillingVector2)) == 0 % This is if team 1 won the match
                PointsFromRound(1) = PointsFromRound(1) + 2*sum(sum(2*(KillingVector2 == 0) - (KillingVector1 == 0)));
            end
            
            if sum(sum(KillingVector1)) == 0 % This is if team 2 won the match
                PointsFromRound(2) = PointsFromRound(2) + 2*sum(sum(2*(KillingVector1 == 0) - (KillingVector2 == 0)));
            end
            
            break
        end
        
    end
    
    if sum(sum(KillingVector1))*sum(sum(KillingVector2)) ~= 0
        
        RCM1 = [mean(nonzeros(Locations_Of_Ants1(1,:))) mean(nonzeros(Locations_Of_Ants1(2,:)))];
        RCM2 = [mean(nonzeros(Locations_Of_Ants2(1,:))) mean(nonzeros(Locations_Of_Ants2(2,:)))];
        
        DisplacementVectorFromRCM1 = KillingVector2.*(diag(RCM1)*ones(size(Locations_Of_Ants2)) - Locations_Of_Ants2);
        DisplacementVectorFromRCM2 = KillingVector1.*(diag(RCM2)*ones(size(Locations_Of_Ants1)) - Locations_Of_Ants1);
        
        
        SquareOfDisplacementVectors2 = (sum(DisplacementVectorFromRCM1.*DisplacementVectorFromRCM1));
        SquareOfDisplacementVectors1 = (sum(DisplacementVectorFromRCM2.*DisplacementVectorFromRCM2));
        
        
        DotProduct_BetwennDisplacement_andChangeVector1=  0;
        DotProduct_BetwennDisplacement_andChangeVector2 = 0;
        for i = 1:NumberOfAnts
            if KillingVector1(1,i) ~=0
                
                DotProduct_BetwennDisplacement_andChangeVector1 = DotProduct_BetwennDisplacement_andChangeVector1 + sum(sum(DisplacementVectorFromRCM2(:,i).*ChangeVector_OfAnts1(:,i)./SquareOfDisplacementVectors1(:,i)));
            end
            if KillingVector2(1,i) ~=0
                DotProduct_BetwennDisplacement_andChangeVector2 =DotProduct_BetwennDisplacement_andChangeVector2 +  sum(sum(DisplacementVectorFromRCM1(:,i).*ChangeVector_OfAnts2(:,i)./SquareOfDisplacementVectors2(:,i)));
                
                % DotProduct_BetwennDisplacement_andChangeVector1 = sum(sum((SquareOfDisplacementVectors1 ~= 0).*DisplacementVectorFromRCM2.*ChangeVector_OfAnts1./SquareOfDisplacementVectors1));
                % DotProduct_BetwennDisplacement_andChangeVector2 = sum(sum((SquareOfDisplacementVectors1 ~= 0).*DisplacementVectorFromRCM1.*ChangeVector_OfAnts2./SquareOfDisplacementVectors2));
            end
        end
        
       
        PointsFromRound(1) = PointsFromRound(1) + 10*DotProduct_BetwennDisplacement_andChangeVector1 + sum(1./sqrt(SquareOfDisplacementVectors1 + 0.1)) + sum(sum(abs(InitialLocations_Of_Ants1 - InitialLocations_Of_Ants1)));
        PointsFromRound(2) = PointsFromRound(2) + 10*DotProduct_BetwennDisplacement_andChangeVector2 + sum(1./sqrt(SquareOfDisplacementVectors2 + 0.1)) + sum(sum(abs(InitialLocations_Of_Ants2 - InitialLocations_Of_Ants2)));
    
    
        PointsFromRound(1) = PointsFromRound(1) + 2*sum(sum(2*(KillingVector2 == 0) - (KillingVector1 == 0)));
        PointsFromRound(2) = PointsFromRound(2) + 2*sum(sum(2*(KillingVector1 == 0) - (KillingVector2 == 0)));
    end
    
end


[~,Winner] = max(PointsFromRound);

PointsFromRound;
%Winner

