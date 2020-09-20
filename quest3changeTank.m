function actTank = quest3changeTank(tankQuantity)
% function actTank = quest3changeTank(tankQuantity,tankInitQuantity)
% tankQuantityPercent = tankQuantity ./ tankInitQuantity;
actTank = false(1,6);
% [~,tankInd] = sort(tankQuantityPercent,'descend');
[~,tankInd] = sort(tankQuantity,'descend');
actTankNum = 0;
actEngineTankNum = 0;
for i = 1:6
    if tankQuantity(tankInd(i)) < 0.01
        break
    end
    if ismember(tankInd(i),[2 3 4 5])
        actEngineTankNum = actEngineTankNum + 1;
    end
    actTankNum = actTankNum + 1;
    if actTankNum == 4
        break
    end
    if actEngineTankNum == 3
        actTankNum = actTankNum - 1;
        actEngineTankNum = 2;
        continue
    end
    actTank(tankInd(i)) = true;
end
end