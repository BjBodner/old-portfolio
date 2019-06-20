# Learning Lagrangians Of Physical Systems


This project was created during my first semester at Brown, as a final project in my course on modern classical physics.

This project was aimed at learning a representation of the lagrangians which govern behaviour of a 
few physical systems.  That is taking the observations of the states of the particles in a system,
and trying to learn a lagrangian which generates the observed behaviour. 
This can be rephrased as learning the lagrangian which is minimized by the observed space-time path.

First I generated data over constant time intervals, using a simulation of the known lagrangians of
 a 1D hamonic oscillator and 
a particle in a central force (like the earth around the sun). Then the derrivative of these lagrangians 
were taken to generate the equations of motion of these systems. More specifically this helped 
calculate the changes of the particles state, between different time steps, the changes in the
position and momenta.


Once the data was created in this was, 
a complex valued neural network was trained to generate a scalar function (outputs a single real value),
that is it inputs the current state and it estimates the value of the corresponding lagrangian.
Then the derrivative of this function was taken, in order to predict the changes in the state
of the system (positions and momenta). The cost function used to train this system, was the 
squared difference between the predicted state changes and the true changes fromt the data.
The networks which generate these lagrangians were trained using one of my
black box optimization algorithms - Two mode. 

This systems was able to learn very good representations of the lagrangians as can be seen in the images
of the phase space paths they generated. However, it had some difficulty dealing with 
situations that had very strong gradients and sharp state transitions, such as in the central force scenario.

