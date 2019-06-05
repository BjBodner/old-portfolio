function [b,Time,VoltageVector] = TwoD_Plot_Dynamic_State(VoltageSequence_and_Test_Parameters,VoltageVector,NumberOfVoltageTests,FirstChargedSystem,AveragedState,Time,CurrentTime,NumberOfDots,Ix_front,Ix_back,Iy_up,Iy_down,Vleft,Vg,C,Cg,n,ThresholdVoltage,AverageChargesTransfered,TotalTime,TotalTimeOfRun,az,el,Full_CurrentThroughSystem,CM,TransitionProbabilityVector,NextMoveArray,SizeAndDisorder_parameters,Full_AppliedVoltage,NumberOfMeasurementForBacktrack)

VoltageSequence = VoltageSequence_and_Test_Parameters.VoltageSequence;
NumberOfVoltageTests = max(NumberOfVoltageTests,n);



CCg = C/Cg;
b = getframe(gcf);

[x,y] = meshgrid(1:1:NumberOfDots(1),1:1:NumberOfDots(2));

CM;


CgVector = Cg + SizeAndDisorder_parameters.Cg_Disorder;

if mean(size(max(TransitionProbabilityVector))) ~=1
    a = 1;
end
TransitionNormalization = 1/(2*max(TransitionProbabilityVector));
X_TransitionArray1 = zeros(NumberOfDots(1),NumberOfDots(2));
X_TransitionArray2 = zeros(NumberOfDots(1),NumberOfDots(2));
X_TransitionOffArray= zeros(NumberOfDots(1),NumberOfDots(2));
Y_TransitionArray1= zeros(NumberOfDots(1),NumberOfDots(2));
Y_TransitionArray2= zeros(NumberOfDots(1),NumberOfDots(2));

for i = 1:length(NextMoveArray(1,1,:))
    
    [~,Index] = max(reshape(NextMoveArray(:,:,i),1,NumberOfDots(1)*NumberOfDots(2)));
    [I_row_max, I_col_max] = ind2sub(size(NextMoveArray(:,:,i)),Index);
    [~,Index] = min(reshape(NextMoveArray(:,:,i),1,NumberOfDots(1)*NumberOfDots(2)));
    [I_row_min, I_col_min] = ind2sub(size(NextMoveArray(:,:,i)),Index);
    
    if I_col_max > I_col_min
        if mod(I_col_max,2) == 1
    Y_TransitionArray2 = Y_TransitionArray2 -NextMoveArray(:,:,i)*TransitionProbabilityVector(i);
        end
        if mod(I_col_max,2) == 0
     Y_TransitionArray1 = Y_TransitionArray1 -NextMoveArray(:,:,i)*TransitionProbabilityVector(i);           
        end
    end
    if I_row_max > I_row_min
        if mod(I_row_max,2) == 1
            X_TransitionArray1 = X_TransitionArray1 -NextMoveArray(:,:,i)*TransitionProbabilityVector(i);
        end
        if mod(I_row_max,2) == 0
            X_TransitionArray2 = X_TransitionArray2 -NextMoveArray(:,:,i)*TransitionProbabilityVector(i);
        end
    end
    if max(max(NextMoveArray(:,:,i))) == 0
        if I_row_min == NumberOfDots(1)
            X_TransitionOffArray = X_TransitionOffArray - NextMoveArray(:,:,i)*TransitionProbabilityVector(i);
        end
        if I_row_min == 1
            X_TransitionOffArray = X_TransitionOffArray + NextMoveArray(:,:,i)*TransitionProbabilityVector(i);
        end
    end
end

X_TransitionArray1 = X_TransitionArray1*TransitionNormalization;
X_TransitionArray2 = X_TransitionArray2*TransitionNormalization;
X_TransitionOffArray= X_TransitionOffArray*TransitionNormalization;
Y_TransitionArray1= Y_TransitionArray1*TransitionNormalization;
Y_TransitionArray2= Y_TransitionArray2*TransitionNormalization;



DynamicDots = zeros(NumberOfDots(1),NumberOfDots(2));
StaticDots = zeros(NumberOfDots(1),NumberOfDots(2));

Time(n) = CurrentTime;
%VoltageVector(n) = Vleft/ThresholdVoltage;
if max(size(nonzeros(mean(Full_AppliedVoltage.')))) ~= n
    a = 1;
end
%if NumberOfMeasurementForBacktrack-n ==0
%    VoltageVector(1:n) = mean(Full_AppliedVoltage(1:n,:).')/ThresholdVoltage;
%end
%if NumberOfMeasurementForBacktrack-n ~= 0
VoltageVector(1:n) = mean(Full_AppliedVoltage(1:n,:).')/ThresholdVoltage;
%end
AveragingNumberOfCharges = round(sum(AverageChargesTransfered));
Vmax = 0;



Vmax = max(VoltageSequence);
MaxVoltage = ones(NumberOfVoltageTests,1)*Vmax;
MinVoltage = ones(NumberOfVoltageTests,1)*min(VoltageSequence);

% New Bar Plot

%StaticDots1 = Ix_front == 0;
%StaticDots1 = StaticDots1 + (Ix_back == 0);
%StaticDots1 = StaticDots1 + (Iy_up == 0);
%StaticDots1 = StaticDots1 + (Iy_down == 0);
%DynamicDots1 = StaticDots1 == 0;


DynamicDots1 = Ix_front ~= 0;
DynamicDots1 = DynamicDots1 + (Ix_back ~= 0);
DynamicDots1 = DynamicDots1 + (Iy_up ~= 0);
DynamicDots1 = DynamicDots1 + (Iy_down ~= 0);
StaticDots1 = DynamicDots1 == 0;

for p = 1:NumberOfDots(1)*NumberOfDots(2)
    if DynamicDots1(p) ~= 0
        DynamicDots(p) = AveragedState(p);
    end
        if StaticDots1(p) ~= 0
            StaticDots(p) = AveragedState(p);
        end
end

%% I may need to invert it



ax1 = subplot(2,3,1);
bar3(ax1,StaticDots,'r')
hold on
bar3(ax1,DynamicDots,'b')
%alpha(0.5)
hold off
zlim ([-5 5])
view(ax1,az,el)




Time = 1:length(MinVoltage);
%% Voltage Diagram
ax3 = subplot(2,3,2);
plot(ax3,Time,MinVoltage,'-b',Time,MaxVoltage,'-b',Time,VoltageVector,'-rs')
ylabel(ax3,'V/VT (NU)')
xlabel(ax3,'Measurement (NU)');
ylim(ax3,[0.95*min(min(min(MinVoltage))) 1.05*max(max(max(MaxVoltage,MinVoltage)))])

[~,i] = max(VoltageVector);

CurrentThroughSystem = sum(Full_CurrentThroughSystem.');
ax4 = subplot(2,3,3);
if i == n
semilogy(ax4,VoltageVector(1:n),CurrentThroughSystem(1:n),'-sb')
end
if i < n
    hold on
    semilogy(ax4,VoltageVector(i:n),CurrentThroughSystem(i:n),'-sg')
    hold off
end
if max(CurrentThroughSystem) > 0
ylim(ax4,[0 max(CurrentThroughSystem)])
end
ylabel(ax4,'Current (E)')
xlabel(ax4,'V/VT (NU)');
%ylim(ax4,[0.95*min(MinVoltage) 1.05*max(MaxVoltage)])




%% transition rates

X_TransitionArray1_y = zeros(NumberOfDots(1),NumberOfDots(2));
X_TransitionArray2_y = zeros(NumberOfDots(1),NumberOfDots(2));
X_TransitionOffArray_y= zeros(NumberOfDots(1),NumberOfDots(2));
Y_TransitionArray1_x= zeros(NumberOfDots(1),NumberOfDots(2));
Y_TransitionArray2_x= zeros(NumberOfDots(1),NumberOfDots(2));



ax5 = subplot(2,3,5);

Tx1 = quiver(ax5,x,y,X_TransitionArray1.',X_TransitionArray1_y.','b');
Tx1.AutoScale = 'off';
Tx1.ShowArrowHead = 'off';
xlim([(min(min(x))-1) (max(max(x))+1)])
ylim([(min(min(y))-1) (max(max(y))+1)])
hold on

Tx2 = quiver(ax5,x,y,X_TransitionArray2.',X_TransitionArray2_y.','b');
Tx2.AutoScale = 'off';
Tx2.ShowArrowHead = 'off';
xlim([(min(min(x))-1) (max(max(x))+1)])
ylim([(min(min(y))-1) (max(max(y))+1)])
hold on

Tx3 = quiver(ax5,x,y,Y_TransitionArray1_x.',Y_TransitionArray1.','b');
Tx3.AutoScale = 'off';
Tx3.ShowArrowHead = 'off';
xlim([(min(min(x))-1) (max(max(x))+1)])
ylim([(min(min(y))-1) (max(max(y))+1)])
hold on
Tx4 = quiver(ax5,x,y,Y_TransitionArray2_x.',Y_TransitionArray2.','b');
Tx4.AutoScale = 'off';
Tx4.ShowArrowHead = 'off';
xlim([(min(min(x))-1) (max(max(x))+1)])
ylim([(min(min(y))-1) (max(max(y))+1)])
hold on
Tx5 = quiver(ax5,x,y,X_TransitionOffArray.',X_TransitionOffArray_y.','b');
Tx5.AutoScale = 'off';
Tx5.ShowArrowHead = 'off';
xlim([(min(min(x))-1) (max(max(x))+1)])
ylim([(min(min(y))-1) (max(max(y))+1)])

for n = 1:NumberOfDots(2)
   % y(n,1:NumberOfDots(2)) = x(n)*ones(size(x));
    hold on
    scatter(ax5,x(n,:),y(n,:),'ks');
    hold off
end
xlabel(ax5,'Transition Rate Disorder')
hold off


%title(ax5,sprintf('Averaged State of system:  C/Cg = %g \n Averageing over %d Transfered Charges',CCg,AveragingNumberOfCharges))

title(ax5,sprintf('Averaged State of system:  Vg = %g \n Averageing over %d Transfered Charges',Vg,AveragingNumberOfCharges))


%% Capacitance Plot

CapacitanceNormalizationFactor = 1/(2*max(max(abs(CM - diag(diag(CM))))));

%CapacitanceNormalizationFactor = 1/(max(max(C+SizeAndDisorder_parameters.C_Disorder)));


            CapacitanceXMatrix1 = zeros(NumberOfDots(1),NumberOfDots(2));
            CapacitanceXMatrix2= zeros(NumberOfDots(1),NumberOfDots(2));
            CapacitanceYMatrix1= zeros(NumberOfDots(1),NumberOfDots(2));
            CapacitanceYMatrix2= zeros(NumberOfDots(1),NumberOfDots(2));
            CapacitanceXMatrixOff= zeros(NumberOfDots(1),NumberOfDots(2));

ax6 = subplot(2,3,6);
for i = 1:NumberOfDots(1)*NumberOfDots(2)
    for j = 1:NumberOfDots(1)*NumberOfDots(2)
        if CM(i,j) ~= 0
            
            Irow1 = mod(i,NumberOfDots(1));
            Icol1 = (i-mod(i,NumberOfDots(1)))/NumberOfDots(1)+1;
            Irow2 =    mod(j,NumberOfDots(1)) ;      
            Icol2 = (j-mod(j,NumberOfDots(1)))/NumberOfDots(1)+1;

            if Irow1 == 0
                Irow1 = NumberOfDots(1);
                Icol1 = Icol1 -1;
            end
            if Irow2 == 0
                Irow2 = NumberOfDots(1);
                Icol2 = Icol2 - 1;
            end
            
            if Irow2 > Irow1
                if mod(Irow1,2) == 1
            CapacitanceXMatrix1(Irow1,Icol1) = -CM(i,j);
            CapacitanceXMatrix1(Irow2,Icol2) = CM(i,j);
                end
                if mod(Irow1,2) == 0
            CapacitanceXMatrix2(Irow1,Icol1) = -CM(i,j);
            CapacitanceXMatrix2(Irow2,Icol2) = CM(i,j);
                end
            end
            
            if Icol2 > Icol1
                if mod(Icol1,2) == 1
            CapacitanceYMatrix1(Irow1,Icol1) = -CM(i,j);
            CapacitanceYMatrix1(Irow2,Icol2) = CM(i,j);
                end
                if mod(Icol1,2) == 0
            CapacitanceYMatrix2(Irow1,Icol1) = -CM(i,j);
            CapacitanceYMatrix2(Irow2,Icol2) = CM(i,j);
                end
            end
            
            if Irow1 == 1
            CapacitanceXMatrixOff(Irow1,Icol1) = -C;
            end
            if Irow1 == NumberOfDots(1)
                CapacitanceXMatrixOff(Irow1,Icol1) = C;
            end
            
            if i == j
                if max(CgVector)/Cg <= 1.7
                if i == 1
                    c = 1;
                    hold on
                    scatter(ax6,Irow1,Icol1,[],c,'s','filled')
                    xlim([(min(min(x))-1) (max(max(x))+1)])
                    ylim([(min(min(y))-1) (max(max(y))+1)])
                    hold off
                end
                end
                
                c = CgVector(i)/(2*Cg);
                hold on
                scatter(ax6,Irow1,Icol1,[],c,'s','filled')
                xlim([(min(min(x))-1) (max(max(x))+1)])
                ylim([(min(min(y))-1) (max(max(y))+1)])
                hold off
            end
        end
    end
end

hold on
% Normalizing
            CapacitanceXMatrix1 = CapacitanceNormalizationFactor*CapacitanceXMatrix1;
            CapacitanceXMatrix2= CapacitanceNormalizationFactor*CapacitanceXMatrix2;
            CapacitanceYMatrix1= CapacitanceNormalizationFactor*CapacitanceYMatrix1;
            CapacitanceYMatrix2= CapacitanceNormalizationFactor*CapacitanceYMatrix2;
            CapacitanceXMatrixOff= CapacitanceNormalizationFactor*CapacitanceXMatrixOff;

% Making dummer arrays for plot
            CapacitanceXMatrix1_y = zeros(NumberOfDots(1),NumberOfDots(2));
            CapacitanceXMatrix2_y= zeros(NumberOfDots(1),NumberOfDots(2));
            CapacitanceYMatrix1_x= zeros(NumberOfDots(1),NumberOfDots(2));
            CapacitanceYMatrix2_x= zeros(NumberOfDots(1),NumberOfDots(2));
            CapacitanceXMatrixOff_y= zeros(NumberOfDots(1),NumberOfDots(2));



%ax6 = subplot(2,3,5)

Cx1 = quiver(ax6,x,y,CapacitanceXMatrix1.',CapacitanceXMatrix1_y.','b');
Cx1.AutoScale = 'off';
Cx1.ShowArrowHead = 'off';
xlim([(min(min(x))-1) (max(max(x))+1)])
ylim([(min(min(y))-1) (max(max(y))+1)])
hold on

Cx2 = quiver(ax6,x,y,CapacitanceXMatrix2.',CapacitanceXMatrix2_y.','b');
Cx2.AutoScale = 'off';
Cx2.ShowArrowHead = 'off';
xlim([(min(min(x))-1) (max(max(x))+1)])
ylim([(min(min(y))-1) (max(max(y))+1)])
hold on

Cx3 = quiver(ax6,x,y,CapacitanceYMatrix1_x.',CapacitanceYMatrix1.','b');
Cx3.AutoScale = 'off';
Cx3.ShowArrowHead = 'off';
xlim([(min(min(x))-1) (max(max(x))+1)])
ylim([(min(min(y))-1) (max(max(y))+1)])
hold on
Cx4 = quiver(ax6,x,y,CapacitanceYMatrix2_x.',CapacitanceYMatrix2.','b');
Cx4.AutoScale = 'off';
Cx4.ShowArrowHead = 'off';
xlim([(min(min(x))-1) (max(max(x))+1)])
ylim([(min(min(y))-1) (max(max(y))+1)])
hold on

Cx5 = quiver(ax6,x,y,CapacitanceXMatrixOff.',CapacitanceXMatrixOff_y.','b');
Cx5.AutoScale = 'off';
Cx5.ShowArrowHead = 'off';
xlim([(min(min(x))-1) (max(max(x))+1)])
ylim([(min(min(y))-1) (max(max(y))+1)])

xlabel(ax6,'Capacitance Disorder')
hold off






%% Current Plot
%%The nonzero matrixes are      :   Ix_front,Ix_back,Iy_up,Iy_down
Iy_front = zeros(size(Ix_front)).';
Iy_back = zeros(size(Ix_front)).';
Ix_up = zeros(size(Ix_front)).';
Ix_down = zeros(size(Ix_front)).';

%% Normalizing
%CurrentNormalizationFactor = NumberOfDots(1)/sum(sum(abs(Ix_front) + abs(Ix_back) + abs(Iy_up) + abs(Iy_down)));
CurrentNormalizationFactor = 1./max(max(max(max(abs(Ix_front))),max(max(abs(Ix_back)))),max(max(max(abs(Iy_up))),max(max(abs(Iy_down)))));

Ix_front = CurrentNormalizationFactor*Ix_front.';
Ix_back = CurrentNormalizationFactor*Ix_back.';
Iy_up = CurrentNormalizationFactor*Iy_up.';
Iy_down = CurrentNormalizationFactor*Iy_down.';
%  title(['Averaged State Of system ',num2str(NumberOfDots),' Dots'])

ax2 = subplot(2,3,4);


%% Front Arrows
qFront = quiver(ax2,x,y,Ix_front,Iy_front,'b');
qFront.AutoScale = 'off';
xlim([(min(min(x))-1) (max(max(x))+1)])
ylim([(min(min(y))-1) (max(max(y))+1)])
%% Back Arrows
hold on
qBack = quiver(ax2,x,y,Ix_back,Iy_back,'b');
qBack.AutoScale = 'off';
xlim([(min(min(x))-1) (max(max(x))+1)])
ylim([(min(min(y))-1) (max(max(y))+1)])
%% Up Arrows
hold on
qUp = quiver(ax2,x,y,Ix_up,Iy_up,'b');
qUp.AutoScale = 'off';
xlim([(min(min(x))-1) (max(max(x))+1)])
ylim([(min(min(y))-1) (max(max(y))+1)])
%% Down Arrows
hold on
qDown = quiver(ax2,x,y,Ix_down,Iy_down,'b');
qDown.AutoScale = 'off';
xlim([(min(min(x))-1) (max(max(x))+1)])
ylim([(min(min(y))-1) (max(max(y))+1)])
%% Dot Animation
%x = 1:NumberOfDots(1);
for n = 1:NumberOfDots(2)
   % y(n,1:NumberOfDots(2)) = x(n)*ones(size(x));
    hold on
    scatter(ax2,x(n,:),y(n,:),'ks');
    hold off
end

hold off
xlim([0 NumberOfDots(1)+1])
ylim([0 NumberOfDots(2)+1])
xlabel(ax2,'Current Distribution')
grid on


%title(sprintf('Averaged State of system:  C/Cg = %g \n Averageing over %d Transfered Charges',CCg,AveragingNumberOfCharges))

