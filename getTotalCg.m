function totalCg = getTotalCg(tankQuantity,aircraftPitch,tankPosi,tankSize,aircraftMass,oilDensity)
tankCg = getTankCg(tankQuantity,aircraftPitch,tankPosi,tankSize);
totalCg = sum(tankCg.*tankQuantity*oilDensity,2)...
    /(aircraftMass + sum(tankQuantity*oilDensity));
end

function tankCg = getTankCg(tankQuantity,aircraftPitch,tankPosi,tankSize)
tankCgOffset = getTankCgOffset(tankQuantity,aircraftPitch,tankSize);
tankCg = tankPosi;
tankCg([1 3],:) = tankCg([1 3],:) + tankCgOffset;
end

function tankCgOffset = getTankCgOffset(tankQuantity,aircraftPitch,tankSize)
tankBase = tankSize(1,:).*tankSize(2,:);
oilCenterHeight = tankQuantity ./ tankBase;
tankCgX = tankSize(1,:).^2 * tand(aircraftPitch) ./ (12 * oilCenterHeight);
tankCgZ = (oilCenterHeight - tankSize(3,:)) / 2;
tankCgOffset = [tankCgX;tankCgZ];
end