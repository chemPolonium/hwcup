clear,clc;
load('tankData.mat');
load('quest1.mat');

totalCg = zeros(size(t,1),3);
tankFlow(:,[2 5]) = tankFlow(:,[2 5]) - tankFlow(:,[1 6]);
tankQuantity = tankInitQuantity - cumtrapz(tankFlow/oilDensity);
for i = 1:numel(t)
    totalCg(i,:) = getTotalCg(tankQuantity(i,:),...
        aircraftPitch(i),tankPosi,tankSize,aircraftMass,oilDensity)';
end

close all
plot(t,totalCg,'LineWidth',1.5);
title('center of gravity (CG)')
legend('x','y','z')
xlabel('time / second');
ylabel('CG position / m');
exportgraphics(gca,'quest1cg.png');