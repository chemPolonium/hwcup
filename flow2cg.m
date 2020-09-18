function totalCg = flow2cg(tankFlow,tankPosi,tankSize,aircraftMass,oilDensity,tankInitQuantity)
tankFlow(:,[2 5]) = tankFlow(:,[2 5]) - tankFlow(:,[1 6]);
tankQuantity = tankInitQuantity - cumtrapz(tankFlow/oilDensity);
totalCg = zeros(size(tankFlow,1),3);
for i = 1:size(tankFlow,1)
    totalCg(i,:) = getTotalCg(tankQuantity(i,:),tankPosi,tankSize,aircraftMass,oilDensity)';
end
end

function totalCg = getTotalCg(tankQuantity,tankPosi,tankSize,aircraftMass,oilDensity)
tankCg = getTankCg(tankQuantity,tankPosi,tankSize);
totalCg = sum(tankCg.*tankQuantity*oilDensity,2)...
    /(aircraftMass + sum(tankQuantity*oilDensity));
end

function tankCg = getTankCg(tankQuantity,tankPosi,tankSize)
tankCgOffset = getTankCgOffset(tankQuantity,tankSize);
tankCg = tankPosi;
tankCg(3,:) = tankCg(3,:) + tankCgOffset;
end

function tankCgZ = getTankCgOffset(tankQuantity,tankSize)
tankBase = tankSize(1,:).*tankSize(2,:);
oilCenterHeight = tankQuantity ./ tankBase;
tankCgZ = (oilCenterHeight - tankSize(3,:)) / 2;
end