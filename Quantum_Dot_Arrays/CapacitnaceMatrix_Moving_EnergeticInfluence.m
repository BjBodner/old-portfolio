function [Movie] = CapacitnaceMatrix_Moving_EnergeticInfluence(NumberOfDots,barplot,surfplot,plotDoubleCharges,Energetic_PairingTest,MovingCharges,Regular_Round_Matrix,Eliptical1_Long_in_X_Direction_Matrix,Eliptical1_Long_in_Y_Direction_Matrix,Oscilating_Lines_and_Rows,Oscliating_Rows_Only,ForceFieldPlot,SideWays_Matrix,Increasing_Screeninglength_Matrix,Decreasing_Screeninglength_Matrix)

EnergeticAveragingNumber = 40
[x,y] = meshgrid(1:1:NumberOfDots,1:1:NumberOfDots);
FinalCCg = 1000;
InitialCCg = 0.1;
InitialCg = 100;
InitialC = InitialCg*InitialCCg;
NumberOfSteps = 20;
EnergyOfTwoJoinedDots = zeros(NumberOfSteps);
EnergyOfTwoSeperateDots = zeros(NumberOfSteps);

if MovingCharges == 0
    Movie = 0;
end
PowerDifference = log10(FinalCCg/InitialCCg);

for n = 1:NumberOfSteps
    
    C = InitialC*10^((n*(PowerDifference/NumberOfSteps))/2)
    Cg = InitialCg*10^(-(n*(PowerDifference/NumberOfSteps))/2)
    CCg = C/Cg;
    
    [invCM,CM] = TwoD_Create_Selected_invCM(C,Cg,NumberOfDots,Regular_Round_Matrix,Eliptical1_Long_in_X_Direction_Matrix,Eliptical1_Long_in_Y_Direction_Matrix,Oscilating_Lines_and_Rows,Oscliating_Rows_Only,SideWays_Matrix,Increasing_Screeninglength_Matrix,Decreasing_Screeninglength_Matrix)

    %% Regular invCM - Round Influence
    % [invCM,CM] = TwoDim_invCM_Generator(C,Cg,NumberOfDots);
    
    %% Different Lines invCM
   % [invCM,CM] = TwoDim_Special_invCM_Generator1(C,Cg,NumberOfDots);
    
    %% Oscilating Left Right invCm
    % [invCM,CM] = TwoDim_Special_invCM_Generator2(C,Cg,NumberOfDots);
    
    %% Eliptic 1 invCM - long in x direction
     % [invCM,CM] = TwoDim_Special_invCM_Generator3(C,Cg,NumberOfDots);
    
    %% Eliptic 2 invCM - long in y direction
  %  [invCM,CM] = TwoDim_Special_invCM_Generator4(C,Cg,NumberOfDots);
    
    
    %%Energy Tests
    if  Energetic_PairingTest == 1
        for p = 1:EnergeticAveragingNumber
            Q1_1 = rand(NumberOfDots,NumberOfDots);
            Q2 = rand(NumberOfDots,NumberOfDots);
            
            % Apart
            Q1_1(10,10) = Q1_1(10,10) + 1;
            Q1_1(8,10) = Q1_1(8,10) + 1;
            
            % Joined
            Q2(10,10) = Q2(10,10) + 1;
            Q2(10,7) = Q2(10,7) + 1;
            
            EnergyOfTwoSeperateDots(n) = EnergyOfTwoSeperateDots(n) +  0.5*reshape(Q1_1,1,NumberOfDots*NumberOfDots)*invCM*reshape(Q1_1,NumberOfDots*NumberOfDots,1);
            EnergyOfTwoJoinedDots(n) = EnergyOfTwoJoinedDots(n) + 0.5*reshape(Q2,1,NumberOfDots*NumberOfDots)*invCM*reshape(Q2,NumberOfDots*NumberOfDots,1);
            CCg1(n) = C/Cg;
        end
        EnergyOfTwoSeperateDots(n) = EnergyOfTwoSeperateDots(n)/EnergeticAveragingNumber;
        EnergyOfTwoJoinedDots(n) = EnergyOfTwoJoinedDots(n)/EnergeticAveragingNumber;
    end
    %% Running Loop
    
    if MovingCharges ==1
        for k = 1:NumberOfDots
            
            DotNumber = round(NumberOfDots^2/2)+k;
            
            EnergeticInfluence1 = reshape(invCM(DotNumber,:),NumberOfDots,NumberOfDots);
            Normalized_EnergeticInfluence1 = EnergeticInfluence1/max(max(EnergeticInfluence1));
            
            if plotDoubleCharges == 1
            EnergeticInfluence2 = reshape(invCM(DotNumber+2*NumberOfDots + 1,:),NumberOfDots,NumberOfDots);
            Normalized_EnergeticInfluence2 = EnergeticInfluence2/max(max(EnergeticInfluence2));
            end
            
            if barplot == 1
                b = bar3(Normalized_EnergeticInfluence1);
                for t = 1:length(b)
                    zdata = b(t).ZData;
                    b(t).CData = zdata;
                    b(t).FaceColor = 'interp';
                end
                
                if plotDoubleCharges == 1
                    b2 = bar3(Normalized_EnergeticInfluence1+Normalized_EnergeticInfluence2);
                    for t = 1:length(b2)
                        zdata = b2(t).ZData;
                        b2(t).CData = zdata;
                        b2(t).FaceColor = 'interp';
                    end
                end
                
                
            end
            if surfplot == 1
                surf(x,y,Normalized_EnergeticInfluence)
                shading flat
            end
            
            if ForceFieldPlot == 1
                [fx,fy] = gradient(-Normalized_EnergeticInfluence1);
                quiver(x,y,fx,fy);
                            xlim([0 21])
                                        ylim([0 21])
            end
            title(sprintf('Normalized Energetic Influence \n For 2D array of  %g by %g dots \n and C/Cg = %f',NumberOfDots,NumberOfDots,CCg))
            zlim([0 1.2])
            
            Movie(k+(n-1)*NumberOfDots) = getframe(gcf);
             f = getframe(gcf);
             f = getframe(gcf);
            %    f = getframe(gcf);
        end
        
    end
    
end

if Energetic_PairingTest == 1
    figure = loglog(CCg1,EnergyOfTwoSeperateDots,'-rs',CCg1,EnergyOfTwoJoinedDots,'-bs');
    title(sprintf('Energy of 2 Charges, far apart in red, and close in blue \n For 2D array of  %g by %g dots',NumberOfDots,NumberOfDots));
end