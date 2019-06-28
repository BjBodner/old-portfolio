# Learning to Swim and Eat Using Genetic Algorithms and Model Based Reinforcement Learning





<p align="center">     
  <img src=https://github.com/BjBodner/Portfolio/blob/master/Machine_Learning_and_Optimization_Projects/Learning_to_Swim_and_Eat_Using_GA_and_Model_Based_RL/Learning_To_Swim_And_Eat_Snippet2.gif width="350" title="Designing Metamaterials using genetic algorithms">
</p>
   

  ## Overview
This project was made in an attempt to explore genetic algorithms and model-based reinforcement learning and apply them to a fun side project. 
In This project I created a simulated aquatic environment which allows tiny stick figures to swim in it. The swimming motions they create can generate both forward movement (in all 2D directions) and torque as well, giving the stick figures the ability to rotate themselves. 

## Building the Model
In this experiment, two different motions were created by defining the fitness function for the genetic algorithm. One move was optimized to maximize rotation and minimize forward motion and the other to maximize forward motion and minimize rotation.
After the movements were generated in this manner, we defined them as "actions" for a model-based reinforcement learning model. In this model, the "Bug" was trained to swim and catch as many "Food" particles as possible.
The states for the model were defined using the distance between the body and the food,
the direction the food is at, and the orientation of the body relative to the direction to the food.

## Going to the food  
<p align="left">   
   <img src=https://github.com/BjBodner/Portfolio/blob/master/Machine_Learning_and_Optimization_Projects/Learning_to_Swim_and_Eat_Using_GA_and_Model_Based_RL/Learning_To_Swim_And_Eat_Snippet3.gif width="350" title="Designing Metamaterials using genetic algorithms">
</p>
     

Using a probabilistic action selection model - these "Bugs" learned to swim towards the food and maximize the amount of food they caught. The learning was quite successful in some cases, 
and the bugs learned to go straight towards the food. However, this did not always work, and occasionally the learning stagnated. Especially when the bugs were very far from the food, and the absolute direction which the "Bug" should swim, did not change enough for moving between states.

<p align="right">
    <img src=https://github.com/BjBodner/Portfolio/blob/master/Machine_Learning_and_Optimization_Projects/Learning_to_Swim_and_Eat_Using_GA_and_Model_Based_RL/Learning_To_Swim_And_Eat_Snippet1.gif width="350" title="Generating Swimming Motions using genetic algortihms">
    
