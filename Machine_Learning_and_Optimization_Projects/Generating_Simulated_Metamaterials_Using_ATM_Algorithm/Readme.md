
# Generating_Simulated_Metamaterials_Using_ATM_Algorithm







<p align="center">
    <img src=https://github.com/BjBodner/Portfolio/blob/master/Machine_Learning_and_Optimization_Projects/Images/Filtering_Picture.JPG width="350" title="Generating Swimming Motions using genetic algortihms">
  <img src=https://github.com/BjBodner/Portfolio/blob/master/Machine_Learning_and_Optimization_Projects/Images/Focusing_Picture.JPG width="350" title="Designing Metamaterials using genetic algorithms">
</p>



This project was created during my second semester at Brown, as part of a final project in the electromagnetism course.

The project consists of a numerical PDE simulation of the propogation of electromagnetic waves through a 2D system.
This 2D system consisted of an antenna which generated the EM waves, perfectly reflecting walls,
and a partially transmitting dielectic material. The dielectric material in this experiment consisted of a 2D grid
of different refrective indexes, which we tried to vary in a way which maximizes/minimizes a certain behaviour 
we wish to generate in the interaction of the dielectric material and the incommnig EM waves.

This was in attempt to recreate the conditions and the process which created the amazing nano-structures
in butterfly wings, which can reflect very specific wavelengths of light. 
Though these nano-structures were created of millions of years through the process of evolution
 (a specific optimization algorithm), in this project I attempted to create similar behaviour 
using a different optimization algorith, and the use of a simulated enviournment allows us to test the "fittness"
of the nano-structures in fractions of seconds rather than in days/months.

In this project we attempted to create structures in the dielectric which generate two different 
behaviours in the simulated enviournment.
1. Focusing the incomming lightwaves into a small region of space - creating a lense.
2. Creating a Band-Pass Filter - to tranfer specific bands of frequencies.


This project was very successful at both tasks. However, for the filtering task, this was successful in this
optimization task for certain long wavelength bands of frequencies. This was likely due to the finite resolution
of the dielectric grid.

Videos of the performance of the "learned" filters can be found at:

_____


