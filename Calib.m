syms G0 C0 E_r E_i; % 
Y0 = 1/50;

f = 5e+7;         %frequency to eval
%w = 2*pi*f;
w = 50;
t = 8.07e-12;   %relaxation time for water
E_s = 4.6;
E_inf = 78.3;
S = 2+2i;       %empiracal reference data place holder
S_t = 5+5i;       %empiracal test data place holder

%E_c = E_inf + ((E_s - E_inf)/(1+1i*w*t));
E_c = 1+1i;
ReY1 = real(Y0*((1-S)/(1+S)));
ImY1 = imag(Y0*((1-S)/(1+S)));

ReG0 = real( E_c^(5/2));
ImG0 = imag(E_c^(5/2));

ReC0 = real(1i*w*E_c);
ImC0 = imag(1i*w*E_c);

Eqn1 = ((G0*ReG0 + C0*ReC0) == ReY1);
Eqn2 = ((G0*ImG0 + C0*ImC0) == ImY1);

[solG,solC] = solve([Eqn1,Eqn2],[G0,C0]);
disp(double(solG));
disp(double(solC));

Y_nR = real(Y0*((1-S_t)/(1+S_t)));
Y_nI = imag(Y0*((1-S_t)/(1+S_t)));

%E_CA  = (E_r + 1i*E_i)^(5/2)

%Eqn3 = solG*real(E_CA) + solC*real(1i*w*E_r) == Y_nR;
%Eqn4 = solG*imag(E_CA) + solC*imag(1i*w*E_i) == Y_nI;

%[solER,solEI] = solve([Eqn3,Eqn4],[E_r,E_i]);

%Eval = double(solER) + double(1i*solEI);
%disp(Eval);

Eqn5 = solG*(E_r^(5/2)) + solC*1i*w*E_r == Y_nR + Y_nI;
Eval = solve(Eqn5);
disp(Eval);
