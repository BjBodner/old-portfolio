# The Pinball Optimization Algorithm



This is an optimization algorithm I developed during the last year of my undergrad.
It used a combination of two search strategies - Isotropic random search and grid search along a line.
This line is either chosen from the sampled directions found from the random search, if that direction
leads to improvement of he cost function. If no such direction is found then the direction 
is chosen at random from a normal distribution.

This algorithm is quite simple to implement and it only has two hyperparameters. 
It is a quick an dirty way to optimize scalar functions in very high dimensional settings, such as in deep learning

(Also known as curveball.)
