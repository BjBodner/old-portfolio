
clear
%syms E0 detla detla_adj

%H = [E0 detla ; detla_adj -E0]

%[V,D] = eig(H)

%% Numerical Simulation of K in Metal and K in SC
h = 1
m = 1
Ef=  1;

Kf = (1/h)*sqrt(2*m*Ef);
EnergyRange_Of_Test = (-2*Ef:0.01:2*Ef)/10;

Epsilon_e = EnergyRange_Of_Test;
Epsilon_h = EnergyRange_Of_Test;

K_N_e = (1/h)*sqrt(2*m*(Ef + Epsilon_e))/Kf;
K_N_h = (1/h)*sqrt(2*m*(Ef - Epsilon_h))/Kf;

plot_different_K = 0;
if plot_different_K == 1
ax1 = subplot(2,1,1);
plot(ax1,K_N_e,Epsilon_e,'-bs',K_N_h,Epsilon_h,'-rs');
title(ax1,'Dispersion RElation - electrons in blue and holes in red');
xlabel(ax1,'K of particles (K/Kf)');
ylabel(ax1,'Energy of particles relative to E (Eps/Ef)');
end


Epsilon_State_1 = EnergyRange_Of_Test;
Epsilon_State_2 = EnergyRange_Of_Test;
delta = 0.1;

K_SC_State_1 = (1/h)*sqrt(2*m*(Ef + sqrt(Epsilon_State_1.^2 - delta^2)))/Kf;
K_SC_State_2 = (1/h)*sqrt(2*m*(Ef - sqrt(Epsilon_State_1.^2 - delta^2)))/Kf;


if plot_different_K == 1
ax2 = subplot(2,1,2);
plot(ax2,K_SC_State_1,Epsilon_State_1,'-bs',K_SC_State_2,Epsilon_State_2,'-rs');
title(ax2,'Dispersion RElation - State 1 in blue and State 2 in red (Real in square, Imaginary in Circles)');
xlabel(ax2,'K of states (K/Kf)');
ylabel(ax2,'Energy of states relative to E (Eps/Ef)');

hold on
ax2 = subplot(2,1,2);
plot(ax2,imag(K_SC_State_1),Epsilon_State_1,'-bo',imag(K_SC_State_2),Epsilon_State_2,'-ro');
%title(ax2,'Dispersion RElation - State 1 in blue and State 2 in red');
%xlabel(ax2,'K of states (K/Kf)');
%ylabel(ax2,'Energy of states relative to E (Eps/Ef)');
%xlim()

hold off
end

%% Part 2

Psi_N_e_plus = 1;
x = 0:0.1:100;
x_expanded = ones(length(K_SC_State_1),length(x))*diag(x);
Psi_Sc_1_plus = exp(1i*diag(K_SC_State_1)*x_expanded );
Psi_Sc_2_plus = exp(1i*diag(K_SC_State_2)*x_expanded );


for n = 1:length(K_SC_State_1)
plot(x_expanded(n,:),Psi_Sc_1_plus(n,:),'b',x_expanded(n,:),Psi_Sc_2_plus(n,:),'r');
xlabel('position');
ylabel('Real Part of wavefunction');
ylim([-20 20])
s1 = strcat('State 1 - blue state: K1 = ',num2str(K_SC_State_1(n)), '.   Energy1 =',num2str(Epsilon_State_1(n)));
s2 = strcat('State 2 - red state: K2 = ',num2str(K_SC_State_2(n)), '.   Energy1 =',num2str(Epsilon_State_2(n)));
s3 = strcat('SC Gap (Delta) = ',num2str(delta));
title({s1;' ';s2;' ';s3});
getframe(gcf);
%pause(0.1)
end
