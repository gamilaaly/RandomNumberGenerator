from pylab import show,hist,subplot,figure
from numpy import asarray,finfo
import math

eps = finfo(float).eps
uniformdataarr = []
gaussiandataarr1=[]
gaussiandataarr2 =[]

f = open("randomNum.txt", "r")
data = f.readlines()  # list
data = [float(i) for i in data]  # string to float
N=len(data)
uniformdata=data[0:math.floor(N/2)]
gaussiandata1=data[math.floor(N/2)+1 :math.floor(N-(N/4)) ]
gaussiandata2=data[math.floor(N-(N/4)) +1 : N]

print(len(uniformdata))
print(len(gaussiandata1))
print(len(gaussiandata2))


uniformdataarr= asarray(uniformdata)
gaussiandataarr1= asarray(gaussiandata1)
gaussiandataarr2= asarray(gaussiandata2)

print(len(uniformdataarr))
print(len(gaussiandataarr1))
print(len(gaussiandataarr2))

figure()
subplot(311) # the first row of graphs
hist(uniformdataarr)     # contains the histograms of u1 and u2
subplot(312)
hist(gaussiandataarr1,1000)
subplot(313) # the second contains
hist(gaussiandataarr2,1000)    # the histograms of z1 and z
show()
