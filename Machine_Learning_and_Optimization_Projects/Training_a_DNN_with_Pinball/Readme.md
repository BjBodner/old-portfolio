# Training a DNN with Pinball



In this project we tested the performance of the pinball algorithm on the mnist data-set.

The algorithm was the optimization task of training a feed forward network, with over 24000 parameters,
 on the mnist dataset.
In this test, the algorithm managed to optimize the the neural networks, and was able to achieve
an test and validation error bellow 15 percent, within 5 epochs, with minibatches of size 50

The test was quite succesful, given the simplicity of the optimization algorithm, and the number of samples it took in each
minibatch. I believe this could be useful for quick and dirty training of relatively simple nets.
This method has the advantage that it does not use any information about the architecture of the net,
so the same algorithm can be be used to train any kind of neural network model. However, more research 
is needed to find the advantages and disadvatages of this method.


Run the "Error_Network.m" file to run an optimize a feed forward net, using the Curveball optimizer on mnist


