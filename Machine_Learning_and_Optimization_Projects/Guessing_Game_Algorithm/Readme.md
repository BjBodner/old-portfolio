# The Guessing Game Algorithm

This is an optimization algorithm which I developed during the last year of my undergraduate degree.
It is based on quasi - newton optimization methods, but has an addition of randomness in the direction of optimization
This allows us to keep the dimensionallity of the Hessian, and the jacobian relatively small
while relying on the random processes to explore new directions which could lead to minimization of the objective function
This gives it the advatage of that the required memory and needed calclations in
each optimization step scales linearly with the size of the search space.
Unlke BFGS which scales as the dimansionality of the search space squared - 
which is not practicle for extremely high dimensional problems, where the dimensionality of 
the search space is on the order of millions of variables.
