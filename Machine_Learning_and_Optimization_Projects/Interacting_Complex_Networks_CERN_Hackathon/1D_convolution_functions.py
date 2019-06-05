
# coding: utf-8

# In[28]:


def ToReducedRowEchelonForm( M ):
    if not M: return
    lead = 0
    rowCount = len(M)
    columnCount = len(M[0])
    for r in range(rowCount):
        if lead >= columnCount:
            return
        i = r
        while M[i][lead] == 0:
            i += 1
            if i == rowCount:
                i = r
                lead += 1
                if columnCount == lead:
                    return
        M[i],M[r] = M[r],M[i]
        lv = M[r][lead]
        M[r] = [ mrx / lv for mrx in M[r]]
        for i in range(rowCount):
            if i != r:
                lv = M[i][lead]
                M[i] = [ iv - lv*rv for rv,iv in zip(M[r],M[i])]
        lead += 1
    return M
 
def pmtx(mtx):
    print ('\n'.join(''.join(' %4s' % col for col in row) for row in mtx))
 
def convolve(f, h):
    g = [0] * (len(f) + len(h) - 1)
    for hindex, hval in enumerate(h):
        for findex, fval in enumerate(f):
            g[hindex + findex] += fval * hval
    return g
 
def deconvolve(g, f):
    lenh = len(g) - len(f) + 1
    mtx = [[0 for x in range(lenh+1)] for y in g]
    for hindex in range(lenh):
        for findex, fval in enumerate(f):
            gindex = hindex + findex
            mtx[gindex][hindex] = fval
    for gindex, gval in enumerate(g):        
        mtx[gindex][lenh] = gval
    ToReducedRowEchelonForm( mtx )
    return [mtx[i][lenh] for i in range(lenh)]  # h
 
if __name__ == '__main__':
    h = [-8,-9,-3,-1,-6,7]
    f = [-3,-6,-1,8,-6,3,-1,-9,-9,3,-2,5,2,-2,-7,-1]
    g = [24,75,71,-34,3,22,-45,23,245,25,52,25,-67,-96,96,31,55,36,29,-43,-7]
    assert convolve(f,h) == g
    assert deconvolve(g, f) == h


# In[157]:


## Attempt at deconv

import numpy as no

def Convolve_1d_valid_With_many_Channels(Vector, filters,padding):
#     print("Don't forget this only convolves the first row of the input vector")

    if padding != 0:
        
         Vector = np.concatenate([np.zeros((padding)),Vector,np.zeros((padding))])

    if np.shape(np.shape(Vector))[0] == 1:
        Vector = np.array([Vector])
        
    if np.shape(np.shape(filters))[0] == 1:
        filters = np.array([filters])

    print(len(Vector[0,:]))
    Number_Of_Channels = len(filters[:,0])
    Length_Of_Convolution = len(Vector[0,:]) - len(filters[0,:]) + 1
    Convolution = np.zeros((Number_Of_Channels,Length_Of_Convolution))
    
    for channel in range(0,Number_Of_Channels):
        for i in range(0,Length_Of_Convolution):
            Convolution[channel,i] = np.dot(Vector[0,i:i+len(filters[0,:])],filters[channel,:])
    return Convolution


## Input Vector
Vector = np.array([1.0,3,4,1,3,5,5])


## Creating Filters
filters = np.zeros((2,3))
filters[0,:] = np.array([[1,3,5]])
filters[1,:] = np.array([[1,5,5]])

Conv1 = Convolve_1d_valid_With_many_Channels(Vector, filters,padding = 0)
Conv2 = Convolve_1d_valid_With_many_Channels(Conv1[0,:], filters[0,:], padding = 2)
Conv3 = Convolve_1d_valid_With_many_Channels(Conv2[0,:], filters, padding = 2)



print(Conv3)


# In[184]:


def Max_pooling_1d(Vector,pooling_number):

    Pooling_Length = int((len(Vector) -np.mod(len(Vector),pooling_number))/pooling_number)
    
    extension  = 0
    if np.mod(len(Vector),pooling_number) > 0:
          extension = 1
    
    Pooled_Vector = np.zeros(( Pooling_Length  +  extension))
    for i in range(0,Pooling_Length) :
        Pooled_Vector[i] = np.max(Vector[0 + (i)*pooling_number:pooling_number + (i)*pooling_number])
        
     ## this just ad all the remaining ones into another slot
    if np.mod(len(Vector),pooling_number) > 0:        
        Pooled_Vector[i+1] = np.max(Vector[(i+1)*pooling_number:len(Vector)])
    return   Pooled_Vector    


print(Vector)
print(Max_pooling_1d(Vector,pooling_number = 3)    )

