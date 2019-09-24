# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import numpy as np
import matplotlib.pyplot as plt


f = open("/home/gamila/Documents/GP/RandomNumberGenerator/randomNum.txt", "r")
data =f.readlines() #list
#data.list(delimeter)

print (type(data))
print(data)
myarray = np.asarray(data)
print (type(myarray))
for i in myarray: 
    print(myarray[0]) 
    
    
plt.plot(myarray)
plt.show()

