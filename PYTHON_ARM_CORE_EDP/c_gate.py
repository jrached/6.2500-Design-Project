L_s = 50e-7
t_s = 35e-7
L_ox = 35e-7
epsilon = 8.854e-14
epsilon_ox = 3.7 * epsilon
t_ox = 5e-7

c_gs = (L_s * epsilon_ox)/t_s
c_gc = (L_ox * epsilon_ox)/(t_ox/2)

c_gc_orig = (L_ox * epsilon_ox)/5e-7

c_gate = c_gs + c_gc

ratio = c_gate/(c_gs + c_gc_orig)
print(ratio)
