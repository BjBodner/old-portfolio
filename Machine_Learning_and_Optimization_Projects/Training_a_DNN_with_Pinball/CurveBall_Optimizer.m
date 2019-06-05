function [W1_prev,W2_prev,W3_prev,b1_prev,b2_prev,b3_prev] = CurveBall_Optimizer(X,Y,Do_Single_Class_Classification,Do_Multi_Class_Classification)


%Do_Single_Class_Classification = 1;

%Do_Multi_Class_Classification = 1;

%a = open('DataSetForDigitRecognition_binance.mat');
%X = a.DigitVector;
%Y = a.DigitLabel;


if Do_Single_Class_Classification == 1
    Y = Y == 1;
end

%% Converting Data into multiclass classification
if Do_Multi_Class_Classification == 1
    for sample = 1:length(Y)
        for i = 0:9
            Expanded_Y(i+1,sample) = Y(sample) == i;
        end
    end
    
    Y = Expanded_Y;
end

Number_Of_Epochs = 5;
Number_Of_Minibatches = 1;
NumberOfItterations_per_Minibatch = 50;
dt = 0.1;
t_Total = 2;



PlotProgress = 1;

NumberOfSamples = length(Y(1,:));
Size_Of_TrainingSet = 0.7;
Size_Of_CV = 0.15;
Size_Of_Test = 0.15;

FinalIndexOfTrainingSet = round(Size_Of_TrainingSet*NumberOfSamples);
InitialIndexOfCV = FinalIndexOfTrainingSet+1;
FinalIndexOfCV = InitialIndexOfCV + round(Size_Of_CV*NumberOfSamples);
InitialIndexOf_Test = FinalIndexOfCV+1;
FinalIndexOf_Test = NumberOfSamples;

MiniBatch_Index(1,1) = 1;
for minibatch = 1:Number_Of_Minibatches
    if minibatch == 1
        MiniBatch_Index(minibatch,2) = round(FinalIndexOfTrainingSet/Number_Of_Minibatches);
    end
    if minibatch ~= 1
        MiniBatch_Index(minibatch,1) = MiniBatch_Index(minibatch-1,2) + 1;
        MiniBatch_Index(minibatch,2) = round(minibatch*FinalIndexOfTrainingSet/Number_Of_Minibatches);
    end
end
X1 = X(:,MiniBatch_Index(1,1):MiniBatch_Index(1,2));
Y1 = Y(:,MiniBatch_Index(1,1):MiniBatch_Index(1,2));

Ntot = t_Total/dt + 1;
CostFunction_track = zeros(1,NumberOfItterations_per_Minibatch*Number_Of_Minibatches*Number_Of_Epochs);
CostFunction = zeros(Ntot,1);



% initialize Weights and biases
[W1_prev,W2_prev,W3_prev,b1_prev,b2_prev,b3_prev] = Generate_Random_Vectors(X1,Y1);

NumberOfParameters = length(W1_prev(:,1))*length(W1_prev(1,:)) + length(W2_prev(:,1))*length(W2_prev(1,:))+...
    length(W3_prev(:,1))*length(W3_prev(1,:)) + length(b1_prev(:,1))*length(b1_prev(1,:)) + length(b2_prev(:,1))*length(b2_prev(1,:))+...
    length(b3_prev(:,1))*length(b3_prev(1,:));

b1 = zeros([size(b1_prev),Ntot]);
b2 = zeros([size(b2_prev),Ntot]);
b3 = zeros([size(b3_prev),Ntot]);
W1 = zeros([size(W1_prev),Ntot]);
W2 = zeros([size(W2_prev),Ntot]);
W3 = zeros([size(W3_prev),Ntot]);


GradientVector_W1 = zeros(size(W1_prev));
GradientVector_W2 = zeros(size(W2_prev));
GradientVector_W3 = zeros(size(W3_prev));
GradientVector_b1 = zeros(size(b1_prev));
GradientVector_b2 = zeros(size(b2_prev));
GradientVector_b3 = zeros(size(b3_prev));

Total_Itteration = 1;
tic
for epoc = 1:Number_Of_Epochs
    for minibatch = 1:Number_Of_Minibatches
        X1 = X(:,MiniBatch_Index(minibatch ,1):MiniBatch_Index(minibatch ,2));
        Y1 = Y(:,MiniBatch_Index(minibatch ,1):MiniBatch_Index(minibatch ,2));
        for itteration = 1:NumberOfItterations_per_Minibatch
            
            [RandomVector_W1,RandomVector_W2,RandomVector_W3,RandomVector_b1,RandomVector_b2,RandomVector_b3] = Generate_Random_Vectors(X1,Y1);
            
            RelativeWeightOfVectors = exp(-2*Total_Itteration/(Number_Of_Epochs*Number_Of_Minibatches*NumberOfItterations_per_Minibatch));

            %% Implimentation without momentum
            Update_Vectors_Without_Momentum = 0;
            if Update_Vectors_Without_Momentum == 1
            RandomVector_W1 = RelativeWeightOfVectors*RandomVector_W1 + (1-RelativeWeightOfVectors)*GradientVector_W1;
            RandomVector_W2 = RelativeWeightOfVectors*RandomVector_W2 + (1-RelativeWeightOfVectors)*GradientVector_W2;
            RandomVector_W3 = RelativeWeightOfVectors*RandomVector_W3 + (1-RelativeWeightOfVectors)*GradientVector_W3;
            RandomVector_b1 = RelativeWeightOfVectors*RandomVector_b1 + (1-RelativeWeightOfVectors)*GradientVector_b1;
            RandomVector_b2 = RelativeWeightOfVectors*RandomVector_b2 + (1-RelativeWeightOfVectors)*GradientVector_b2;
            RandomVector_b3 = RelativeWeightOfVectors*RandomVector_b3 + (1-RelativeWeightOfVectors)*GradientVector_b3;
            end
            
            %% Implimentation of momentum
            beta = 0.8;
            Update_Vectors_With_Momentum = 1;
            if Update_Vectors_With_Momentum == 1
            RandomVector_W1 = beta*RandomVector_W1 + (1-beta)*(RelativeWeightOfVectors*RandomVector_W1 + (1-RelativeWeightOfVectors)*GradientVector_W1);
            RandomVector_W2 = beta*RandomVector_W2 + (1-beta)*(RelativeWeightOfVectors*RandomVector_W2 + (1-RelativeWeightOfVectors)*GradientVector_W2);
            RandomVector_W3 = beta*RandomVector_W3 + (1-beta)*(RelativeWeightOfVectors*RandomVector_W3 + (1-RelativeWeightOfVectors)*GradientVector_W3);
            RandomVector_b1 = beta*RandomVector_b1 + (1-beta)*(RelativeWeightOfVectors*RandomVector_b1 + (1-RelativeWeightOfVectors)*GradientVector_b1);
            RandomVector_b2 = beta*RandomVector_b2 + (1-beta)*(RelativeWeightOfVectors*RandomVector_b2 + (1-RelativeWeightOfVectors)*GradientVector_b2);
            RandomVector_b3 = beta*RandomVector_b3 + (1-beta)*(RelativeWeightOfVectors*RandomVector_b3 + (1-RelativeWeightOfVectors)*GradientVector_b3);
            end
            
            
            n = 1;
            %% Random Vector Optimization;
            for t = 0:dt:t_Total
                % Advance Along Random Vector
                [b1(:,:,n),b2(:,:,n),b3(:,:,n),W1(:,:,n),W2(:,:,n),W3(:,:,n)] = Advance_Wb_Along_Vector(W1_prev,W2_prev,W3_prev,b1_prev,b2_prev,b3_prev,RandomVector_W1,RandomVector_W2,RandomVector_W3,RandomVector_b1,RandomVector_b2,RandomVector_b3,t);
                
                %% ForwardProp
                [A3] = ForwardProp(X1,W1(:,:,n),W2(:,:,n),W3(:,:,n),b1(:,:,n),b2(:,:,n),b3(:,:,n));
                
                %% Use Least Squares Cost Function
                %CostFunction(n) = (1/2*NumberOfSamples)*sum((A3 - Y).^2);
                
                %% Use Logistic Regression Cost Function
                CostFunction(n) = (1/2*NumberOfSamples)*sum(sum(-Y1.*log(A3) - (1-Y1).*log(1-A3)));
                n = n+1;
                
            end
            
            
            %% Gradient Estimation
            if max(round((t_Total/dt)*(1-RelativeWeightOfVectors)),1) > 1
            for random_test = 1:max(round((t_Total/dt)*(1-RelativeWeightOfVectors)),1)
                
                b1(:,:,n) = b1_prev + dt*(rand(size(b1_prev))-0.5);
                b2(:,:,n) = b2_prev + dt*(rand(size(b2_prev))-0.5); 
                b3(:,:,n) = b3_prev + dt*(rand(size(b3_prev))-0.5); 
                W1(:,:,n) = W1_prev + dt*(rand(size(W1_prev))-0.5);
                W2(:,:,n) = W2_prev + dt*(rand(size(W2_prev))-0.5); 
                W3(:,:,n) = W3_prev + dt*(rand(size(W3_prev))-0.5);
                
                
                                %% ForwardProp
                [A3] = ForwardProp(X1,W1(:,:,n),W2(:,:,n),W3(:,:,n),b1(:,:,n),b2(:,:,n),b3(:,:,n));
                
                %% Use Least Squares Cost Function
                %CostFunction(n) = (1/2*NumberOfSamples)*sum((A3 - Y).^2);
                
                %% Use Logistic Regression Cost Function
                CostFunction(n) = (1/2*NumberOfSamples)*sum(sum(-Y1.*log(A3) - (1-Y1).*log(1-A3)));
                n = n+1;
            end
            
            %% Calculating  best Gradient
            
                GradientVector_W1 = reshape(permute(max(permute(reshape(W1-W1_prev,length(W1(:,1,1))*length(W1(1,:,1)),length(W1(1,1,:)))*diag((CostFunction-CostFunction(1))),[2 1])),[2 1]),length(W1(:,1,1)),length(W1(1,:,1)));
                GradientVector_W2 = reshape(permute(max(permute(reshape(W2-W2_prev,length(W2(:,1,1))*length(W2(1,:,1)),length(W2(1,1,:)))*diag((CostFunction-CostFunction(1))),[2 1])),[2 1]),length(W2(:,1,1)),length(W2(1,:,1)));
                GradientVector_W3 = reshape(permute(max(permute(reshape(W3-W3_prev,length(W3(:,1,1))*length(W3(1,:,1)),length(W2(1,1,:)))*diag((CostFunction-CostFunction(1))),[2 1])),[2 1]),length(W3(:,1,1)),length(W3(1,:,1)));
                GradientVector_b1 = max(permute(squeeze(b1-b1_prev)*diag((CostFunction-CostFunction(1))),[2 1])).';
                GradientVector_b2 = max(permute(squeeze(b2-b2_prev)*diag((CostFunction-CostFunction(1))),[2 1])).';
                GradientVector_b3 = max(permute(squeeze(b3-b3_prev)*diag((CostFunction-CostFunction(1))),[2 1])).';
            
                %Normalizing
                GradientVector_W1 = GradientVector_W1/(max(max(GradientVector_W1)));
                GradientVector_W2 = GradientVector_W2/(max(max(GradientVector_W2)));
                GradientVector_W3 = GradientVector_W3/(max(max(GradientVector_W3)));
                GradientVector_b1 = GradientVector_b1/(max(max(GradientVector_b1)));
                GradientVector_b2 = GradientVector_b2/(max(max(GradientVector_b2)));
                GradientVector_b3 = GradientVector_b3/(max(max(GradientVector_b3)));
            end  
            
            % Update Weights and biases
            Total_Itteration = itteration + (minibatch-1)*NumberOfItterations_per_Minibatch + (epoc-1)*NumberOfItterations_per_Minibatch*Number_Of_Minibatches;
            [CostFunction_track(Total_Itteration ),I] = min(CostFunction);
            [W1_prev,W2_prev,W3_prev,b1_prev,b2_prev,b3_prev] = Update_WB(W1,W2,W3,b1,b2,b3,I);
            
            
            
            
        end
        %% Plot Progress
        if PlotProgress == 1
            plot(nonzeros(CostFunction_track));
            s = strcat('Cost Function through optimization');
            title(s)
            xlabel('Itterations of optimizer')
            ylabel('Cost Function')
            ylim([0 1.1*max(CostFunction_track)])
            getframe(gcf);
        end
    end
end
t2 = toc

InitialIndexOfCV = FinalIndexOfTrainingSet+1;
FinalIndexOfCV = InitialIndexOfCV + round(Size_Of_CV*NumberOfSamples);
InitialIndexOf_Test = FinalIndexOfCV+1;
FinalIndexOf_Test = NumberOfSamples;

X1 = X(:,InitialIndexOfCV:FinalIndexOfCV);
Y1 = Y(:,InitialIndexOfCV:FinalIndexOfCV);
[A3] = ForwardProp(X1,W1_prev,W2_prev,W3_prev,b1_prev,b2_prev,b3_prev);
Predictions = zeros(length(Y1(:,1)),length(Y1(1,:)));
if length(Y1(:,1)) > 1
    for sample = 1:length(Y1(1,:))
        [~,I] = max(A3(:,sample));
        Predictions(I,sample) = 1;
    end
end
if length(Y1(:,1)) == 1
    Predictions = A3>0.5;
end
Percent_Error_CV = 100*sum(sum((Predictions ~= Y1))/(max(length(Y1(:,1)),2)*length(Y1(1,:))));

X1 = X(:,InitialIndexOf_Test:FinalIndexOf_Test);
Y1 = Y(:,InitialIndexOf_Test:FinalIndexOf_Test);
[A3] = ForwardProp(X1,W1_prev,W2_prev,W3_prev,b1_prev,b2_prev,b3_prev);
Predictions = zeros(length(Y1(:,1)),length(Y1(1,:)));
if length(Y1(:,1)) > 1
    for sample = 1:length(Y1(1,:))
        [~,I] = max(A3(:,sample));
        Predictions(I,sample) = 1;
    end
end
if length(Y1(:,1)) == 1
    Predictions = A3>0.5;
end
Percent_Error_test = 100*sum(sum((Predictions ~= Y1))/(max(length(Y1(:,1)),2)*length(Y1(1,:))));

X1 = X(:,1:FinalIndexOfTrainingSet);
Y1 = Y(:,1:FinalIndexOfTrainingSet);
[A3] = ForwardProp(X1,W1_prev,W2_prev,W3_prev,b1_prev,b2_prev,b3_prev);
Predictions = zeros(length(Y1(:,1)),length(Y1(1,:)));
if length(Y1(:,1)) > 1
    for sample = 1:length(Y1(1,:))
        [~,I] = max(A3(:,sample));
        Predictions(I,sample) = 1;
    end
end
if length(Y1(:,1)) == 1
    Predictions = A3>0.5;
end
Train_Error = 100*sum(sum((Predictions ~= Y1))/(max(length(Y1(:,1)),2)*length(Y1(1,:))));


plot(CostFunction_track)
s1 = strcat('Train Error=',num2str(Train_Error), '%, CV Error=',num2str(Percent_Error_CV),'%, Test set Error=',num2str(Percent_Error_test),'%');
s2 = strcat(' Optimized : ',num2str(NumberOfParameters),' parameters in, :',num2str(t2),' seconds');

title({s2;' ';s1})
xlabel('Itterations of optimizer')
ylabel('Cost Function')
ylim([0 1.1*max(CostFunction_track)])