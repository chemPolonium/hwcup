function totalCg = getTotalCg(tankQuantity,aircraftPitch,tankPosi,tankSize,aircraftMass,oilDensity)
tankCg = getTankCg(tankQuantity,aircraftPitch,tankPosi,tankSize);
totalCg = sum(tankCg.*tankQuantity*oilDensity,2)...
    /(aircraftMass + sum(tankQuantity*oilDensity));
end

function tankCg = getTankCg(tankQuantity,aircraftPitch,tankPosi,tankSize)
tankCgOffset = getTankCgOffset(tankQuantity,aircraftPitch,tankSize);
tankCg = tankPosi;
tankCg([1 3],:) = tankCg([1 3],:) + tankCgOffset;
cosPitch = cosd(aircraftPitch);
sinPitch = sind(aircraftPitch);
tankCg([1 3],:) = [cosPitch,-sinPitch;sinPitch,cosPitch] * tankCg([1 3],:);
end

function tankCgOffset = getTankCgOffset(tankQuantity,aircraftPitch,tankSize)
tankBase = tankSize(1,:).*tankSize(2,:);
oilCenterHeight = tankQuantity ./ tankBase;
% oilFrontHeight = oilCenterHeight-tankSize(:,1)*cosd(aircraftPitch)/2;
% oilRearHeight = oilCenterHeight+tankSize(:,1)*cosd(aircraftPitch)/2;
% tankCgX = tankSize(:,1)*(2*oilFrontHeight+oilRearHeight)/12/oilCenterHeight;
tankCgX = tankSize(1,:).^2 * tand(aircraftPitch) ./ (12 * oilCenterHeight);
tankCgZ = (oilCenterHeight - tankSize(3,:)) / 2;
tankCgOffset = [tankCgX;tankCgZ];
end