
# coding: utf-8

# In[351]:


## This is the conductor 


## Defining the initial hyperparameters


# In[450]:


## Two mode optimizer
#function [Suggested_Parameter_Samples_From_Two_Mode,ImprovementItteration] = Two_Mode_Optimizer(InitialParameters,NumberOfSamples,Parameter_ChangeVector,Cost_Change,ImprovementItteration,TargetedSearchDecayRate,RandomSearchGrowthRate,TargetedMultiplicationFactor,RandomMultiplicationFactor,SignificantChangeValue)
import numpy as np
import matplotlib.pyplot as plt

def Two_Mode_Optimizer(InitialParameters,NumberOfSamples,Parameter_ChangeVector,Cost_Change,ImprovementItteration,TargetedSearchDecayRate,RandomSearchGrowthRate,TargetedMultiplicationFactor,RandomMultiplicationFactor,SignificantChangeValue,Maximal_Random_Search):

# function [Suggested_Parameter_Samples_From_Two_Mode,ImprovementItteration] = Two_Mode_Optimizer(InitialParameters,NumberOfSamples,Parameter_ChangeVector,Cost_Change,ImprovementItteration,TargetedSearchDecayRate,RandomSearchGrowthRate,TargetedMultiplicationFactor,RandomMultiplicationFactor,SignificantChangeValue)


    Vectorized_Implimentation = 0
    For_Loop_Implimentation = 1
    TargetedSearch = np.zeros((len(InitialParameters),NumberOfSamples))
    if sum(abs(Parameter_ChangeVector)) > SignificantChangeValue:
        ImprovementItteration = 1


    if Vectorized_Implimentation == 1:
        TargetedSearch = exp(-(ImprovementItteration-1)/TargetedSearchDecayRate)*diag(TargetedMultiplicationFactor*(-Cost_Change)*Parameter_ChangeVector)*ones(length(InitialParameters),NumberOfSamples)*diag(rand(NumberOfSamples,1))
        RandomSearch = exp((ImprovementItteration-1)*RandomSearchGrowthRate)*RandomMultiplicationFactor*(rand(length(InitialParameters),NumberOfSamples)-0.5)


    if For_Loop_Implimentation == 1:
        RandomNumbers = np.random.rand(NumberOfSamples,1)
        
        TargetedSearch_Amplitude = RandomNumbers*np.exp(-(ImprovementItteration-1)/TargetedSearchDecayRate)         *TargetedMultiplicationFactor*(-Cost_Change)

        for sample in range (1,NumberOfSamples):

            TargetedSearch[:,sample] = TargetedSearch_Amplitude[sample]*Parameter_ChangeVector[:,0]

        
        RandomSearch = min(np.exp((ImprovementItteration-1)*RandomSearchGrowthRate)*RandomMultiplicationFactor,Maximal_Random_Search)         *(np.random.rand(len(InitialParameters),NumberOfSamples)-0.5)
        
    
        if min(np.exp((ImprovementItteration-1)*RandomSearchGrowthRate)*RandomMultiplicationFactor,Maximal_Random_Search) == Maximal_Random_Search:
            RandomSearch = np.sin((ImprovementItteration-1)*2*RandomSearchGrowthRate + np.pi/2)*0.1             *(np.random.rand(len(InitialParameters),NumberOfSamples)-0.5)

#     print(RandomSearch)
    Suggested_Parameter_Samples_From_Two_Mode = InitialParameters + TargetedSearch + RandomSearch
    Suggested_Parameter_Samples_From_Two_Mode[:,1] = InitialParameters[:,0]

    ImprovementItteration = ImprovementItteration +1;


    return Suggested_Parameter_Samples_From_Two_Mode,ImprovementItteration


TestTwo_Mode = 1
if TestTwo_Mode == 1:
    ## Two mode test
    InitialParameters = np.random.rand(20,1)
    x = np.array([np.linspace(0,4,20)]).T
    y = x**2


    NumberOfSamples = 10
    ## Setting the hyperparameters for two mode
    ImprovementItteration = 1
    TargetedSearchDecayRate = 1
    RandomSearchGrowthRate = 0.1
    TargetedMultiplicationFactor = 100
    RandomMultiplicationFactor = 100
    SignificantChangeValue = 0.2
    Maximal_Random_Search = 0.5

    Parameter_ChangeVector = np.zeros((len(InitialParameters),1))
    Cost_Change = 0

    PreviousCost = np.sum((InitialParameters-y)**2)
    Best_Individual = InitialParameters

    for i in range(0,100):
        Suggested_Parameter_Samples_From_Two_Mode,ImprovementItteration = Two_Mode_Optimizer(Best_Individual,NumberOfSamples,Parameter_ChangeVector,Cost_Change,ImprovementItteration,TargetedSearchDecayRate,RandomSearchGrowthRate,TargetedMultiplicationFactor,RandomMultiplicationFactor,SignificantChangeValue,Maximal_Random_Search)

        Cost = np.sum((Suggested_Parameter_Samples_From_Two_Mode-y)**2,0)

        index_min = np.argmin(Cost)
        CurrentCost = Cost[index_min ]

        Cost_Change = CurrentCost - PreviousCost
        Parameter_ChangeVector = np.array([Suggested_Parameter_Samples_From_Two_Mode[:,index_min]]).T - Best_Individual
        Best_Individual = np.array([Suggested_Parameter_Samples_From_Two_Mode[:,index_min]]).T

        PreviousCost = CurrentCost
        print(CurrentCost)






# In[353]:


import numpy as np


def Pinball_Optimizer(Initial_Parameters,NumberOfSamples,Search_Ratio,AmplitudeOfLinearSearch,AmplitudeOfRandomSearch,Linear_Search_Vector):


    ##Initalize infunction arrays
    Suggested_Parameter_Samples_From_Pinball = np.zeros((len(Initial_Parameters),NumberOfSamples))

    Number_Of_Linear_Samples = int(Search_Ratio*NumberOfSamples)

    Step_Size_Vector = np.linspace(-AmplitudeOfLinearSearch/2,AmplitudeOfLinearSearch/2,Number_Of_Linear_Samples)

    I = np.argmin(np.abs(Step_Size_Vector))
    Step_Size_Vector[I] = 0

    for k in range (0,NumberOfSamples):
        if k +1<=Number_Of_Linear_Samples:
                ## Generate Linear Search Samples around the inital parameter vector
            Suggested_Parameter_Samples_From_Pinball[:,k] = Initial_Parameters[:,0] + Linear_Search_Vector[:,0]*Step_Size_Vector[k]                     

        else:
                ## Generate Random Search Samples around the inital parameter vector  
            Suggested_Parameter_Samples_From_Pinball[:,k] = Initial_Parameters[:,0] + 2*AmplitudeOfRandomSearch*(np.random.rand(1,len(Initial_Parameters))-0.5)

    return Suggested_Parameter_Samples_From_Pinball







Test_Pinball = 0
if Test_Pinball == 1:


    ## Pinball HyperParameters
    NumberOfSamples = 10
    Search_Ratio = 0.7;
    AmplitudeOfLinearSearch = 0.5;
    AmplitudeOfRandomSearch = 0.5;
    Linear_Search_Vector = np.random.rand(len(Initial_Parameters),1)-0.5;
    Number_Of_Linear_Samples = int(Search_Ratio*NumberOfSamples)


    ## Testing Pinball

    Initial_Parameters = np.random.rand(20,1)
    Best_Individual = Initial_Parameters
    x = np.array([np.linspace(0,4,20)]).T
    y = x**2

    for i in range(0,50):
        Suggested_Parameter_Samples_From_Pinball = Pinball_Optimizer(Best_Individual,NumberOfSamples,Search_Ratio,AmplitudeOfLinearSearch,AmplitudeOfRandomSearch,Linear_Search_Vector)

        Cost = np.sum((Suggested_Parameter_Samples_From_Pinball-y)**2,0)

        index_min = np.argmin(Cost)
        CurrentCost = Cost[index_min ]

        Cost_Change = CurrentCost - PreviousCost
        Parameter_ChangeVector = np.array([Suggested_Parameter_Samples_From_Pinball[:,index_min]]).T - Best_Individual
        Best_Individual = np.array([Suggested_Parameter_Samples_From_Pinball[:,index_min]]).T



        if index_min > Number_Of_Linear_Samples:                                ## If the best vector was from the random batch
            Linear_Search_Vector = Parameter_ChangeVector                       ## Take a vector that follows the gradient
        else:                                                                   ## If no better vector is found
            Linear_Search_Vector = np.random.rand(len(Initial_Parameters),1)-0.5        ## Take a random vector

        print(CurrentCost)


# In[406]:


## Guessing game part 1
import numpy as np
def Guessing_Game_Optimizer_Part1(Initial_Parameters,NumberRandomVectors,dt):

    RandomVectors = np.random.rand(len(Initial_Parameters),NumberRandomVectors)-0.5
    LengthOfVectors = np.zeros((NumberRandomVectors,1))
    Suggested_Parameter_Samples_From_Guessing_Game = np.zeros((len(Initial_Parameters),3*NumberRandomVectors))
    Suggested_Parameter_Samples_From_Guessing_Game[:,1] = Initial_Parameters[:,0]
    
    for vector in range (0,NumberRandomVectors):
        LengthOfVectors[vector] = np.sqrt(np.dot(RandomVectors[:,vector],RandomVectors[:,vector]))
        Suggested_Parameter_Samples_From_Guessing_Game[:,2 + 2*(vector-1)] = Initial_Parameters[:,0] - dt*RandomVectors[:,vector]
        Suggested_Parameter_Samples_From_Guessing_Game[:,3 + 2*(vector-1)] = Initial_Parameters[:,0] + dt*RandomVectors[:,vector]

    return Suggested_Parameter_Samples_From_Guessing_Game,LengthOfVectors,RandomVectors 




def Guessing_Game_Optimizer_Part2(Initial_Parameters,NumberRandomVectors,CostVector,dt,RandomVectors,LengthOfVectors,NumberOfSamples_For_Round2,NumberOfSamples_For_AverageVector,AmplitudeOf_SingleVectors, AmplitudeOf_EvenVectors,AmplitudeOf_RandomVectors):

    Gradient = np.zeros((NumberRandomVectors,1))
    Hessian = np.zeros((NumberRandomVectors,1))
    Suggested_Parameter_Samples_From_Guessing_Game = np.zeros((len(Initial_Parameters),NumberOfSamples_For_Round2))

    for vector in range (0,NumberRandomVectors):
        ## Calculate Gradients
        Gradient[vector] = (CostVector[3 + 2*(vector-1)] - CostVector[2 + 2*(vector-1)])/(LengthOfVectors[vector]*dt)
        ## Calculate Diagonal Hessian
        Hessian[vector] = (2*CostVector[1] - CostVector[3 + 2*(vector-1)] - CostVector[2 + 2*(vector-1)])/((LengthOfVectors[vector]*dt)**2)
    



    ResizedVectorArray = (RandomVectors*(np.diag((Hessian>0)*Gradient/Hessian - (Hessian<0)*Gradient/Hessian)))


    for sample in range (0,NumberOfSamples_For_Round2):
        vector = sample
        if sample < NumberRandomVectors:
            

            Suggested_Parameter_Samples_From_Guessing_Game[:,sample] = Initial_Parameters[:,0] -             AmplitudeOf_SingleVectors*ResizedVectorArray[:,vector]
        
        if sample > NumberRandomVectors and sample <= NumberRandomVectors + NumberOfSamples_For_AverageVector:
            
            Suggested_Parameter_Samples_From_Guessing_Game[:,sample] = Initial_Parameters[:,0] -             AmplitudeOf_EvenVectors*np.random.rand(1,1)*np.sum(ResizedVectorArray)
        
        if sample > NumberRandomVectors + NumberOfSamples_For_AverageVector:
            
            Suggested_Parameter_Samples_From_Guessing_Game[:,sample] = Initial_Parameters[:,0] -              AmplitudeOf_RandomVectors*np.sum(np.diag(np.random.rand(NumberRandomVectors,1))*ResizedVectorArray)
        
    

    return Suggested_Parameter_Samples_From_Guessing_Game





Test_Guessing_Game = 1
if Test_Guessing_Game == 1:

    ## Guessing Game HyperParameters
    dt = 0.01;
    NumberRandomVectors = 4;
    NumberOfSamples_For_AverageVector = 2;
    AmplitudeOf_SingleVectors = 200;
    AmplitudeOf_EvenVectors = 200;
    AmplitudeOf_RandomVectors = 200;

    ## Testin Guessing game
    NumberOfSamples = 20
    Initial_Parameters = np.random.rand(30,1)
    Best_Individual = Initial_Parameters
    x = np.array([np.linspace(0,4,30)]).T
    y = x**2



    for i in range (0,40):
        Suggested_Parameter_Samples_From_Guessing_Game1,LengthOfVectors,RandomVectors = Guessing_Game_Optimizer_Part1(Best_Individual,NumberRandomVectors,dt)

        NumberOfSamples_For_Round2 = NumberOfSamples - len(Suggested_Parameter_Samples_From_Guessing_Game1[1,:])

        CostVector = np.sum((Suggested_Parameter_Samples_From_Guessing_Game1-y)**2,0)
        Suggested_Parameter_Samples_From_Guessing_Game2 = Guessing_Game_Optimizer_Part2(Best_Individual,NumberRandomVectors,CostVector,dt,RandomVectors,LengthOfVectors,NumberOfSamples_For_Round2,NumberOfSamples_For_AverageVector,AmplitudeOf_SingleVectors, AmplitudeOf_EvenVectors,AmplitudeOf_RandomVectors)

        Cost = np.sum((Suggested_Parameter_Samples_From_Guessing_Game2-y)**2,0)
        index_min = np.argmin(Cost)
        CurrentCost = Cost[index_min ]
        print(CurrentCost)
        Best_Individual = np.array([Suggested_Parameter_Samples_From_Guessing_Game2[:,index_min]]).T


# In[366]:


## Conductor Algorithm
import numpy as np

def Resource_Allocation_Hamiltonian(Initial_Resource_Allocation,Current_Resource_Allocation,Changevector,MassVector,Self_Interaction_Spring_Constants,Neighboring_Algorithm_Interaction_Spring_Constants,Epsilon1):
    Norm = np.sqrt(np.matmul(Changevector,Changevector))
    if Norm != 0:
        Changevector = Changevector/Norm
    
    R0 = Initial_Resource_Allocation
    R = Current_Resource_Allocation
    K0 = Self_Interaction_Spring_Constants
    K = Neighboring_Algorithm_Interaction_Spring_Constants #K(1) = K12, K(2) = K23, K(3) = K31%

    Epsilon = Epsilon1



    InteractionMatrix = np.array([[K[0]+K[2], -K[0], -K[1]], [ -K[0], K[0]+K[1] ,-K[1]], [-K[2], -K[1], K[1]+K[2]]])

    ##This system is equivilent to 3 springs connected in a ring with interactions between them, 
    ## and a self sping connected to the tabel that tries to return them to equilibrium


    for n in range (0,1):
        H_Self = -(K0/MassVector)*(R-R0)
        H_Interaction = np.matmul(InteractionMatrix,(Changevector/MassVector).T)
        H_tot = H_Self + H_Interaction.T

        R = R + H_tot

        
        if np.mean(H_tot/R)<Epsilon:
            break
    

    

    RecomendedResourceAllocation = np.round(R,0)


    return RecomendedResourceAllocation

### Test of the conductor algorithm

## Resource Distribution Algorithm - HyperParameters
Initial_Resource_Allocation = np.array([60 ,60 ,60])
Current_Resource_Allocation =Initial_Resource_Allocation
Best_Change_In_CostFunction_FromAlgorithm = np.array([0 ,0 ,0])
MassVector = 10*np.array([1, 1, 1])
Self_Interaction_Spring_Constants = 5*np.array([1, 1, 1])
Neighboring_Algorithm_Interaction_Spring_Constants = 90*np.array([1, 1, 1])
Epsilon1 = 0.01

for i in range (1,20):
    Changevector = np.array([-1, 0 ,0])
    RecomendedResourceAllocation = Resource_Allocation_Hamiltonian(Initial_Resource_Allocation,Current_Resource_Allocation,Changevector,MassVector,Self_Interaction_Spring_Constants,Neighboring_Algorithm_Interaction_Spring_Constants,Epsilon1)
    Current_Resource_Allocation = RecomendedResourceAllocation

Minimal_Allocation = np.min(Current_Resource_Allocation)
print("Minimal_Allocation is:",Minimal_Allocation)
for i in range (1,20):
    Changevector = np.array([1,0 ,0])
    RecomendedResourceAllocation = Resource_Allocation_Hamiltonian(Initial_Resource_Allocation,Current_Resource_Allocation,Changevector,MassVector,Self_Interaction_Spring_Constants,Neighboring_Algorithm_Interaction_Spring_Constants,Epsilon1)
    Current_Resource_Allocation = RecomendedResourceAllocation

Maximal_Allocation = np.max(Current_Resource_Allocation)
print("Maximal_Allocation is:",Maximal_Allocation)


# In[ ]:


print(1)


# In[367]:


## List of remaining tasks
# make it so that i input the cost function into the algorithm
# make the make a dynamic hyperparameter algorithm
# combine the pieces into a full orchestra algorithm
# test on mnist convnet classifier


# In[368]:


## Using the genetic algorithm

import numpy as np
import matplotlib.pyplot as plt

## Defining Cost Function
class Cost_Function:
    def Cost_Function(self,Y,Individuals): 
        
        ## This should be a cost function to be minimized
        ## This should output the cost / negative fittness - for each of the individuals
        for i in range(0,Number_Of_Individuals_in_Generation):
            Cost_Function1[i] = np.sum((Y - Individuals[:,i])**2)

        return Cost_Function1


## Defining the hyperparameters
Mutation_Amplitude = 1
Number_Of_Parameters = 20 ## these are the parameters /variables which we want to optimize
Number_Of_Individuals_in_Generation = 10
Number_Of_Generations = 1000


## Defining the target (in the case of fitting)
x = np.linspace(0,5,Number_Of_Parameters)
Y = 2*x

## Getting the cost function object
Cost = Cost_Function()


    
Best_Parameters = Optimize_With_Genetic_Algorithm(x, Y, Cost, Mutation_Amplitude, Number_Of_Parameters, Number_Of_Individuals_in_Generation, Number_Of_Generations)

plt.plot(x,Y)
plt.plot(x,Best_Parameters)


# In[457]:


import numpy as np
import matplotlib.pyplot as plt

def Pinball_Optimizer(Initial_Parameters,NumberOfSamples,Search_Ratio,AmplitudeOfLinearSearch,AmplitudeOfRandomSearch,Linear_Search_Vector):


    ##Initalize infunction arrays
    Suggested_Parameter_Samples_From_Pinball = np.zeros((len(Initial_Parameters),NumberOfSamples))

    Number_Of_Linear_Samples = int(Search_Ratio*NumberOfSamples)

    Step_Size_Vector = np.linspace(-AmplitudeOfLinearSearch/2,AmplitudeOfLinearSearch/2,Number_Of_Linear_Samples)

    I = np.argmin(np.abs(Step_Size_Vector))
    Step_Size_Vector[I] = 0

    for k in range (0,NumberOfSamples):
        if k +1<=Number_Of_Linear_Samples:
                ## Generate Linear Search Samples around the inital parameter vector
            Suggested_Parameter_Samples_From_Pinball[:,k] = Initial_Parameters[:,0] + Linear_Search_Vector[:,0]*Step_Size_Vector[k]                     

        else:
                ## Generate Random Search Samples around the inital parameter vector  
            Suggested_Parameter_Samples_From_Pinball[:,k] = Initial_Parameters[:,0] + 2*AmplitudeOfRandomSearch*(np.random.rand(1,len(Initial_Parameters))-0.5)

    return Suggested_Parameter_Samples_From_Pinball






def Optimize_With_Pinball_Algorithm(x,y,Initial_Parameters,Cost1,Number_Of_Itterations,print_Cost,NumberOfSamples,Search_Ratio,AmplitudeOfLinearSearch,AmplitudeOfRandomSearch):


    ## Testing Pinball

#     Initial_Parameters = np.random.rand(20,1)
    Best_Individual = Initial_Parameters
    Linear_Search_Vector = np.random.rand(len(Initial_Parameters),1)-0.5;
    Number_Of_Linear_Samples = int(Search_Ratio*NumberOfSamples)
#     x = np.array([np.linspace(0,4,20)]).T
#     y = x**2

    for i in range(0,Number_Of_Itterations):
        Suggested_Parameter_Samples_From_Pinball = Pinball_Optimizer(Best_Individual,NumberOfSamples,Search_Ratio,AmplitudeOfLinearSearch,AmplitudeOfRandomSearch,Linear_Search_Vector)

#         Cost = np.sum((Suggested_Parameter_Samples_From_Pinball-y)**2,0)
        Cost = Cost1.Cost_Function(y,Suggested_Parameter_Samples_From_Pinball)
        index_min = np.argmin(Cost)
        CurrentCost = Cost[index_min ]

        Cost_Change = CurrentCost - PreviousCost
        Parameter_ChangeVector = np.array([Suggested_Parameter_Samples_From_Pinball[:,index_min]]).T - Best_Individual
        Best_Individual = np.array([Suggested_Parameter_Samples_From_Pinball[:,index_min]]).T



        if index_min > Number_Of_Linear_Samples:                                ## If the best vector was from the random batch
            Linear_Search_Vector = Parameter_ChangeVector                       ## Take a vector that follows the gradient
        else:                                                                   ## If no better vector is found
            Linear_Search_Vector = np.random.rand(len(Initial_Parameters),1)-0.5        ## Take a random vector
        
        if print_Cost == 1:
            print(CurrentCost)
    return Best_Individual, CurrentCost
        
        
        
        
## Defining Cost Function
class Cost_Function:
    def Cost_Function(self,Y,Individuals): 
        
        ## This should be a cost function to be minimized
        ## This should output the cost / negative fittness - for each of the individuals

        Cost_Function1 = np.sum((Y - Individuals)**2,0)

        return Cost_Function1
    
## Defining Pinball HyperParameters
NumberOfSamples = 10
Search_Ratio = 0.7;
AmplitudeOfLinearSearch = 0.1;
AmplitudeOfRandomSearch = 0.1;
print_Cost = 0

Number_Of_Itterations = 200
Initial_Parameters = np.random.rand(20,1)

x = np.array([np.linspace(0,1,20)]).T
Y = x**2
Cost1 = Cost_Function()


Best_Individual, CurrentCost = Optimize_With_Pinball_Algorithm(x,Y,Initial_Parameters,Cost1,Number_Of_Itterations,print_Cost,NumberOfSamples,Search_Ratio,AmplitudeOfLinearSearch,AmplitudeOfRandomSearch)


plt.plot(x,Y)
plt.plot(x,Best_Individual)


# In[486]:


## Guessing game part 1
import numpy as np
def Guessing_Game_Optimizer_Part1(Initial_Parameters,NumberRandomVectors,dt):

    RandomVectors = np.random.rand(len(Initial_Parameters),NumberRandomVectors)-0.5
    LengthOfVectors = np.zeros((NumberRandomVectors,1))
    Suggested_Parameter_Samples_From_Guessing_Game = np.zeros((len(Initial_Parameters),3*NumberRandomVectors))
    Suggested_Parameter_Samples_From_Guessing_Game[:,1] = Initial_Parameters[:,0]
    
    for vector in range (0,NumberRandomVectors):
        LengthOfVectors[vector] = np.sqrt(np.dot(RandomVectors[:,vector],RandomVectors[:,vector]))
        Suggested_Parameter_Samples_From_Guessing_Game[:,2 + 2*(vector-1)] = Initial_Parameters[:,0] - dt*RandomVectors[:,vector]
        Suggested_Parameter_Samples_From_Guessing_Game[:,3 + 2*(vector-1)] = Initial_Parameters[:,0] + dt*RandomVectors[:,vector]

    return Suggested_Parameter_Samples_From_Guessing_Game,LengthOfVectors,RandomVectors 




def Guessing_Game_Optimizer_Part2(Initial_Parameters,NumberRandomVectors,CostVector,dt,RandomVectors,LengthOfVectors,NumberOfSamples_For_Round2,NumberOfSamples_For_AverageVector,AmplitudeOf_SingleVectors, AmplitudeOf_EvenVectors,AmplitudeOf_RandomVectors):

    Gradient = np.zeros((NumberRandomVectors,1))
    Hessian = np.zeros((NumberRandomVectors,1))
    Suggested_Parameter_Samples_From_Guessing_Game = np.zeros((len(Initial_Parameters),NumberOfSamples_For_Round2))

    for vector in range (0,NumberRandomVectors):
        ## Calculate Gradients
        Gradient[vector] = (CostVector[3 + 2*(vector-1)] - CostVector[2 + 2*(vector-1)])/(LengthOfVectors[vector]*dt)
        ## Calculate Diagonal Hessian
        Hessian[vector] = (2*CostVector[1] - CostVector[3 + 2*(vector-1)] - CostVector[2 + 2*(vector-1)])/((LengthOfVectors[vector]*dt)**2)
    



    ResizedVectorArray = (RandomVectors*(np.diag((Hessian>0)*Gradient/Hessian - (Hessian<0)*Gradient/Hessian)))


    for sample in range (0,NumberOfSamples_For_Round2):
        vector = sample
        if sample < NumberRandomVectors:
            

            Suggested_Parameter_Samples_From_Guessing_Game[:,sample] = Initial_Parameters[:,0] -             AmplitudeOf_SingleVectors*ResizedVectorArray[:,vector]
        
        if sample > NumberRandomVectors and sample <= NumberRandomVectors + NumberOfSamples_For_AverageVector:
            
            Suggested_Parameter_Samples_From_Guessing_Game[:,sample] = Initial_Parameters[:,0] -             AmplitudeOf_EvenVectors*np.random.rand(1,1)*np.sum(ResizedVectorArray)
        
        if sample > NumberRandomVectors + NumberOfSamples_For_AverageVector:
            
            Suggested_Parameter_Samples_From_Guessing_Game[:,sample] = Initial_Parameters[:,0] -              AmplitudeOf_RandomVectors*np.sum(np.diag(np.random.rand(NumberRandomVectors,1))*ResizedVectorArray)
        
    

    return Suggested_Parameter_Samples_From_Guessing_Game



def Optimize_With_Guessing_Game_Algorithm(x,y,Initial_Parameters,Cost1,dt,NumberRandomVectors,NumberOfSamples_For_AverageVector,AmplitudeOf_SingleVectors,AmplitudeOf_EvenVectors,AmplitudeOf_RandomVectors,NumberOfSamples,print_Cost):

    Best_Individual = Initial_Parameters
    for i in range (0,40):
        Suggested_Parameter_Samples_From_Guessing_Game1,LengthOfVectors,RandomVectors = Guessing_Game_Optimizer_Part1(Best_Individual,NumberRandomVectors,dt)

        NumberOfSamples_For_Round2 = NumberOfSamples - len(Suggested_Parameter_Samples_From_Guessing_Game1[1,:])

        CostVector = Cost1.Cost_Function(y,Suggested_Parameter_Samples_From_Guessing_Game1)
#         CostVector = np.sum((Suggested_Parameter_Samples_From_Guessing_Game1-y)**2,0)
        Suggested_Parameter_Samples_From_Guessing_Game2 = Guessing_Game_Optimizer_Part2(Best_Individual,NumberRandomVectors,CostVector,dt,RandomVectors,LengthOfVectors,NumberOfSamples_For_Round2,NumberOfSamples_For_AverageVector,AmplitudeOf_SingleVectors, AmplitudeOf_EvenVectors,AmplitudeOf_RandomVectors)

        Cost = Cost1.Cost_Function(y,Suggested_Parameter_Samples_From_Guessing_Game2)
#         Cost = np.sum((Suggested_Parameter_Samples_From_Guessing_Game2-y)**2,0)
        index_min = np.argmin(Cost)
        CurrentCost = Cost[index_min ]
        if print_Cost == 1:
            print(CurrentCost)
        Best_Individual = np.array([Suggested_Parameter_Samples_From_Guessing_Game2[:,index_min]]).T
        
    return Best_Individual
 
    
    
    
## Defining Cost Function
class Cost_Function:
    def Cost_Function(self,Y,Individuals): 
        
        ## This should be a cost function to be minimized
        ## This should output the cost / negative fittness - for each of the individuals

        Cost_Function1 = np.sum((Y - Individuals)**2,0)

        return Cost_Function1
    
    
## Guessing Game HyperParameters
dt = 0.01;
NumberRandomVectors = 4;
NumberOfSamples_For_AverageVector = 2;
AmplitudeOf_SingleVectors = 10;
AmplitudeOf_EvenVectors = 10;
AmplitudeOf_RandomVectors = 10;

## Testin Guessing game
NumberOfSamples = 20
Initial_Parameters = np.random.rand(20,1)
Number_Of_Itterations = 3
print_Cost = 0

x = np.array([np.linspace(0,1,20)]).T
y = x**2
Cost1 = Cost_Function()

Best_Individual = Optimize_With_Guessing_Game_Algorithm(x,y,Initial_Parameters,Cost1,dt,NumberRandomVectors,NumberOfSamples_For_AverageVector,AmplitudeOf_SingleVectors,AmplitudeOf_EvenVectors,AmplitudeOf_RandomVectors,NumberOfSamples,print_Cost)


plt.plot(x,Y)
plt.plot(x,Best_Individual)


# In[476]:


## Two mode optimizer
#function [Suggested_Parameter_Samples_From_Two_Mode,ImprovementItteration] = Two_Mode_Optimizer(InitialParameters,NumberOfSamples,Parameter_ChangeVector,Cost_Change,ImprovementItteration,TargetedSearchDecayRate,RandomSearchGrowthRate,TargetedMultiplicationFactor,RandomMultiplicationFactor,SignificantChangeValue)
import numpy as np
import matplotlib.pyplot as plt

def Two_Mode_Optimizer(InitialParameters,NumberOfSamples,Parameter_ChangeVector,Cost_Change,ImprovementItteration,TargetedSearchDecayRate,RandomSearchGrowthRate,TargetedMultiplicationFactor,RandomMultiplicationFactor,SignificantChangeValue,Maximal_Random_Search):

# function [Suggested_Parameter_Samples_From_Two_Mode,ImprovementItteration] = Two_Mode_Optimizer(InitialParameters,NumberOfSamples,Parameter_ChangeVector,Cost_Change,ImprovementItteration,TargetedSearchDecayRate,RandomSearchGrowthRate,TargetedMultiplicationFactor,RandomMultiplicationFactor,SignificantChangeValue)


    Vectorized_Implimentation = 0
    For_Loop_Implimentation = 1
    TargetedSearch = np.zeros((len(InitialParameters),NumberOfSamples))
    if sum(abs(Parameter_ChangeVector)) > SignificantChangeValue:
        ImprovementItteration = 1


    if Vectorized_Implimentation == 1:
        TargetedSearch = exp(-(ImprovementItteration-1)/TargetedSearchDecayRate)*diag(TargetedMultiplicationFactor*(-Cost_Change)*Parameter_ChangeVector)*ones(length(InitialParameters),NumberOfSamples)*diag(rand(NumberOfSamples,1))
        RandomSearch = exp((ImprovementItteration-1)*RandomSearchGrowthRate)*RandomMultiplicationFactor*(rand(length(InitialParameters),NumberOfSamples)-0.5)


    if For_Loop_Implimentation == 1:
        RandomNumbers = np.random.rand(NumberOfSamples,1)
        
        TargetedSearch_Amplitude = RandomNumbers*np.exp(-(ImprovementItteration-1)/TargetedSearchDecayRate)         *TargetedMultiplicationFactor*(-Cost_Change)

        for sample in range (1,NumberOfSamples):

            TargetedSearch[:,sample] = TargetedSearch_Amplitude[sample]*Parameter_ChangeVector[:,0]

        
        RandomSearch = min(np.exp((ImprovementItteration-1)*RandomSearchGrowthRate)*RandomMultiplicationFactor,Maximal_Random_Search)         *(np.random.rand(len(InitialParameters),NumberOfSamples)-0.5)
        
    
        if min(np.exp((ImprovementItteration-1)*RandomSearchGrowthRate)*RandomMultiplicationFactor,Maximal_Random_Search) == Maximal_Random_Search:
            RandomSearch = np.sin((ImprovementItteration-1)*2*RandomSearchGrowthRate + np.pi/2)*0.1             *(np.random.rand(len(InitialParameters),NumberOfSamples)-0.5)

#     print(RandomSearch)
    Suggested_Parameter_Samples_From_Two_Mode = InitialParameters + TargetedSearch + RandomSearch
    Suggested_Parameter_Samples_From_Two_Mode[:,1] = InitialParameters[:,0]

    ImprovementItteration = ImprovementItteration +1;


    return Suggested_Parameter_Samples_From_Two_Mode,ImprovementItteration




def Optimize_With_Two_Mode_Algorithm(x,y,InitialParameters,Cost1,NumberOfSamples,ImprovementItteration,TargetedSearchDecayRate,RandomSearchGrowthRate,TargetedMultiplicationFactor ,RandomMultiplicationFactor,SignificantChangeValue,Maximal_Random_Search,print_Cost,Number_Of_Itterations):
    
    Parameter_ChangeVector = np.zeros((len(InitialParameters),1))
    Cost_Change = 0
    
    PreviousCost = Cost1.Cost_Function(y,InitialParameters)
#     PreviousCost = np.sum((InitialParameters-y)**2)
    Best_Individual = InitialParameters

    for i in range(0,Number_Of_Itterations):
        Suggested_Parameter_Samples_From_Two_Mode,ImprovementItteration = Two_Mode_Optimizer(Best_Individual,NumberOfSamples,Parameter_ChangeVector,Cost_Change,ImprovementItteration,TargetedSearchDecayRate,RandomSearchGrowthRate,TargetedMultiplicationFactor,RandomMultiplicationFactor,SignificantChangeValue,Maximal_Random_Search)

#         Cost = np.sum((Suggested_Parameter_Samples_From_Two_Mode-y)**2,0)
        Cost    = Cost1.Cost_Function(y,Suggested_Parameter_Samples_From_Two_Mode)
        index_min = np.argmin(Cost)
        CurrentCost = Cost[index_min ]

        Cost_Change = CurrentCost - PreviousCost
        Parameter_ChangeVector = np.array([Suggested_Parameter_Samples_From_Two_Mode[:,index_min]]).T - Best_Individual
        Best_Individual = np.array([Suggested_Parameter_Samples_From_Two_Mode[:,index_min]]).T

        PreviousCost = CurrentCost
        if print_Cost == 1:
            print(CurrentCost)
    
    return Best_Individual



## Defining Cost Function
class Cost_Function:
    def Cost_Function(self,Y,Individuals): 
        
        ## This should be a cost function to be minimized
        ## This should output the cost / negative fittness - for each of the individuals

        Cost_Function1 = np.sum((Y - Individuals)**2,0)

        return Cost_Function1
    
    
    
    ## Two mode test
InitialParameters = np.random.rand(20,1)
x = np.array([np.linspace(0,4,20)]).T
y = x**2
Cost1 = Cost_Function()

NumberOfSamples = 10
## Setting the hyperparameters for two mode
ImprovementItteration = 1
TargetedSearchDecayRate = 1
RandomSearchGrowthRate = 0.1
TargetedMultiplicationFactor = 100
RandomMultiplicationFactor = 100
SignificantChangeValue = 0.2
Maximal_Random_Search = 0.5

print_Cost = 0
Best_Individual = Optimize_With_Two_Mode_Algorithm(x,y,InitialParameters,Cost1,NumberOfSamples,ImprovementItteration,TargetedSearchDecayRate,RandomSearchGrowthRate,TargetedMultiplicationFactor ,RandomMultiplicationFactor,SignificantChangeValue,Maximal_Random_Search,print_Cost,Number_Of_Itterations)

plt.plot(x,y)
plt.plot(x,Best_Individual)

