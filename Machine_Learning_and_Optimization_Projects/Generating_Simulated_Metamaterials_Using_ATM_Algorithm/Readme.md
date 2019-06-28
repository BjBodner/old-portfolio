
# Generating_Simulated_Metamaterials_Using_ATM_Algorithm

<p align="center">
  <img src=https://github.com/BjBodner/Portfolio/blob/master/Machine_Learning_and_Optimization_Projects/Generating_Simulated_Metamaterials_Using_ATM_Algorithm/MetaMaterials.gif
width="350" title="Designing Metamaterials using genetic algorithms">
</p>



This project was created during my second semester at Brown, as part of the final project in our electromagnetism course.

The project consists of a numerical PDE simulation of the propagation of electromagnetic waves through a 2D system.
This 2D system consisted of an antenna which generated the EM waves, perfectly reflecting walls, and a partially transparent dielectric material. The dielectric material in this experiment consisted of a 2D grid of different refractive indexes, which is the metamaterial we are trying to design. The goal of the project was to show that it is possible to optimize the refractive indices within this grid in such a way that generates certain specified optical behaviors. 

This project was mostly inspired by the amazing nanostructures which can be found in butterfly wings, that can reflect very specific wavelengths of light (Image taken from Saranathan et al.).  
<p align="center">
  <img src=https://github.com/BjBodner/Portfolio/blob/master/Machine_Learning_and_Optimization_Projects/Images/Focusing_Picture.JPG width="400" title="Designing Metamaterials using genetic algorithms">
</p>


These nanostructures were created over millions of years through the process of natural selection, which is just one kind of optimization algorithm. In this project I attempted to generate similar optical behaviors using a different optimization algorithm, in a simulated environment. This allowed for testing of the "fitness" of the nanostructures, within the metamaterial, in fractions of seconds, rather than in days/months.

The nanostructures in the metamaterial were optimized to generate two different optical behaviors within the simulated environment.
1. To focus the incoming light waves into a small region of space – i.e. to creating a focusing lens.

<p align="center">
  <img src=https://github.com/BjBodner/Portfolio/blob/master/Machine_Learning_and_Optimization_Projects/Images/Focusing_Picture.JPG width="400" title="Designing Metamaterials using genetic algorithms">
</p>

2. To create a pand-pass filter - which transfer specific bands of frequencies.
<p align="center">
    <img src=https://github.com/BjBodner/Portfolio/blob/master/Machine_Learning_and_Optimization_Projects/Images/Filtering_Picture.JPG width="400" title="Generating Swimming Motions using genetic algortihms">
</p>



This project was very successful at both tasks. However, for the filtering task, this was successful in this
optimization task for certain long wavelength bands of frequencies. This was likely due to the finite resolution
of the dielectric grid.


References:
-
[7]  Vinodkumar Saranathana,b, Chinedum O. Osujib,c,d, Simon G. J. Mochrieb,d,e, Heeso Nohb,d, Suresh Narayananf, Alec Sandyf, Eric R. Dufresneb,d,e,g, and Richard O. Pru 
“Structure, function, and self-assembly of single network gyroid (I4132) photonic crystals in butterfly wing scales”, 11676–11681 ∣ PNAS ∣ June 29, 2010 ∣ vol. 107 ∣ no. 2


