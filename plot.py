# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import matplotlib.pyplot as plt

probability=[]
dataarr=[]
f = open("randomNum.txt", "r")
data =f.readlines() #list
data=[int(i) for i in data]
totalNums=len(data)
#print(totalNums)
data.sort()
for i in data: 
    probability.append(data.count(i)/totalNums)
    dataarr.append(i)
    
print (dataarr)
print (probability)
    

    
plt.ylabel('probability')
plt.xlabel('Random Numbers')
plt.plot(dataarr,probability)
plt.show()

