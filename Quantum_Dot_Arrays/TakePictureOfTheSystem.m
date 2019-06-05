function [f] = TakePictureOfTheSystem(Q)

Holes = -Q+3;
f = getframe(gcf);

ax1 = subplot(2,1,1);
bar3(ax1,Q,'b');
zlim([0 10]);
zlabel(ax1,'Electron Configuration In 2D QD Array')

ax2 = subplot(2,1,2);
bar3(ax2,Holes,'r')
zlim([-10 10]);
zlabel(ax2,'Holes Configuration In 2D QD Array')
