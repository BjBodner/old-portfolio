# Interacting Complex Networks - CERN Hackatho

This project was made during my first semester at Brown, as part of a hackathon which was hosted by CERN,
to improve the classification capabilities of the detectors in the CMS particle detector. 
This hackathon was focused on classifying events which generate HIGGs particles,
using structured data from a set of detectors. This problem is nutorious for very low signal to noise rations
which makes it difficult to  distinguish between events which generate HIGGs particles and those that don't

The approach that I took in this task was to use a combination of boosting bagging complex valued 
feed forward neural neworks. One group of network were trained networks in parallel and trained to overvit on the
data they were trained on. A second group of networks was trained on the activations 
in the last hidden layer of the data-trained networks. The goal of this second group was to classify 
if the nets in the first group were confident in their predictions. A third group was trained as well to classify 
When the nets were not confident in their predictions. 
(Two differnt entropy optimized nets, instead of a signle cross entropy optimized net).

These Networks were trained with one of my black box optimization algorithms - Two mode
Though now the ATM, would likely optimize them much quicker.

