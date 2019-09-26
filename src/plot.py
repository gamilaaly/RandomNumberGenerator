
import matplotlib.pyplot as plt

dataarr = []
indecies = []

f = open("randomNum.txt", "r")
data = f.readlines() #list
data.pop(0)  #to remove the maximun number from the array
data = [float(i) for i in data] #string to int
totalNums = len(data) -1
Max = data[0]

for i in data:
    dataarr.append(i)
    indecies.append(data.index(i))


    
print(dataarr)
print(indecies)

plt.axis([0, totalNums, 0, Max])
plt.plot(indecies,data, 'b.')
plt.show()