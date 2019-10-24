fPoints = 100;
freq = linspace(400e6, 2e9, fPoints);
S11 = zeros(1,fPoints);
C = zeros(1, fPoints);
G = zeros(1, fPoints);
Y = zeros(1, fPoints);
eps = zeros(1, fPoints);



syms e_real e_im
assume(e_real, 'real');
assume(e_im, 'real');
p = (e_real + e_im*1i)^5;
p_exp = expand(p);

p_real = real(p_exp);
p_im = imag(p_exp);


Y_re = 5;
Y_im = 4;
f_test = 1e9;

eqns = [real(sqrt(p_exp))*2e-12 + e_im * (2*3.1415 * f_test)*3e-6 == Y_re, imag(sqrt(p_exp))*2e-12 + e_real * (2*3.1415 * f_test)*3e-6 == Y_im];
S = vpasolve(eqns, [e_real, e_im]);
S.e_real
S.e_im

eps_inf = 4.6;
eps_s = 78.3;
tau = 8.07e-12;
for i=1:fPoints
    eps(i) = eps_inf + (eps_inf - eps_s)/(1 + 2*(3.1415)*tau*(1j));
end