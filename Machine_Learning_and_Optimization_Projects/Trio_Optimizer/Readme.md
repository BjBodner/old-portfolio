# The Trio Optimization Algorithm


The Trio framework was created as a boosting framework for optimization algorithms.
It allows us to combine different optimization algorithms, which use parallel evaluation strategies,
in such a way that prioritizes better performing algorithms and allow us to maximize they contributions to the 
optimization of the problem.
This is done by a resource allocation algorithm, which distributes samples between the different algorithm,
and allocates more samples to better performing algorithms.

The Trio algorithm is built in a modular way, which allows for combination of any number of optimization algorithms.
In this implementations we did so, only with 3 of my optimization algorithms - Two mode, Guessing Game, and Pinball.
This composite optimization algorithm, was quite succesful at optimizing relatively simple cost function,
but has not yet been tested on large scale problems. 
I hope to continue to work on this project in the future and make it more accessable.

You can see the comparison of the different algorithm on a custom made
cost function by running the file "Trio_Optimizer_With_Multiple_Tests_Cost1.m"

These are all custom made optimization algorithms


