import numpy as np
import matplotlib.pyplot as plt

plt.figure(figsize=(4,2.6))
plt.psd(5*np.random.randn(10000000))
plt.tight_layout()
plt.savefig('psd1.svg')

plt.figure(figsize=(4,2.6))
plt.psd(5*np.random.randn(10000000), sides='twosided')
plt.tight_layout()
plt.savefig('psd2.svg')

plt.figure(figsize=(4,2))
flist = [       1,           1e3,         10e3,        100e3,          1e6,          2e6,          5e6]
Rlist = [  172.24,        172.28,       172.70,       191.63,       463.59,       643.14,       999.41]
Llist = [612.9e-6,      612.5e-6,     609.9e-6,     580.7e-6,     506.2e-6,     486.2e-6,     467.5e-6]
Glist = [0.000e-6,      0.072e-6,     0.531e-6,     3.327e-6,    29.111e-6,    53.205e-6,   118.074e-6]
Clist = [51.57e-9,      51.57e-9,     51.57e-9,     51.57e-9,     51.57e-9,     51.57e-9,     51.57e-9]
f = np.arange(1, 1e6, 1e2)
R = np.interp(f, flist, Rlist)
L = np.interp(f, flist, Llist)
G = np.interp(f, flist, Glist)
C = np.interp(f, flist, Clist)
plt.plot(1e-6*f, -20.*np.log10(np.e)*np.real(np.sqrt((R+2j*np.pi*f*L)*(G+2j*np.pi*f*C))))
plt.xlabel('Frequência (MHz)')
plt.ylabel('Atenuação (dB)')
plt.tight_layout()
plt.savefig('attenuation.svg')
