fPoints = 50;
freq = logspace(6, 12, fPoints);
S11 = zeros(1,fPoints);
C = zeros(1, fPoints);
G = zeros(1, fPoints);
Y = zeros(1, fPoints);
eps = zeros(1, fPoints);

eps_new = zeros(1, fPoints);
eps_new = sym(eps_new);

%S(w), Eps are arrays w/ respect to frequency

%% First extract C0, G0 from known permittivity

syms C0 G0

eps_inf = 4.6;
eps_s = 78.3;
tau = 8.07e-12;
for i=1:fPoints
    eps(i) = eps_inf + (eps_s - eps_inf)/(1 + 2*(3.1415)*freq(i)*tau*(1j));
end

Y_data = (10*rand(1,fPoints)+11) + (10*1j*rand(1, fPoints)+11*1j);
Y_meas = (10*rand(1,fPoints)+11) + (10*1j*rand(1, fPoints)+11*1j);
%eqns(1, 2 * fPoints);
eqn1 = zeros(1, fPoints);
eqn2 = zeros(1, fPoints);
eqn1 = sym(eqn1);
eqn2 = sym(eqn2);
C0_sol = zeros(1, fPoints);
G0_sol = zeros(1, fPoints);

%% Extract C0(w), G0(w) from Water 30 C
for i = 1:fPoints
    eqn1(i) = real(sqrt(eps(i).^5)).*G0 + real(1j*eps(i)) .* (2*3.1415 .* freq(i)).*C0 == real(Y_data(i));
    eqn2(i) = imag(sqrt(eps(i).^5)).*G0 + imag(1j*eps(i)) .* (2*3.1415 .* freq(i)).*C0 == imag(Y_data(i));
    S = vpasolve([eqn1(i), eqn2(i)], [C0, G0]);
    C0_sol(i) = S.C0;
    G0_sol(i) = S.G0;
end

syms eps_r eps_im
eqn1_new = zeros(1, fPoints);
eqn2_new = zeros(1, fPoints);
eqn1_new = sym(eqn1_new);
eqn2_new = sym(eqn2_new);
eps_rsol = zeros(1, fPoints);
eps_imsol = zeros(1, fPoints);

for i = 1:fPoints
    eqn1_new(i) = real(sqrt((eps_r + 1j * eps_im)^5)).*G0_sol(i) + real(1j*(eps_r + 1j * eps_im)) .* (2*3.1415 .* freq(i)).*C0_sol(i) == real(Y_meas(i));
    eqn2_new(i) = imag(sqrt((eps_r + 1j * eps_im)^5)).*G0_sol(i) + imag(1j*(eps_r + 1j * eps_im)) .* (2*3.1415 .* freq(i)).*C0_sol(i) == imag(Y_meas(i));
    Ksol = vpasolve([eqn1_new(i), eqn2_new(i)], [eps_r, eps_im]);
    %eps_rsol(i) = Ksol(1).eps_r;
    %eps_imsol(i) = Ksol(1).eps_im;
    val_r = Ksol(1).eps_r;
    val_im = Ksol(1).eps_im;
    eps_rsol(i) = val_r;
    eps_imsol(i) = val_im;
end

    eqn1_new(1) = real(sqrt((eps_r + 1j * eps_im)^5)).*G0_sol(1) + real(1j*(eps_r + 1j * eps_im)) .* (2*3.1415 .* freq(1)).*C0_sol(1) == real(Y_meas(1));
    eqn2_new(1) = imag(sqrt((eps_r + 1j * eps_im)^5)).*G0_sol(1) + imag(1j*(eps_r + 1j * eps_im)) .* (2*3.1415 .* freq(1)).*C0_sol(1) == imag(Y_meas(1));
    Ksol = vpasolve([eqn1_new(1), eqn2_new(1)], [eps_r, eps_im]);
    %eps_rsol(i) = Ksol.eps_r;
    %eps_imsol(i) = Ksol.eps_im;
    %Ksol(1).eps_r
    %Ksol(1).eps_im

%%
%{
    eqn1(1) = (real(sqrt(eps(1).^5)).*G0 +  .* (2*3.1415 .* freq(1)).*C0 == real(Y_data(1)));
    eqn2(1) = (imag(sqrt(eps(1).^5)).*G0 +  .* (2*3.1415 .* freq(1)).*C0 == imag(Y_data(1)));
    S = vpasolve([eqn1(1), eqn2(1)], [C0, G0]); 
%}
%{ 
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

%}
%%


%semilogx(freq, real(eps)); hold on;
%semilogx(freq, -imag(eps)); hold on;

%semilogx(freq, C0_sol); hold on;
%semilogx(freq, G0_sol); hold on;

semilogx(freq, eps_rsol); hold on;
semilogx(freq, eps_imsol); hold on;