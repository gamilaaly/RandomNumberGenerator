
import matplotlib.pyplot as plt

dataarr = []
indecies = []

f = open("src/randomNum.txt", "r")
data = f.readlines() #list
data = [int(i) for i in data] #string to int
totalNums = len(data)

for i in data:
    dataarr.append(i)
    indecies.append(data.index(i))

    
print(dataarr)
print(indecies)

plt.axis([0, totalNums, 0, 100])
plt.plot(indecies,data, 'ro')
plt.show()