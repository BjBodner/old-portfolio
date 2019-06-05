
C = 1;
Cg = 10;
NumberOfDots = 20;

Q = rand(NumberOfDots,NumberOfDots);


[invCM,CM] = TwoDim_Special_invCM_Generator5(C,Cg,NumberOfDots);

%[Energy_Graph] = CapacitanceMatrix_PairingTests(NumberOfDots)




barplot = 1;
surfplot = 0;
Full_invCM_Matrix_Animation = 0;
recordmovie =0;
plotDoubleCharges = 0;
Energetic_PairingTest = 0;
MovingCharges = 1;
Plot_InitialEnergyLandScape = 0;
ForceFieldPlot = 0;


%% Chosing Capacitance Matrix
Regular_Round_Matrix = 0;
Eliptical1_Long_in_X_Direction_Matrix = 0;
Eliptical1_Long_in_Y_Direction_Matrix = 0;
Oscliating_Rows_Only = 0;
Oscilating_Lines_and_Rows = 0 ;
SideWays_Matrix = 0;
Increasing_Screeninglength_Matrix = 1;
Decreasing_Screeninglength_Matrix = 0;



%% Checking Reshape
Q = zeros(NumberOfDots,NumberOfDots);
for i = 1:NumberOfDots
    for j = 1:NumberOfDots
        Q(i,j) = 10*i + j;
    end
end

Q;
Q_Row_Vector = reshape(Q,1,NumberOfDots*NumberOfDots);
Q_Column_Vector = reshape(Q,NumberOfDots*NumberOfDots,1);
Q_Row_Vector(1,1:NumberOfDots:NumberOfDots*NumberOfDots - NumberOfDots + 1);

for j = 1:NumberOfDots
Q_Column_Vector(1 + (j-1)*NumberOfDots,1);
end

%% Choice of invCM
[invCM,CM] = TwoD_Create_Selected_invCM(C,Cg,NumberOfDots,Regular_Round_Matrix,Eliptical1_Long_in_X_Direction_Matrix,Eliptical1_Long_in_Y_Direction_Matrix,Oscilating_Lines_and_Rows,Oscliating_Rows_Only,SideWays_Matrix,Increasing_Screeninglength_Matrix,Decreasing_Screeninglength_Matrix)



Q = rand(NumberOfDots,NumberOfDots)
Q(round(NumberOfDots/2),round(NumberOfDots/2)) = Q(round(NumberOfDots/2),round(NumberOfDots/2))+3
if Plot_InitialEnergyLandScape == 1
    for k = 1:80
        C = 10^(-3+k/10)
        [invCM,CM] = TwoD_Create_Selected_invCM(C,Cg,NumberOfDots,Regular_Round_Matrix,Eliptical1_Long_in_X_Direction_Matrix,Eliptical1_Long_in_Y_Direction_Matrix,Oscilating_Lines_and_Rows,Oscliating_Rows_Only,Increasing_Screeninglength_Matrix,Decreasing_Screeninglength_Matrix);
        [EnergyLanscape_for_single_extra_charge,EnergyLanscape] = TwoD_EnergyLanscape_for_single_extra_charge(NumberOfDots,C,Cg,Q,invCM);
    end
end

[Movie] = CapacitnaceMatrix_Moving_EnergeticInfluence(NumberOfDots,barplot,surfplot,plotDoubleCharges,Energetic_PairingTest,MovingCharges,Regular_Round_Matrix,Eliptical1_Long_in_X_Direction_Matrix,Eliptical1_Long_in_Y_Direction_Matrix,Oscilating_Lines_and_Rows,Oscliating_Rows_Only,ForceFieldPlot,SideWays_Matrix,Increasing_Screeninglength_Matrix,Decreasing_Screeninglength_Matrix);

%[Movie] = CapacitnaceMatrix_EnergeticInfluenceMovie(NumberOfDots,barplot,surfplot)



if Full_invCM_Matrix_Animation == 1
    [x,y] = meshgrid(1:1:NumberOfDots*NumberOfDots,1:1:NumberOfDots*NumberOfDots);
    FinalCCg = 100
    InitialCCg = 0.0001
    InitialCg = 10000
    InitialC = Cg*InitialCCg
    NumberOfSteps = 50;
    
    PowerDifference = log10(FinalCCg/InitialCCg)
    
    for n = 1:NumberOfSteps
        C = InitialC*10^((n*(PowerDifference/NumberOfSteps))/2)
        Cg = InitialCg*10^(-(n*(PowerDifference/NumberOfSteps))/2)
        CCg = C/Cg;
        [invCM,CM] = TwoDim_invCM_Generator(C,Cg,NumberOfDots);
        if barplot == 1
            bar3(invCM);
           % colormap(grey)
        end
        if surfplot == 1
            surf(x,y,invCM)
            shading flat
        end
        title(sprintf('Elements Of invCM \n For 2D array of  %g by %g dots \n and C/Cg = %f',NumberOfDots,NumberOfDots,CCg))
        zlim([0 0.004])
        f = getframe(gcf);
        % f = getframe(gcf);
        % f = getframe(gcf);
        %    f = getframe(gcf);
    end
end


if recordmovie ==1

        v = VideoWriter('Moving Energetic Influence - Decreasing Screening Length  20 dot array.avi','Uncompressed AVI');
       open(v)
        writeVideo(v,Movie)
        close(v)
end