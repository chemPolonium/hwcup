clear,clc;
load('tankData.mat');
load('quest1.mat');

totalCg = zeros(size(t,1),3);
tankQuantity = tankInitQuantity - cumsum(tankFlow/oilDensity);
for i = 1:numel(t)
    totalCg(i,:) = getTotalCg(tankQuantity(i,:),...
        aircraftPitch(i),tankPosi,tankSize,aircraftMass,oilDensity)';
end

plot(t,totalCg);
legend('x','y','z');