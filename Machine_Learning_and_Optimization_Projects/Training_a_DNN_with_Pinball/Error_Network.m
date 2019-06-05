[trainingdata, traingnd] = mnist_parse('train-images.idx3-ubyte', 'train-labels.idx1-ubyte');
trainingdata = double(reshape(trainingdata, size(trainingdata,1)*size(trainingdata,2), []).');
traingnd = double(traingnd);

i = 1;
X = trainingdata(1+(i-1)*1000:i*1000,:).';
Y = traingnd(1+(i-1)*1000:i*1000).';

%% Optimizer
Do_Single_Class_Classification = 0;
Do_Multi_Class_Classification = 1;
[W1_prev,W2_prev,W3_prev,b1_prev,b2_prev,b3_prev] = CurveBall_Optimizer(X,Y,Do_Single_Class_Classification,Do_Multi_Class_Classification);

Do_Multi_Class_Classification = 1;
if Do_Multi_Class_Classification == 1
    for sample = 1:length(Y)
        for i = 0:9
            Expanded_Y(i+1,sample) = Y(sample) == i;
        end
    end
    
    Y = Expanded_Y;
end

%% Testing Network
[A3] = ForwardProp(X,W1_prev,W2_prev,W3_prev,b1_prev,b2_prev,b3_prev);
Predictions = zeros(length(Y(:,1)),length(Y(1,:)));
if length(Y(:,1)) > 1
    for sample = 1:length(Y(1,:))
        [~,I] = max(A3(:,sample));
        Predictions(I,sample) = 1;
    end
end
if length(Y(:,1)) == 1
    Predictions = A3>0.5;
end



Train_Error = 100*sum(sum((Predictions ~= Y))/(max(length(Y(:,1)),2)*length(Y(1,:))));

pause(2)


%% Generate Error Network
X_For_Error_Network = A3;
Y_For_Error_Network = sum(Predictions ~= Y)/2;

%% Optimizer
Do_Single_Class_Classification = 1;
Do_Multi_Class_Classification = 0;
[W1_prev,W2_prev,W3_prev,b1_prev,b2_prev,b3_prev] = CurveBall_Optimizer(X_For_Error_Network,Y_For_Error_Network,Do_Single_Class_Classification,Do_Multi_Class_Classification);


[A3] = ForwardProp(X_For_Error_Network,W1_prev,W2_prev,W3_prev,b1_prev,b2_prev,b3_prev);
Predictions = zeros(length(Y_For_Error_Network(:,1)),length(Y_For_Error_Network(1,:)));
if length(Y_For_Error_Network(:,1)) > 1
    for sample = 1:length(Y_For_Error_Network(1,:))
        [~,I] = max(A3(:,sample));
        Predictions(I,sample) = 1;
    end
end
if length(Y_For_Error_Network(:,1)) == 1
    Predictions = A3>0.5;
end

Train_Error = 100*sum(sum((Predictions ~= Y_For_Error_Network))/(max(length(Y_For_Error_Network(:,1)),2)*length(Y_For_Error_Network(1,:))));