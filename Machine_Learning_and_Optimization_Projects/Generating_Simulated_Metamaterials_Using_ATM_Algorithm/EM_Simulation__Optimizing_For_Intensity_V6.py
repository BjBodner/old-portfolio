
# coding: utf-8

# Things I want to change (as of 7:56 AM 7.4.19):
# 2. Try to Kill the Boundry effects, by deleating the amplitudes before they reaches the edge of the domain
# 3. Get an average FFT from the far wall, on a small number of pixels there - perhaps just 10
# 4. Solve the issue that the whole simulation becomes the same color

# In[1]:



import numpy as np
import math as m
import imageio
from scipy import misc
import time
from PIL import Image
import matplotlib.pyplot as plt
# from matplotlib.animation import FuncAnimation
import matplotlib.animation as animation
import pandas
import csv
import array
import Adaptive_Two_Mode_Optimizer
import datetime


# This is the main class encapsulating all simulation methods
class wave_simulation_AI:


    def __init__(self, dx_in, dt_in, sz_x_in, sz_y_in, steps_in, Incoming_Wave_Generator_Function,Dielectric_array):
        self.dx = dx_in
        self.dt = dt_in
        self.sz_x = sz_x_in
        self.sz_y = sz_y_in
        self.steps = steps_in
        self.Incoming_Wave_Generator_Function  = Incoming_Wave_Generator_Function       
        
        
        
    # Inplementation of the laplace operator that is used in the wave equation
    # It takes the following parameters:
    # u_array - grid containing the displacement values
    # dx - step size to be used in the aproximation fo the second derivative
    def Laplace(self, u_array, dx):
        sz_x = u_array.shape[0]
        sz_y = u_array.shape[1]

        dx2 = np.zeros((sz_x, sz_y), float)
        dy2 = np.zeros((sz_x, sz_y), float)

        dx2[1:sz_x - 1, 1:sz_y - 1] = ((u_array[0:(sz_x - 2), 1:(sz_y - 1)] - u_array[1:(sz_x - 1),
                                                                              1:(sz_y - 1)]) / dx - (
                                       u_array[1:(sz_x - 1), 1:(sz_y - 1)] - u_array[2:sz_x, 1:(sz_y - 1)]) / dx) / dx
        dy2[1:sz_x - 1, 1:sz_y - 1] = ((u_array[1:(sz_x - 1), 0:(sz_y - 2)] - u_array[1:(sz_x - 1),
                                                                              1:(sz_y - 1)]) / dx - (
                                       u_array[1:(sz_x - 1), 1:(sz_y - 1)] - u_array[1:(sz_x - 1), 2:sz_y]) / dx) / dx
        
        
        return (dx2 + dy2)

    # A simple edge detector intended for signification of the steps in the refractive index
    # It takes the following parameters:
    # c_array - The grid contining the wave propagation speed values for every pixel
    def Edge_detect(self, c_array):

        dx = np.zeros((sz_x, sz_y), float)
        contour = np.zeros((sz_x, sz_y), float)
        dx[0:(sz_x - 1), 0:(sz_y - 1)] = (np.abs(c_array[0:(sz_x - 1), 1:(sz_y)] - c_array[1:(sz_x), 1:(sz_y)]) + np.abs(
            c_array[1:(sz_x), 0:(sz_y - 1)] - c_array[1:(sz_x), 1:(sz_y)]) > 0)
        contour[dx>0]=1

        return (contour)

    # The method that actually executes the simulation
    def run(self,Dielectric_array):

        I_x = np.zeros((Intensity_Measuring_Pixels[3]-Intensity_Measuring_Pixels[2],self.steps))
        u_array = np.zeros((self.sz_x, self.sz_y), float)
        u_array_v = np.zeros((self.sz_x, self.sz_y), float)

        
        if Create_Visualization_Video == 1:
            arr_new_r = np.zeros((self.sz_x, self.sz_y), float)
            arr_new_g = np.zeros((self.sz_x, self.sz_y), float)
            arr_new_b = np.zeros((self.sz_x, self.sz_y), float)

            outputdata = np.zeros((self.sz_x, self.sz_y, 3), int)


            writer = imageio.get_writer(File_Name, fps=30)
        
        
        ## this creates the area with different index of refraction
        ## c = is the area with different indexes of refraction
        ## This is where we can just resahpe a vector into different indexes of refraction
        ## this can be done by just setting this to be an array of certain size
        c_const = 3
        c = np.ones((sz_x, sz_y), float) * c_const
        pixel_y_bias_for_images = 0
#         c[(waveguide_img[0:sz_x,pixel_y_bias_for_images + 0:pixel_y_bias_for_images + sz_y,2]/255)>0.5] = c_const * 0.6 ### This is where he uses the image as a a BW image
   
        
        ##Example of how this may look
        c[x_min_dielectric:x_max_dielectric,y_min_dielectric:y_max_dielectric] = c_const *Dielectric_array
        
#         print("Dielectric_array[1,1]",Dielectric_array[1,1])
        c[x_min_dielectric:sz_x,y_max_dielectric:sz_y-1] = c_const *0.1
        c[x_min_dielectric:sz_x,0:y_min_dielectric] = c_const *0.1
#     Dielectric_array
    
        for t in range(0, self.steps):
        
#             if np.mod(t,int(self.steps/10))==0:
#                 print("Now runing iteration ",t)

            b_el, b_el_mask  = self.Incoming_Wave_Generator_Function(t,sz_x, sz_y)
            
            
            u_array[b_el_mask == 1] = b_el[b_el_mask == 1]
            u_array_v = u_array_v + np.multiply(np.square(c), self.Laplace(u_array, self.dx) * self.dt)

            u_array = u_array + u_array_v * self.dt

            I_x[:,t] = Calculate_Intensity_Projection_In_X_Direction(u_array,Intensity_Measuring_Pixels)

             ## An attempt to kill boundry effects
            
                
                
            if Create_Visualization_Video == 1:
                arr_new = u_array
                arr_new[b_el_mask == 1] = 0

                arr_new_r = np.maximum(arr_new, 0) / np.max(np.maximum(arr_new, 0) + 1e-10)
                arr_new_g = np.minimum(arr_new, 0) / np.min(np.minimum(arr_new, 0) + 1e-10)
                arr_new_b[b_el_mask == 1] = 1

                arr_new_b[self.Edge_detect(c) == 1] = 1
#                 arr_new_b[Focal_Region == 1] = 1
                
                outputdata[0:self.sz_x, 0:self.sz_y, 0] = arr_new_r[0:self.sz_x, 0:self.sz_y] * 255
                outputdata[0:self.sz_x, 0:self.sz_y, 1] = arr_new_g[0:self.sz_x, 0:self.sz_y] * 255
                outputdata[0:self.sz_x, 0:self.sz_y, 2] = arr_new_b * 255
                outputdata[0, 0, 0] = 1


                writer.append_data(outputdata.astype(np.uint8))
            
            

        return I_x


# In[2]:



# This function was used to obtain the video https://youtu.be/uBiQsoDaGkE?t=2m44s
# The function simulates a passage of a plane wave through a piece material with high refractive index
# It is meant to be passed as the last argument of the wave_simulation_AI constructor
def broadcast_func_lin_wave(t):

    broadcast_el = np.zeros((sz_x, sz_y), float)
    broadcast_el_mask = np.zeros((sz_x, sz_y), int)

    broadcast_el[0:5, 0:1024] = 0
    broadcast_el_mask[0:5, 0:1024] = 1
    broadcast_el[5:15, 5:(1024-5)] = m.sin(2*m.pi*t*0.008)
    broadcast_el_mask[5:15, 5:(1024-5)] = 1

    c_const = 6
    c = np.ones((sz_x, sz_y), float) * c_const
    c[502:542, (200):(1024-200)] = c_const * 0.5

    return broadcast_el, broadcast_el_mask, c


# In[3]:





# This function simulates a passage of a plane wave through a prism
# It is meant to be passed as the last argument of the wave_simulation_AI constructor
def broadcast_func_prism_wave(t):

    broadcast_el = np.zeros((sz_x, sz_y), float)
    broadcast_el_mask = np.zeros((sz_x, sz_y), int)

    broadcast_el[0:5, 0:1024] = 0
    broadcast_el_mask[0:5, 0:1024] = 1
    broadcast_el[5:15, 5:(1024 - 5)] = m.sin(2 * m.pi * t * 0.024)
    broadcast_el_mask[5:15, 5:(1024 - 5)] = 1

    c_const = 6
    c = np.ones((sz_x, sz_y), float) * c_const

    for y in range(200,1024 - 200):
        c[(542-round((y-201)/3)):542, y] = c_const * 0.5

    return broadcast_el, broadcast_el_mask, c


# In[4]:




# This function simulates a passage of a plane wave through a lens
# It is meant to be passed as the last argument of the wave_simulation_AI constructor
def broadcast_func_circlular_lens(t):
    broadcast_el = np.zeros((sz_x, sz_y), float)
    broadcast_el_mask = np.zeros((sz_x, sz_y), int)

    broadcast_el[0:5, 0:1024] = 0
    broadcast_el_mask[0:5, 0:1024] = 1
    broadcast_el[5:15, 5:(1024 - 5)] = m.sin(2 * m.pi * t * 0.020)
    broadcast_el_mask[5:15, 5:(1024 - 5)] = 1

    c_const = 6
    c = np.ones((sz_x, sz_y), float) * c_const

    for y in range(100,1024 - 100):

        c[(542-round(m.pow(m.pow((1024-200)/2,2)-m.pow(-(y-100)+((1024-200)/2),2),0.5))):542, y] = c_const * 0.6

    return broadcast_el, broadcast_el_mask, c


# In[5]:



# This function simulates a passage of a plane wave through a Fresnel lens
# It is meant to be passed as the last argument of the wave_simulation_AI constructor
def broadcast_func_fresnel(t):
    broadcast_el = np.zeros((sz_x, sz_y), float)
    broadcast_el_mask = np.zeros((sz_x, sz_y), int)

    broadcast_el[0:5, 0:1024] = 0
    broadcast_el_mask[0:5, 0:1024] = 1

    if (t<800):
        broadcast_el[5:15, 5:(1024 - 5)] = m.sin(2 * m.pi * t * 0.024)
    broadcast_el_mask[5:15, 5:(1024 - 5)] = 1

    c_const = 6
    c = np.ones((sz_x, sz_y), float) * c_const

    for y in range(100,1024 - 100):

        y_full=m.pow(m.pow((1024 - 200) / 2, 2) - m.pow(-(y - 100) + ((1024 - 200) / 2), 2), 0.5)
        my_lambda = 2*c_const * 0.5 * (1/0.024)*0.01/0.1

        c[(542-round(y_full-round(y_full/(my_lambda)-0.5)*(my_lambda))):542, y] = c_const * 0.5

    return broadcast_el, broadcast_el_mask, c


# In[6]:



# This function simulates a passage of a plane wave through a blazed grating
# It is meant to be passed as the last argument of the wave_simulation_AI constructor
def broadcast_func_blazed_grading(t):

    broadcast_el = np.zeros((sz_x, sz_y), float)
    broadcast_el_mask = np.zeros((sz_x, sz_y), int)

    broadcast_el[0:5, 0:1024] = 0
    broadcast_el_mask[0:5, 0:1024] = 1
    broadcast_el[5:15, 5:(1024 - 5)] = m.sin(2 * m.pi * t * 0.024)
    broadcast_el_mask[5:15, 5:(1024 - 5)] = 1

    c_const = 6
    c = np.ones((sz_x, sz_y), float) * c_const

    for y in range(200,1024 - 200): ## this can also be parallelized
        y_full = (542 - round((y - 201) / 3))
        my_lambda = 2*c_const * 0.5 * (1 / 0.024) * 0.01 / 0.1

        c[(542-round(y_full-round(y_full/(my_lambda)-0.5)*(my_lambda))):542, y] = c_const * 0.5

    return broadcast_el, broadcast_el_mask, c


# In[7]:



def broadcast_func_phased_antenna_streight(t):

    broadcast_el = np.zeros((sz_x, sz_y), float)
    broadcast_el_mask = np.zeros((sz_x, sz_y), int)

    c_const = 6
    c = np.ones((sz_x, sz_y), float) * c_const

    my_lambda = c_const * (1 / 0.010) * 0.01 / 0.1

    broadcast_el[0:5, 0:1024] = 0
    broadcast_el_mask[0:5, 0:1024] = 1

    n = 10

    for a in range(0, n): ## this can also be parallelized

        broadcast_el_mask[5:15, int(1024/2-5+my_lambda/2*(a-n/2)):int(1024/2+5+my_lambda/2*(a-n/2))] = 1
        broadcast_el[5:15, int(1024/2-5+my_lambda/2*(a-n/2)):int(1024/2+5+my_lambda/2*(a-n/2))] = m.sin(2 * m.pi * t * 0.010)

    return broadcast_el, broadcast_el_mask, c


# In[8]:



def broadcast_func_phased_antenna_angle(t):

    broadcast_el = np.zeros((sz_x, sz_y), float)
    broadcast_el_mask = np.zeros((sz_x, sz_y), int)

    c_const = 3
    c = np.ones((sz_x, sz_y), float) * c_const

    my_lambda = c_const * (1 / 0.008) * 0.01 / 0.1

    #broadcast_el[100:105, 0:1024] = 0
    #broadcast_el_mask[100:105, 0:1024] = 1

    n = 16

    if (t<1000):
        for a in range(0, n): ## this can also be parallelized
            phase=2 * m.pi / 4 * a
            phase = 0
            broadcast_el_mask[int(1024/2-1):int(1024/2+1), int(1024/2-1+my_lambda/4*(a)-my_lambda/4*n/2):int(1024/2+1+my_lambda/4*(a)-my_lambda/4*n/2)] = 1
            broadcast_el[int(1024/2-1):int(1024/2+1), int(1024/2-1+my_lambda/4*(a)-my_lambda/4*n/2):int(1024/2+1+my_lambda/4*(a)-my_lambda/4*n/2)] = m.sin(2 * m.pi * (t) * 0.008 + phase)

    return broadcast_el, broadcast_el_mask, c


# In[9]:



def broadcast_func_phased_antenna_focus(t):

    broadcast_el = np.zeros((sz_x, sz_y), float)
    broadcast_el_mask = np.zeros((sz_x, sz_y), int)

    c_const = 6
    c = np.ones((sz_x, sz_y), float) * c_const

    my_lambda = c_const * (1 / 0.008) * 0.01 / 0.1

    broadcast_el[0:5, 0:1024] = 0
    broadcast_el_mask[0:5, 0:1024] = 1

    n = 10

    if (t<1000):
        for a in range(0, n): ## this can also be parallelized

            phase=2 * m.pi * m.sqrt(m.pow(500,2)-m.pow(my_lambda/2*(a-n/2),2))/my_lambda

            broadcast_el_mask[5:15, int(1024/2-5+my_lambda/2*(a-n/2)):int(1024/2+5+my_lambda/2*(a-n/2))] = 1
            broadcast_el[5:15, int(1024/2-5+my_lambda/2*(a-n/2)):int(1024/2+5+my_lambda/2*(a-n/2))] = m.sin(2 * m.pi * (t) * 0.008 + phase)

    return broadcast_el, broadcast_el_mask, c


# In[10]:



def broadcast_func_phased_antenna_focus2(t):

    broadcast_el = np.zeros((sz_x, sz_y), float)
    broadcast_el_mask = np.zeros((sz_x, sz_y), int)

    c_const = 6
    c = np.ones((sz_x, sz_y), float) * c_const

    my_lambda = c_const * (1 / 0.008) * 0.01 / 0.1

    broadcast_el[100:105, 0:1024] = 0
    broadcast_el_mask[100:105, 0:1024] = 1

    n = 10

    if (t<1000):
        for a in range(0, n): ## this can also be parallelized

            phase=-2 * m.pi * m.sqrt(m.pow(400,2)-m.pow(my_lambda/2*(a-n/2),2))/my_lambda

            broadcast_el_mask[105:115, int(1024/2-5+my_lambda/2*(a-n/2)):int(1024/2+5+my_lambda/2*(a-n/2))] = 1
            broadcast_el[105:115, int(1024/2-5+my_lambda/2*(a-n/2)):int(1024/2+5+my_lambda/2*(a-n/2))] = m.sin(2 * m.pi * (t) * 0.008 + phase)


    return broadcast_el, broadcast_el_mask, c


# In[11]:



def broadcast_func_radar(t):


    broadcast_el = np.zeros((sz_x, sz_y), float)
    broadcast_el_mask = np.zeros((sz_x, sz_y), int)

    c_const = 6
    c = np.ones((sz_x, sz_y), float) * c_const

    for y in range(-20, 20): ## this can be parallelized
        c[(400-y):(400+y),int(1024/2+250-m.sqrt(m.pow(40/2,2)-m.pow(y,2))):int(1024/2+250+m.sqrt(m.pow(40/2,2)-m.pow(y,2)))]=c_const/5

    my_lambda = c_const * (1 / 0.024) * 0.01 / 0.1

    broadcast_el[0:5, 0:1024] = 0
    broadcast_el_mask[0:5, 0:1024] = 1

    n = 10

    if (t<500):
        for a in range(0, n):
            phase=2 * m.pi / 4 * a

            broadcast_el_mask[5:15, int(1024/2-5+my_lambda/2*(a-n/2)):int(1024/2+5+my_lambda/2*(a-n/2))] = 1
            broadcast_el[5:15, int(1024/2-5+my_lambda/2*(a-n/2)):int(1024/2+5+my_lambda/2*(a-n/2))] = m.sin(2 * m.pi * (t) * 0.024 + phase)

    if ((t>1000)&(t<1500)):
        for a in range(0, n):
            phase=-2 * m.pi / 4 * a

            broadcast_el_mask[5:15, int(1024/2-5+my_lambda/2*(a-n/2)):int(1024/2+5+my_lambda/2*(a-n/2))] = 1
            broadcast_el[5:15, int(1024/2-5+my_lambda/2*(a-n/2)):int(1024/2+5+my_lambda/2*(a-n/2))] = m.sin(2 * m.pi * (t) * 0.024 + phase)


    return broadcast_el, broadcast_el_mask, c


# In[12]:




# waveguide_img = misc.imread('/Path_to_your_image_goes_here/kepler_telescope.bmp')

def broadcast_func_image(t,sz_x, sz_y): ## this also pastes the image in the 

    broadcast_el = np.zeros((sz_x, sz_y), float)
    broadcast_el_mask = np.zeros((sz_x, sz_y), int)

    broadcast_el[0:5, 0:sz_y] = 0
    broadcast_el_mask[0:5, 0:sz_y] = 1
    
    broadcast_el[5:15, 5:(sz_y - 5)] = m.sin(2 * m.pi * t * 0.024)
    
    broadcast_el_mask[5:15, 5:(sz_y - 5)] = 1


    c_const = 3
    c = np.ones((sz_x, sz_y), float) * c_const
    
    
    print("Now runing iteration ",t)
    pixel_y_bias_for_images = 0
    
    ## this operation doesn't need to happen in each operation - we can do it once at the begining and thats it
    c[(waveguide_img[0:sz_x,pixel_y_bias_for_images + 0:pixel_y_bias_for_images + sz_y,2]/255)>0.5] = c_const * 0.6 ### This is where he uses the image as a a BW image
   


    ## What is 0.6 is that the index of refraction?
    

    
    #my_lambda = c_const * (1 / 0.008) * 0.01 / 0.1

    #broadcast_el[112:116, (66-20):(66+20)] = 0
    #broadcast_el_mask[112:116, (66-20):(66+20)] = 1

    #broadcast_el_mask[116:118, (66-5):(66+5)] = 1
    #broadcast_el[116:118, (66-5):(66+5)] = m.sin(2 * m.pi * (t) * 0.008)

    return broadcast_el, broadcast_el_mask, c




def broadcast_func_image2(t,sz_x, sz_y): ## this also pastes the image in the 

    broadcast_el = np.zeros((sz_x, sz_y), float)
    broadcast_el_mask = np.zeros((sz_x, sz_y), int)

    broadcast_el[0:5, 0:sz_y] = 0
    broadcast_el_mask[0:5, 0:sz_y] = 1
    
#     broadcast_el[5:15, 5:(sz_y - 5)] = m.sin(2 * m.pi * t * 0.024)
#     broadcast_el[5:15, 5:(sz_y - 5)] = Generate_Frequencies_Of_Incomming_Waves(Frequencies,
#                                                                                Phases,t,
#                                                                                Frequency_Variation_Amplitude,
#                                                                                Phase_Variation_Amplitude)
    
    
    broadcast_el[5:10, 0:(sz_y - 0)] = Generate_Frequencies_Of_Incomming_Waves(Frequencies,
                                                                               Phases,t,
                                                                               Frequency_Variation_Amplitude,
                                                                               Phase_Variation_Amplitude)
    
    broadcast_el_mask[5:10, 0:(sz_y - 0)] = 1

    


    return broadcast_el, broadcast_el_mask



def Generate_Frequencies_Of_Incomming_Waves(Frequencies,Phases,t,Frequency_Variation_Amplitude,Phase_Variation_Amplitude): ## t usually has steps of 0.01
    

    Time_Domain_Wave = np.sum(np.sin(2 * m.pi *( t *
                                    ( Frequencies+Frequency_Variation_Amplitude*(np.random.rand(len(Frequencies))-0.5))
                                     + (Phases+Phase_Variation_Amplitude*(np.random.rand(len(Phases))-0.5)))))
    
    return Time_Domain_Wave




def Calculate_Intensity_Projection_In_X_Direction(broadcast_el,Intensity_Measuring_Pixels):
    
    I_x = np.sum(broadcast_el[Intensity_Measuring_Pixels[0]:Intensity_Measuring_Pixels[1],Intensity_Measuring_Pixels[2]:Intensity_Measuring_Pixels[3]]**2,0)
    
    return  I_x


# In[13]:



def Check_Dimensions_For_Direlectric(x_max_dielectric,x_min_dielectric,y_max_dielectric,y_min_dielectric,Size_Of_Dielectric_Blocks):
    
    Number_Of_Blocks_In_X_Direction = int(( x_max_dielectric-x_min_dielectric)/Size_Of_Dielectric_Blocks[0])
    Error_In_Number_Of_Blocks_In_X_Direction =np.round(Size_Of_Dielectric_Blocks[1]* ( Number_Of_Blocks_In_X_Direction - (x_max_dielectric-x_min_dielectric)/Size_Of_Dielectric_Blocks[0]))
    
    
    Number_Of_Blocks_In_Y_Direction = int(( y_max_dielectric-y_min_dielectric)/Size_Of_Dielectric_Blocks[1]) 
    Error_In_Number_Of_Blocks_In_Y_Direction = np.round(Size_Of_Dielectric_Blocks[1]* (Number_Of_Blocks_In_Y_Direction - (y_max_dielectric-y_min_dielectric)/Size_Of_Dielectric_Blocks[1]))
    
        
    ## this is an error message if the sizes don't match
    if np.abs(Error_In_Number_Of_Blocks_In_X_Direction) + np.abs(Error_In_Number_Of_Blocks_In_Y_Direction) > 0:
        print("The size of the dielectric doesn't match an round number of blocks")
        print(Error_In_Number_Of_Blocks_In_X_Direction,Error_In_Number_Of_Blocks_In_Y_Direction)

        

    Number_Of_Parameters = Number_Of_Blocks_In_X_Direction*Number_Of_Blocks_In_Y_Direction
    return Number_Of_Parameters, Number_Of_Blocks_In_X_Direction,Number_Of_Blocks_In_Y_Direction





def Construct_Direlectric_Blocks_From_Parameters(Parameters, Number_Of_Blocks_In_X_Direction,Number_Of_Blocks_In_Y_Direction,Size_Of_Dielectric_Blocks,x_max_dielectric,x_min_dielectric,y_max_dielectric,y_min_dielectric ):
    
    
    x_max_dielectric,x_min_dielectric,y_max_dielectric,y_min_dielectric
    Dielectric_array = np.zeros(( x_max_dielectric-x_min_dielectric, y_max_dielectric-y_min_dielectric))
    
    for i in range(0,Number_Of_Blocks_In_X_Direction):
        for j in range(0,Number_Of_Blocks_In_Y_Direction):
            Dielectric_array[i*Size_Of_Dielectric_Blocks[0]:(i+1)*Size_Of_Dielectric_Blocks[0],
                            j*Size_Of_Dielectric_Blocks[1]:(j+1)*Size_Of_Dielectric_Blocks[1]] = Parameters[j + i*Number_Of_Blocks_In_Y_Direction ]

    return Dielectric_array


# In[14]:



def Create_Intensity_Animation(I_x):
    fig = plt.figure(figsize=(10,6))
    I_x_sum = np.zeros((I_x.shape[0],I_x.shape[1]))
    I_x_sum[:,0] = I_x[:,0]
    for i in range(1,I_x.shape[1]):
        I_x_sum[:,i] =I_x_sum[:,i-1] + I_x[:,i]


    def animate(i):
        p = plt.plot(I_x_sum[:,3*i])

        
#     Intervals_Of_Frames = 3
    ani = animation.FuncAnimation(fig, animate, frames=100, repeat=False)
    ani.save( "Intensity.mp4",fps=30)
    print("all done")
    
    return I_x_sum

def Calculate_I_x_Sum(I_x):
    I_x_sum = np.zeros((I_x.shape[0],I_x.shape[1]))
    I_x_sum[:,0] = I_x[:,0]
    for i in range(1,I_x.shape[1]):
        I_x_sum[:,i] =I_x_sum[:,i-1] + I_x[:,i]
    return  I_x_sum


def signaltonoise(a, axis=0, ddof=0):
    a = np.asanyarray(a)
    m = a.mean(axis)
    sd = a.std(axis=axis, ddof=ddof)
    return np.where(sd == 0, 0, m/sd)


def Exponential_Ratio_Of_Signal_Amplification(a):
    return np.exp(np.max(a[Range_for_Centering_Focal_Point [0]:Range_for_Centering_Focal_Point [1]])/np.mean(a[Range_for_Checking_SNR[0]:Range_for_Checking_SNR[1]]))*np.max(a[Range_for_Centering_Focal_Point [0]:Range_for_Centering_Focal_Point [1]]) ## 40:60 is so that the focus is in the middle



# In[15]:


def Save_Images_Of_Dielectric(Parameters,Number_Of_Parameter_File):
    
#     Adjusted_Parameters = Adjust_Parameters_To_Fit_Within_Allowed_Values(Parameters)

    Dielectric_array = Construct_Direlectric_Blocks_From_Parameters(Parameters, Number_Of_Blocks_In_X_Direction,Number_Of_Blocks_In_Y_Direction,Size_Of_Dielectric_Blocks,x_max_dielectric,x_min_dielectric,y_max_dielectric,y_min_dielectric )
    print(Dielectric_array.shape)

    Dielectric_array1 = (Dielectric_array**3)*255

    new_im = Image. fromarray(Dielectric_array1)
    new_p = new_im.convert("L")



    basewidth = 350
    img = new_p
    wpercent = (basewidth/float(img.size[0]))
    hsize = int((float(img.size[1])*float(wpercent)))
    img = img.resize((basewidth,hsize), Image.ANTIALIAS)

#     if Display_Plots:
    plt.imshow(Dielectric_array1) ## This shows a heat map of the created Dielectric
    plt.savefig('Dielectric_Image_HeatMap' +str (Number_Of_Parameter_File) +  '.png')
    img. save("Dielectric_Image_Grayscale" +str (Number_Of_Parameter_File) +  ".bmp")
    plt.close()
    
def     Save_Parameters_to_CSV(Parameters,Number_Of_Parameter_File):
    
        ## Save the parameters of the network
        Name_Of_Parameter_File = "Parameters_For_Intensity_Optimization" + str (Number_Of_Parameter_File) + ".csv"
    #     print(Name_Of_Parameter_File )


        with open(Name_Of_Parameter_File, 'w') as csvfile:
            fieldnames = ['Parameters_For_Intensity_Optimization']
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            writer.writeheader()

            for i in range(0,Parameters.shape[0]):
                writer.writerow({ 'Parameters_For_Intensity_Optimization':Parameters[i], })
                
                

def Create_And_Save_Intensity_Plot_Created_From_Parameters_Before_and_After(x0,x1,Title):

    Adjusted_Parameters = Adjust_Parameters_To_Fit_Within_Allowed_Values(x0)
    Dielectric_array = Construct_Direlectric_Blocks_From_Parameters(Adjusted_Parameters, Number_Of_Blocks_In_X_Direction,Number_Of_Blocks_In_Y_Direction,Size_Of_Dielectric_Blocks,x_max_dielectric,x_min_dielectric,y_max_dielectric,y_min_dielectric )

    I_x = my_sim.run(Dielectric_array)
    I_x_sum = Calculate_I_x_Sum(I_x)
    plt.plot(I_x_sum[y_min_dielectric+5:y_max_dielectric-15,I_x_sum.shape[1]-1])
    
    
    
    Adjusted_Parameters = Adjust_Parameters_To_Fit_Within_Allowed_Values(x1)
    Dielectric_array = Construct_Direlectric_Blocks_From_Parameters(Adjusted_Parameters, Number_Of_Blocks_In_X_Direction,Number_Of_Blocks_In_Y_Direction,Size_Of_Dielectric_Blocks,x_max_dielectric,x_min_dielectric,y_max_dielectric,y_min_dielectric )

    I_x = my_sim.run(Dielectric_array)
    I_x_sum = Calculate_I_x_Sum(I_x)
    plt.plot(I_x_sum[y_min_dielectric+5:y_max_dielectric-15,I_x_sum.shape[1]-1])
    
    
    
    plt.xlabel('Index of pixel in the perpandicular plane (NU)')
    plt.ylabel('Intensity of incoming light (NU)')
    plt.title(Title+ str (Number_Of_Parameter_File) )
    plt.legend(['Before ','After'])
    plt.savefig(Title +str (Number_Of_Parameter_File) +  '.png')
    plt.close()
    


# In[16]:


def Adjust_Parameters_To_Fit_Within_Allowed_Values(Parameters):

    ## This maps the values to be within the allowed values for the speed of light
    Parameters = Minimum_Velocity_In_Matter + (Parameters + 5)/20 ## this maps them to between 0.5 and 1
    Adjusted_Parameters = np.minimum(np.maximum(Parameters ,Minimum_Velocity_In_Matter ),0.99)

    return Adjusted_Parameters


def Cost_Function_For_SNR_Optimization(Parameters):
    

#     Parameters = Minimum_Velocity_In_Matter + (Parameters + 5)/20 ## this maps them to between 0.5 and 1
#     Parameters = np.minimum(np.maximum(Parameters ,Minimum_Velocity_In_Matter ),0.99)
    
    Adjusted_Parameters = Adjust_Parameters_To_Fit_Within_Allowed_Values(Parameters)
    
    Dielectric_array = Construct_Direlectric_Blocks_From_Parameters(Adjusted_Parameters, Number_Of_Blocks_In_X_Direction,Number_Of_Blocks_In_Y_Direction,Size_Of_Dielectric_Blocks,x_max_dielectric,x_min_dielectric,y_max_dielectric,y_min_dielectric )

    I_x = my_sim.run(Dielectric_array)
    I_x_sum = Calculate_I_x_Sum(I_x)
    Signal_To_Noise_Ratio = Exponential_Ratio_Of_Signal_Amplification(I_x_sum[y_min_dielectric+5:y_max_dielectric-15,I_x_sum.shape[1]-1])
    
#     print(-Signal_To_Noise_Ratio)
    return -Signal_To_Noise_Ratio ## the minus sign is because we are trying to minimize




def Plot_Intensity_Created_From_Parameters(Parameters):

#     Parameters = Minimum_Velocity_In_Matter + (Parameters + 5)/20 ## this maps them to between 0.5 and 1
#     Parameters = np.minimum(np.maximum(Parameters ,Minimum_Velocity_In_Matter ),1)
    
    Adjusted_Parameters = Adjust_Parameters_To_Fit_Within_Allowed_Values(Parameters)
    
    Dielectric_array = Construct_Direlectric_Blocks_From_Parameters(Adjusted_Parameters, Number_Of_Blocks_In_X_Direction,Number_Of_Blocks_In_Y_Direction,Size_Of_Dielectric_Blocks,x_max_dielectric,x_min_dielectric,y_max_dielectric,y_min_dielectric )


    I_x = my_sim.run(Dielectric_array)
    I_x_sum = Calculate_I_x_Sum(I_x)
    plt.plot(I_x_sum[y_min_dielectric+5:y_max_dielectric-15,I_x_sum.shape[1]-1])
    if Display_Plots:
        plt.show()
    plt.close()
        
    
    
def Create_Intensity_Video(Parameters):
    
    Adjusted_Parameters = Adjust_Parameters_To_Fit_Within_Allowed_Values(Parameters)
    
    Dielectric_array = Construct_Direlectric_Blocks_From_Parameters(Adjusted_Parameters, Number_Of_Blocks_In_X_Direction,Number_Of_Blocks_In_Y_Direction,Size_Of_Dielectric_Blocks,x_max_dielectric,x_min_dielectric,y_max_dielectric,y_min_dielectric )


    I_x = my_sim.run(Dielectric_array)
    I_x_sum = Create_Intensity_Animation(I_x)
    
    
    
    
def Calculate_Relative_Intensity_At_Focal_Point_Before_And_After(x0 ,x1):

    ### Calculate Average_Intensity
    Adjusted_Parameters = Adjust_Parameters_To_Fit_Within_Allowed_Values(x0)
    Dielectric_array = Construct_Direlectric_Blocks_From_Parameters(Adjusted_Parameters, Number_Of_Blocks_In_X_Direction,Number_Of_Blocks_In_Y_Direction,Size_Of_Dielectric_Blocks,x_max_dielectric,x_min_dielectric,y_max_dielectric,y_min_dielectric )

    I_x = my_sim.run(Dielectric_array)
    I_x_sum = Calculate_I_x_Sum(I_x)
    Average_Intensity_Before = np.mean(I_x_sum[y_min_dielectric+5:y_max_dielectric-15,I_x_sum.shape[1]-1])
    
    
    ### Calculate Max Intensity After
    Adjusted_Parameters = Adjust_Parameters_To_Fit_Within_Allowed_Values(x1)
    Dielectric_array = Construct_Direlectric_Blocks_From_Parameters(Adjusted_Parameters, Number_Of_Blocks_In_X_Direction,Number_Of_Blocks_In_Y_Direction,Size_Of_Dielectric_Blocks,x_max_dielectric,x_min_dielectric,y_max_dielectric,y_min_dielectric )

    I_x = my_sim.run(Dielectric_array)
    I_x_sum = Calculate_I_x_Sum(I_x)
    I_x_Sum1 = I_x_sum[y_min_dielectric+5:y_max_dielectric-15,I_x_sum.shape[1]-1]
    Max_Intensity_After = np.max(I_x_Sum1[Range_for_Centering_Focal_Point[0]:Range_for_Centering_Focal_Point[1]])
    
    
    Relative_Itensity = Max_Intensity_After/Average_Intensity_Before
    return Relative_Itensity


# In[17]:


# ### This sets all the system parameters

# dx = 0.1
# dt = 0.01
# sz_x = 96## this is the first index in the arrays - looks like it goes top to does (meaning it is actually the y axis)
# sz_y = 256 ## this is the second index in the arrays - looks like it goes left to right  (meaning it is actually the x axis)
# ## this is find if the whole image is rotated clockswise 90 degrees, this way the propogation is in the x direction
# steps = 500

# # waveguide_img = np.array(Image.open("kepler_telescope.bmp"))

# ### This is whee we select the incomming frequencies
# Number_Of_Frequencies = 100
# Amplitude_Of_Frequencies = 0.05 ## to minimize numerical errors
# Frequencies = Amplitude_Of_Frequencies*np.random.rand(Number_Of_Frequencies)
# Phases = np.random.rand(Number_Of_Frequencies)
# Frequency_Variation_Amplitude = 0
# Phase_Variation_Amplitude = 0



# ## Defining the region of the dielectric
# ## These are the indexes in the array where the direlectric is possitioned
# x_min_dielectric = 32
# x_max_dielectric = 44
# y_min_dielectric = 64
# y_max_dielectric =  192
# Size_Of_Dielectric_Blocks = np.array([2,2])
# Width_Of_Dielectric = y_max_dielectric - y_min_dielectric

# print("Width_Of_Dielectric",Width_Of_Dielectric)


# ## defining in which pixels to measure intensity -- Important Note - I_x is an array that grows with number of iterations
# ## This is where we define the focal point
# # x is the direction of propogation up to down
# x_start = 72
# x_finish = 74
# # y is the direction of propogation up to down
# y_start = 5
# y_finish = (sz_y - 5)

# Intensity_Measuring_Pixels = np.array([x_start,x_finish,y_start,y_finish])

# Range_for_Centering_Focal_Point = np.array([int(Width_Of_Dielectric/2-8),int(Width_Of_Dielectric/2+8)])
# Range_for_Checking_SNR = np.array([int(Width_Of_Dielectric/2-40),int(Width_Of_Dielectric/2+40)])



# Number_Of_Parameters, Number_Of_Blocks_In_X_Direction,Number_Of_Blocks_In_Y_Direction = Check_Dimensions_For_Direlectric(x_max_dielectric,x_min_dielectric,y_max_dielectric,y_min_dielectric,Size_Of_Dielectric_Blocks)



# Parameter_Vector= 0.5 +  0.5*np.random.rand(Number_Of_Parameters )  


# Use_Constant_Dielectric = 0
# Use_Parameter_Dielectric = 1
# t1 = time.time()

# if Use_Constant_Dielectric:
#     Dielectric_array = 0.6 ## this is where we will use a vector of parametrs that we will reshape

# if Use_Parameter_Dielectric:
#     Dielectric_array = Construct_Direlectric_Blocks_From_Parameters(Parameter_Vector, Number_Of_Blocks_In_X_Direction,Number_Of_Blocks_In_Y_Direction,Size_Of_Dielectric_Blocks,x_max_dielectric,x_min_dielectric,y_max_dielectric,y_min_dielectric )

# #     Dielectric_array = np.reshape(Parameter_Vector,( x_max_dielectric-x_min_dielectric, y_max_dielectric-y_min_dielectric))

    
    
# Create_Visualization_Video = 0
# my_sim = wave_simulation_AI(dx, dt, sz_x, sz_y, steps, broadcast_func_image2,Dielectric_array)

# I_x = my_sim.run(Dielectric_array)

# print()
# print("All done")
# print("Total time",time.time() - t1)
# print("Average Frame Generation Rate:", float(time.time() - t1)/steps)


# I_x_sum = Calculate_I_x_Sum(I_x)

# Signal_To_Noise_Ratio = Exponential_Ratio_Of_Signal_Amplification(I_x_sum[y_min_dielectric:y_max_dielectric,I_x_sum.shape[1]-1])
# print("Signal_To_Noise_Ratio",Signal_To_Noise_Ratio)


# # plt.plot(I_x_sum[y_min_dielectric:y_max_dielectric,I_x_sum.shape[1]-1])


# In[18]:


### This sets all the system parameters

dx = 0.1
dt = 0.01
sz_x = 96## this is the first index in the arrays - looks like it goes top to does (meaning it is actually the y axis)
sz_y = 256 ## this is the second index in the arrays - looks like it goes left to right  (meaning it is actually the x axis)
## this is find if the whole image is rotated clockswise 90 degrees, this way the propogation is in the x direction
steps = 500

# waveguide_img = np.array(Image.open("kepler_telescope.bmp"))

### This is whee we select the incomming frequencies
Number_Of_Frequencies = 100
Amplitude_Of_Frequencies = 0.05 ## to minimize numerical errors
Frequencies = Amplitude_Of_Frequencies*np.random.rand(Number_Of_Frequencies)
Phases = np.random.rand(Number_Of_Frequencies)
Frequency_Variation_Amplitude = 0
Phase_Variation_Amplitude = 0



## Defining the region of the dielectric
## These are the indexes in the array where the direlectric is possitioned
x_min_dielectric = 32
x_max_dielectric = 44
y_min_dielectric = 64
y_max_dielectric =  192
Size_Of_Dielectric_Blocks = np.array([2,2])
Width_Of_Dielectric = y_max_dielectric - y_min_dielectric

print("Width_Of_Dielectric",Width_Of_Dielectric)


## defining in which pixels to measure intensity -- Important Note - I_x is an array that grows with number of iterations
## This is where we define the focal point
# x is the direction of propogation up to down
x_start = 72
x_finish = 74
# y is the direction of propogation up to down
y_start = 5
y_finish = (sz_y - 5)

Intensity_Measuring_Pixels = np.array([x_start,x_finish,y_start,y_finish])

Range_for_Centering_Focal_Point = np.array([int(Width_Of_Dielectric/2-8),int(Width_Of_Dielectric/2+8)])
Range_for_Checking_SNR = np.array([int(Width_Of_Dielectric/2-40),int(Width_Of_Dielectric/2+40)])




## Initializing the system
Number_Of_Parameters, Number_Of_Blocks_In_X_Direction,Number_Of_Blocks_In_Y_Direction = Check_Dimensions_For_Direlectric(x_max_dielectric,x_min_dielectric,y_max_dielectric,y_min_dielectric,Size_Of_Dielectric_Blocks)
Parameter_Vector= 0.5 +  0.5*np.random.rand(Number_Of_Parameters )  

Use_Constant_Dielectric = 0
Use_Parameter_Dielectric = 1

if Use_Constant_Dielectric:
    Dielectric_array = 0.6 ## this is where we will use a vector of parametrs that we will reshape

if Use_Parameter_Dielectric:
    Dielectric_array = Construct_Direlectric_Blocks_From_Parameters(Parameter_Vector, Number_Of_Blocks_In_X_Direction,Number_Of_Blocks_In_Y_Direction,Size_Of_Dielectric_Blocks,x_max_dielectric,x_min_dielectric,y_max_dielectric,y_min_dielectric )

Create_Visualization_Video = 0
my_sim = wave_simulation_AI(dx, dt, sz_x, sz_y, steps, broadcast_func_image2,Dielectric_array)


# In[19]:



#####################################################################################
#####################################################################################
#####################################################################################
Number_Of_Iterations = 1

Number_Of_Parameter_File=1

Display_Plots = 0
#####################################################################################
#####################################################################################
#####################################################################################


Minimum_Velocity_In_Matter = 0.3

Create_Visualization_Video = 0
t1 = time.time()
remaining_evals = 64*1

x0 = 5.0*np.ones(Number_Of_Parameters ) ## this will be mapped to 1.0 after readjustment



print("Started Running Timing experiment: ",1,"iterations")
Best_Parameters_After_Optimization = Adaptive_Two_Mode_Optimizer.optimize(Cost_Function_For_SNR_Optimization, x0, remaining_evals )
Expected_Time_For_1_Iteration = time.time() - t1
print("Expected RunTime For 1 Optimization Iteration is: ",Expected_Time_For_1_Iteration)


# In[20]:


## This is where the real Optimization Occurs


Minimum_Velocity_In_Matter = 0.3

Create_Visualization_Video = 0
t1 = time.time()
remaining_evals = 64*Number_Of_Iterations

x0 = 5.0*np.ones(Number_Of_Parameters ) ## this will be mapped to 1.0 after readjustment


print("Started Running ",Number_Of_Iterations,"iterations")
currentDT = datetime.datetime.now()
print("started at",str(currentDT))



Expected_Run_time =Expected_Time_For_1_Iteration*Number_Of_Iterations 



ERT_Hours = int(np.floor(Expected_Run_time/3600))
ERT_Min = int(np.floor(Expected_Run_time/60))
ERT_Sec = int(np.mod(Expected_Run_time,60))
print("Estimated Time of completing optimization:  (",ERT_Hours,":",ERT_Min ,":",ERT_Sec,")           (hh:mm:ss)")
print()


print("Initial Cost",Cost_Function_For_SNR_Optimization(x0))
Best_Parameters_After_Optimization = Adaptive_Two_Mode_Optimizer.optimize(Cost_Function_For_SNR_Optimization, x0, remaining_evals )
print("Final Cost",Cost_Function_For_SNR_Optimization(Best_Parameters_After_Optimization))


print()
print("All done")
currentDT = datetime.datetime.now()
print("Finished at",str(currentDT))
print("Total time",time.time() - t1)
print("Time for each optimization step:", float(time.time() - t1)/Number_Of_Iterations )

print()
print()
## Make a video of after optimization
Create_Visualization_Video = 1
print("The plot below is before intensity optimization")
File_Name = 'Focusing_Dielectric_Before_Optimization.mp4'
Plot_Intensity_Created_From_Parameters(x0 )
print("The plot below is After intensity optimization")
File_Name = 'Focusing_Dielectric_After_Optimization.mp4'
Plot_Intensity_Created_From_Parameters(Best_Parameters_After_Optimization)

Create_Intensity_Video = 0
if Create_Intensity_Video:
    Create_Intensity_Video(Parameters)
    
    
    
    
### Calculate the relative intensity 
Create_Visualization_Video = 0
Relative_Itensity = Calculate_Relative_Intensity_At_Focal_Point_Before_And_After(x0 ,Best_Parameters_After_Optimization)

print("Relative_Itensity:  ",Relative_Itensity)


# In[21]:



    
    

Title = "Intensity distribution before and after optimization"
Create_And_Save_Intensity_Plot_Created_From_Parameters_Before_and_After(x0,Best_Parameters_After_Optimization,Title)


# In[26]:



## Save Parameters

Adjusted_Parameters = Adjust_Parameters_To_Fit_Within_Allowed_Values(Best_Parameters_After_Optimization)
Save_Parameters_to_CSV(Adjusted_Parameters,Number_Of_Parameter_File) ## This saves the parameters
Save_Images_Of_Dielectric(Adjusted_Parameters,Number_Of_Parameter_File) ## This saves the Images of the parameters

### Load Parameters
File_Name = "Parameters_For_Intensity_Optimization" + str (Number_Of_Parameter_File) + ".csv"
Data = pandas.read_csv(File_Name)
Data = np.array(Data)
print("Number Of Optimized  Parameters",Data.shape)


# In[23]:


### This save all the system parameters 


f= open("Experiment_Parameters.txt","w+")



f.write("Experiment_Parameters For Experiment - " + str(Number_Of_Parameter_File)+ ":\n")
f.write("\n")
f.write("----------------------------------------\n")
f.write("\n")
f.write("This is where we select the General Parameters:\n")
f.write("dx =" + str(dx) + "\n")
f.write("dt =" + str(dt)+ "\n")
f.write("sz_x =" + str(sz_x) + "\n")
f.write("sz_y =" + str(sz_y)+ "\n")
f.write("steps =" + str(steps)+ "\n")
f.write("\n")
f.write("----------------------------------------\n")
f.write("\n")



f.write("This is where we select the incomming frequencies:\n")
f.write("\n")
f.write("Number_Of_Frequencies =" + str(Number_Of_Frequencies)+ "\n")
f.write("Amplitude_Of_Frequencies =" + str(Amplitude_Of_Frequencies)+ "\n")
f.write("Frequencies = Amplitude_Of_Frequencies*np.random.rand(Number_Of_Frequencies)\n")
f.write("Frequencies_Values =" + str(Frequencies)+ "\n")
f.write("Phases = np.random.rand(Number_Of_Frequencies) \n")
f.write("Phases_Values =" + str(Phases)+ "\n")
f.write("Frequency_Variation_Amplitude =" + str(Frequency_Variation_Amplitude)+ "\n")
f.write("Phase_Variation_Amplitude =" + str(Phase_Variation_Amplitude)+ "\n")
f.write("\n")
f.write("----------------------------------------\n")
f.write("\n")



f.write("Defining the region of the dielectric:\n")
f.write("These are the indexes in the array where the direlectric is possitioned:\n")
f.write("\n")
f.write("Size_Of_Dielectric_Blocks = np.array([2,2]):\n")
f.write("x_min_dielectric =" + str(x_min_dielectric)+ "\n")
f.write("x_max_dielectric =" + str(x_max_dielectric)+ "\n")
f.write("y_min_dielectric =" + str(y_max_dielectric)+ "\n")
f.write("y_max_dielectric =" + str(y_max_dielectric)+ "\n")
f.write("Width_Of_Dielectric = y_max_dielectric - y_min_dielectric\n")
f.write("\n")
f.write("----------------------------------------\n")
f.write("\n")



f.write("Defining the region of the dielectric:\n")
f.write("These are the indexes in the array where the direlectric is possitioned:\n")
f.write("\n")
f.write("Size_Of_Dielectric_Blocks = np.array([2,2]):\n")
f.write("x_start =" + str(x_start)+ "\n")
f.write("x_finish =" + str(x_finish)+ "\n")
f.write("y_finish  =" + str(y_finish )+ "\n")
f.write("y_finish = (sz_y - 5)\n")
f.write("Intensity_Measuring_Pixels = np.array([x_start,x_finish,y_start,y_finish])\n")
f.write("Range_for_Centering_Focal_Point = np.array([int(Width_Of_Dielectric/2-8),int(Width_Of_Dielectric/2+8)])\n")
f.write("Range_for_Checking_SNR = np.array([int(Width_Of_Dielectric/2-40),int(Width_Of_Dielectric/2+40)])\n")
f.write("\n")
f.write("----------------------------------------\n")
f.write("\n")



f.write("Defining the Optimization Settings:\n")
f.write("\n")
f.write("Number_Of_Iterations =" + str(Number_Of_Iterations)+ "\n")
f.write("Minimum_Velocity_In_Matter =" + str(Minimum_Velocity_In_Matter)+ "\n")
f.write("Maximum_Velocity_In_Matter = 1\n")
f.write("remaining_evals = 64*Number_Of_Iterations\n")
f.write("x0 = 5.0*np.ones(Number_Of_Parameters ) \n")
f.write("\n")
f.write("----------------------------------------\n")
f.write("\n")


f.write("Results:\n")
f.write("\n")
f.write("Relative_Itensity =" + str(Relative_Itensity)+ "\n")
f.write("Initial Value Of Cost Function =" + str(Cost_Function_For_SNR_Optimization(x0))+ "\n")
f.write("Final Value Of Cost Function =" + str(Cost_Function_For_SNR_Optimization(Best_Parameters_After_Optimization))+ "\n")
f.write("\n")
f.write("----------------------------------------\n")
f.write("\n")
f.close() 


# In[24]:


print("Finished Saving all Results")

