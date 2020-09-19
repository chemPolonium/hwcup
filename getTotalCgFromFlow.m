function totalCg = getTotalCgFromFlow(tankQuantity,actTank,actTankFlow,aircraftPitch,tankPosi,tankSize,aircraftMass,oilDensity)
tankFlow = zeros(1,6);
tankFlow(actTank) = actTankFlow;
tankFlow(:,[2 5]) = tankFlow(:,[2 5]) - tankFlow(:,[1 6]);
tankQuantity = tankQuantity - tankFlow;
totalCg = getTotalCg(tankQuantity,aircraftPitch,tankPosi,tankSize,aircraftMass,oilDensity);
end