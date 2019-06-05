function [Movie] = CapacitnaceMatrix_EnergeticInfluenceMovie(NumberOfDots,barplot,surfplot)

[x,y] = meshgrid(1:1:NumberOfDots,1:1:NumberOfDots);
FinalCCg = 100000
InitialCCg = 0.0001
InitialCg = 100000
InitialC = InitialCg*InitialCCg
NumberOfSteps = 50;

PowerDifference = log10(FinalCCg/InitialCCg)


for k = 1:9
    
    if k == 1
        DotNumber = 1;
    end
    
    if k == 2
        DotNumber = round(NumberOfDots/2);
    end
    
    if k == 3
        DotNumber = round(NumberOfDots);
    end
    
    if k == 4
        DotNumber = round(NumberOfDots^2/2 - NumberOfDots+1);
    end
    
    if k == 5
        DotNumber = round(NumberOfDots^2/2 + NumberOfDots/2);
    end
    
    if k == 6
        DotNumber = round((NumberOfDots^2)/2);
    end
    
    
    
    if k == 7
        DotNumber = round(NumberOfDots^2-NumberOfDots+1);
    end
    
    if k == 8
        DotNumber = round(NumberOfDots^2 -NumberOfDots/2 );
    end
    
    if k == 9
        DotNumber = round(NumberOfDots^2);
    end
    
    for n = 1:NumberOfSteps
        
        C = InitialC*10^((n*(PowerDifference/NumberOfSteps))/2)
        Cg = InitialCg*10^(-(n*(PowerDifference/NumberOfSteps))/2)
        CCg = C/Cg;
        [invCM,CM] = TwoDim_invCM_Generator(C,Cg,NumberOfDots);
        
        EnergeticInfluence = reshape(invCM(DotNumber,:),NumberOfDots,NumberOfDots);
        Normalized_EnergeticInfluence = EnergeticInfluence/max(max(EnergeticInfluence));
        if barplot == 1
            b = bar3(Normalized_EnergeticInfluence);
            for t = 1:length(b)
                zdata = b(t).ZData;
                b(t).CData = zdata;
                b(t).FaceColor = 'interp';
            end
        end
        if surfplot == 1
            surf(x,y,Normalized_EnergeticInfluence)
            shading flat
        end
        title(sprintf('Normalized Energetic Influence \n For 2D array of  %g by %g dots \n and C/Cg = %f',NumberOfDots,NumberOfDots,CCg))
        zlim([0 1.2])
        if n == NumberOfSteps
            n+(k-1)*NumberOfSteps
        end
        Movie(n+(k-1)*NumberOfSteps) = getframe(gcf);
        % f = getframe(gcf);
        % f = getframe(gcf);
        %    f = getframe(gcf);
    end
end