# The Adaptive Two Mode (ATM) Optimization Algorithm

<p align="center">
   <img src=https://github.com/BjBodner/Portfolio/blob/master/Machine_Learning_and_Optimization_Projects/Images/ATM_Optimization_Snapshot.JPG width="300" title="Snapshot Of ATM Optimization Algorithm">
   <img src=https://github.com/BjBodner/Portfolio/blob/master/Machine_Learning_and_Optimization_Projects/Images/BBOB_20D.JPG width="400" title="Comparing ATM to other optimizers in the seperable functions section of the BBOB testbed">
   
## Intro: 
This is an gradient-free optimization algorithm designed for high dimensional problems such as optimizing deep neural networks.
The algorithm is based of evolutionary strategies for optimization, with additional add-on which allow it to rapidly transverse large distances in the parameter search space. It has a built in metalearning system, to for automatic addpatation of the hyperparamers to the problem at hand. It is architecture agnostic and does not require backpropgation as part of the optimization process, which can allow for more freedom in architecture design of neural network models. 


To try it out, download the files and see example code snippit titled "Example_Of_Calling_Adaptive_To_Mode_Optimizer.py"
to see how to use this optimization algorithm.

As of June 2019, the algorithm is still in stages of addaptation to the deep learning frameworks, PyTorch and Tensorflow. 


## Abstract:
In deep learning and physical science problems, there is a growing need for better optimization methods capable of working in very high dimensional settings. Though the use of approximated Hessians and co-variance matrices can accelerate the optimization process, these methods do not always scale well to high dimensional settings. In an attempt to meet these needs, in this paper, we propose an optimization method, called Adaptive Two Mode (ATM), that does not use any DxD objects, but rather relies on the interplay of isotropic and directional search modes. It can adapt to different optimization problems, by the use of an online parameter tuning scheme, that allocates more resources to better performing versions of the algorithm. To test the performance of this method, the Adaptive Two Mode algorithm was benchmarked on the noiseless BBOB-2009 testbed. Our results show that it is capable of solving 23/24 of the functions in 2D and can solve higher dimensional problems that do not require many changes in the direction of the search. However, it underperforms on problems in which the function to be minimized changes rapidly in non-separable directions, yet mildly in others.
