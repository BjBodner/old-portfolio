
# coding: utf-8

# In[38]:



# coding: utf-8

# In[346]:


import numpy as np
from matplotlib.pyplot import *
import math
from array import array
import math
import sys
from scipy.integrate import odeint

from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FormatStrFormatter
import numpy as np


# In[39]:


class Net(object):
    
    def __init__(self, Parameter_Vector):
        Layer_sizes = (3,3,2,1)
        
        self.W1 = Parameter_Vector[0:9].reshape(3,3)
        self.b1 = Parameter_Vector[9:12].reshape(3,1)
        self.W2 = Parameter_Vector[12:21].reshape(3,3)
        self.b2 = Parameter_Vector[21:24].reshape(3,1)
        self.W3 = Parameter_Vector[24:30].reshape(3,2)
        self.b3 = Parameter_Vector[30:32].reshape(2,1)
        self.W4 = Parameter_Vector[32:34].reshape(2,1)
        self.b4 = Parameter_Vector[34:35]
        
        
def Reshape_into_4_layer_Nural_Network_for_1D_SHO(Parameter_Vector):
    Net_ = Net(Parameter_Vector)
    return Net_

Parameter_Vector = np.random.rand(35)
Net4 = Reshape_into_4_layer_Nural_Network_for_1D_SHO(Parameter_Vector)


# In[40]:


def Run_Through_Nural_Network_for_1D_SHO(Net,X):
    Z1 = np.dot(Net.W1.T,X) + Net.b1
    A1 = 1/(1 + np.exp(-Z1))
    

    Z2 = np.dot(Net.W2.T,A1) + Net.b2
    A2 = 1/(1 + np.exp(-Z2))
    

    Z3 = np.dot(Net.W3.T,A2) + Net.b3
    A3 = 1/(1 + np.exp(-Z3))
    
    A4 = np.dot(Net.W4.T,A3) + Net.b4
    
    return A4


# In[41]:


def Square_difference_Cost_Function(Y_predict,Y_true):

    CostFunction = np.sum((Y_predict-Y_true)**2)
    return CostFunction


# In[42]:


def Genetic_Algorithm_Optimizer_for_for_1D_SHO(Initial_Parameter_Vector):

    Net1 = Reshape_into_4_layer_Nural_Network_for_1D_SHO(Individuals_Parameter_Vector[0:35])
    Net2 = Reshape_into_4_layer_Nural_Network_for_1D_SHO(Individuals_Parameter_Vector[0:35])
    
    


# In[43]:


def Create_Predictions_for_paths(Net1,Net2,Initial_conditions,dt,dq,dp,T_total):
    ## Change this to curent state and include time
    i = 1
    t = np.linspace(0,T_total,np.int(T_total/dt))
    
    Sample1 = np.array([t[i],Initial_conditions[0] - dq/2,Initial_conditions[1]])               
    Sample2 = np.array([t[i],Initial_conditions[0] + dq/2,Initial_conditions[1]])
    Sample3 = np.array([t[i],Initial_conditions[0] ,Initial_conditions[1] - dp/2])               
    Sample4 = np.array([t[i],Initial_conditions[0] ,Initial_conditions[1] + dp/2]) 
    

    Phase_Space_time_samples = np.array([Sample1, Sample2, Sample3, Sample4]).transpose()
    
    Hamiltonian_Samples = Run_Through_Nural_Network_for_1D_SHO(Net1,Phase_Space_time_samples) + Run_Through_Nural_Network_for_1D_SHO(Net2,Phase_Space_time_samples)
    
#     print( Phase_Space_time_samples)
#     print( Hamiltonian_Samples)
#     print(np.shape(Hamiltonian_Samples))
#     print(Hamiltonian_Samples[0,1],Hamiltonian_Samples[0,0])
#     print(Hamiltonian_Samples[0,3],Hamiltonian_Samples[0,2])
    
    dp_predicted  = -(Hamiltonian_Samples[0,1] - Hamiltonian_Samples[0,0])/dq
    dq_predicted  = (Hamiltonian_Samples[0,3] - Hamiltonian_Samples[0,2])/dp
    
    return dq_predicted, dp_predicted    
    


# In[44]:


def Create_predicted_path(Parameter_Vector,First_two_phase_space_samples,T_total):

    # Individuals_Parameter_Vector = np.random.rand(70)
    Net1 = Reshape_into_4_layer_Nural_Network_for_1D_SHO(Parameter_Vector[0:35])
    Net2 = Reshape_into_4_layer_Nural_Network_for_1D_SHO(Parameter_Vector[35:70])

    # Individuals_Parameter_Vector = np.random.rand(70)
    # Net1 = Reshape_into_4_layer_Nural_Network_for_1D_SHO(Individuals_Parameter_Vector[0:35])
    # Net2 = Reshape_into_4_layer_Nural_Network_for_1D_SHO(Individuals_Parameter_Vector[35:70])

    dq = First_two_phase_space_samples[0,1] - First_two_phase_space_samples[0,0]
    dp = First_two_phase_space_samples[1,1] - First_two_phase_space_samples[1,0]
    dt = First_two_phase_space_samples[2,1] - First_two_phase_space_samples[2,0]

    # dq = 0.1 ## this should be q[i] - q[i-1]
    # dp = 0.1 ## this should be p[i] - q[i-1]
    # dt = 0.1 ## this should be t[i] - t[i-1]

    # T_total = 10
    Initial_conditions = np.array([First_two_phase_space_samples[0,0],First_two_phase_space_samples[0,1]])

    # dq_predicted, dp_predicted = Create_Predictions_for_paths(Net1,Net2,Initial_conditions,dt,dq,dp,T_total)


    # NumberOfSamples = 10000
    NumberOfSamples = int(T_total/dt)
    dq_predicted = np.zeros(NumberOfSamples)
    dp_predicted = np.zeros(NumberOfSamples)
    q_predicted = np.zeros(NumberOfSamples)
    p_predicted = np.zeros(NumberOfSamples)

    ## Initializing
    q_predicted[0] = Initial_conditions[0]
    p_predicted[0] = Initial_conditions[1]
    dq_predicted[0], dp_predicted[0] = Create_Predictions_for_paths(Net1,Net2,Initial_conditions,dt,dq,dp,T_total)


    for i in range(1,NumberOfSamples):

        q_predicted[i] = q_predicted[i-1] + dq_predicted[i-1]
        p_predicted[i] = p_predicted[i-1] + dp_predicted[i-1]
        dq_predicted[i], dp_predicted[i] = Create_Predictions_for_paths(Net1,Net2,np.array([q_predicted[i],p_predicted[i]]),dt,dq_predicted[i-1],dp_predicted[i-1],T_total)

    return q_predicted, p_predicted, dq_predicted, dp_predicted


# In[45]:


def Calculate_Loss_Function(q_true, p_true, dq_true, dp_true, q_predicted, p_predicted, dq_predicted, dp_predicted):
    Loss1 = np.sum((q_true - q_predicted)**2) + np.sum((p_true - p_predicted)**2)

    Scaling_Factor1 = np.mean((q_true - q_predicted)/(dq_true - dq_predicted))
    Scaling_Factor2 = np.mean((p_true - p_predicted)/(dp_true - dp_predicted))

    Loss2 = Scaling_Factor1*np.sum((dq_true - dq_predicted)**2) + Scaling_Factor1*np.sum((dp_true - dp_predicted)**2)

    Loss = Loss1 + Loss2
    return Loss


# In[46]:


Individuals_Parameter_Vector = np.random.rand(70,20)
T_total = 10
First_two_phase_space_samples = np.array([[1,1.1],[2,1.1],[0,0.1]])


q_predicted, p_predicted, dq_predicted, dp_predicted = Create_predicted_path(Individuals_Parameter_Vector[:,1],First_two_phase_space_samples,T_total)
q_true, p_true, dq_true, dp_true = Create_predicted_path(Individuals_Parameter_Vector[:,2],First_two_phase_space_samples,T_total)

Loss = Calculate_Loss_Function(q_true, p_true, dq_true, dp_true, q_predicted, p_predicted, dq_predicted, dp_predicted)
plt.plot(q_true,p_true)
plt.plot(q_predicted,p_predicted)
plt.xlabel("q")
plt.xlabel("p")
print(Loss)


# In[104]:



class Hamiltonians(object):
    
    def __init__(self):
        m = 1

    def SHO_Hamiltonian(self,Phase_Space_time_samples):
        m = 1
        k = 1
        x = Phase_Space_time_samples[1,:]
        p = Phase_Space_time_samples[2,:]   

        Hamiltonian_Samples = (p**2)/(2*m) + (x**2)*k/2
        
        return         Hamiltonian_Samples 
    
    
def Calculate_Hamiltonian_for_1D_SHO_(Phase_Space_time_samples):
    Hamiltonian_for_1D_SHO_ = Hamiltonian_for_1D_SHO(Phase_Space_time_samples)
    return Hamiltonian_for_1D_SHO_



Phase_Space_time_samples = np.random.rand(4,3)
H = Hamiltonians()
print(H.SHO_Hamiltonian(Phase_Space_time_samples))


# In[105]:


def Create_true_path(First_two_phase_space_samples,T_total):

#     # Individuals_Parameter_Vector = np.random.rand(70)
#     Net1 = Reshape_into_4_layer_Nural_Network_for_1D_SHO(Parameter_Vector[0:35])
#     Net2 = Reshape_into_4_layer_Nural_Network_for_1D_SHO(Parameter_Vector[35:70])

    
    dq = First_two_phase_space_samples[0,1] - First_two_phase_space_samples[0,0]
    dp = First_two_phase_space_samples[1,1] - First_two_phase_space_samples[1,0]
    dt = First_two_phase_space_samples[2,1] - First_two_phase_space_samples[2,0]

    # dq = 0.1 ## this should be q[i] - q[i-1]
    # dp = 0.1 ## this should be p[i] - q[i-1]
    # dt = 0.1 ## this should be t[i] - t[i-1]

    # T_total = 10
    Initial_conditions = np.array([First_two_phase_space_samples[0,0],First_two_phase_space_samples[1,0]])

    print(dp,dq,dt)
    # dq_predicted, dp_predicted = Create_Predictions_for_paths(Net1,Net2,Initial_conditions,dt,dq,dp,T_total)


    # NumberOfSamples = 10000
    NumberOfSamples = int(T_total/dt)
    dq_true = np.zeros(NumberOfSamples)
    dp_true = np.zeros(NumberOfSamples)
    q_true = np.zeros(NumberOfSamples)
    p_true = np.zeros(NumberOfSamples)

    ## Initializing
    q_true[0] = Initial_conditions[0]
    p_true[0] = Initial_conditions[1]
    
    H = H = Hamiltonians()
    dq_true[0], dp_true[0] = Create_True_Hamiltonian_paths(H,Initial_conditions,dt,dq,dp,T_total)


    for i in range(1,NumberOfSamples):

        q_true[i] = q_true[i-1] + dq_true[i-1]
        p_true[i] = p_true[i-1] + dp_true[i-1]
        dq_true[i], dp_true[i] = Create_True_Hamiltonian_paths(H,np.array([q_true[i],p_true[i]]),dt,dq_true[i-1],dp_true[i-1],T_total)

    return q_true, p_true, dq_true, dp_true


# In[110]:


def Create_True_Hamiltonian_paths(H,Initial_conditions,dt,dq,dp,T_total):
    ## Change this to curent state and include time
    i = 1
    t = np.linspace(0,T_total,np.int(T_total/dt))
    
    Sample1 = np.array([t[i],Initial_conditions[0] - dq/2,Initial_conditions[1]])               
    Sample2 = np.array([t[i],Initial_conditions[0] + dq/2,Initial_conditions[1]])
    Sample3 = np.array([t[i],Initial_conditions[0] ,Initial_conditions[1] - dp/2])               
    Sample4 = np.array([t[i],Initial_conditions[0] ,Initial_conditions[1] + dp/2]) 
    

    Phase_Space_time_samples = np.array([Sample1, Sample2, Sample3, Sample4]).transpose()
    
    Hamiltonian_Samples = H.SHO_Hamiltonian(Phase_Space_time_samples)
#     Hamiltonian_Samples = Run_Through_Nural_Network_for_1D_SHO(Net1,Phase_Space_time_samples) + Run_Through_Nural_Network_for_1D_SHO(Net2,Phase_Space_time_samples)
    
#     print(Hamiltonian_Samples.shape)
#     print(Initial_conditions)
#     print(Hamiltonian_Samples)
    dp_true  = -(Hamiltonian_Samples[1] - Hamiltonian_Samples[0])*dt/dq
    dq_true  = (Hamiltonian_Samples[3] - Hamiltonian_Samples[2])*dt/dp
    
    return dq_true, dp_true    
    


# In[118]:


Individuals_Parameter_Vector = np.random.rand(70,20)
T_total = 10
First_two_phase_space_samples = np.array([[1,1.01],[2,2.01],[0,0.01]])


q_predicted, p_predicted, dq_predicted, dp_predicted = Create_predicted_path(Individuals_Parameter_Vector[:,1],First_two_phase_space_samples,T_total)
q_true, p_true, dq_true, dp_true = Create_true_path(First_two_phase_space_samples,T_total)



Loss = Calculate_Loss_Function(q_true, p_true, dq_true, dp_true, q_predicted, p_predicted, dq_predicted, dp_predicted)
plt.plot(q_true,p_true)
plt.plot(q_predicted,p_predicted)
plt.title("Phase space paths from SHO and learned hamiltonians")
plt.xlabel("q")
plt.ylabel("p")
plt.legend(["SHO Hamiltonian generated path","NN Generated Path"])

