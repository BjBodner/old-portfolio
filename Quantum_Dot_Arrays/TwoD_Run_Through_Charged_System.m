function [TotalTime,Q_Final,f] = TwoD_Run_Through_Charged_System(Q,C,Cg,NumberOfDots,Vleft,TimeVector,framenumber)


Vg = 0;
%%AveragingNumber = 1;
NumberOfVoltageTests  = 3;
%%ElectronInEachVoltage = 2;

NumberOfTest = NumberOfVoltageTests;
%%VtAveragingMatrix = ones(AveragingNumber,1);
NextStep = 1;
OptimalCol =1;
NumberOfCharges = NumberOfDots*NumberOfDots*NumberOfDots;
CurrentRow = 1;
CurrentCol = 1;
LastRow = 1;
LastCol = 1;
ChargeStuck =1;
I = 1;
TransferedElectrons = 0;
alpha = 0;
StepVoltageDifference = zeros(4,1);
DotOfLastTransfer = zeros(NumberOfTest,1);
marker = 0;
NumberOfMove = 1;
TimeVector = zeros(round(NumberOfDots*NumberOfDots*NumberOfDots),round(1));
framenumber = 1;

%%for reference Q(i,j) = Q(rows-TopToBottom, cols-LeftToRight)




%% building capacitance matrix
[invCM,CM] = TwoDim_invCM_Generator(C,Cg,NumberOfDots);




%% Running Higher Voltages on System
    %%for NumberOfTest = 1:(2*NumberOfVoltageTests*ElectronInEachVoltage)
    %%Averaging Loop
    %%for n = 1:AveragingNumber
    %%Q = rand(NumberOfDots,NumberOfDots);
    %%Vleft = 0;
    %%TransferedElectrons = 0;


	%% Running the system Loop - inserting charges by voltage


	for i = 1:NumberOfCharges
		
		if TransferedElectrons >= 1
			break;
		end


		%% When Charges cannot move anymore - Raise Voltage, And Add Charge
        if ChargeStuck >=1


                %% Determanistic Adding Charge to First Dot
                %%[Q,CurrentRow,CurrentCol,EnergyDifference] = Determanistic_AddingChargeToFirstDot(Vleft,Q,Cg,NumberOfDots);
                
                %% Probabilistic Adding Charge to First Dot
                [Q,CurrentRow,CurrentCol,ChargingTime] = TwoD_Probabilistic_AddingChargeToFirstDot(Q,Cg,Vleft,NumberOfDots,invCM,C);
                ChargingTimeVector(i) = ChargingTime
                %% Taking a picture of the system
                [f(framenumber)] = TakePictureOfTheSystem(Q);
                framenumber = framenumber + 1;
        end
        
        %% Rebooting ChargeStuck so the system, and Tracking index
		ChargeStuck = 0;
        TrackingIndex = 1;
        
        
        
		%% Moving Charge to rest point algorithm %%
		while CurrentRow < NumberOfDots+1

            %% Tracking Path Of Current
            LastRow(TrackingIndex) = CurrentRow;
            LastCol(TrackingIndex) = CurrentCol;
            TrackingIndex = TrackingIndex + 1; 
            
            %% Creating Next Step "Slides"
            [NextStepArray,TransferedElectrons] = NextStepSlides_Generator(NumberOfDots,CurrentRow,CurrentCol,Q,TransferedElectrons);
        
            %% Deterministicly Excecuting Next Step
            %%[Q,CurrentRow,CurrentCol,OptimalStep,EnergyDifference] = TwoD_Deterministic_Excecution_Of_NextStep(Q,NextStepArray,NumberOfDots,invCM,C,Vleft);
                
            %% Probabilisticly Excecuting Next Step            
            [Q,CurrentRow,CurrentCol,ChosenStep,EnergyDifference] = TwoD_Probabilistic_Excecution_Of_NextStep(Q,NextStepArray,invCM,C,Vleft,NumberOfDots);
            OptimalStep = ChosenStep;
            
            %% Timing the move
            [TimeVector,NumberOfMove] = TwoD_Timing_Algorithm(EnergyDifference,NumberOfMove,TimeVector);
            
            %% Taking Picture of system
                [f(framenumber)] = TakePictureOfTheSystem(Q);
                framenumber = framenumber + 1;
            %Checking if charge made it through the system   
            if TransferedElectrons >= 1
                break
            end
            %Checking if charge is stuck
            if OptimalStep == 17
                CurrentRow = LastRow(TrackingIndex-1);
                CurrentCol = LastCol(TrackingIndex-1);
                ChargeStuck =1;
                break
            end
		end

	%%end of loop for single transfer of electron

    end
    


            %% Taking Picture of system
                [f(framenumber)] = TakePictureOfTheSystem(Q);
                framenumber = framenumber + 1;
%% Gathering data from current voltage test

VoltageOnSystem(NumberOfTest,1) = Vleft;
DotOfLastTransfer(NumberOfTest,1) = CurrentCol;
TransferedElectrons = 0;
TotalTime = sum(TimeVector) + sum(ChargingTimeVector)
Q_Final = Q;

%% End ofVoltage change algortihm



%%if mod(NumberOfTest,ElectronInEachVoltage) == 0

%%	if NumberOfTest < NumberOfVoltageTests*ElectronInEachVoltage
%%		Vleft = Vleft + 1;
%%	end

%%	if NumberOfTest > NumberOfVoltageTests*ElectronInEachVoltage
%%		Vleft = Vleft - 1;
%%	end

%%end

%%Vthreshold = Vleft - Vright
%%VtAveragingMatrix(n) = Vthreshold;
%%end of averaging loop
%%end
%%alpha = mean(VtAveragingMatrix)/NumberOfDots



