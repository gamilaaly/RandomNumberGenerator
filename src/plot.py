
import matplotlib.pyplot as plt
import numpy as np
import math

dataarr = []
indecies = []

f = open("randomNum.txt", "r")
data = f.readlines() #list
data = [float(i) for i in data] #string to int
totalNums = len(data) -1
Max = data[0]
data.pop(0)  #to remove the maximun number from the array

for i in data:
    dataarr.append(i)
    indecies.append(data.index(i))

firstChunk = data[0:math.floor(totalNums/5)-1]
secondChunk = data[math.floor((totalNums/5)):math.floor(2*totalNums/5)-1]
thirdChunk = data[math.floor((2*totalNums/5)):math.floor((3*totalNums/5))-1]
fourthChunk = data[math.floor((3*totalNums/5)):math.floor((4*totalNums/5))-1]
fifthChunk = data[math.floor((4*totalNums/5)):totalNums-1]

firstAvg = np.mean(firstChunk)
secondAvg = np.mean(secondChunk)
thirdAvg = np.mean(thirdChunk)
fourthAvg = np.mean(fourthChunk)
fifthAvg = np.mean(fifthChunk)

firstHistoBar = np.full(len(firstChunk)+1,firstAvg)
secondHistoBar = np.full(len(secondChunk)+1,secondAvg)
thirdHistoBar = np.full(len(thirdChunk)+1,thirdAvg)
fourthHistoBar = np.full(len(fourthChunk)+1,fourthAvg)
fifthHistoBar = np.full(len(fifthChunk)+1,fifthAvg)

histogram= np.zeros(5*(len(firstChunk)+1))

histogram[0:len(firstHistoBar)]= firstHistoBar
histogram[len(firstHistoBar):2*len(firstHistoBar)]= secondHistoBar
histogram[2*len(firstHistoBar):3*len(firstHistoBar)]= thirdHistoBar
histogram[3*len(firstHistoBar):4*len(firstHistoBar)]= fourthHistoBar
histogram[4*len(firstHistoBar):5*len(firstHistoBar)]= fifthHistoBar

print("Average= " + str(np.mean(data)))
plt.axis([0, totalNums, 0, 1])
plt.plot(histogram)
plt.show()
#plt.axis([0, totalNums, 0, Max])
#plt.plot(indecies,data, 'b.')
#plt.show()

