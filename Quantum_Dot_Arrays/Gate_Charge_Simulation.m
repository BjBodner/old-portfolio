Rg = 100;
Cg = 10;
C = 1;
Vg = 0;
Vleft_Old = 1;
Vleft_New = 1.2;
Q_Old = 1;
Q_New = 2;




q_Gate_Old = ((2*C*Cg)/(2*C+Cg))*(Vg + Vleft_Old/2) + (Cg/(2*C+Cg))*Q_Old;
q_Gate_New = ((2*C*Cg)/(2*C+Cg))*(Vg + Vleft_New/2) + (Cg/(2*C+Cg))*Q_New;

t = 1:10000;
q = q_Gate_Old + (q_Gate_New-q_Gate_Old)*(1-exp(-t/(Rg*Cg)));

plot(t,q)