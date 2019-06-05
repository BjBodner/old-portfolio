function [NextStepArray,TransferedElectrons] = NextStepSlides_Generator(NumberOfDots,CurrentRow,CurrentCol,Q,TransferedElectrons)


%% Creating Next Step "Slides"

		NextStepArray = zeros(NumberOfDots,NumberOfDots,17);

		%% Front Steps (l= 1:4)
            for l = 1:min(4,NumberOfDots-CurrentRow+2)
				NextStepArray(max(1,CurrentRow-3 + l),CurrentCol,l) = -1;
				NextStepArray(max(2,CurrentRow-2 + l),CurrentCol,l) = 1;
            end
        %% Drainig Last Dot
            if Q(NumberOfDots,CurrentCol) >= 1
                NextStepArray(NumberOfDots-1,CurrentCol,4) = 0;
                NextStepArray(NumberOfDots,CurrentCol,4) = -1;
                TransferedElectrons = 1;
            end
                

		%% Right Steps (l= 5:8)
			for l = 5:min(8,NumberOfDots-CurrentCol+6)
				NextStepArray(CurrentRow,max(1,CurrentCol-7+l),l) = -1;
				NextStepArray(CurrentRow,max(2,CurrentCol-6+l),l) = 1;
			end

		%% Back Steps (l= 9:12) %% Left Steps (l= 13:16)
            for l = 9:16
				NextStepArray(:,:,l) = -1*NextStepArray(:,:,l-8);
            end
