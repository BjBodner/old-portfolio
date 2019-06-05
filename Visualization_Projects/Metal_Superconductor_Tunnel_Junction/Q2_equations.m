clear

syms Epsilon delta phi Ef A B C D E F x h m


K_SC_State_1 = (1/h)*sqrt(2*m*(Ef + sqrt(Epsilon.^2 - delta^2)));
K_SC_State_2 = (1/h)*sqrt(2*m*(Ef - sqrt(Epsilon.^2 - delta^2)));

K_N_e = (1/h)*sqrt(2*m*(Ef + Epsilon))
K_N_h = (1/h)*sqrt(2*m*(Ef - Epsilon))


Psi_SC_State_1_Plus_e = (1/sqrt((h^2*K_SC_State_1^2/(2*m) - Ef) + delta^2))*(h^2*K_SC_State_1^2/(2*m) - Ef + Epsilon)*exp(1i*(-phi + K_SC_State_1*x));
Psi_SC_State_1_Plus_h = (1/sqrt((h^2*K_SC_State_1^2/(2*m) - Ef) + delta^2))*(delta)*exp(1i*( K_SC_State_1*x));

Psi_SC_State_2_Plus_e = (1/sqrt((h^2*K_SC_State_2^2/(2*m) - Ef) + delta^2))*(-delta)*exp(1i*(K_SC_State_2*x));
Psi_SC_State_2_Plus_h = (1/sqrt((h^2*K_SC_State_2^2/(2*m) - Ef) + delta^2))*(h^2*K_SC_State_2^2/(2*m) - Ef + Epsilon)*exp(1i*(phi + K_SC_State_2*x));

Psi_N_Plus_e = exp(1i*K_N_e *x);
Psi_N_Minus_e = exp(-1i*K_N_e *x);

Psi_N_Plus_h = exp(1i*K_N_h*x);
Psi_N_Minus_h = exp(-1i*K_N_h*x);


%% Continuity equations
Eq1_1 = A*Psi_N_Plus_e + B*Psi_N_Minus_e - (E*Psi_SC_State_1_Plus_e + F*Psi_SC_State_2_Plus_e);
Eq1 = simplify(subs(Eq1_1,x,0));

Eq2_1 = C*Psi_N_Plus_h + D*Psi_N_Minus_h - (E*Psi_SC_State_1_Plus_h + F*Psi_SC_State_2_Plus_h);
Eq2 = simplify(subs(Eq2_1,x,0));

%% Derrivative equations
Eq3 = diff(Eq1_1,x);
Eq3 = simplify(subs(Eq3,x,0));


Eq4 = diff(Eq2_1,x);
Eq4 = simplify(subs(Eq4,x,0));

%% Nomalization Equations - 
Eq5 = A^2 + B^2 + (E*(1/sqrt((h^2*K_SC_State_1^2/(2*m) - Ef) + delta^2))*(h^2*K_SC_State_1^2/(2*m) - Ef + Epsilon))^2 +  (F*(1/sqrt((h^2*K_SC_State_2^2/(2*m) - Ef) + delta^2))*(delta))^2- 1;
Eq6 = C^2 + D^2 + (E*(1/sqrt((h^2*K_SC_State_2^2/(2*m) - Ef) + delta^2))*(delta))^2 + (F*(1/sqrt((h^2*K_SC_State_2^2/(2*m) - Ef) + delta^2))*(h^2*K_SC_State_2^2/(2*m) - Ef + Epsilon))^2- 1;

Equations = [Eq1 == 0; Eq2 ==0; Eq3 ==0; Eq4 ==0; Eq5 ==0; Eq6 ==0];
Variable = [A B C D E F];
solve(Equations,Variable )
 a= 1