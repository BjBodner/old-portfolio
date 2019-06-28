
# Generating_Simulated_Metamaterials_Using_ATM_Algorithm

<p align="center">
  <img src=https://github.com/BjBodner/Portfolio/blob/master/Machine_Learning_and_Optimization_Projects/Generating_Simulated_Metamaterials_Using_ATM_Algorithm/MetaMaterials.gif
width="350" title="Designing Metamaterials using genetic algorithms">
</p>



This project was created during my second semester at Brown, as part of the final project in our electromagnetism course.

The project consists of a numerical PDE simulation of the propagation of electromagnetic waves through a 2D system.
This 2D system consisted of an antenna which generated the EM waves, perfectly reflecting walls, and a partially transparent dielectric material. This metamaterial in this experiment consisted of a 2D grid of different refractive indexes, which is the metamaterial we are trying to design. The goal of the project was to show that it is possible to optimize the refractive indices within this grid in such a way that generates certain specified optical behaviors. 

This project was mostly inspired by the amazing nanostructures which can be found in butterfly wings, that can reflect very specific wavelengths of light (Images taken from [1] and [2]).  
<p align="center">
  <img src=https://github.com/BjBodner/Portfolio/blob/master/Machine_Learning_and_Optimization_Projects/Generating_Simulated_Metamaterials_Using_ATM_Algorithm/Butterfly_Wings.JPG width="400" title="Designing Metamaterials using genetic algorithms">
</p>

<p align="center">
  <img src=https://github.com/BjBodner/Portfolio/blob/master/Machine_Learning_and_Optimization_Projects/Generating_Simulated_Metamaterials_Using_ATM_Algorithm/Image%20Of%20Nano%20Structures.JPG width="400" title="Designing Metamaterials using genetic algorithms">
</p>


These nanostructures were created over millions of years through the process of natural selection, which is just one kind of optimization algorithm. In this project I attempted to generate similar optical behaviors using a different optimization algorithm (the ATM algorithm), in a simulated environment. This allowed for testing of the "fitness" of the nanostructures, within the metamaterial, in fractions of seconds, rather than in days/months.

The nanostructures in the metamaterial were optimized to generate two different optical behaviors within the simulated environment.
## 1. To focus the incoming light waves into a small region of space – i.e. to create a focusing lens.

<p align="center">
  <img src=https://github.com/BjBodner/Portfolio/blob/master/Machine_Learning_and_Optimization_Projects/Images/Focusing_Picture.JPG width="400" title="Designing Metamaterials using genetic algorithms">
</p>

As can be seen in 7,8-a, the ATM algorithm indeed manages to find very good solutions which are able to focus light to a small region of space.  This can be seen as a sharp peak in the intensity in a narrow range of the x-axis.
In 9,10-b we can see the generated nanostructures in the metamaterial. The darker regions indicate areas which with higher refractive indices, and the lighter regions indicate refractive indices closer to 1, which indicates a hole in the metamaterial. 
In 9-10-c we can see a picture of the metamaterials' interaction with the incoming light, before the optimization process. In In 9-10-d we see the material at the same time step, but after the optimization process - a clear focusing effect can be seen. 



## 2. To create a band-pass filter - which transfer specific bands of frequencies.
<p align="center">
    <img src=https://github.com/BjBodner/Portfolio/blob/master/Machine_Learning_and_Optimization_Projects/Images/Filtering_Picture.JPG width="400" title="Generating Swimming Motions using genetic algortihms">
</p>

As can be seen by the power spectrum in 9-1 and 10-1, the algorithm succeeds and decreasing the amplitudes of most frequencies higher than 20 (1/time) and manages to increase the amplitude of those at frequencies lower than 20. This indicates that it successfully created structures in the metamaterial which reflect shorter wavelength waves yet transmit the longer ones. 
In 9,10-b we can see the generated nanostructures in the metamaterial. The black regions indicate areas which have the maximal refractive index of 3, and the light-yellow mark the regions with a refractive index of 1, which indicates a hole in the metamaterial. 



- 
To Summarize, the optimization algorithm was very successful at both tasks. However, for the filtering task, this was successful in this
optimization task for certain long wavelength bands of frequencies. This was likely due to the finite resolution
of the dielectric grid.


References:
-
[1]  Vinodkumar Saranathana,b, Chinedum O. Osujib,c,d, Simon G. J. Mochrieb,d,e, Heeso Nohb,d, Suresh Narayananf, Alec Sandyf, Eric R. Dufresneb,d,e,g, and Richard O. Pru 
“Structure, function, and self-assembly of single network gyroid (I4132) photonic crystals in butterfly wing scales”, 11676–11681 ∣ PNAS ∣ June 29, 2010 ∣ vol. 107 ∣ no. 2


[2] 
Shichao Niu, Bo Li, Zhengzhi Mu, Meng Yang, Junqiu Zhang, Zhiwu Han, Luquan Ren 
"Excellent Structure-Based Multifunction of Morpho Butterfly Wings:
A Review ". Journal of Bionic Engineering 12 (2015) 170–189 

