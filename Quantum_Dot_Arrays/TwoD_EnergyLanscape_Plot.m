function [EnergyLanscape_Plot] = TwoD_EnergyLanscape_Plot(NumberOfDots,C,Cg,Q,invCM,Vleft,Vg)

initial_Q = Q;
%[Vleft,~] = NextVoltageCalculator(Q,NumberOfDots,invCM,C,Vleft);
 % Vleft = 10*Vleft;    
Q = reshape(initial_Q,1,NumberOfDots(1)*NumberOfDots(2));

for n = 1:NumberOfDots(1)*NumberOfDots(2)
%EnergyLanscape(n) = sum(0.5*Q(n)*invCM*Q.') + C*Vleft*sum(invCM(n,1:NumberOfDots:NumberOfDots*NumberOfDots - NumberOfDots + 1))*Q(n);
EnergyLanscape(n) = sum(0.5*Q(n)*invCM*Q.') + C*Vleft*sum(invCM(n,1:NumberOfDots(1):NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(1) + 1).')*Q(n) + ( Cg*Vg*sum(invCM(n,:).'))*Q(n);
end


EnergyLanscape1 = reshape(EnergyLanscape,NumberOfDots(1),NumberOfDots(2));


%bar3(EnergyLanscape1);
[x,y] = meshgrid(1:1:NumberOfDots(1),1:1:NumberOfDots(2));
%surf(x,y,EnergyLanscape1)
%bar3(EnergyLanscape1);
                b = bar3(EnergyLanscape1);
                for t = 1:length(b)
                    zdata = b(t).ZData;
                    b(t).CData = zdata;
                    b(t).FaceColor = 'interp';
                end
%view(150,40)


CCg = C/Cg;
           % title(sprintf('Energetic Landscape \n For 2D array of  %g by %g dots \n and C/Cg = %f \n Vleft = %g',NumberOfDots,NumberOfDots,CCg,Vleft))
          % zmax = 200;
           
            %zlim([0 zmax])
EnergyLanscape_Plot = getframe(gcf);