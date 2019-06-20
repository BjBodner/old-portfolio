# Learning to Swim and Eat Using Genetic Algorithm and Model Based Reenforcement RL


This project is an extension of the swimming AI project.
In this project I took the same framworks of generating swimming motions,
with the extension of allowing the motions to generate torque and allow for rotation of the "Bugs"

A few different motions were created - one to maximize rotation and minimize forward motion and the other 
to maximize forward motion and minimize rotation.
These movements were then used as "actions" in a model based reenforcement learning model, 
where the "Bug" was trained to swim and catch as many "Food" particles as possible.
The states for the model were defined using the distance between the body and the food,
the direction the food is at, and the orientation of the body relative to the direction to the food.

Using a noisy enviournment - these "Bugs" slowly learned to swim towards the food and maximize the
amount of food they caught. The learning was quite succesful in most cases, 
and the bugs learned to go straight towards the food.
However, the learned occasionally did not advance, when the bugs were 
very far from the food, and the abosulte direction which the "Bug" should swim , did not change much.

