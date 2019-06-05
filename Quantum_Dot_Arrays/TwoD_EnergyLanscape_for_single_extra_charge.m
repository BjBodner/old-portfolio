function [EnergyLanscape_for_single_extra_charge,EnergyLanscape] = TwoD_EnergyLanscape_for_single_extra_charge(NumberOfDots,C,Cg,Q,invCM)

initial_Q = Q;
Vleft = 0;
[Vleft,~] = NextVoltageCalculator(Q,NumberOfDots,invCM,C,Vleft);
  Vleft = 10*Vleft;    
Q = reshape(initial_Q,1,NumberOfDots*NumberOfDots);

for n = 1:NumberOfDots*NumberOfDots
    Q(n) = Q(n) + 1;
Energy(n) = 0.5*Q*invCM*Q.' + C*Vleft*sum(invCM(:,1:NumberOfDots:NumberOfDots*NumberOfDots - NumberOfDots + 1).')*Q.';
Q(n) = Q(n) - 1;
end

EnergyLanscape = reshape(Energy,NumberOfDots,NumberOfDots);
EnergyLanscape = EnergyLanscape/max(max(EnergyLanscape));
[x,y] = meshgrid(1:1:NumberOfDots,1:1:NumberOfDots);
EnergyLanscape_for_single_extra_charge = surf(x,y,EnergyLanscape);
                shading flat
CCg = C/Cg
            title(sprintf('Normalized Energetic Landscape \n For 2D array of  %g by %g dots \n and C/Cg = %f',NumberOfDots,NumberOfDots,CCg))
            zlim([0 1.2])
f = getframe(gcf);