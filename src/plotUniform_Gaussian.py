from pylab import show,hist,subplot,figure
from numpy import sqrt, log, sin, cos, pi, asarray,finfo

eps = finfo(float).eps
dataarr = []
f = open("randomNum.txt", "r")
data = f.readlines()  # list
data = [float(i) for i in data]  # string to float
totalNums = len(data) - 1
Max = data[0]
data.pop(0)  # to remove the maximum number from the array

data=asarray(data)

for i in data:
    if (i> eps):
        dataarr.append(i)
dataarr = asarray(dataarr)


def gaussian(u1,u2):
    z1 = sqrt(-2*log(u1))*cos(2*pi*u2)
    z2 = sqrt(-2*log(u1))*sin(2*pi*u2)
    return z1,z2


u1 = dataarr[0:40000]
u2 = dataarr[40001:80001]

z1, z2 = gaussian(u1, u2)


figure()
subplot(221) # the first row of graphs
hist(u1)     # contains the histograms of u1 and u2
subplot(222)
hist(u2)
subplot(223) # the second contains
hist(z1)     # the histograms of z1 and z2
subplot(224)
hist(z2)
show()