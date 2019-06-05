[images, labels] = mnist_parse('train-images.idx3-ubyte', 'train-labels.idx1-ubyte');
[images, labels] = mnist_parse('t10k-images.idx3-ubyte', 't10k-labels.idx1-ubyte');

%% This is how to access the dataset
%digit = images(:,:,k);
%lbl = label(k);


[trainingdata, traingnd] = mnist_parse('train-images.idx3-ubyte', 'train-labels.idx1-ubyte');
trainingdata = double(reshape(trainingdata, size(trainingdata,1)*size(trainingdata,2), []).');
traingnd = double(traingnd);

%RandomVector_Optimizer_Function(trainingdata.',traingnd.')
for i = 1:60
    
X = trainingdata(1+(i-1)*1000:i*1000,:).';
Y = traingnd(1+(i-1)*1000:i*1000).';
%Random_Vector_PlusGadientEstimation_Optimizer(X,Y)

RandomVector_Optimizer_Function(X,Y)
pause(2)
end
[testdata, testgnd] = mnist_parse('t10k-images.idx3-ubyte', 't10k-labels.idx1-ubyte');
testdata = double(reshape(testdata, size(testdata,1)*size(testdata_data,2), []).');
testgnd = double(testgnd);